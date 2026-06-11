# Lesson 2.1 — What Makes a Record Complete

**Module:** 02 — Intake and Minimum Viable Complete Record
**Concept:** Define required fields for quotes, orders, and vendor submissions

---

## Context

Module 01 showed what happens when data fails downstream. This module builds the prevention layer. The first question is foundational: what does a *complete* record actually mean?

Completeness is not the same as fullness. A record with 40 fields filled is not necessarily complete. A record with 8 fields filled may be perfectly complete. Completeness is a function of what the downstream process requires — not how many fields exist.

---

## Concept: The Minimum Viable Complete Record

A **minimum viable complete record (MVCR)** is the smallest set of fields that, when filled correctly, allows every downstream step to proceed without ambiguity or manual intervention.

The MVCR is defined separately for each record type. A quote MVCR is not the same as an order MVCR. Both differ from a vendor submission MVCR. Each is defined by asking: *what must be present for the next person in the process to act on this record without stopping to ask a question?*

### Field Classification

Every field in a record belongs to one of three classes:

| Class | Definition | Intake behavior |
|-------|------------|------------------|
| **Authoritative** | Has a single designated source of truth; value is definitive | Required; validated against the authoritative source |
| **Derived** | Calculated or auto-populated from an authoritative field | Never entered manually; system-generated |
| **Approximate** | Estimate or preliminary value; subject to confirmation | Permitted, but must be tagged with a `confirmation_status` |

A complete record has all authoritative fields present and validated. Derived fields are present if the authoritative sources that generate them are present. Approximate fields are permitted as long as they are explicitly tagged as approximate.

### MVCR by Record Type

**Quote MVCR:**

| Field | Class | Notes |
|-------|-------|-------|
| `customer_id` | Authoritative | Foreign key to validated customer record; not free text |
| `line_items[]` | Authoritative | Each line: `sku`, `quantity` (numeric), `unit_of_measure` (controlled vocab) |
| `delivery_location_id` | Authoritative | Foreign key to validated location; drives territory routing |
| `quote_requested_at` | Authoritative | Timestamp of submission |
| `requested_delivery_date` | Approximate | Tagged as estimate until confirmed; cannot drive commitments until confirmed |
| `quoted_price` | Derived | System-generated from pricing engine; not manually entered |
| `assigned_rep_id` | Derived | Auto-populated from territory rules on `delivery_location_id` |

**Order MVCR:**

| Field | Class | Notes |
|-------|-------|-------|
| `customer_id` | Authoritative | |
| `po_number` | Authoritative | Customer-issued; required for invoicing |
| `line_items[]` | Authoritative | Confirmed SKU, confirmed quantity, confirmed UOM |
| `confirmed_delivery_date` | Authoritative | Required before order enters fulfillment queue |
| `ship_to_address_id` | Authoritative | Foreign key; not free text |
| `payment_terms_id` | Authoritative | Foreign key to approved terms |

**Vendor Submission MVCR:**

| Field | Class | Notes |
|-------|-------|-------|
| `vendor_id` | Authoritative | |
| `vendor_part_number` | Authoritative | As the vendor defines it; mapped to internal SKU in the translation layer |
| `internal_sku` | Derived | Populated by translation layer from `vendor_part_number` |
| `lead_time_days` | Approximate | Tagged `estimated` until vendor provides a formal confirmation |
| `unit_price` | Approximate | Tagged `quoted` until PO is issued and vendor confirms |
| `uom` | Authoritative | Controlled vocab; must map to internal UOM standard |

---

## Work Lab: Field Audit

You are given a sample intake form with 14 fields. For each field:

1. Classify it as **authoritative**, **derived**, or **approximate**
2. Identify whether it should be required, optional, or auto-populated
3. Flag any field that is currently free text but should be a validated lookup
4. Identify which fields, if missing, would block the next downstream step

> **Lab response recorded in:** `rfq_course_app.lesson_reflections`

---

## Reflection

1. **Past:** Think of a record you processed that was technically submitted but required follow-up to complete. Which field was missing or wrong?
2. **Present:** For the most common record type you work with today, can you write its MVCR? What are the authoritative fields that, if absent, block the next step?
3. **Future:** What is the cost — in time, errors, or escalations — of processing one incomplete record in your current environment? Multiply by your weekly volume.

> **Reflection recorded in:** `rfq_course_app.lesson_reflections`

---

## Key Principle

> A record that cannot be processed completely should not be accepted completely. The cost of incompleteness is always paid — the only question is who pays it and when.

---

**Next:** [Lesson 2.2 — Controlled Vocabulary in Practice](lesson-2-2.md)
