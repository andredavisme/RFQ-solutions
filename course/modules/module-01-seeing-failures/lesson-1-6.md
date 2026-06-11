# Lesson 1.6 — The Status Field That Lied

**Module:** 01 — Seeing the Failures
**Failure Category:** Naming / governance confusion

---

## Scenario Card

A operations manager, Kevin, pulls a weekly fulfillment report. The report shows 94% of orders in a "Complete" status. He presents this to leadership as evidence of strong fulfillment performance.

Two weeks later, a customer escalates: three orders marked "Complete" in the system were never shipped. An investigation reveals:

- "Complete" in the system means the order was *processed* (entered, priced, and assigned), not *fulfilled* (shipped and delivered)
- A different team uses "Complete" to mean *invoiced*
- The field was named `status` with no documentation of its allowed values
- At some point in the system's history, a developer added the value "Complete" to distinguish processed orders from drafts — and the meaning drifted across teams over time

The report was accurate. The data it was based on was technically consistent. The problem was that `status = 'Complete'` meant three different things to three different people — and no authoritative definition existed.

---

## Classification Challenge

Before reading further, select the failure category that best describes this scenario.

Use the controlled vocabulary from [`_schema/failure-categories.json`](../../_schema/failure-categories.json):

- No single source of truth
- Intake / minimum viable complete record failure
- Dirty-state visibility missing
- Vague commitments / declarations instead of proof
- Vendor data / translation failure
- Transparent substitution failure
- Naming / governance confusion

> **Learner response recorded in:** `rfq_course_app.scenario_responses.selected_failure_category`

---

## Expert Lens

**Primary failure category: Naming / governance confusion**

The field existed. The data was stored. The report ran. Everything worked — technically. The failure was that the value `'Complete'` had no authoritative definition, and different teams assigned it different meanings without a mechanism to surface or resolve the divergence.

This is a governance failure that presented as a reporting failure. The field name (`status`) was too generic. The allowed value (`Complete`) was too ambiguous. No documentation existed to resolve the ambiguity. No review process existed to catch the drift.

### The Status Field Lifecycle Problem

Status fields are among the most failure-prone in any data system because:
1. They accumulate meaning over time as teams repurpose existing values instead of adding new ones
2. They are rarely documented with the precision of transactional fields
3. Their meaning is context-dependent — "complete" in fulfillment is not "complete" in finance

### What Would Have Prevented This

1. **Explicit status vocabulary** with documented definitions for each allowed value, stored in the schema itself or an adjacent data dictionary
2. **Lifecycle-specific status fields** instead of one generic `status`:
 - `processing_status`: `draft` | `submitted` | `assigned` | `processing_complete`
 - `fulfillment_status`: `pending` | `picking` | `shipped` | `delivered`
 - `billing_status`: `uninvoiced` | `invoiced` | `paid` | `disputed`
3. **Governance review for new status values** — adding a value requires documentation and cross-team sign-off
4. **Report labeling** — every report that displays a status field must display the field name and definition, not just the value

### The Relationship to Technical Debt

This scenario illustrates how naming/governance confusion compounds into technical debt. A poorly named field with undocumented values doesn't break immediately — it accumulates meaning drift, incorrect reports, and misaligned team expectations until a failure event forces a reckoning. The cost of fixing it grows with every record written against the ambiguous definition.

---

## Reflection

1. **Past:** Have you encountered a field, report, or metric where the same term meant different things to different teams? How was it discovered and resolved?
2. **Present:** What is the most ambiguously named field in a system you currently use? How would you describe its definition to a new team member?
3. **Future:** Write a one-sentence definition for the most important status field in your environment. Would every team that uses it agree with your definition?

> **Reflection recorded in:** `rfq_course_app.lesson_reflections`

---

## Metrics Hook

- What percentage of learners confused this with "no single source of truth"? (Both involve inconsistency — but NSOT is about competing *records*, governance confusion is about ambiguous *definitions*)
- Reflection data: what ambiguous fields do learners identify in their environments? (Creates an index of real-world governance debt across the learner population)

---

## Module 01 Complete

You have now classified all six failure scenarios and developed a working vocabulary for the most common, most costly, and most preventable data and communication failures in RFQ processes.

Before proceeding, complete the **Module 01 Work Lab**: you will receive a composite scenario containing multiple overlapping failure types and must identify the primary failure, any secondary contributions, and one structural change that would prevent recurrence.

**Previous:** [Lesson 1.5 — The Substitution Nobody Mentioned](lesson-1-5.md)
**Next:** [Module 02 — Intake and Minimum Viable Complete Record](../../module-02-intake/README.md) → after completing the Work Lab
