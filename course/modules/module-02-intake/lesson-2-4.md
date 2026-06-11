# Lesson 2.4 — Dirty State as a Feature, Not a Bug

**Module:** 02 — Intake and Minimum Viable Complete Record
**Concept:** Build draft → pending → confirmed → fulfilled status lifecycles

---

## Context

Lesson 1.2 showed what happens when estimated data is treated as confirmed. That failure has a structural solution: build the distinction into the data model itself.

The term "dirty state" refers to any record that is incomplete, unconfirmed, or in-progress. Dirty state is not a problem to be hidden — it is information to be surfaced. A record in draft state tells the system: *do not route this, do not quote from this, do not commit to this.* A record in confirmed state says: *this is ready to act on.*

The failure is not having dirty data. The failure is having no mechanism to tell the difference.

---

## Concept: The Status Lifecycle

A status lifecycle defines the valid states a record can occupy, the valid transitions between states, and what each state permits downstream.

### The Four-Stage Lifecycle

For most RFQ-related records, a four-stage lifecycle covers the required distinctions:

```
draft → pending → confirmed → fulfilled
```

| Stage | Meaning | What it permits |
|-------|---------|------------------|
| `draft` | Record exists but is incomplete; not yet submitted for processing | No downstream action; can be edited freely |
| `pending` | Record is submitted and under review or awaiting confirmation from an external party | Read-only for submitter; can trigger notifications; cannot be used in commitments |
| `confirmed` | Record has been validated, approved, or confirmed by the authoritative party | Can be used in downstream commitments; read-only except for authorized changes |
| `fulfilled` | Record's purpose is complete (shipped, paid, delivered, etc.) | Archived; changes require a new record or amendment |

### Transition Rules

Not every transition is valid. A record should not be able to move from `draft` directly to `fulfilled`, or from `fulfilled` back to `draft`. Transition rules are enforced in the application layer (or database constraints), not left to user judgment.

Example transition rules for an order record:

```
draft       → pending     ≈ all MVCR fields are present and validated
pending     → confirmed   ≈ authorized approver has reviewed and approved
pending     → draft       ≈ rejection: record returned for correction (with reason)
confirmed   → fulfilled   ≈ fulfillment event recorded (shipped_at timestamp populated)
confirmed   → pending     ≈ amendment: authorized change request submitted
fulfilled   → [no transition] ≈ fulfilled is terminal; amendments create new records
```

The `≈` symbol here means "when the following condition is true." Transitions are not manual status updates — they are triggered by business events.

### Dirty State Fields

Beyond the primary status lifecycle, individual fields within a record carry their own confirmation state. This is especially important for values received from external parties:

| Field | Dirty state indicator | Confirmed state indicator |
|-------|-----------------------|--------------------------|
| `lead_time_days` | `lead_time_status = 'estimated'` | `lead_time_status = 'confirmed'` + `lead_time_confirmed_at` |
| `unit_price` | `price_status = 'quoted'` | `price_status = 'confirmed'` + `price_confirmed_at` |
| `delivery_date` | `delivery_date_status = 'requested'` | `delivery_date_status = 'confirmed'` + `delivery_confirmed_at` |

A record can be in `confirmed` status overall while still containing individual fields in estimated state — as long as the estimated fields are not required for the downstream action being taken.

### Surfacing Dirty State

Dirty state is only useful if it is visible. Design requirements:

1. **Reports** that aggregate on any estimated field must surface the estimate count alongside the aggregate — not bury it
2. **Commitment workflows** that reference an estimated field must require explicit acknowledgment before proceeding
3. **Dashboards** that display status must show the lifecycle stage, not just a binary complete/incomplete
4. **Exports** must include the confirmation status of every approximate field, not just the value

---

## Work Lab: Lifecycle Design

You are given a description of a quote workflow with five steps: submission, review, pricing, customer approval, order conversion.

1. Map each step to a lifecycle stage (`draft`, `pending`, `confirmed`, `fulfilled`)
2. Define the transition condition for each stage change
3. Identify which fields in the quote record are approximate at each stage
4. Write the rule that determines when an approximate field must be confirmed before the record can advance

> **Lab response recorded in:** `rfq_course_app.lesson_reflections`

---

## Reflection

1. **Past:** Has a record in your environment ever been acted on as if it were confirmed when it was actually still estimated or in-progress? What happened?
2. **Present:** In your current systems, is there a visual or structural distinction between a record that is confirmed vs. one that is still in draft or pending? How easy is it to tell?
3. **Future:** Sketch the four-stage lifecycle for the most important record type in your environment. What is the transition condition for each stage change?

> **Reflection recorded in:** `rfq_course_app.lesson_reflections`

---

## Key Principle

> Incomplete data is not the enemy. Invisible incomplete data is. A draft is not a failure — a draft masquerading as a confirmed record is.

---

## Module 02 Complete

You have now built the intake prevention layer:

- **Lesson 2.1:** Every record type has a minimum viable complete record — a defined set of authoritative, derived, and approximate fields
- **Lesson 2.2:** Free-text fields are failure vectors; controlled vocabulary eliminates the most common intake failures
- **Lesson 2.3:** Normalization happens at entry, not downstream — once, at the boundary, not many times inside the system
- **Lesson 2.4:** Dirty state is information; status lifecycles make it visible and actionable

Complete the **Module 02 Work Lab** before proceeding: redesign a broken intake form using all four principles.

**Previous:** [Lesson 2.3 — Normalization Before Storage](lesson-2-3.md)
**Next:** [Module 03 — Communication and Commitment Discipline](../../module-03-communication/README.md) → after completing the Work Lab
