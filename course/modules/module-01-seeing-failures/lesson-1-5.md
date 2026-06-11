# Lesson 1.5 — The Substitution Nobody Mentioned

**Module:** 01 — Seeing the Failures
**Failure Category:** Transparent substitution failure

---

## Scenario Card

A facilities contractor, Ray, orders 40 units of a specific pressure relief valve — model PRV-220B — for an HVAC installation. The valve has a specific pressure rating required by the building's engineering spec.

The distributor's warehouse is out of PRV-220B. A fulfillment associate checks the system, finds PRV-220C listed as a "compatible substitute," and ships it. The packing slip lists the item as "pressure relief valve" with no model number. The invoice shows the PRV-220C SKU, but Ray's accounts payable team processes it without comparing to the original PO.

Ray installs all 40 valves. Three weeks later, during an inspection, the engineer flags that PRV-220C has a 15% lower pressure rating than PRV-220B and does not meet the building spec. All 40 valves must be replaced.

The substitution was made in good faith. The "compatible substitute" flag in the system referred to physical fit, not pressure rating compatibility. No one communicated the substitution to Ray. No one asked for authorization.

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

**Primary failure category: Transparent substitution failure**

A substitution occurred. The customer did not know. This is the defining pattern: a change was made to the order that the customer had a right to evaluate — and the information was not communicated.

The secondary failure (the "compatible substitute" flag not capturing specification compatibility) is real, but it is a data quality problem that made the primary failure worse. The primary failure — shipping a different product without disclosure and authorization — would have been harmful even if PRV-220C had been a perfect specification match. Ray had the right to know.

### The Substitution Authorization Rule

Any deviation from the ordered item requires:
1. **Disclosure** — the customer is informed of the substitution before or at the time of shipment
2. **Specification comparison** — the relevant specs of the original and substitute are presented side by side
3. **Authorization** — the customer (or a designated authority) approves the substitution before shipment proceeds, or at minimum before the goods are considered accepted

For regulated or engineering-spec applications, authorization must be explicit and documented. "No response within 24 hours = approval" is not a substitution authorization policy.

### Why Not the Other Categories?

- **Vendor data / translation failure?** The issue is not translation between external and internal data. The original spec was correctly captured. The problem is that a known deviation was not disclosed.
- **No single source of truth?** The PO had one clear source. The substitution introduced a deviation from that source without flagging it.
- **Naming/governance confusion?** The "compatible substitute" flag was misleadingly scoped, but the core failure is the absence of a disclosure-and-authorization workflow.

---

## Reflection

1. **Past:** Have you shipped, received, or approved a substitution that caused a downstream problem? What information was missing at the decision point?
2. **Present:** In your current fulfillment workflow, is there a defined process for substitution disclosure and authorization? If yes, is it consistently followed?
3. **Future:** Write a substitution authorization rule for your environment: what must happen before a substitute item ships?

> **Reflection recorded in:** `rfq_course_app.lesson_reflections`

---

## Metrics Hook

- What percentage of learners confused this with "vendor data / translation failure"? (Signals the need to sharpen the vendor translation concept in Module 04)
- Reflection data: what substitution practices exist (or are absent) in learners' current environments? (Benchmarks organizational maturity on substitution governance)

---

**Previous:** [Lesson 1.4 — We'll Look Into It](lesson-1-4.md)
**Next:** [Lesson 1.6 — The Status Field That Lied](lesson-1-6.md)
