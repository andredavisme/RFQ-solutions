-- ============================================================
-- Migration 006: Row Level Security policies
-- Philosophy: RLS by default (governance before data)
-- ============================================================

-- Enable RLS on every table
alter table public.courses                enable row level security;
alter table public.modules                enable row level security;
alter table public.lessons                enable row level security;
alter table public.failure_categories     enable row level security;
alter table public.profiles               enable row level security;
alter table public.enrollments            enable row level security;
alter table public.lesson_progress        enable row level security;
alter table public.capstone_submissions   enable row level security;

-- ============================================================
-- Helper: is the current user an admin?
-- ============================================================
create or replace function public.is_admin()
returns boolean language sql security definer stable as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin'
  );
$$;

-- ============================================================
-- courses — read-only for all authenticated users
-- ============================================================
create policy "courses: authenticated read"
  on public.courses for select
  to authenticated
  using (is_active = true);

create policy "courses: admin full access"
  on public.courses for all
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

-- ============================================================
-- modules — same as courses
-- ============================================================
create policy "modules: authenticated read"
  on public.modules for select
  to authenticated
  using (true);

create policy "modules: admin full access"
  on public.modules for all
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

-- ============================================================
-- lessons — same as modules
-- ============================================================
create policy "lessons: authenticated read"
  on public.lessons for select
  to authenticated
  using (true);

create policy "lessons: admin full access"
  on public.lessons for all
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

-- ============================================================
-- failure_categories — read-only for authenticated
-- ============================================================
create policy "failure_categories: authenticated read"
  on public.failure_categories for select
  to authenticated
  using (true);

create policy "failure_categories: admin full access"
  on public.failure_categories for all
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

-- ============================================================
-- profiles — users see own row; admins see all
-- ============================================================
create policy "profiles: own row"
  on public.profiles for select
  to authenticated
  using (id = auth.uid() or public.is_admin());

create policy "profiles: own update"
  on public.profiles for update
  to authenticated
  using (id = auth.uid())
  with check (id = auth.uid());

create policy "profiles: admin full access"
  on public.profiles for all
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

-- ============================================================
-- enrollments — users see own; admins see all
-- ============================================================
create policy "enrollments: own read"
  on public.enrollments for select
  to authenticated
  using (user_id = auth.uid() or public.is_admin());

create policy "enrollments: own insert"
  on public.enrollments for insert
  to authenticated
  with check (user_id = auth.uid());

create policy "enrollments: admin full access"
  on public.enrollments for all
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

-- ============================================================
-- lesson_progress — users own their rows; admins see all
-- ============================================================
create policy "lesson_progress: own read"
  on public.lesson_progress for select
  to authenticated
  using (user_id = auth.uid() or public.is_admin());

create policy "lesson_progress: own insert"
  on public.lesson_progress for insert
  to authenticated
  with check (user_id = auth.uid());

create policy "lesson_progress: own update"
  on public.lesson_progress for update
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

create policy "lesson_progress: admin full access"
  on public.lesson_progress for all
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

-- ============================================================
-- capstone_submissions — users own their rows; admins review
-- ============================================================
create policy "capstone: own read"
  on public.capstone_submissions for select
  to authenticated
  using (user_id = auth.uid() or public.is_admin());

create policy "capstone: own insert"
  on public.capstone_submissions for insert
  to authenticated
  with check (user_id = auth.uid());

-- Learners may update only while in draft; admins can update any
create policy "capstone: own update draft only"
  on public.capstone_submissions for update
  to authenticated
  using (user_id = auth.uid() and status = 'draft')
  with check (user_id = auth.uid());

create policy "capstone: admin full access"
  on public.capstone_submissions for all
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());
