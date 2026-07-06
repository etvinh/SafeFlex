#!/usr/bin/env python3
"""Sample sensor-data simulator for SafeFlex.

Serves WebSocket connections on port 8080 and streams simulated
flex/stability readings that produce clean reps in the app: flex sweeps
from ~80 up to ~920 and back on each cycle, so flexPercent crosses the
50% rep threshold once per cycle (~one rep every 3.5s).

Usage:
    python3 Scripts/rep_simulator.py [port]

Then in the app, tap the CONNECTED/DISCONNECTED pill during a live
session and enter <this Mac's IP>:8080 (printed below on startup).
No third-party packages required (pure standard library).
"""

import base64
import hashlib
import json
import math
import random
import socket
import struct
import sys
import threading
import time

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8080
SEND_HZ = 20            # readings per second
REP_PERIOD_S = 3.5      # seconds per rep cycle
WS_MAGIC = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"


def local_ip() -> str:
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(("8.8.8.8", 80))
        return s.getsockname()[0]
    except OSError:
        return "127.0.0.1"
    finally:
        s.close()


def handshake(conn: socket.socket) -> bool:
    request = b""
    while b"\r\n\r\n" not in request:
        chunk = conn.recv(4096)
        if not chunk:
            return False
        request += chunk

    key = None
    for line in request.decode("utf-8", "replace").split("\r\n"):
        if line.lower().startswith("sec-websocket-key:"):
            key = line.split(":", 1)[1].strip()
    if key is None:
        return False

    accept = base64.b64encode(
        hashlib.sha1((key + WS_MAGIC).encode()).digest()
    ).decode()
    conn.sendall(
        (
            "HTTP/1.1 101 Switching Protocols\r\n"
            "Upgrade: websocket\r\n"
            "Connection: Upgrade\r\n"
            f"Sec-WebSocket-Accept: {accept}\r\n\r\n"
        ).encode()
    )
    return True


def text_frame(payload: str) -> bytes:
    data = payload.encode()
    if len(data) < 126:
        header = struct.pack("!BB", 0x81, len(data))
    else:
        header = struct.pack("!BBH", 0x81, 126, len(data))
    return header + data


def reading(elapsed: float) -> str:
    # Half-sine "lift and lower" per rep, with slight amplitude jitter and
    # a brief rest at the bottom of each cycle.
    phase = (elapsed % REP_PERIOD_S) / REP_PERIOD_S
    if phase < 0.85:
        wave = math.sin(math.pi * phase / 0.85)  # 0 -> 1 -> 0
    else:
        wave = 0.0  # rest between reps
    amplitude = 840 * random.uniform(0.96, 1.0)
    flex = 80 + amplitude * wave + random.uniform(-12, 12)

    # Stability dips a little mid-lift, stays in the 4.x "good" range.
    stability = 4.7 - 0.5 * wave + random.uniform(-0.15, 0.15)

    return json.dumps(
        {
            "timestamp": int(time.time() * 1000),
            "flex": round(max(0.0, min(1000.0, flex)), 1),
            "stability": round(max(0.0, min(5.0, stability)), 2),
        }
    )


def serve_client(conn: socket.socket, addr) -> None:
    try:
        if not handshake(conn):
            return
        print(f"[Sim] Client connected: {addr[0]}:{addr[1]}")
        start = time.monotonic()
        while True:
            conn.sendall(text_frame(reading(time.monotonic() - start)))
            time.sleep(1 / SEND_HZ)
    except OSError:
        pass
    finally:
        conn.close()
        print(f"[Sim] Client disconnected: {addr[0]}:{addr[1]}")


def main() -> None:
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind(("0.0.0.0", PORT))
    server.listen()
    print(f"[Sim] Streaming sample rep data on ws://{local_ip()}:{PORT}")
    print(f"[Sim] One rep every {REP_PERIOD_S}s — set the app's sensor "
          f"address to {local_ip()}:{PORT} and tap Start Workout.")
    while True:
        conn, addr = server.accept()
        threading.Thread(target=serve_client, args=(conn, addr), daemon=True).start()


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n[Sim] Stopped.")
