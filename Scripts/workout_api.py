#!/usr/bin/env python3
"""Workout API for SafeFlex.

Receives finished workouts from the app (POST /workouts, JSON) and stores
them in a Postgres table. The app posts to port 8081 on the same host as
the sensor server.

Usage:
    python3 Scripts/workout_api.py [port]

Requires: pip3 install psycopg2-binary
Database: set SAFEFLEX_DB to a libpq DSN (default "dbname=safeflex").
Create the database once with: createdb safeflex
The workouts table is created automatically on startup.

GET /workouts returns the most recent 20 rows for quick inspection.
"""

import datetime
import json
import os
import sys
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

import psycopg2

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8081
DSN = os.environ.get("SAFEFLEX_DB", "dbname=safeflex")

# Prescribed program: which exercises are due each weekday (0 = Monday)
# and the rep target that counts as 100% adherence.
WEEKLY_PLAN = {
    0: [("Shoulder Abduction", 36), ("Wrist Flexion", 30)],
    1: [("Shoulder Abduction", 36), ("Neck Stretch", 3)],
    2: [("Shoulder Abduction", 36), ("Wrist Flexion", 30)],
    3: [("Shoulder Abduction", 36), ("Neck Stretch", 3)],
    4: [("Shoulder Abduction", 36), ("Wrist Flexion", 30)],
    5: [("Wrist Flexion", 30), ("Neck Stretch", 3)],
    6: [("Shoulder Abduction", 36)],
}
WEEKDAY_NAMES = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

# Performance blends joint control and achieved range: stability is already
# a percentage; ROM is normalized against the 180° full range.
def performance_score(avg_rom, avg_stability):
    return round(0.5 * avg_stability + 0.5 * (avg_rom / 180 * 100), 1)


SCHEMA = """
CREATE TABLE IF NOT EXISTS workouts (
    id UUID PRIMARY KEY,
    exercise TEXT NOT NULL,
    started_at TIMESTAMPTZ NOT NULL,
    ended_at TIMESTAMPTZ NOT NULL,
    duration_seconds INTEGER NOT NULL,
    total_reps INTEGER NOT NULL,
    sets_completed INTEGER NOT NULL,
    avg_rom_degrees DOUBLE PRECISION NOT NULL,
    avg_stability_percent DOUBLE PRECISION NOT NULL,
    rom_per_rep JSONB NOT NULL,
    stability_per_rep JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS weekly_logs (
    week_start DATE PRIMARY KEY,
    days JSONB NOT NULL,
    performance DOUBLE PRECISION,
    total_reps INTEGER NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS progress_log (
    date DATE NOT NULL,
    exercise TEXT NOT NULL,
    planned_reps INTEGER NOT NULL,
    completed_reps INTEGER NOT NULL,
    percent DOUBLE PRECISION NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (date, exercise)
);
"""

INSERT = """
INSERT INTO workouts (
    id, exercise, started_at, ended_at, duration_seconds, total_reps,
    sets_completed, avg_rom_degrees, avg_stability_percent,
    rom_per_rep, stability_per_rep
) VALUES (
    %(id)s, %(exercise)s, %(started_at)s, %(ended_at)s,
    %(duration_seconds)s, %(total_reps)s, %(sets_completed)s,
    %(avg_rom_degrees)s, %(avg_stability_percent)s,
    %(rom_per_rep)s, %(stability_per_rep)s
)
ON CONFLICT (id) DO NOTHING;
"""


def compute_insights(conn):
    """Builds this week's insights from workouts, and persists the weekly
    ROM/stability log and the per-exercise progress log."""
    today = datetime.date.today()
    week_start = today - datetime.timedelta(days=today.weekday())
    week_end = week_start + datetime.timedelta(days=6)

    with conn.cursor() as cur:
        cur.execute("""
            SELECT ended_at::date,
                   AVG(avg_rom_degrees), AVG(avg_stability_percent),
                   SUM(total_reps)
            FROM workouts
            WHERE ended_at::date BETWEEN %s AND %s
            GROUP BY 1
        """, (week_start, week_end))
        by_day = {r[0]: r for r in cur.fetchall()}

        cur.execute("""
            SELECT ended_at::date, exercise, SUM(total_reps)
            FROM workouts
            WHERE ended_at::date BETWEEN %s AND %s
            GROUP BY 1, 2
        """, (week_start, week_end))
        reps_done = {(r[0], r[1]): r[2] for r in cur.fetchall()}

    days, adherence = [], []
    for i in range(7):
        date = week_start + datetime.timedelta(days=i)
        row = by_day.get(date)
        avg_rom = round(float(row[1]), 1) if row else None
        avg_stab = round(float(row[2]), 1) if row else None
        days.append({
            "date": date.isoformat(),
            "weekday": WEEKDAY_NAMES[i],
            "avg_rom_degrees": avg_rom,
            "avg_stability_percent": avg_stab,
            "performance": performance_score(avg_rom, avg_stab) if row else None,
            "total_reps": int(row[3]) if row else 0,
        })
        for exercise, planned in WEEKLY_PLAN[i]:
            completed = int(reps_done.get((date, exercise), 0))
            adherence.append({
                "date": date.isoformat(),
                "weekday": WEEKDAY_NAMES[i],
                "exercise": exercise,
                "planned_reps": planned,
                "completed_reps": completed,
                "percent": round(min(100.0, completed / planned * 100), 1),
            })

    scored = [d["performance"] for d in days if d["performance"] is not None]
    report = {
        "week_start": week_start.isoformat(),
        "days": days,
        "performance": round(sum(scored) / len(scored), 1) if scored else None,
        "total_reps": sum(d["total_reps"] for d in days),
        "adherence": adherence,
    }

    with conn.cursor() as cur:
        cur.execute("""
            INSERT INTO weekly_logs (week_start, days, performance, total_reps)
            VALUES (%s, %s, %s, %s)
            ON CONFLICT (week_start) DO UPDATE SET
                days = EXCLUDED.days,
                performance = EXCLUDED.performance,
                total_reps = EXCLUDED.total_reps,
                updated_at = now()
        """, (week_start, json.dumps(days), report["performance"],
              report["total_reps"]))
        for entry in adherence:
            cur.execute("""
                INSERT INTO progress_log
                    (date, exercise, planned_reps, completed_reps, percent)
                VALUES (%(date)s, %(exercise)s, %(planned_reps)s,
                        %(completed_reps)s, %(percent)s)
                ON CONFLICT (date, exercise) DO UPDATE SET
                    completed_reps = EXCLUDED.completed_reps,
                    percent = EXCLUDED.percent,
                    updated_at = now()
            """, entry)

    return report


class Handler(BaseHTTPRequestHandler):
    def _respond(self, status: int, body: dict) -> None:
        payload = json.dumps(body).encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(payload)))
        self.end_headers()
        self.wfile.write(payload)

    def do_POST(self) -> None:
        if self.path != "/workouts":
            self._respond(404, {"error": "not found"})
            return
        try:
            length = int(self.headers.get("Content-Length", 0))
            workout = json.loads(self.rfile.read(length))
            workout["rom_per_rep"] = json.dumps(workout["rom_per_rep"])
            workout["stability_per_rep"] = json.dumps(workout["stability_per_rep"])
            with psycopg2.connect(DSN) as conn:
                with conn.cursor() as cur:
                    cur.execute(INSERT, workout)
                compute_insights(conn)
            print(f"[API] Saved workout {workout['id']}: "
                  f"{workout['total_reps']} reps, "
                  f"{workout['avg_rom_degrees']:.0f}° avg ROM, "
                  f"{workout['avg_stability_percent']:.0f}% stability")
            self._respond(201, {"saved": workout["id"]})
        except (KeyError, ValueError, json.JSONDecodeError) as e:
            self._respond(400, {"error": str(e)})
        except psycopg2.Error as e:
            print(f"[API] Database error: {e}")
            self._respond(500, {"error": str(e)})

    def do_GET(self) -> None:
        if self.path == "/insights":
            try:
                with psycopg2.connect(DSN) as conn:
                    report = compute_insights(conn)
                self._respond(200, report)
            except psycopg2.Error as e:
                self._respond(500, {"error": str(e)})
            return
        if self.path != "/workouts":
            self._respond(404, {"error": "not found"})
            return
        try:
            with psycopg2.connect(DSN) as conn, conn.cursor() as cur:
                cur.execute("""
                    SELECT id, exercise, ended_at, duration_seconds, total_reps,
                           sets_completed, avg_rom_degrees, avg_stability_percent
                    FROM workouts ORDER BY ended_at DESC LIMIT 20
                """)
                rows = [
                    {
                        "id": str(r[0]), "exercise": r[1],
                        "ended_at": r[2].isoformat(),
                        "duration_seconds": r[3], "total_reps": r[4],
                        "sets_completed": r[5], "avg_rom_degrees": r[6],
                        "avg_stability_percent": r[7],
                    }
                    for r in cur.fetchall()
                ]
            self._respond(200, {"workouts": rows})
        except psycopg2.Error as e:
            self._respond(500, {"error": str(e)})

    def log_message(self, *args) -> None:
        pass  # request lines are noisy; we print our own summaries


def main() -> None:
    with psycopg2.connect(DSN) as conn, conn.cursor() as cur:
        cur.execute(SCHEMA)
    print(f"[API] Workouts table ready (dsn: {DSN})")
    server = ThreadingHTTPServer(("0.0.0.0", PORT), Handler)
    print(f"[API] Listening on http://0.0.0.0:{PORT}/workouts")
    server.serve_forever()


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n[API] Stopped.")
