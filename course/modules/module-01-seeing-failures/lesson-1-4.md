# Lesson 1.4 — "We'll Look Into It"

**Module:** 01 — Seeing the Failures
**Failure Category:** Vague commitments / declarations instead of proof

---

## Scenario Card

A customer, Sandra, places a time-sensitive order for components needed for a production run starting in 10 days. She emails to confirm the order status on day 3. She receives:

> *"Thank you for your order. We are looking into this and will get back to you shortly."*

She follows up on day 5. She receives:

> *"We apologize for the delay. Our team is working on this as a priority and you can expect to hear from us soon."*

She escalates on day 7. A manager responds:

> *"We take customer satisfaction very seriously and are committed to resolving this. We will reach out with an update at our earliest convenience."*

By day 10, Sandra has no status, no ship date, and no information she can use to make a production decision. She places an emergency order with a competitor at a 22% premium.

No one in the original company's thread was dishonest. Each response was polite. None contained a single verifiable commitment.

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

**Primary failure category: Vague commitments / declarations instead of proof**

Every response in this thread contains declarations — statements of intent, quality, and priority. None contains information. "Shortly," "soon," "at our earliest convenience," and "as a priority" are words that communicate tone but carry no data.

A customer facing a deadline needs one thing: a specific date or condition they can act on. The absence of that — across three responses and seven days — is a communication failure, not a service failure. The order may have been perfectly on track. Sandra had no way to know.

### Anatomy of a Vague Response

| Phrase Used | What It Contains | What Was Needed |
|-------------|-----------------|------------------|
| "shortly" | Tone | A date or hour count |
| "as a priority" | Declaration | Evidence of action taken |
| "at our earliest convenience" | Deferral | A specific callback time |
| "we are committed" | Assertion | A verifiable next step |

### What Would Have Prevented This

First response (day 3) rewritten with commitment discipline:

> *"Your order #4471 is in our system and assigned to [Name] in fulfillment. I'll have a confirmed ship date to you by 5pm tomorrow. If there's a hold, I'll let you know the reason and our proposed resolution at the same time."*

This response contains: an order reference, an owner, a specific deadline, and a contingency. It is four sentences. It is everything the original three responses were not.

---

## Reflection

1. **Past:** When have you sent or received a response that felt responsive but contained no actionable information? What was the cost?
2. **Present:** What phrases do you or your team use most frequently that function as declarations rather than proof? ("ASAP," "shortly," "we'll look into it," etc.)
3. **Future:** Write a one-sentence rule your team could apply to every customer status update: what must every response contain before it is sent?

> **Reflection recorded in:** `rfq_course_app.lesson_reflections`

---

## Metrics Hook

- Reflection data: what "vague phrases" do learners most frequently identify from their own environments? (Creates a living glossary of organizational communication debt)
- What percentage of learners correctly identified vague commitments vs. no single source of truth? (Both involve missing information — but the root cause and remediation are completely different)

---

**Previous:** [Lesson 1.3 — The Form That Let Anything Through](lesson-1-3.md)
**Next:** [Lesson 1.5 — The Substitution Nobody Mentioned](lesson-1-5.md)
