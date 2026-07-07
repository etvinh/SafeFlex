-- SafeFlex schema. Every table is row-level-secured to the signed-in user:
-- user_id defaults to auth.uid() on insert and policies restrict reads and
-- writes to the owner. The anon key alone can see nothing.

create table public.workouts (
    id uuid primary key,
    user_id uuid not null default auth.uid() references auth.users (id),
    exercise text not null,
    started_at timestamptz not null,
    ended_at timestamptz not null,
    duration_seconds integer not null check (duration_seconds between 0 and 86400),
    total_reps integer not null check (total_reps between 0 and 1000),
    sets_completed integer not null check (sets_completed between 0 and 100),
    avg_rom_degrees double precision not null check (avg_rom_degrees between 0 and 180),
    avg_stability_percent double precision not null check (avg_stability_percent between 0 and 100),
    rom_per_rep jsonb not null,
    stability_per_rep jsonb not null,
    created_at timestamptz not null default now(),
    check (ended_at >= started_at)
);

alter table public.workouts enable row level security;

create policy "Users manage own workouts"
    on public.workouts for all
    using (auth.uid() = user_id)
    with check (auth.uid() = user_id);

-- Weekly ROM/stability log: one row per user per week (derived cache,
-- recomputed by the app whenever insights refresh).
create table public.weekly_logs (
    user_id uuid not null default auth.uid() references auth.users (id),
    week_start date not null,
    days jsonb not null,
    performance double precision,
    total_reps integer not null,
    updated_at timestamptz not null default now(),
    primary key (user_id, week_start)
);

alter table public.weekly_logs enable row level security;

create policy "Users manage own weekly logs"
    on public.weekly_logs for all
    using (auth.uid() = user_id)
    with check (auth.uid() = user_id);

-- Per-day, per-exercise adherence (workout progress log).
create table public.progress_log (
    user_id uuid not null default auth.uid() references auth.users (id),
    date date not null,
    exercise text not null,
    planned_reps integer not null,
    completed_reps integer not null,
    percent double precision not null,
    updated_at timestamptz not null default now(),
    primary key (user_id, date, exercise)
);

alter table public.progress_log enable row level security;

create policy "Users manage own progress log"
    on public.progress_log for all
    using (auth.uid() = user_id)
    with check (auth.uid() = user_id);

-- Least-privilege grants: only signed-in users touch these tables (RLS
-- further narrows rows to their own), and nothing is granted to anon.
grant select, insert on public.workouts to authenticated;
grant select, insert, update on public.weekly_logs to authenticated;
grant select, insert, update on public.progress_log to authenticated;
