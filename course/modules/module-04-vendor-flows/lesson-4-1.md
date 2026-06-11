# Lesson 4.1 — The Translation Layer

**Module:** 04 — Vendor and External Party Data Flows
**Concept:** Map vendor part numbers, UOM, and lead time conventions to internal fields

---

## Context

Modules 02 and 03 addressed internal data integrity and customer-facing communication. Module 04 addresses the boundary between your organization and its external data sources: vendors, distributors, logistics partners, and customers submitting specifications.

Every external data relationship introduces a translation problem. This lesson builds the architecture to solve it.

---

## Concept: The Translation Layer

A **translation layer** is a structured mapping between external data formats and internal standards. It sits at the boundary between an external party's data and your system — processing every inbound value before it is stored.

Without a translation layer, translation happens anyway — informally, inconsistently, by individual people using individual judgment. This produces the same data in five slightly different forms and no reliable way to join them.

### What the Translation Layer Maps

**1. Part numbers and identifiers**

Every vendor has their own part numbering convention. A vendor's `XZ-4421-B` is your `SKU-887231-C`. A distributor may use a third identifier for the same physical item. The translation layer maintains a mapping table:

```
vendor_parts
─────────────────────────────────────────────
vendor_id          fk → vendors
vendor_part_number text           -- as the vendor defines it
internal_sku       fk → products  -- your authoritative identifier
alias_type         controlled vocab -- 'manufacturer_pn' | 'distributor_sku' | 'customer_pn'
effective_from     date
effective_to       date           -- null = currently active
created_by         fk → users
created_at         timestamptz
```

Key rules:
- The vendor's identifier is stored and preserved — never discarded
- The internal SKU is the join key for all downstream processing
- `effective_from` / `effective_to` handles vendor part number changes without corrupting history
- One `internal_sku` may have many vendor identifiers; one vendor identifier maps to exactly one `internal_sku`

**2. Unit of measure (UOM)**

Vendors quote in their preferred UOM. Your system operates in yours. The translation layer converts at intake:

```
uom_mappings
─────────────────────────────────────────────
external_uom       text           -- what the vendor sends ('dozen', 'dz', 'BX/12')
internal_uom_code  fk → uom_codes -- your standard ('EA', 'CS', 'LB')
conversion_factor  numeric        -- e.g., 12.0 for dozen → EA
notes              text
```

Ambiguous external UOM values ("some", "approx", "TBD") are blocked at intake, not mapped.

**3. Lead time conventions**

Lead time is one of the most inconsistently communicated values in vendor data:

| What the vendor says | What they mean | What you must confirm |
|----------------------|----------------|----------------------|
| "2 weeks" | Calendar days? Business days? From order or from stock? | All three |
| "Net 14" | 14 business days from PO receipt | Confirm the start event |
| "Ships same day" | If ordered before noon, their time zone | Confirm cutoff and time zone |
| "6–8 weeks" | A range — not a commitment | Which end of the range is the commitment? |

The translation layer converts lead time expressions to a standard structure:

```
lead_time_days         integer         -- always in calendar days
lead_time_basis        controlled vocab -- 'from_po_receipt' | 'from_stock_available' | 'from_production_start'
lead_time_status       controlled vocab -- 'estimated' | 'quoted' | 'confirmed' | 'contracted'
lead_time_source_text  text            -- preserve the original expression verbatim
```

Preserving `lead_time_source_text` means you can always return to what the vendor originally said if a dispute arises.

### Translation Layer Maintenance

The translation layer is a living system:
- New vendor part numbers require new mapping entries before orders can be processed
- When a vendor changes their part numbering scheme, old mappings are end-dated; new mappings are added
- When a vendor changes their UOM convention, the `uom_mappings` table is updated
- The translation layer is version-controlled and audited — every change is logged with who made it and when

---

## Work Lab: Translation Audit

You are given a vendor submission spreadsheet with 10 line items in vendor format (vendor part numbers, vendor UOM, vendor lead time expressions).

For each line item:
1. Write the translated `internal_sku`, `internal_uom_code`, and `lead_time_days`
2. Identify any value that cannot be translated without additional confirmation from the vendor
3. Write the `lead_time_source_text` for each lead time entry
4. Flag any vendor part number that does not exist in the current `vendor_parts` mapping table (i.e., requires a new mapping entry before processing)

> **Lab response recorded in:** `rfq_course_app.lesson_reflections`

---

## Reflection

1. **Past:** Has your organization ever processed an order using a vendor's identifier instead of an internal one? What happened when the vendor changed their part number?
2. **Present:** In your current workflow, where does vendor-to-internal translation happen? Is it documented in a mapping table, or does it live in someone's head?
3. **Future:** What is the highest-risk untranslated value in your current vendor data? What would a mapping table for that value need to contain?

> **Reflection recorded in:** `rfq_course_app.lesson_reflections`

---

## Key Principle

> Every vendor speaks a different language. The translation layer is the interpreter that lets your system hear only one. Without it, every person in your organization becomes an informal interpreter — producing inconsistent results and carrying undocumented assumptions.

---

**Next:** [Lesson 4.2 — Confirmed vs. Estimated](lesson-4-2.md)
