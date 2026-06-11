# RFQ-Solutions Project Tracker

**Purpose:** Assemble knowledge and philosophies from source repositories into a standalone, in-depth business knowledge guide — focused on improving data flow, preservation, accessibility, and accuracy across lines of business and with external parties (customers, vendors, transportation logistics).

**Space Context:** Communication Essential for Requests for Service

**Last Updated:** 2026-06-11

---

## 🗂️ Source Repositories

| # | Repo | Status | Output File | Notes |
|---|------|--------|-------------|-------|
| 1 | [finfolio](https://github.com/andredavisme/finfolio) | ✅ Complete | `guide/01-finfolio.md` | Data ownership, single source of truth, intake normalization, dirty-state visibility, round-trip fidelity |
| 2 | [underdog-war-room](https://github.com/andredavisme/underdog-war-room) | ✅ Complete | `guide/02-underdog-war-room.md` | Competitive intelligence as data, battlecard model, proof over declarations, pilot as proof, objection handling as structured data |
| 3 | [parts-spec-matcher](https://github.com/andredavisme/parts-spec-matcher) | ✅ Complete | `guide/03-parts-spec-matcher.md` | RFQ information asymmetry, schema isolation, vendor/distributor distinction, guided spec intake, transparent matching, authorization-driven routing, status lifecycle, role-based access, database integrity |
| 4 | [tech-debt-explorer](https://github.com/andredavisme/tech-debt-explorer) | ✅ Complete | `guide/04-tech-debt-explorer.md` | Expectation gaps, survivable governance, naming conventions, documentation debt, standard-before-custom, time-to-change as health signal, data quality amplification, rebuild vs. refactor |
| 5 | [data-solutions-for-me](https://github.com/andredavisme/data-solutions-for-me) | ✅ Complete | `guide/05-data-solutions-for-me.md` | Expectation-deviation-adaptation framework, automatic vs. manual events, two-stage event pipeline, context isolation, realtime visibility, annotation discipline, portfolio-ready scoping, exception documentation |
| 6 | [westbrook-datacenter-informed](https://github.com/andredavisme/westbrook-datacenter-informed) | ✅ Complete | `guide/06-westbrook-datacenter-informed.md` | Moratorium as decision discipline, taxonomy before evaluation, findings of fact, vision gap, risk register, opportunity list as negotiating positions, buyer-built comparison table, countdown forcing function, template principle |
| 7 | [data-cleaning-guide](https://github.com/andredavisme/data-cleaning-guide) | ✅ Complete | `guide/07-data-cleaning-guide.md` | Transformation as contract, raw data sacred, zone architecture, audit trails, null type classification, idempotency, schema assertions, scale awareness, profile before analysis |
| 8 | [field-tech-blueprint](https://github.com/andredavisme/field-tech-blueprint) | ✅ Complete | `guide/08-field-tech-blueprint.md` | Talent as infrastructure, PAE model, coachability over credentials, LOTO calm assertion, manual before instinct, root cause over symptom, documentation over verbal, PAE scenario stress-testing |
| 9 | [sales-scenario-training-portal](https://github.com/andredavisme/sales-scenario-training-portal) | ✅ Complete | `guide/09-sales-scenario-training-portal.md` | Dual-deliverable design, schema as minimum viable record, explicit access control vs. friction, voice discipline, stateless design as feature, migration convention, post-mortem + rule change, non-negotiable constraints |
| 10 | [internationally-tribal](https://github.com/andredavisme/internationally-tribal) | ✅ Complete | `guide/10-internationally-tribal.md` | AI as hammer not artist, creative brief before prompt, direction vs. execution model, inventory of human authorship, 5-phase build, judgment as asset to protect |
| 11 | [fork-in-the-road](https://github.com/andredavisme/fork-in-the-road) | ✅ Complete | `guide/11-fork-in-the-road.md` | Story-first positioning as evidence inventory, segment-specific data design, constraints as architecture inputs, pay-it-forward data integrity, request operations as data asset, templates as data contracts, actionable-only metrics, lean stack as risk management |
| 12 | [alexandria](https://github.com/andredavisme/alexandria) | ✅ Complete | `guide/12-alexandria.md` | Database as ecosystem single source of truth, append-only migration history, RLS by default, schema separation as domain enforcement, contribution workflow as change control, secrets in Vault never in code, governance before data, foundation discipline |

**Status Key:** ⬜ Not Started · 🔄 In Progress · ✅ Complete

---

## 📚 Course: RFQ Data Integrity (5 Modules)

A standalone, scenario-driven course built from the principles extracted across all 12 source repos. Each module has a README and numbered lesson files.

| Module | Title | Status | Lessons | Key Concepts |
|--------|-------|--------|---------|---------------|
| 01 | Seeing Failures | ✅ Complete | 6 (1.1–1.6) | Five failure taxonomy: missing data, dirty state, broken chain of custody, unauthorized substitution, communication failure |
| 02 | Intake Architecture | ✅ Complete | 4 (2.1–2.4) | Minimum viable complete record, three-property framework (authoritative/required/validated), dirty-state lifecycle |
| 03 | Communication Discipline | ✅ Complete | 4 (3.1–3.4) | Declaration vs. proof, voice discipline, specific commitment anatomy, objection as structured data |
| 04 | Vendor and External Party Data Flows | ✅ Complete | 4 (4.1–4.4) | Translation layer, confirmed vs. estimated certainty spectrum, vendor vs. distributor reliability profiles, authorization-driven routing |
| 05 | Governance, Naming, and Data Architecture | ✅ Complete | 5 (5.1–5.5) | Naming conventions, append-only migration, database as contract, AI three-gate review, capstone |

**Course total: 23 lessons across 5 modules. All lesson files committed.**

---

## ⏳ Remaining Work

| Item | Status | Depends On | Notes |
|------|--------|------------|-------|
| `rfq_course_app` schema migrations | ✅ Complete | All modules complete ✅ | 6 migration files committed to `migrations/` |
| `MASTER-GUIDE.md` synthesis | ⬜ Not Started | All guide files complete ✅ | Synthesize all 12 `guide/` files into a single standalone business guide |

---

## 🏁 Next Steps

### Next: MASTER-GUIDE.md Synthesis

Schema migrations are complete. The final step is to synthesize all 12 guide files into `MASTER-GUIDE.md`.

To begin the synthesis session, paste the following into a new conversation:

> **"I'm continuing the RFQ-solutions project. The repo is at https://github.com/andredavisme/RFQ-solutions. Schema migrations are complete. Please read all 12 guide files in the guide/ directory and synthesize them into MASTER-GUIDE.md — a standalone, in-depth business guide for improving data flow, preservation, accessibility, and accuracy across lines of business and with external parties (customers, vendors, transportation logistics)."**

---

## 📁 Output Structure

```
RFQ-solutions/
├── PROJECT-TRACKER.md              ← This file
├── README.md                       ← Project overview
├── guide/
│   ├── 01-finfolio.md
│   ├── 02-underdog-war-room.md
│   ├── 03-parts-spec-matcher.md
│   ├── 04-tech-debt-explorer.md
│   ├── 05-data-solutions-for-me.md
│   ├── 06-westbrook-datacenter-informed.md
│   ├── 07-data-cleaning-guide.md
│   ├── 08-field-tech-blueprint.md
│   ├── 09-sales-scenario-training-portal.md
│   ├── 10-internationally-tribal.md
│   ├── 11-fork-in-the-road.md
│   └── 12-alexandria.md
├── course/
│   ├── README.md
│   ├── _schema/
│   │   ├── failure-categories.json
│   │   └── course-manifest.json
│   └── modules/
│       ├── module-01-seeing-failures/   (README + lessons 1.1–1.6)
│       ├── module-02-intake/            (README + lessons 2.1–2.4)
│       ├── module-03-communication/     (README + lessons 3.1–3.4)
│       ├── module-04-vendor-flows/      (README + lessons 4.1–4.4)
│       └── module-05-governance/        (README + lessons 5.1–5.5)
├── migrations/
│   ├── 001_create_course_schema.sql
│   ├── 002_create_user_enrollment.sql
│   ├── 003_create_progress_tracking.sql
│   ├── 004_create_capstone_submissions.sql
│   ├── 005_seed_course_data.sql
│   └── 006_enable_rls.sql
└── MASTER-GUIDE.md                 ← Final synthesized guide (next step)
```

---

## 📝 Session Log

| Date | Session Summary |
|------|-----------------|
| 2026-06-10 | Project initialized. Repo created. Tracking document added. Ready to begin with repo #1: finfolio. |
| 2026-06-10 | Completed repos #1–10. Wrote guide files 01 through 10 covering: data ownership & round-trip fidelity (finfolio); competitive intelligence as data (underdog-war-room); RFQ data architecture & transparent matching (parts-spec-matcher); technical debt as governance problem (tech-debt-explorer); expectation-deviation-adaptation framework (data-solutions-for-me); informed decision-making & negotiation under time pressure (westbrook-datacenter-informed); pipeline zone architecture & data integrity contracts (data-cleaning-guide); workforce pipeline ROI & PAE model (field-tech-blueprint); scenario-based training design & post-mortem discipline (sales-scenario-training-portal); AI as creative collaborator, direction vs. execution, human authorship as asset (internationally-tribal). Next: repo #11 fork-in-the-road. |
| 2026-06-11 | Completed repo #11 fork-in-the-road. Wrote guide/11-fork-in-the-road.md covering: story-first positioning as evidence inventory, segment-specific data design, constraints as architecture inputs, pay-it-forward data integrity model, request operations as data asset, outreach templates as data contracts, actionable-only metrics, lean stack as risk management. One repo remaining: #12 alexandria. |
| 2026-06-11 | Completed repo #12 alexandria. Wrote guide/12-alexandria.md covering: database as ecosystem single source of truth, append-only migration history, RLS by default (security as architecture), schema separation as domain boundary enforcement, contribution workflow as change control process, secrets in Vault never in code, governance before data, foundation discipline as ecosystem maturity signal. ALL 12 SOURCE REPOS COMPLETE. |
| 2026-06-11 | Built course scaffold: course/README.md, _schema/failure-categories.json, _schema/course-manifest.json. Wrote all 5 module READMEs (02–05 in one session, 01 previously). |
| 2026-06-11 | Completed all course lesson files: Module 01 (6 lessons), Module 02 (4 lessons), Module 03 (4 lessons), Module 04 (4 lessons), Module 05 (5 lessons). 23 lessons total across 5 modules. COURSE COMPLETE. |
| 2026-06-11 | Wrote and committed 6 schema migrations for rfq_course_app to migrations/. Schema covers: courses/modules/lessons/failure_categories (001), user profiles + enrollment + auto-create trigger (002), lesson_progress with forward-only enforcement + module_progress_summary view (003), capstone_submissions with review workflow (004), seed data from course-manifest.json for all 23 lessons (005), RLS policies on all 8 tables with is_admin() helper (006). ONE ITEM REMAINING: MASTER-GUIDE.md synthesis. |
