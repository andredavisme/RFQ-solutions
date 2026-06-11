-- ============================================================
-- Migration 004: Capstone submissions (Module 05 lesson 5-5)
-- ============================================================

-- --------------------------------------------------------
-- capstone_submissions
-- One capstone per user per course.
-- --------------------------------------------------------
create table public.capstone_submissions (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null references public.profiles (id) on delete cascade,
  course_id      uuid not null references public.courses (id) on delete cascade,
  -- The three-part capstone structure from lesson 5-5
  failure_identified    text not null,     -- which failure type the learner chose
  before_state          text not null,     -- description of the broken state
  after_state           text not null,     -- description of the fixed state
  data_principle_used   text not null,     -- which principle from the course anchors the fix
  -- Review workflow
  status         text not null default 'draft'
                   check (status in ('draft', 'submitted', 'reviewed')),
  reviewer_notes text,
  submitted_at   timestamptz,
  reviewed_at    timestamptz,
  reviewed_by    uuid references public.profiles (id) on delete set null,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),
  unique (user_id, course_id)
);

comment on table public.capstone_submissions is
  'Capstone project submissions. One per (user, course). Review workflow: draft → submitted → reviewed.';
comment on column public.capstone_submissions.failure_identified is
  'The failure category the learner selected as their capstone focus.';
comment on column public.capstone_submissions.data_principle_used is
  'The course principle (named, not vague) the learner applied to resolve the failure.';

create trigger trg_capstone_updated_at
  before update on public.capstone_submissions
  for each row execute function public.set_updated_at();

-- Auto-stamp submitted_at on status change to submitted
create or replace function public.stamp_capstone_submitted_at()
returns trigger language plpgsql as $$
begin
  if new.status = 'submitted' and old.status = 'draft' then
    new.submitted_at := coalesce(new.submitted_at, now());
  end if;
  if new.status = 'reviewed' and old.status = 'submitted' then
    new.reviewed_at := coalesce(new.reviewed_at, now());
  end if;
  return new;
end;
$$;

create trigger trg_stamp_capstone_timestamps
  before update on public.capstone_submissions
  for each row execute function public.stamp_capstone_submitted_at();

create index idx_capstone_user   on public.capstone_submissions (user_id);
create index idx_capstone_status on public.capstone_submissions (status);
