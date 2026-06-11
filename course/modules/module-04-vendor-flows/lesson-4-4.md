# Lesson 4.4 — Authorization-Driven Routing

**Module:** 04 — Vendor and External Party Data Flows
**Concept:** Define which requests need which approval path — and why

---

## Context

The previous three lessons built the data infrastructure for vendor flows: translation (4.1), certainty tagging (4.2), and source authority (4.3). This lesson addresses the routing and approval layer — the rules that determine what happens to a record after it enters the system.

Routing decisions are data decisions. They should be driven by attributes of the record, not by individual judgment applied inconsistently. Authorization-driven routing replaces informal escalation with a structured decision framework.

---

## Concept: Authorization-Driven Routing

**Authorization-driven routing** defines, for each combination of request attributes, the required processing path: who must review, what must be confirmed, and what conditions must be met before the request advances.

The alternative — routing by individual judgment — produces two failure modes:
1. **Under-escalation**: requests that require authorization proceed without it; commitments are made without the required review
2. **Over-escalation**: routine requests are held for approval they don't require; cycle time is inflated without risk reduction

### Routing Dimensions

Routing rules are defined across three dimensions:

**1. Request type**
- Standard order (previously purchased SKU, standard quantity, standard terms)
- Non-standard order (new SKU, unusual quantity, non-standard terms)
- Substitution request (deviation from ordered item)
- Exception request (override of a standard rule: expedite, price exception, lead time override)
- New vendor onboarding

**2. Value threshold**

Higher-value transactions carry higher risk and require higher authorization:

| Value range | Authorization level |
|-------------|--------------------|
| < $500 | Rep self-authorization |
| $500–$5,000 | Rep + manager review |
| $5,000–$25,000 | Manager + procurement approval |
| > $25,000 | VP / director sign-off |
| Any contract value | Legal review |

Thresholds are organization-specific — these are illustrative. The principle is that value thresholds are documented and enforced, not left to individual judgment.

**3. Exception condition**

Certain conditions trigger mandatory escalation regardless of value:

| Exception condition | Mandatory escalation |
|--------------------|---------------------|
| Substitution from ordered SKU | Customer authorization required (see Lesson 1.5) |
| Lead time extension > 20% of committed date | Customer notification + manager review |
| Price change from quoted price | Customer notification + manager approval |
| New vendor (not in approved vendor master) | Procurement + quality review |
| Out-of-spec substitution (any spec deviation) | Engineering review + customer authorization |
| Single-source supply (no alternative vendor) | Risk acknowledgment + executive awareness |

### The Routing Matrix

The routing matrix is the operational form of these rules — a lookup that, given a request's type, value, and exception conditions, returns the required approval path.

```
routing_rules
─────────────────────────────────────────────────────────
rule_id              uuid
request_type         controlled vocab
value_threshold_min  numeric
value_threshold_max  numeric         -- null = no upper bound
exception_condition  controlled vocab -- null = applies to all in type/value range
required_approvers   text[]          -- ordered list of approval roles
max_cycle_hours      integer         -- SLA for this path
auto_approve         boolean         -- true for fully automated paths
notes                text
effective_from       date
effective_to         date
```

The routing matrix is itself a governed data asset — changes require review and version control, not ad hoc edits.

### Routing in Practice

When a request enters the system, it is evaluated against the routing matrix:

1. **Request type** is determined from intake fields (controlled vocab from Lesson 2.2)
2. **Value** is calculated from line items (derived field — not entered manually)
3. **Exception conditions** are checked against system rules (substitution flag, lead time delta, price delta)
4. **Routing path** is returned from the matrix and applied automatically
5. **Approvers are notified** via the system — not via informal communication
6. **Cycle time is tracked** — every approval step has a timestamp; the total is measured against `max_cycle_hours`

The key requirement: **routing must be automatic, not manual**. A routing decision made by a human reading a record and deciding where to send it is not authorization-driven routing — it is the judgment-based system that produces under- and over-escalation.

### Audit and Accountability

Every routing decision is logged:

```
routing_events
─────────────────────────────────────────────────────────
event_id          uuid
request_id        fk → (orders | quotes | vendor_submissions)
rule_id           fk → routing_rules
applied_at        timestamptz
approver_id       fk → users
decision          controlled vocab  -- 'approved' | 'rejected' | 'escalated' | 'auto_approved'
decision_at       timestamptz
notes             text
```

This log answers: who authorized this, under what rule, and when. It is the audit trail for every exception and every commitment.

---

## Work Lab: Routing Matrix Design

You are given five request scenarios with varying types, values, and exception conditions.

For each:
1. Identify the request type, value range, and any exception conditions present
2. Apply the routing matrix to determine the required approval path
3. Identify any scenario where the current routing rules (as given) would produce an under-escalation or over-escalation
4. Write one new routing rule that would address a gap in the current matrix

> **Lab response recorded in:** `rfq_course_app.lesson_reflections`

---

## Reflection

1. **Past:** Think of a request that was approved without the appropriate authorization, or one that was held for approval it didn't need. What were the consequences?
2. **Present:** In your current workflow, how are escalation decisions made? Are they rule-driven or judgment-driven? If judgment-driven, what is the consistency of outcomes across different individuals?
3. **Future:** Write three routing rules for the most common request type in your environment: one for standard requests, one for value-threshold escalations, and one for exception conditions.

> **Reflection recorded in:** `rfq_course_app.lesson_reflections`

---

## Key Principle

> Routing by individual judgment is a tax on consistency. Authorization-driven routing is a governance investment — it pays dividends in audit trails, cycle time measurement, and the elimination of "it depends who handles it" as an operational answer.

---

## Module 04 Complete

You have now built the external data integrity layer:

- **Lesson 4.1:** The translation layer maps every external identifier, UOM, and lead time expression to internal standards at the entry point — once, with version control
- **Lesson 4.2:** Vendor data exists on a five-stage certainty spectrum; field-level tagging makes the stage visible and downstream commitment rules enforce it
- **Lesson 4.3:** Manufacturer and distributor data have fundamentally different reliability profiles; `vendor_type` drives specification verification, lead time rules, and substitution authorization
- **Lesson 4.4:** Authorization-driven routing replaces judgment-based escalation with a rules matrix — documented, automatic, and audited

Complete the **Module 04 Work Lab** before proceeding: audit a sample vendor submission, identify authoritative vs. derived vs. estimated fields, and write five routing rules for the submission type.

**Previous:** [Lesson 4.3 — Vendor vs. Distributor](lesson-4-3.md)
**Next:** [Module 05 — Governance, Naming, and Data Architecture](../../module-05-governance/README.md) → after completing the Work Lab
