# Lesson 3.3 — Specific Commitments

**Module:** 03 — Communication and Commitment Discipline
**Concept:** Replace every vague time reference with a date or condition

---

## Context

Lesson 3.2 identified vague quantifiers as one of the three voice failures. This lesson treats the problem in depth — because specific commitments are not just a writing technique. They are a data discipline.

A specific commitment is a record. It has a date, an owner, and an observable outcome. It can be entered into a system, tracked, and evaluated. A vague commitment is none of these things. It exists only as an impression in the customer's memory, which will drift toward the most favorable interpretation of "soon."

---

## Concept: The Anatomy of a Specific Commitment

A commitment is specific when it has three components:

| Component | Definition | Example |
|-----------|------------|---------|
| **Date or condition** | When the outcome will occur, or what event triggers it | "by 5pm Friday" / "within 2 hours of receiving the signed PO" |
| **Named owner** | Who is responsible for the outcome | "I will" / "our logistics team will" / "[Name] will" |
| **Observable outcome** | What the customer will receive or be able to verify | "a confirmed ship date" / "a revised quote" / "a call from our warehouse manager" |

A commitment missing any of these components is vague. "We'll get back to you" has no date, no owner, and no defined outcome. "I'll send you a confirmed ship date by 3pm today" has all three.

### The Commitment as a Data Record

Every specific commitment made to a customer should be recorded as a data point:

```
commitment_id       uuid
customer_id         fk → customers
order_id            fk → orders (nullable)
committed_by        fk → users
commitment_text     text
due_at              timestamptz     -- the specific date/time committed
condition           text            -- if condition-based rather than time-based
outcome_type        controlled vocab  -- 'ship_date' | 'price_confirmation' | 'callback' | 'document'
status              controlled vocab  -- 'open' | 'met' | 'missed' | 'superseded'
met_at              timestamptz     -- populated when status = 'met'
notes               text
```

This structure makes commitments trackable. It enables:
- Alerting when a commitment is approaching its `due_at` and still `open`
- Reporting on commitment reliability by rep, by team, by customer segment
- Identifying systemic patterns where certain commitment types are consistently missed

### Vague-to-Specific Transformation

| Vague commitment | Specific equivalent |
|------------------|---------------------|
| "We'll look into it." | "I'll check with our warehouse and send you a status update by 2pm today." |
| "Someone will call you back." | "[Name] from our fulfillment team will call you by 10am tomorrow." |
| "We'll get you a price shortly." | "I'll have a formal quote to you by end of business Thursday." |
| "We're working on expediting this." | "I've submitted an expedite request. I'll confirm the updated ship date by noon Friday, or let you know if it can't be expedited and give you options." |
| "Let us see what we can do." | "I'll check our current inventory and lead time. You'll have a definitive answer by 4pm today." |

### The Conditional Commitment

Not every commitment can be time-anchored. When the timeline depends on an external event, use a conditional structure:

> "Once I receive the vendor's confirmation — which I'm waiting on by end of day today — I'll send you the updated delivery date within one hour."

This structure is still specific: it names the trigger event, the owner, the timeline from trigger to outcome, and the outcome type. The customer knows what to expect and when.

Conditional commitments must be tracked against their trigger event. If the trigger doesn't arrive on time, the customer is proactively informed — not left waiting.

### The Missed Commitment Protocol

Missed commitments are inevitable. The protocol matters more than the miss:

1. **Notify before the deadline, not after** — if you know at 2pm that you cannot meet a 5pm commitment, notify the customer at 2pm
2. **Give a reason and a new commitment** — not an apology, a reason and a new specific date
3. **Record the miss** — `status = 'missed'`, `notes` = reason; this data informs commitment reliability reporting

A missed commitment that is proactively communicated with a new specific date almost always recovers customer trust. A missed commitment discovered by the customer — because no one called — almost never does.

---

## Work Lab: Commitment Conversion

You are given a sample customer email thread with 6 vague commitments.

1. Identify every vague commitment
2. Rewrite each as a specific commitment with all three components (date/condition, owner, observable outcome)
3. Write the database record for each commitment using the schema above
4. Identify which commitments, if missed, would most damage the customer relationship — and why

> **Lab response recorded in:** `rfq_course_app.lesson_reflections`

---

## Reflection

1. **Past:** Think of a time a commitment was missed and the customer found out on their own rather than being proactively notified. What was the cost to the relationship?
2. **Present:** In your current workflow, are customer commitments recorded anywhere? If yes — in what form? If no — what is the mechanism by which missed commitments are caught?
3. **Future:** Design a minimal commitment-tracking record for your environment: what fields are required to make a commitment trackable and reportable?

> **Reflection recorded in:** `rfq_course_app.lesson_reflections`

---

## Key Principle

> A vague commitment is a liability deferred. A specific commitment is a liability measured. The difference is not in the outcome — it is in whether the outcome can be tracked, reported, and learned from.

---

**Previous:** [Lesson 3.2 — Voice Discipline](lesson-3-2.md)
**Next:** [Lesson 3.4 — The Objection as Data](lesson-3-4.md)
