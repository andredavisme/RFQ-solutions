# Lesson 1.2 — The Vendor Lead Time That Wasn't

**Module:** 01 — Seeing the Failures
**Failure Category:** Dirty-state visibility missing

---

## Scenario Card

A procurement specialist, Diane, is building a customer delivery commitment for a large project order. She checks the vendor record in the system and sees a lead time of 6 weeks for the primary component. She communicates a 7-week delivery window to the customer, accounting for one week of internal processing.

Four weeks later, the vendor calls to confirm the order — and mentions that the actual lead time is 10 weeks. The 6 weeks in the system was an estimate provided during initial vendor onboarding, before any orders had been placed.

The customer's project schedule is disrupted. The delivery commitment is missed by three weeks. Diane had no way to know the lead time was an estimate — nothing in the system distinguished it from a confirmed value.

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

**Primary failure category: Dirty-state visibility missing**

The data in the system was not wrong — it was incomplete in a specific and critical way. The lead time value of 6 weeks was an estimate. Estimates are legitimate data. The failure was the absence of any mechanism to communicate that the value was unconfirmed.

When estimated and confirmed values look identical in a system, every consumer of that data will treat them identically. Diane was not careless — she was working with the only signal the system gave her.

### Why Not the Other Categories?

- **No single source of truth?** There was one source — the vendor record. The problem wasn't competing sources; it was that the single source didn't distinguish data states.
- **Vendor data / translation failure?** The vendor's lead time was correctly entered. The failure was the absence of a `confirmation_status` field, not a translation error.
- **Vague commitments?** Diane made a specific commitment to the customer. The vagueness was upstream, in the data she relied on.

### What Would Have Prevented This

1. A `lead_time_status` field with values: `estimated` | `quoted` | `confirmed` | `contracted`
2. A `lead_time_confirmed_at` timestamp — null until a vendor formally confirms the value on a live order
3. A UI rule: any downstream commitment (customer delivery date, project schedule) that references an `estimated` lead time triggers a warning requiring acknowledgment
4. A workflow step: before communicating a delivery date, the system requires the user to verify the confirmation status of every upstream lead time

---

## Reflection

1. **Past:** Can you recall a time when you relied on data that turned out to be preliminary or estimated? What downstream effect did it have?
2. **Present:** In your current systems, is there a field that can contain either an estimate or a confirmed value without visual distinction?
3. **Future:** What would a `confirmation_status` field need to contain to be useful in your environment? What are the states?

> **Reflection recorded in:** `rfq_course_app.lesson_reflections`

---

## Metrics Hook

- What percentage of learners confused this with "vendor data / translation failure"? (Signals need to reinforce the confirmed-vs-estimated concept in Module 04)
- What percentage confused it with "no single source of truth"? (Signals the lesson on source authority vs. data state needs more contrast)

---

**Previous:** [Lesson 1.1 — Three Prices, Zero Truth](lesson-1-1.md)
**Next:** [Lesson 1.3 — The Form That Let Anything Through](lesson-1-3.md)
