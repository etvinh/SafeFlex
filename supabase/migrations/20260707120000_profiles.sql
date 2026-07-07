-- Onboarding profile: one row per user, written when first-time
-- onboarding completes.

create table public.profiles (
    user_id uuid primary key default auth.uid() references auth.users (id),
    usage_type text not null check (usage_type in ('prescribed', 'personal')),
    sessions_per_week integer check (sessions_per_week between 1 and 14),
    weight_kg double precision check (weight_kg between 20 and 300),
    pain_description text,
    recommendations jsonb,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

create policy "Users manage own profile"
    on public.profiles for all
    using (auth.uid() = user_id)
    with check (auth.uid() = user_id);

grant select, insert, update on public.profiles to authenticated;
