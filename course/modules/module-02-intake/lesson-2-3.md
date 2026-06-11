# Lesson 2.3 — Normalization Before Storage

**Module:** 02 — Intake and Minimum Viable Complete Record
**Concept:** Map customer terms → internal terms at the entry point

---

## Context

Controlled vocabulary (Lesson 2.2) prevents bad values from entering the system. Normalization addresses a different but related problem: the value a customer or vendor submits may be *valid* in their context but *incompatible* with your internal standards.

A customer calls it a "gasket." Your catalog calls it a "sealing element." A vendor's part number is `XZ-4421-B`. Your SKU is `887231-C`. A customer's PO uses "Net 30" for payment terms. Your system stores `PT-030-NET`.

None of these is wrong. They are different vocabularies for the same reality. Normalization is the act of translating at the boundary — before storage — so that everything inside your system speaks one language.

---

## Concept: The Normalization Entry Point

**The entry point is the only right place to normalize.** A value that enters the system in non-standard form will be queried, reported, joined, and displayed in non-standard form until someone fixes it — which means fixing every record it touched.

Normalization performed at entry costs one lookup per submission. Normalization performed after storage costs one data migration per affected record, plus retroactive review of every report, join, and downstream system that consumed the non-standard value.

### Three Normalization Layers

**Layer 1: Terminology mapping**

Customer/vendor term → internal standard term, captured in a mapping table.

```
customer_term          →  internal_term
-------------------------------------------
"gasket"               →  "sealing_element"
"fitting"              →  "pipe_connector"
"blue valve"           →  [lookup blocked: no match; intake requires SKU]
```

The mapping table is a first-class data asset. It is versioned, audited, and maintained like any other master data. When a customer uses a new term, a new mapping entry is created — the internal vocabulary does not change to accommodate the customer term.

**Layer 2: Identifier translation**

External identifiers (vendor part numbers, customer PO formats, third-party SKUs) are mapped to internal identifiers at intake.

```
vendor_part_number     →  internal_sku
-------------------------------------------
"XZ-4421-B"           →  "887231-C"
"PRV-220C"             →  "FV-10044"
```

The external identifier is stored *alongside* the internal identifier in the record — it is not discarded. Storing both preserves the ability to reconcile against the vendor's documents. Discarding the external identifier makes every future vendor communication harder.

**Layer 3: Unit and format standardization**

External values that arrive in non-standard units or formats are converted at entry.

```
external_value         →  stored_value
-------------------------------------------
"1 dozen"              →  quantity: 12, uom: EA
"Net 30"               →  payment_terms_id: PT-030-NET
"2 weeks"              →  lead_time_days: 14, lead_time_status: estimated
```

The conversion rule is documented. Ambiguous values ("about two weeks") are blocked rather than guessed.

### What Normalization Is Not

- **Not data cleaning** — data cleaning fixes values already in the system. Normalization prevents non-standard values from entering.
- **Not the same as validation** — validation checks that a value is permitted. Normalization translates a valid external value into the internal standard.
- **Not a one-time project** — normalization is an ongoing process. Every new customer term, vendor identifier, or format variant requires a mapping entry. The mapping tables are living documents.

---

## Work Lab: Mapping Exercise

You are given a sample inbound RFQ with 8 fields in customer format. For each field:

1. Identify whether it requires terminology mapping, identifier translation, or unit/format standardization
2. Write the internal representation of the value
3. Identify any value that is ambiguous and should be blocked rather than mapped
4. Add one row to the terminology mapping table for a term not currently in the system

> **Lab response recorded in:** `rfq_course_app.lesson_reflections`

---

## Reflection

1. **Past:** Have you had to reconcile data from two systems that used different terms or identifiers for the same thing? What was the effort required?
2. **Present:** In your current intake process, where does terminology or identifier translation happen? At intake, or somewhere downstream?
3. **Future:** Identify one external data source (customer, vendor, or logistics partner) that uses different terminology than your internal standard. What three mappings would a normalization layer need to contain?

> **Reflection recorded in:** `rfq_course_app.lesson_reflections`

---

## Key Principle

> Every term that enters your system in non-standard form is a debt. Normalization at intake pays the debt once. Normalization downstream pays it many times over.

---

**Previous:** [Lesson 2.2 — Controlled Vocabulary in Practice](lesson-2-2.md)
**Next:** [Lesson 2.4 — Dirty State as a Feature, Not a Bug](lesson-2-4.md)
