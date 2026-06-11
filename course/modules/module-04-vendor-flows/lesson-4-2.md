# Lesson 4.2 — Confirmed vs. Estimated

**Module:** 04 — Vendor and External Party Data Flows
**Concept:** Tag every data point in a sample quote as confirmed or estimated

---

## Context

Lesson 1.2 introduced the dirty-state failure. Lesson 2.4 built the lifecycle architecture to prevent it. This lesson applies that architecture specifically to vendor data — where the confirmed/estimated distinction is most frequently collapsed and most consequentially ignored.

Vendor data arrives in a spectrum of certainty. A catalog price is different from a quoted price, which is different from a contracted price. An estimated lead time is different from a quoted lead time, which is different from a confirmed ship date. Every downstream decision that relies on vendor data must know where on that spectrum it is operating.

---

## Concept: The Vendor Data Certainty Spectrum

Vendor data does not arrive in a binary confirmed/unconfirmed state. It exists on a spectrum with at least four meaningful stages:

| Stage | Definition | Downstream use |
|-------|------------|----------------|
| `catalog` | Published list value; no negotiation; no order context | Reference only; cannot be used in customer commitments |
| `estimated` | Vendor's best guess; no formal commitment; subject to change | Planning only; must be tagged; cannot drive delivery commitments |
| `quoted` | Formal quote issued; valid for a defined period; not yet contracted | Can be used in customer quotes if quote validity is communicated |
| `confirmed` | Vendor has confirmed against a live PO or binding agreement | Can be used in customer commitments; must include `confirmed_at` timestamp |
| `contracted` | Contractually bound; deviation triggers a formal process | Highest certainty; can anchor SLA commitments |

### The Confirmation Event

Moving a value from one stage to the next requires a **confirmation event** — a specific, documented interaction with the vendor that explicitly commits the value.

| Transition | Required confirmation event |
|------------|----------------------------|
| `estimated` → `quoted` | Vendor issues a formal quote document with validity period |
| `quoted` → `confirmed` | Vendor acknowledges the PO and confirms price and lead time against it |
| `confirmed` → `contracted` | Signed agreement or binding order acknowledgment received |

A verbal confirmation is not a confirmation event. A vendor's casual reply of "yeah, 2 weeks" does not advance `lead_time_status` from `estimated` to `confirmed`. The confirmation event must be documented — an email, a PO acknowledgment, a signed document.

### Field-Level Tagging

In practice, a single vendor record may contain values at multiple certainty stages simultaneously. A price may be `confirmed` while the lead time is still `estimated`. Field-level tagging handles this:

```
vendor_quote_lines
─────────────────────────────────────────────────────────
internal_sku              fk → products
unit_price                numeric
price_status              controlled vocab    -- 'catalog' | 'estimated' | 'quoted' | 'confirmed' | 'contracted'
price_valid_through       date                -- null if not quoted/confirmed
price_confirmed_at        timestamptz         -- null until confirmed
lead_time_days            integer
lead_time_status          controlled vocab    -- same vocab as price_status
lead_time_confirmed_at    timestamptz         -- null until confirmed
lead_time_source_text     text                -- original vendor expression (from 4.1)
quote_expires_at          timestamptz         -- when does this quote lapse?
vendor_quote_reference    text                -- vendor's document/quote number
```

### Downstream Commitment Rules

Each certainty stage authorizes a different level of downstream commitment to the customer:

| Vendor data stage | Customer commitment authorized |
|-------------------|---------------------------------|
| `catalog` | "Our list price is approximately X — subject to quote" |
| `estimated` | "Estimated delivery in approximately X weeks — not confirmed" |
| `quoted` | "We can commit to X at Y price, valid through [date]" |
| `confirmed` | "Confirmed ship date: [date]. Confirmed price: $X" |
| `contracted` | Can anchor SLA language and penalty clauses |

Making a `confirmed` customer commitment based on `estimated` vendor data is the pattern that produced Lesson 1.2's scenario. Field-level tagging makes this pattern structurally visible — and application rules can block it.

---

## Work Lab: Certainty Audit

You are given a vendor quote with 8 line items. Each line has a price, a lead time, and a quote date.

For each line item:
1. Assign a `price_status` and `lead_time_status` based on the available documentation
2. Identify what confirmation event would be required to advance each to `confirmed`
3. Determine what customer commitment is authorized based on the current status of each value
4. Flag any value being used in a downstream customer commitment that is not yet at the required certainty stage

> **Lab response recorded in:** `rfq_course_app.lesson_reflections`

---

## Reflection

1. **Past:** Has a vendor's estimated value ever been treated as confirmed in your environment? What was the downstream impact?
2. **Present:** For the most common vendor data point you work with (price or lead time), what certainty stage is it usually at when you first receive it? At what stage does your team typically begin making customer commitments?
3. **Future:** What confirmation event would you institute for the most consequential vendor value in your workflow? What documentation would constitute that event?

> **Reflection recorded in:** `rfq_course_app.lesson_reflections`

---

## Key Principle

> The gap between "the vendor said" and "the vendor confirmed" is where most delivery failures are born. The certainty stage of every vendor value must be visible before any downstream commitment is made against it.

---

**Previous:** [Lesson 4.1 — The Translation Layer](lesson-4-1.md)
**Next:** [Lesson 4.3 — Vendor vs. Distributor](lesson-4-3.md)
