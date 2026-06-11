-- ============================================================
-- Migration 001: Core course schema
-- rfq_course_app
-- Creates: courses, modules, lessons tables
-- ============================================================

-- Enable UUID generation
create extension if not exists "pgcrypto";

-- --------------------------------------------------------
-- courses
-- --------------------------------------------------------
create table public.courses (
  id          uuid primary key default gen_random_uuid(),
  slug        text not null unique,
  title       text not null,
  description text,
  version     text not null default '1.0.0',
  is_active   boolean not null default true,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

comment on table public.courses is
  'Top-level course records. One row per published course.';

-- --------------------------------------------------------
-- modules
-- --------------------------------------------------------
create table public.modules (
  id           uuid primary key default gen_random_uuid(),
  course_id    uuid not null references public.courses (id) on delete cascade,
  slug         text not null,
  sort_order   smallint not null,
  title        text not null,
  description  text,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  unique (course_id, slug),
  unique (course_id, sort_order)
);

comment on table public.modules is
  'Course modules, ordered within a course. Cascades deletes from courses.';
comment on column public.modules.sort_order is
  '1-based display order within the parent course.';

-- --------------------------------------------------------
-- lessons
-- --------------------------------------------------------
create table public.lessons (
  id              uuid primary key default gen_random_uuid(),
  module_id       uuid not null references public.modules (id) on delete cascade,
  slug            text not null,
  sort_order      smallint not null,
  title           text not null,
  failure_category_slug text,          -- optional link to a failure category
  content_path    text,                -- relative path in repo, e.g. course/modules/.../lesson-1-1.md
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  unique (module_id, slug),
  unique (module_id, sort_order)
);

comment on table public.lessons is
  'Individual lessons within a module. Cascades deletes from modules.';
comment on column public.lessons.failure_category_slug is
  'Links to failure_categories.slug when the lesson is anchored to a specific failure type.';
comment on column public.lessons.content_path is
  'Relative repo path for the source Markdown file. Used for admin reference, not runtime.';

-- --------------------------------------------------------
-- failure_categories
-- (separate table; lessons may reference it)
-- --------------------------------------------------------
create table public.failure_categories (
  id          uuid primary key default gen_random_uuid(),
  slug        text not null unique,
  label       text not null,
  description text,
  created_at  timestamptz not null default now()
);

comment on table public.failure_categories is
  'Controlled vocabulary for failure types, drawn from course/_schema/failure-categories.json.';

-- Add FK from lessons → failure_categories
alter table public.lessons
  add constraint fk_lessons_failure_category
  foreign key (failure_category_slug)
  references public.failure_categories (slug)
  on update cascade
  on delete set null;

-- --------------------------------------------------------
-- updated_at auto-maintenance
-- --------------------------------------------------------
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger trg_courses_updated_at
  before update on public.courses
  for each row execute function public.set_updated_at();

create trigger trg_modules_updated_at
  before update on public.modules
  for each row execute function public.set_updated_at();

create trigger trg_lessons_updated_at
  before update on public.lessons
  for each row execute function public.set_updated_at();
