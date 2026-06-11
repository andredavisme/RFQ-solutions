# Lesson 4.3 — Vendor vs. Distributor

**Module:** 04 — Vendor and External Party Data Flows
**Concept:** Distinguish data reliability profiles; build the distinction into a vendor data model

---

## Context

Lessons 4.1 and 4.2 built the translation layer and certainty tagging system. Both assumed a generic "vendor." This lesson adds a critical distinction: **not all external parties have the same data authority**.

A manufacturer and a distributor may supply the same physical product. Their data, however, is not equivalent. Treating distributor data with the same authority as manufacturer data is a structural error — one that produces the same downstream failures as treating estimated data as confirmed.

---

## Concept: The Data Reliability Profile

Every external data source has a **data reliability profile** — a description of which fields it has authoritative data on, and which fields are derived, estimated, or potentially stale.

### Manufacturer vs. Distributor: Full Comparison

| Data dimension | Manufacturer | Distributor |
|----------------|-------------|-------------|
| **Specification authority** | Definitive — the manufacturer defines what the product is | Reference only — distributor republishes manufacturer specs; verify against manufacturer for engineering decisions |
| **Lead time authority** | Production lead time is authoritative (subject to capacity) | Stocking lead time is derived (inventory on hand) + production lead time (if out of stock) — distributor may not disclose which applies |
| **Pricing authority** | List price / contract price is authoritative | Current market price — may reflect negotiated terms, volume breaks, or market conditions not visible to you |
| **Stock visibility** | Own production schedule; authoritative on availability | Inventory on hand — may be stale, allocated to other customers, or shared across distribution network |
| **Substitution authority** | Can define compatible alternatives with full spec comparison | May flag "compatible" substitutes based on physical fit without full specification review (see Lesson 1.5) |
| **Part number authority** | Manufacturer part number (MPN) is the universal identifier | Distributor SKU is their internal identifier — always map back to MPN for specification verification |

### The Lead Time Problem

Distributor lead times are the most commonly misapplied data point in RFQ workflows. The issue: a distributor quote may show a 2-week lead time, but that figure could mean:

1. **In-stock ship time** — the distributor has inventory and can ship in 2 weeks
2. **Replenishment lead time** — the distributor needs to reorder from the manufacturer and is estimating 2 weeks based on historical patterns
3. **Manufacturer lead time (passed through)** — the distributor is quoting what the manufacturer told them, possibly months ago

These three scenarios have completely different reliability profiles and completely different risk levels for downstream customer commitments. The data model must capture which scenario applies:

```
vendor_quotes
─────────────────────────────────────────────────────
vendor_id              fk → vendors
vendor_type            controlled vocab  -- 'manufacturer' | 'distributor' | 'broker'
lead_time_basis        controlled vocab  -- 'in_stock' | 'replenishment' | 'manufacturer_passthrough'
lead_time_days         integer
lead_time_status       controlled vocab  -- from Lesson 4.2 certainty stages
lead_time_verified_at  timestamptz       -- when was stock/availability last confirmed?
stock_as_of            timestamptz       -- when was the inventory check performed?
```

`stock_as_of` is particularly important: a distributor's stock confirmation from 3 weeks ago may no longer reflect current availability. Every stock-dependent commitment should check whether `stock_as_of` is recent enough to support it.

### Building the Distinction into the Data Model

The `vendor_type` field is a first-class data attribute — not a note or a comment. It drives:

1. **Specification verification rules** — for engineering-spec applications, specifications from a `distributor` source require verification against the `manufacturer` source before customer commitments
2. **Lead time reliability rules** — `distributor` lead times with `lead_time_basis = 'replenishment'` or `'manufacturer_passthrough'` require an additional confirmation step before use in customer commitments
3. **Substitution authorization rules** — substitutions proposed by a `distributor` source require manufacturer specification comparison before approval (see Lesson 1.5)
4. **Audit and escalation paths** — when a discrepancy arises, the escalation path differs: manufacturer disputes go to their sales or technical team; distributor disputes may need to be escalated to the manufacturer behind the distributor

---

## Work Lab: Source Authority Audit

You are given a vendor master with 8 vendors — a mix of manufacturers, distributors, and one broker.

For each vendor:
1. Assign a `vendor_type`
2. Identify which data fields from that vendor are authoritative and which are derived or estimated
3. Write one data rule that should apply to that vendor type (e.g., "all lead times from distributors with `lead_time_basis = replenishment` require manufacturer confirmation before use in customer commitments")
4. Identify one field in the current vendor master that needs to be added to support proper source authority tracking

> **Lab response recorded in:** `rfq_course_app.lesson_reflections`

---

## Reflection

1. **Past:** Has your organization ever made a customer commitment based on distributor data that turned out to be stale or derived? What happened when the manufacturer's actual lead time was different?
2. **Present:** In your current vendor master, is `vendor_type` (or an equivalent field) recorded? If yes, does it drive any rules in your system? If no, which decisions are being made without this distinction?
3. **Future:** Write the lead time verification rule for your environment: what confirmation step is required before a distributor lead time can be used in a customer commitment?

> **Reflection recorded in:** `rfq_course_app.lesson_reflections`

---

## Key Principle

> A distributor's lead time and a manufacturer's lead time are not the same data type — even when they appear in the same field. The source of a value is part of the value's meaning. Build that distinction into the model, or leave it to individuals to remember.

---

**Previous:** [Lesson 4.2 — Confirmed vs. Estimated](lesson-4-2.md)
**Next:** [Lesson 4.4 — Authorization-Driven Routing](lesson-4-4.md)
