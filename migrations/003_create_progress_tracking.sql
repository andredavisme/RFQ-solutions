-- ============================================================
-- Migration 003: Lesson progress tracking
-- ============================================================

-- --------------------------------------------------------
-- lesson_progress
-- One row per (user, lesson). Records completion and reflections.
-- --------------------------------------------------------
create table public.lesson_progress (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null references public.profiles (id) on delete cascade,
  lesson_id       uuid not null references public.lessons (id) on delete cascade,
  status          text not null default 'not_started'
                    check (status in ('not_started', 'in_progress', 'completed')),
  started_at      timestamptz,
  completed_at    timestamptz,
  reflection_text text,                  -- learner's free-form written reflection
  reflection_submitted_at timestamptz,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  unique (user_id, lesson_id)
);

comment on table public.lesson_progress is
  'Per-user, per-lesson progress record. Stores completion status and written reflections.';
comment on column public.lesson_progress.reflection_text is
  'The learner''s written reflection after completing the lesson.';
comment on column public.lesson_progress.status is
  'not_started → in_progress → completed. Only moves forward.';

create trigger trg_lesson_progress_updated_at
  before update on public.lesson_progress
  for each row execute function public.set_updated_at();

-- Enforce forward-only status progression
create or replace function public.enforce_lesson_progress_forward()
returns trigger language plpgsql as $$
declare
  order_map text[] := array['not_started','in_progress','completed'];
  old_rank int;
  new_rank int;
begin
  old_rank := array_position(order_map, old.status);
  new_rank := array_position(order_map, new.status);
  if new_rank < old_rank then
    raise exception 'lesson_progress.status cannot move backwards (% → %)',
      old.status, new.status;
  end if;
  -- Auto-set timestamps
  if new.status = 'in_progress' and old.status = 'not_started' then
    new.started_at := coalesce(new.started_at, now());
  end if;
  if new.status = 'completed' and old.status != 'completed' then
    new.completed_at := coalesce(new.completed_at, now());
  end if;
  return new;
end;
$$;

create trigger trg_enforce_lesson_progress_forward
  before update on public.lesson_progress
  for each row execute function public.enforce_lesson_progress_forward();

-- Indexes for common queries
create index idx_lesson_progress_user   on public.lesson_progress (user_id);
create index idx_lesson_progress_lesson on public.lesson_progress (lesson_id);
create index idx_lesson_progress_status on public.lesson_progress (user_id, status);

-- --------------------------------------------------------
-- module_progress (computed summary view)
-- --------------------------------------------------------
create or replace view public.module_progress_summary as
select
  lp.user_id,
  l.module_id,
  count(*)                                    as total_lessons,
  count(*) filter (where lp.status = 'completed') as completed_lessons,
  round(
    count(*) filter (where lp.status = 'completed')::numeric
    / nullif(count(*), 0) * 100
  , 0)                                        as pct_complete,
  max(lp.completed_at)                        as last_completed_at
from public.lesson_progress lp
join public.lessons l on l.id = lp.lesson_id
group by lp.user_id, l.module_id;

comment on view public.module_progress_summary is
  'Aggregated progress per user per module. Computed from lesson_progress.';
