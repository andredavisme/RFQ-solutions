-- ============================================================
-- Migration 002: User profiles and enrollment
-- ============================================================

-- --------------------------------------------------------
-- profiles
-- One row per authenticated Supabase user.
-- Extends auth.users without modifying it.
-- --------------------------------------------------------
create table public.profiles (
  id           uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  email        text,                    -- cached for display; source of truth is auth.users
  role         text not null default 'learner'
                  check (role in ('learner', 'admin')),
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

comment on table public.profiles is
  'Public-facing user profile extending auth.users. One row per user.';
comment on column public.profiles.role is
  'learner: standard course access. admin: course management access.';

create trigger trg_profiles_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

-- Auto-create a profile row when a new auth user is created
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, display_name, email)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'display_name', new.email),
    new.email
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

create trigger trg_on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- --------------------------------------------------------
-- enrollments
-- Tracks which users are enrolled in which courses.
-- --------------------------------------------------------
create table public.enrollments (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references public.profiles (id) on delete cascade,
  course_id   uuid not null references public.courses (id) on delete cascade,
  enrolled_at timestamptz not null default now(),
  unique (user_id, course_id)
);

comment on table public.enrollments is
  'Course enrollment records. A user may enroll in many courses.';

create index idx_enrollments_user   on public.enrollments (user_id);
create index idx_enrollments_course on public.enrollments (course_id);
