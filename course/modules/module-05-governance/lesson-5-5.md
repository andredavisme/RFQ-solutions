# Lesson 5.5 — Capstone: The Complete RFQ Data Architecture

**Module:** 05 — Governance, Naming, and Data Architecture
**Concept:** Integrate all five modules into a complete, production-ready RFQ data architecture spec

---

## Context

This is the capstone lesson. It does not introduce new concepts. It requires you to apply every concept from every module to a single, integrated design problem: a complete RFQ data architecture for a mid-size industrial distributor.

The capstone is a design and documentation exercise, not a coding exercise. Its deliverable is a specification document that a development team could use to build, migrate, or audit a real system.

---

## The Capstone Scenario

**Organization:** Meridian Industrial Supply — a mid-size industrial distributor with 45 employees, processing approximately 200 RFQs per week across 8 product categories, sourcing from 60 active vendors (a mix of manufacturers and distributors), and serving 300 active customer accounts.

**Current state:** All RFQ processing is handled in a combination of email threads, a shared spreadsheet ("THE Master Quote Sheet v17_FINAL_USE_THIS_ONE.xlsx"), and a legacy ERP system that was last meaningfully updated in 2019. Data entry is manual. Lead times and prices are tracked in free-text fields. There is no controlled vocabulary. Substitutions are approved informally by whoever is available. No audit log exists.

**Trigger for change:** In the past 6 months, Meridian has experienced:
- 3 customer escalations due to committed ship dates that were based on estimated (not confirmed) vendor lead times
- 2 substitutions shipped without customer authorization, resulting in returns
- 1 pricing dispute that could not be resolved because no quote history was retained
- Ongoing cycle time variance: the same RFQ type takes between 2 hours and 4 days depending on who handles it

**Your assignment:** Design the complete data architecture that would address all five failure categories above and implement all five modules of this course.

---

## Capstone Deliverables

### Deliverable 1: Failure Classification Map
*(Module 01)*

For each of the four documented failure incidents (committed date from estimated data, 2 unauthorized substitutions, pricing dispute, cycle time variance):

1. Classify using the Module 01 failure taxonomy (missing data, dirty state, broken chain of custody, unauthorized substitution, communication failure)
2. Identify the specific failure point in the data flow
3. Identify which Module 02–05 construct would have prevented it

### Deliverable 2: Complete Intake Schema
*(Module 02)*

Design the complete `rfq_requests` table and all supporting tables required for Meridian's intake process:

- All required and optional fields with data types
- `NOT NULL` constraints on required fields
- All controlled vocabulary fields with the defined value set
- The dirty-state lifecycle (`draft → pending → confirmed → fulfilled`) with `status_changed_at` and `status_changed_by` fields
- All foreign key relationships
- The intake completeness checklist encoded as `CHECK` constraints or application-layer validation rules

### Deliverable 3: Communication Discipline Rules
*(Module 03)*

Write five communication discipline rules for Meridian's RFQ workflow:

- Each rule must be a specific, enforceable statement (not a general principle)
- Each rule must identify the data field or system behavior that enforces it
- Include rules for: declaration vs. proof requirements, commitment anatomy (date + owner + observable outcome), and escalation triggers
- Write example compliant and non-compliant communications for each rule

### Deliverable 4: Vendor Data Architecture
*(Module 04)*

Design the complete vendor data architecture:

- `vendors` table with `vendor_type` (`manufacturer` | `distributor` | `broker`) and all governance fields
- `vendor_parts` translation table with `effective_from` / `effective_to` versioning
- `uom_mappings` table
- `vendor_quote_lines` table with field-level certainty tagging (`price_status`, `lead_time_status`, `lead_time_basis`)
- `routing_rules` and `routing_events` tables
- Five routing rules for Meridian's most common request types, including substitution and lead time extension triggers

### Deliverable 5: Governance Specification
*(Module 05)*

Write the governance specification document for Meridian's new system:

- Naming conventions document (the five rules from Lesson 5.1, plus any Meridian-specific additions)
- Migration policy (append-only principle, deprecation period, migration checklist)
- Constraint inventory (for each table in Deliverable 2 and 4, list all constraints and the business rule each encodes)
- AI collaboration policy (three-gate review checklist for the two most common AI use cases in Meridian's workflow)
- Governance review cadence (who reviews what, how often, and what triggers an out-of-cycle review)

---

## Evaluation Criteria

The capstone specification is evaluated against five dimensions:

| Dimension | What reviewers look for |
|-----------|------------------------|
| **Coverage** | All four failure incidents are addressed; no Module 01–05 concept is absent from the design |
| **Specificity** | Field names follow the conventions; controlled vocabularies are defined, not gestured at; constraints are written as SQL, not described in prose |
| **Integration** | The five deliverables form a coherent whole — a field defined in Deliverable 2 appears correctly referenced in Deliverable 4; a routing rule in Deliverable 4 is consistent with a communication rule in Deliverable 3 |
| **Governance discipline** | The naming convention document is applied consistently across all table designs; the migration policy is referenced in the constraint inventory |
| **Practical applicability** | A development team reading the specification could implement it without significant clarification — ambiguities are resolved, not deferred |

---

## Submission

The capstone specification is submitted as a structured document in `rfq_course_app.capstone_submissions` with the following fields:

```
capstone_submissions
─────────────────────────────────────────────────────────────────
submission_id        uuid
student_id           fk → users
submitted_at         timestamptz
deliverable_1        text            -- failure classification map
deliverable_2        text            -- intake schema (SQL + rationale)
deliverable_3        text            -- communication discipline rules
deliverable_4        text            -- vendor data architecture (SQL + rationale)
deliverable_5        text            -- governance specification document
reviewer_id          fk → users      -- null until reviewed
reviewed_at          timestamptz
review_notes         text
status               controlled vocab  -- 'submitted' | 'under_review' | 'approved' | 'revision_requested'
```

---

## A Final Reflection

Before submitting the capstone, answer one question:

> **What is the single highest-leverage change you could make in your current environment — right now, before any new system is built — that would prevent the failure type most common in your work?**

This question has a specific answer. It is not "implement a new system" or "train the team." It is a concrete, actionable change: a field that needs a constraint, a vocabulary that needs to be defined, a routing rule that needs to be documented, a confirmation event that needs to be required.

The organizations that improve their data flows are not the ones that redesign everything at once. They are the ones that apply the next right constraint, document the next right convention, and enforce the next right rule — continuously, with discipline, one decision at a time.

> **Reflection recorded in:** `rfq_course_app.capstone_submissions`

---

## Course Complete

You have completed the five modules of this course:

| Module | Core contribution |
|--------|------------------|
| 01 — Seeing Failures | A taxonomy for recognizing the five failure patterns before they propagate |
| 02 — Intake Architecture | A completeness framework and dirty-state lifecycle that prevents failures at the entry point |
| 03 — Communication Discipline | The language and structure that makes commitments verifiable and objections productive |
| 04 — Vendor Data Flows | A translation layer, certainty spectrum, source authority model, and routing matrix for external data |
| 05 — Governance | Naming conventions, safe migration, schema constraints, and AI collaboration review as the durable infrastructure of data integrity |

The capstone is not the end of this work — it is the beginning of a practice.

**Previous:** [Lesson 5.4 — AI Collaboration and the Three-Gate Review](lesson-5-4.md)
