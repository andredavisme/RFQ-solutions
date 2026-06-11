-- ============================================================
-- Migration 005: Seed data — course, modules, lessons, failure categories
-- Derived from course/_schema/course-manifest.json
-- ============================================================

-- --------------------------------------------------------
-- Failure categories (from failure-categories.json)
-- --------------------------------------------------------
insert into public.failure_categories (slug, label) values
  ('no-single-source-of-truth',              'No Single Source of Truth'),
  ('dirty-state-visibility-missing',         'Dirty State — Visibility Missing'),
  ('intake-minimum-viable-record-failure',   'Intake — Minimum Viable Record Failure'),
  ('vague-commitments-declarations-instead-of-proof', 'Vague Commitments / Declarations Instead of Proof'),
  ('transparent-substitution-failure',       'Transparent Substitution Failure'),
  ('naming-governance-confusion',            'Naming / Governance Confusion')
on conflict (slug) do nothing;

-- --------------------------------------------------------
-- Course
-- --------------------------------------------------------
insert into public.courses (slug, title, description, version) values (
  'rfq-communication-essentials',
  'RFQ Communication Essentials: Data Flow, Accuracy, and Business Trust',
  'Train business professionals to identify, diagnose, and fix the communication and data-flow failures that corrupt RFQ processes from intake to fulfillment.',
  '1.0.0'
)
on conflict (slug) do nothing;

-- --------------------------------------------------------
-- Modules (using a CTE to avoid hardcoding UUIDs)
-- --------------------------------------------------------
with course as (select id from public.courses where slug = 'rfq-communication-essentials')
insert into public.modules (course_id, slug, sort_order, title, description)
select
  course.id,
  m.slug,
  m.sort_order,
  m.title,
  m.description
from course, (values
  (1, 'seeing-failures',  'Seeing the Failures',
   'Observation and acknowledgment before any solution. Learners classify failure scenarios using controlled vocabulary before the expert lens is revealed.'),
  (2, 'intake',           'Intake and Minimum Viable Complete Record',
   'Rebuild forms and intake flows so failures stop at the door.'),
  (3, 'communication',    'Communication and Commitment Discipline',
   'Voice, proof, and specific commitments.'),
  (4, 'vendor-flows',     'Vendor and External Party Data Flows',
   'Translation layers, confirmation status, and routing.'),
  (5, 'governance',       'Governance, Naming, and Data Architecture',
   'Design decisions that make everything else easier.')
) as m(sort_order, slug, title, description)
on conflict (course_id, slug) do nothing;

-- --------------------------------------------------------
-- Lessons
-- --------------------------------------------------------
with mods as (
  select m.id, m.slug as module_slug
  from public.modules m
  join public.courses c on c.id = m.course_id
  where c.slug = 'rfq-communication-essentials'
)
insert into public.lessons (module_id, slug, sort_order, title, failure_category_slug, content_path)
select mods.id, l.slug, l.sort_order, l.title, l.failure_category_slug, l.content_path
from mods
join (values
  -- Module 01
  ('seeing-failures', 1, 'three-prices-zero-truth',        'Three Prices, Zero Truth',              'no-single-source-of-truth',             'course/modules/module-01-seeing-failures/lesson-1-1.md'),
  ('seeing-failures', 2, 'vendor-lead-time-that-wasnt',    'The Vendor Lead Time That Wasn''t',      'dirty-state-visibility-missing',        'course/modules/module-01-seeing-failures/lesson-1-2.md'),
  ('seeing-failures', 3, 'form-that-let-anything-through', 'The Form That Let Anything Through',    'intake-minimum-viable-record-failure',   'course/modules/module-01-seeing-failures/lesson-1-3.md'),
  ('seeing-failures', 4, 'well-look-into-it',              'We''ll Look Into It',                    'vague-commitments-declarations-instead-of-proof', 'course/modules/module-01-seeing-failures/lesson-1-4.md'),
  ('seeing-failures', 5, 'substitution-nobody-mentioned',  'The Substitution Nobody Mentioned',     'transparent-substitution-failure',      'course/modules/module-01-seeing-failures/lesson-1-5.md'),
  ('seeing-failures', 6, 'status-field-that-lied',         'The Status Field That Lied',            'naming-governance-confusion',           'course/modules/module-01-seeing-failures/lesson-1-6.md'),
  -- Module 02
  ('intake', 1, 'what-makes-a-record-complete',    'What Makes a Record Complete',           null, 'course/modules/module-02-intake/lesson-2-1.md'),
  ('intake', 2, 'controlled-vocabulary-in-practice','Controlled Vocabulary in Practice',     null, 'course/modules/module-02-intake/lesson-2-2.md'),
  ('intake', 3, 'normalization-before-storage',    'Normalization Before Storage',           null, 'course/modules/module-02-intake/lesson-2-3.md'),
  ('intake', 4, 'dirty-state-as-feature',          'Dirty State as a Feature, Not a Bug',   null, 'course/modules/module-02-intake/lesson-2-4.md'),
  -- Module 03
  ('communication', 1, 'declarations-vs-proof',    'Declarations vs. Proof',                null, 'course/modules/module-03-communication/lesson-3-1.md'),
  ('communication', 2, 'voice-discipline',         'Voice Discipline',                      null, 'course/modules/module-03-communication/lesson-3-2.md'),
  ('communication', 3, 'specific-commitments',     'Specific Commitments',                  null, 'course/modules/module-03-communication/lesson-3-3.md'),
  ('communication', 4, 'objection-as-data',        'The Objection as Data',                 null, 'course/modules/module-03-communication/lesson-3-4.md'),
  -- Module 04
  ('vendor-flows', 1, 'translation-layer',         'The Translation Layer',                 null, 'course/modules/module-04-vendor-flows/lesson-4-1.md'),
  ('vendor-flows', 2, 'confirmed-vs-estimated',    'Confirmed vs. Estimated',               null, 'course/modules/module-04-vendor-flows/lesson-4-2.md'),
  ('vendor-flows', 3, 'vendor-vs-distributor',     'Vendor vs. Distributor',                null, 'course/modules/module-04-vendor-flows/lesson-4-3.md'),
  ('vendor-flows', 4, 'authorization-driven-routing','Authorization-Driven Routing',        null, 'course/modules/module-04-vendor-flows/lesson-4-4.md'),
  -- Module 05
  ('governance', 1, 'names-are-documentation',     'Names Are Documentation',               null, 'course/modules/module-05-governance/lesson-5-1.md'),
  ('governance', 2, 'governance-before-data',      'Governance Before Data',                null, 'course/modules/module-05-governance/lesson-5-2.md'),
  ('governance', 3, 'migration-as-append-only-history','Migration as Append-Only History',  null, 'course/modules/module-05-governance/lesson-5-3.md'),
  ('governance', 4, 'database-as-contract',        'The Database as Contract',              null, 'course/modules/module-05-governance/lesson-5-4.md'),
  ('governance', 5, 'ai-as-collaboration-not-delegation','AI as Collaboration, Not Delegation', null, 'course/modules/module-05-governance/lesson-5-5.md')
) as l(module_slug, sort_order, slug, title, failure_category_slug, content_path)
  on mods.module_slug = l.module_slug
on conflict (module_id, slug) do nothing;
