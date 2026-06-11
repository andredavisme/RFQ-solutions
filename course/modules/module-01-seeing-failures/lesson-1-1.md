# Lesson 1.1 — Three Prices, Zero Truth

**Module:** 01 — Seeing the Failures
**Failure Category:** No single source of truth

---

## Scenario Card

A customer, Marcus, submits an RFQ for 200 units of an industrial filtration component. The sales rep quotes him $47.50 per unit over the phone. Later that week, Marcus receives a formal quote document from the company's quoting system showing $49.00 per unit. When the order ships, the invoice reads $51.25 per unit.

Marcus calls to dispute the invoice. The sales rep checks their notes. The quoting system shows a different number. Accounts receivable references the price list. No one is lying — each person is citing a real number from a real source. The problem is that three sources exist and none of them is designated as authoritative.

The dispute takes four days to resolve. The customer leaves with the corrected price but a damaged trust in the company's reliability.

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

**Primary failure category: No single source of truth**

This scenario has one root cause: pricing data exists in at least three locations (verbal notes, quoting system, price list) and no mechanism designates which one is authoritative at the moment of commitment.

The individual actors behaved correctly within their context. The sales rep cited the price they quoted. The quoting system cited the price it generated. Accounts receivable cited the price list. Each source was internally consistent. The failure is architectural — the system permitted multiple authoritative-looking sources to coexist.

### Why Not the Other Categories?

- **Intake failure?** The intake captured enough information to generate a quote — the problem is post-intake price proliferation, not missing intake fields.
- **Dirty state?** Pricing was treated as confirmed in all three sources. The issue isn't confirmed-vs-estimated; it's which confirmed source to trust.
- **Naming/governance confusion?** The fields are named correctly. The problem is source authority, not field naming.

### What Would Have Prevented This

1. **A single pricing record** with a designated `price_source` field indicating origin (verbal, system-generated, price list) and a `locked_at` timestamp when the price was committed
2. **A rule**: the quoting system is the authoritative source; verbal quotes must be entered into the system before being communicated to the customer
3. **Audit trail**: any change to a committed price requires a new version record, not an in-place edit

---

## Reflection

Answer the following before moving to the next lesson:

1. **Past:** Have you seen a scenario where multiple sources contained the same data but with different values? What made it difficult to resolve?
2. **Present:** In your current context, is there a data point that exists in more than one system without a designated authoritative source?
3. **Future:** What one rule would you introduce today to prevent a "three prices, zero truth" scenario in your own environment?

> **Reflection recorded in:** `rfq_course_app.lesson_reflections`

---

## Metrics Hook

After this lesson is complete, the following aggregate metrics become available to instructors:

- What percentage of learners correctly identified "no single source of truth" as the primary failure?
- Of those who selected a different category, which was most common? (Signals where learner perception gaps exist)
- How long did learners spend on the classification step before selecting? (Signals confidence level)

---

**Next:** [Lesson 1.2 — The Vendor Lead Time That Wasn't](lesson-1-2.md)
