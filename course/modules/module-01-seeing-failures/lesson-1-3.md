# Lesson 1.3 — The Form That Let Anything Through

**Module:** 01 — Seeing the Failures
**Failure Category:** Intake / minimum viable complete record failure

---

## Scenario Card

A mid-sized distributor receives RFQs through a web form. The form has one required field: contact email. Everything else — company name, part number, quantity, delivery location — is optional free text.

Over a 90-day period, the data team runs an audit. They find:
- 47 distinct spellings across 12 actual customer companies ("Apex Manufacturing", "Apex Mfg", "Apex Mfg.", "APEX", "apex manufacturing llc", ...)
- 23 RFQs with no part number, just a description ("the blue valve we ordered last time")
- 31 RFQs routed to the wrong sales rep because the territory field was blank
- 14 RFQs that couldn't be quoted because the quantity field said "some" or "TBD"

Each of these records entered the system legally. The form accepted them. The failures were structural — the intake design permitted them.

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

**Primary failure category: Intake / minimum viable complete record failure**

This is a structural design failure. The form was built to minimize friction at entry. In doing so, it maximized friction at every downstream step: routing, quoting, fulfillment, and reporting.

A minimum viable complete record for an RFQ requires, at minimum:
- A validated company identifier (not a free-text name)
- A part number or SKU (with a lookup or validation step)
- A numeric quantity
- A delivery location or territory identifier

None of these is optional if the downstream process depends on them. Making them optional doesn't make the form friendlier — it transfers the cost of incompleteness to every person who handles the record after submission.

### Why Not the Other Categories?

- **No single source of truth?** The problem isn't competing records — it's that individual records are internally incomplete.
- **Naming/governance confusion?** The field names are fine. The problem is missing required-field enforcement and missing controlled vocabulary.
- **Vague commitments?** This is about intake design, not external communication.

### What Would Have Prevented This

1. **Company name** — replaced with a lookup against a validated customer list; free-text blocked
2. **Part number** — validated format (regex or lookup); submission blocked if empty
3. **Quantity** — numeric field with type enforcement; "TBD" and "some" structurally impossible
4. **Territory** — auto-populated from the validated customer record, not user-entered
5. **Intake rule**: a record that cannot be routed cannot be submitted

---

## Reflection

1. **Past:** Have you received data from a form or system that was technically submitted but practically useless? What did it cost to process?
2. **Present:** What is the most common incomplete or ambiguous field in records you receive today?
3. **Future:** What one field in your current intake flow would most benefit from being replaced with a validated lookup?

> **Reflection recorded in:** `rfq_course_app.lesson_reflections`

---

## Metrics Hook

- What percentage of learners correctly identified intake failure vs. naming/governance confusion? (These two are often conflated — the distinction matters for Module 02 vs. Module 05 remediation paths)
- Reflection data: what intake fields do learners most frequently identify as needing validation in their own environments? (Surfaces real-world friction points)

---

**Previous:** [Lesson 1.2 — The Vendor Lead Time That Wasn't](lesson-1-2.md)
**Next:** [Lesson 1.4 — We'll Look Into It](lesson-1-4.md)
