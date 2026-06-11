# Lesson 2.2 — Controlled Vocabulary in Practice

**Module:** 02 — Intake and Minimum Viable Complete Record
**Concept:** Replace open fields with lookups, dropdowns, and validated formats

---

## Context

Lesson 1.3 showed what free-text fields do to a dataset over time: 47 spellings for 12 companies, unroutable records, unquotable inquiries. This lesson builds the practical skill for eliminating that class of failure.

The principle is simple. The implementation requires deliberate decisions for every field.

---

## Concept: Controlled Vocabulary

A **controlled vocabulary** is a defined, finite set of permitted values for a field. Any value not in the set is rejected at entry.

Controlled vocabulary is not about restricting users — it is about ensuring that the values users enter can be used reliably downstream. A value that matches something in a lookup table can be joined, routed, aggregated, and reported on. A value that doesn't match anything is an island.

### Four Enforcement Mechanisms

| Mechanism | Use case | Example |
|-----------|----------|---------|
| **Dropdown / select** | Short, stable list (≤20 options) | Order status, unit of measure, payment terms |
| **Lookup / typeahead** | Long or growing list | Customer name, SKU, vendor, location |
| **Format validation** | Structured free text with a pattern | Phone numbers, postal codes, PO number formats |
| **Foreign key constraint** | Database-level enforcement | `customer_id` must exist in `customers` table |

The right mechanism depends on the field's cardinality (how many possible values), stability (does the list change?), and source of authority (internal list vs. external standard).

### High-Priority Fields for Controlled Vocabulary

In RFQ workflows, the following field types carry the highest risk when left as free text:

**Company / entity identifiers**
- Problem: name variants, typos, abbreviations create duplicate pseudo-entities
- Solution: lookup against a validated customer or vendor master; `customer_id` is authoritative, display name is derived
- Anti-pattern: storing the free-text company name as the join key

**Unit of measure (UOM)**
- Problem: "each", "EA", "Ea.", "pc", "piece" all mean the same thing; pricing and fulfillment calculations break on variant values
- Solution: dropdown from a UOM master; display label is human-readable, stored value is a standardized code (`EA`, `CS`, `LB`)
- Anti-pattern: storing what the user typed

**Status fields**
- Problem: as shown in Lesson 1.6, status fields accumulate meaning drift when values are undocumented
- Solution: enum with documented definitions; new values require governance review before being added
- Anti-pattern: a varchar `status` field with no constraint

**Territory / routing fields**
- Problem: free-text regions cause misrouting when spellings or abbreviations don't match routing rules
- Solution: territory derived from validated `ship_to_address_id`; never entered manually
- Anti-pattern: a free-text "region" field that sales reps fill in themselves

### When Free Text Is Appropriate

Not every field should be controlled vocabulary. Free text is appropriate for:
- Notes, comments, and narrative fields (by definition open-ended)
- Fields where the universe of valid values cannot be enumerated in advance
- Search/filter inputs (the query is free text; the stored values are still controlled)

Free text fields should be clearly labeled as narrative fields and should never be used as join keys, routing logic inputs, or aggregation targets.

---

## Work Lab: Vocabulary Audit

You are given a database table definition with 12 fields. For each field:

1. Determine whether it should use controlled vocabulary
2. If yes: identify the appropriate enforcement mechanism (dropdown, lookup, format validation, FK constraint)
3. If no: confirm it is a legitimate narrative field and document why free text is appropriate
4. For every field you convert to controlled vocabulary: write the first three allowed values

> **Lab response recorded in:** `rfq_course_app.lesson_reflections`

---

## Reflection

1. **Past:** What is the most damaging free-text field you have encountered in a system? What did it cost in manual cleanup or errors?
2. **Present:** In your current environment, which free-text field most urgently needs to become controlled vocabulary? What is the obstacle to changing it?
3. **Future:** Write the allowed values for the most important status field in your environment. Who would need to agree on these definitions?

> **Reflection recorded in:** `rfq_course_app.lesson_reflections`

---

## Key Principle

> A free-text field is a promise that someone downstream will do the normalization work that the form refused to do. Every hour spent cleaning free-text data is a tax on the decision not to enforce controlled vocabulary at intake.

---

**Previous:** [Lesson 2.1 — What Makes a Record Complete](lesson-2-1.md)
**Next:** [Lesson 2.3 — Normalization Before Storage](lesson-2-3.md)
