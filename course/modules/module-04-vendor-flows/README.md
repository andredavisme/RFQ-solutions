# Module 04: Vendor and External Party Data Flows

## Purpose

Build translation layers that preserve data integrity across organizational boundaries.

Every external data relationship — vendor submissions, distributor catalogs, logistics updates, customer-supplied specifications — introduces a **translation problem**. The external party uses their own terminology, their own part numbers, their own status vocabulary, their own lead time conventions. When that data enters your system without translation, it contaminates every downstream process that depends on it.

This module builds the skills to identify where translation is needed, how to structure it, and how to communicate the difference between data that is **confirmed** and data that is **estimated**.

## Core Concepts

### The Translation Layer

A translation layer is a deliberate mapping between external data formats and internal standards. It answers the question: *when a vendor says X, what does our system mean by Y?*

Translation layers must be:
- **Explicit** — documented, not assumed
- **Enforced at entry** — applied before data is stored, not after
- **Version-controlled** — when a vendor changes their terminology, the translation layer is updated, not the data it was already used to translate

Without a translation layer, every team member becomes an informal translator — producing inconsistent results and introducing undocumented assumptions into the data.

### Confirmed vs. Estimated

This is one of the most consequential distinctions in RFQ data management. A lead time can be:
- **Estimated** — the vendor's best guess, subject to change
- **Confirmed** — a binding commitment, documented and referenced

The failure pattern: estimated data is treated as confirmed because no mechanism exists to distinguish the two. The correct architecture makes this distinction structural — a `confirmation_status` field, a `confirmed_at` timestamp, a required confirmation step before the value can be used in downstream commitments.

Every data point that enters from an external party should be tagged at intake: is this confirmed or estimated? If it cannot be confirmed, it must be treated as an estimate until it is.

### Vendor vs. Distributor

Vendors and distributors have fundamentally different data reliability profiles:

| Dimension | Vendor (Manufacturer) | Distributor |
|-----------|----------------------|-------------|
| Lead time authority | Definitive | Derived (may add stocking buffer) |
| Pricing authority | List price (may vary by channel) | Current market/contract price |
| Specification authority | Authoritative | Reference only — verify against manufacturer |
| Stock visibility | Own production | Inventory on hand (may be stale) |

These differences must be encoded in the data model. A lead time from a distributor is not the same data type as a lead time from a manufacturer — even if the field name is identical.

### Authorization-Driven Routing

Not every request should follow the same path. Routing decisions — which requests need which approval, which exceptions require escalation, which substitutions require customer authorization — should be driven by data, not by individual judgment.

Authorization-driven routing defines: for each combination of request type, value threshold, and exception condition, what is the required path? This is governance made operational.

## Lessons

| Lesson | Title | Concept |
|--------|-------|----------|
| [4.1](lesson-4-1.md) | The Translation Layer | Map vendor part numbers, UOM, and lead time conventions to internal fields |
| [4.2](lesson-4-2.md) | Confirmed vs. Estimated | Tag every data point in a sample quote as confirmed or estimated |
| [4.3](lesson-4-3.md) | Vendor vs. Distributor | Distinguish data reliability profiles; build the distinction into a vendor data model |
| [4.4](lesson-4-4.md) | Authorization-Driven Routing | Define which requests need which approval path — and why |

## Work Lab

Learners receive a sample vendor submission — a spreadsheet with part numbers, descriptions, lead times, prices, and UOM in vendor format.

The task:
1. Identify every field that requires translation to internal standards
2. Tag each data point as confirmed or estimated
3. Flag which fields are authoritative (from a manufacturer) vs. derived (from a distributor)
4. Identify what is missing that would block this submission from being processed
5. Write three routing rules that should apply to this submission type

## Failure Categories Addressed

- `vendor-data-translation-failure`
- `dirty-state-visibility-missing`
- `transparent-substitution-failure`
- `intake-minimum-viable-record-failure`

## Navigation

← [Module 03: Communication and Commitment Discipline](../module-03-communication/README.md)
→ [Module 05: Governance, Naming, and Data Architecture](../module-05-governance/README.md)
