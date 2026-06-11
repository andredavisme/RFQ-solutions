# RFQ Communication Essentials: Data Flow, Accuracy, and Business Trust

## Course Overview

This course trains business professionals to identify, diagnose, and fix the communication and data-flow failures that corrupt RFQ processes — from intake to fulfillment.

Grounded in 12 source repositories of real operational patterns, the course builds practical skills in:
- Recognizing failure modes before they become costly
- Designing intake flows that preserve data integrity
- Communicating commitments with proof, not declarations
- Managing vendor data translation and confirmation discipline
- Applying governance and naming conventions that scale

## Platform Architecture

- **Backend:** Supabase (`rfq_course_app` schema)
- **Content model:** Lesson bodies as versioned markdown in this repo; database stores metadata, structure, and learner state
- **Lesson format:** Micro-mission loop — Context → Concept → Work Lab → Reflection → Metrics Hook
- **Analysis layer:** Aggregate learner response data surfaced for admin/instructor view only

## Module Index

| Module | Title | Focus |
|--------|-------|-------|
| [01](modules/module-01-seeing-failures/README.md) | Seeing the Failures | Observation and failure classification before solutions |
| [02](modules/module-02-intake/README.md) | Intake and Minimum Viable Complete Record | Stop failures at the door |
| [03](modules/module-03-communication/README.md) | Communication and Commitment Discipline | Voice, proof, and specific commitments |
| [04](modules/module-04-vendor-flows/README.md) | Vendor and External Party Data Flows | Translation layers, confirmation status, routing |
| [05](modules/module-05-governance/README.md) | Governance, Naming, and Data Architecture | Design decisions that make everything else easier |

## Machine-Readable Schema Files

- [`_schema/course-manifest.json`](_schema/course-manifest.json) — Full lesson index for database seeding
- [`_schema/failure-categories.json`](_schema/failure-categories.json) — Controlled vocabulary for failure classification dropdowns

## Database Tables

| Table | Purpose |
|-------|---------|
| `rfq_course_app.scenario_responses` | Learner failure classifications and reasoning per scenario |
| `rfq_course_app.lesson_reflections` | Past/present/future reflection entries per learner per lesson |
| `rfq_course_app.assessments` | Post-module knowledge checks |
