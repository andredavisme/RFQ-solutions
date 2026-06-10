# 03 — Parts Spec Matcher: RFQ Data Architecture, Spec Normalization, and Transparent Customer Routing

**Source repo:** [andredavisme/parts-spec-matcher](https://github.com/andredavisme/parts-spec-matcher)  
**Completed:** 2026-06-10  
**Theme:** A purpose-built industrial parts procurement platform that encodes foundational principles about how data should flow between customers, distributors, and vendors in a request-for-quotation process — with particular depth on spec normalization, structured intake, transparent matching, and channel-compliant routing.

---

## 1. The Core Problem: Information Asymmetry in the RFQ Chain

The platform's collaboration brief names the structural problem directly: **the end user customer — the person who owns the equipment and needs the part — has the least visibility and control in a process they are most directly affected by.** In the traditional RFQ chain, the customer enters with incomplete spec information, the distributor's catalog knowledge is opaque, spec mismatches aren't surfaced until after delivery, and the customer cannot compare distributor responses on a common basis.

### Business Takeaway
**Every RFQ process has an information asymmetry problem.** The party who knows the most about what's available (the seller) and the party who knows the most about what's needed (the buyer) are not starting from the same information base. Closing that gap — by giving customers structured access to the same catalog logic the seller uses — improves quote quality, reduces rework, and shortens the sales cycle.

**Applied to RFQ/service workflows:**
- Audit where in your RFQ process information is withheld from the customer, even unintentionally. Pricing tables, lead times, substitution options, spec deltas — each is a gap that, when closed, reduces friction.
- Build customer-facing documentation that translates your internal technical vocabulary into plain-language questions and explanations.
- The customer who arrives with complete, correctly structured specs is cheaper and faster to serve than the one who arrives with a vague need. Invest in intake tools that help customers get there.

---

## 2. Schema Isolation: Keeping Data Boundaries Clear

All tables for the platform live in a dedicated PostgreSQL schema (`parts_matcher`) isolated from other projects on the same database instance. This is an explicit architectural decision: the data vocabulary of the system is cleanly separated and independently governed.

The schema is organized into four distinct entity groups with clear purpose separation:
- **Reference/Lookup tables** — the controlled vocabulary (vendors, brands, product types, spec definitions, units)
- **Catalog tables** — actual products and their spec values
- **Distributor & Authorization tables** — who is authorized to sell what
- **Workflow tables** — active requests, sessions, and status tracking

### Business Takeaway
**Data that serves different purposes should live in different places with different governance rules.** Reference data (product types, spec definitions) changes rarely and requires careful DBA oversight. Workflow data (customer requests, RFQ status) changes constantly and requires transactional integrity. Conflating them in a single unstructured table creates governance failures: reference data gets corrupted by operational activity, and operational data gets blocked by reference data change controls.

**Applied to RFQ/service workflows:**
- Separate your data into at least three governance tiers: (1) reference/master data that defines your vocabulary, (2) catalog/product data that describes what you offer, and (3) transactional data that records what customers have requested and what you have responded.
- Each tier should have its own update process, ownership, and audit discipline.
- Never store a customer's active request in the same table as your product catalog. The merge creates ambiguity, corrupts reporting, and makes auditing impossible.

---

## 3. Vendor vs. Distributor: A Critical Distinction

The data architecture makes an explicit, documented distinction between `vendors` (upstream suppliers from whom distributors buy) and `distributors` (customer-facing authorized sellers). These are separate entities with separate tables, separate roles, and separate data relationships. The platform preserves the manufacturer authorization chain without bypassing it.

> *"A vendor is an upstream supplier relationship (who the distributor buys from). A distributor is a customer-facing authorized seller. These are separate entities."*

### Business Takeaway
**Supply chain roles must be modeled as distinct entities in your data architecture.** When vendor and distributor are conflated into a single "supplier" concept, you lose the ability to track authorization chains, enforce territory rules, manage per-distributor pricing, or audit which customers were served by which channel.

**Applied to RFQ/service workflows:**
- Map every party in your supply chain to a distinct role: manufacturer, authorized distributor, reseller, logistics partner, end customer. Each role has different data access rights and different obligations.
- Build authorization tables that record which party is authorized to sell/fulfill what product lines, in what territories, at what price tiers.
- When a customer submits an RFQ, the routing decision should be driven by authorization data — not by whoever answers the phone first.

---

## 4. Guided Spec Intake: Translating Need Into Structured Data

The platform replaces blank technical spec forms with a conditional, plain-language question sequence. The `quote_template_fields` table includes three new columns that enable this: `plain_language_label` (the customer-facing question text), `condition_field_id` (which prior field must be answered first), and `condition_value` (what value it must equal for this question to appear).

This enables progressive disclosure: customers only see questions that are relevant to their prior answers. They can indicate "I don't know" for optional fields without being blocked. The platform translates their plain-language answers into structured spec values.

### Business Takeaway
**The quality of a quote depends entirely on the quality of the spec data that drives it.** Blank forms produce blank fields, guessed values, and mismatched products. Guided intake — built on product-type-specific question logic — produces complete, accurate, structured data at the point of customer entry, before anyone has spent time on a quote.

**Applied to RFQ/service workflows:**
- Replace open-ended RFQ forms with guided intake sequences tailored to your product or service categories.
- Each question should use language the customer uses, not the internal vocabulary your team uses.
- Build conditional logic: a customer replacing an electric motor should not be asked questions that only apply to hydraulic systems.
- Every field that cannot be answered should be explicitly marked as unknown — not left blank. "Unknown" is a valid, useful data value. Blank is ambiguous.
- Capture the intake path itself as data: which questions were answered, which were skipped, and which triggered follow-up questions. This is diagnostic data for improving your intake process over time.

---

## 5. The Match Engine: Algorithmic Transparency

The core matching logic is a PostgreSQL function (`parts_matcher.run_match`) that scores each catalog item against the customer's spec values using three match types:

| Match Type | Logic |
|------------|-------|
| `exact` | 1.0 if values match exactly, 0.0 if not |
| `nearest` | Smooth inverse distance: `1.0 / (1.0 + abs(customer − catalog))` |
| `range` | 1.0 if customer requirement is met by catalog value, 0.0 if not |

Results are ranked by spec match completeness score first, then by vendor priority second. Critically, the scoring rationale is stored as structured JSONB data (`spec_delta_notes`) and surfaced to the customer — not kept as an internal debug string.

### Business Takeaway
**Matching and ranking logic should be transparent to the customer, not just to the seller.** When a distributor presents a quote without explaining why they chose that specific product, the customer has no basis to evaluate whether it actually meets their need. Surfacing the match score and the spec deltas gives the customer information they need to make a confident decision — and reduces returns, disputes, and re-quotes.

**Applied to RFQ/service workflows:**
- Every product recommendation or substitution in a quote should include an explanation of the match rationale: which specs match exactly, which are approximate, and which were substituted.
- When you offer an alternative to what the customer specified, explain the delta. "We're substituting a 1.125" shaft for your 1.00" spec because it's the closest available" is more useful than just shipping the 1.125" without comment.
- Store match rationale as structured data (not narrative text) so it can be reviewed, audited, and used to improve catalog coverage over time.
- Track which spec fields most often produce mismatches — these are signals that your catalog needs expansion or that your intake questions need refinement.

---

## 6. Distributor-Neutral Routing: Authorization Without Favoritism

The platform routes customer RFQs to authorized distributors based on manufacturer authorization data — not commercial preferences, relationship history, or which distributor built the platform. Each distributor's `vendor_item_priority` is scoped per distributor, not global: different distributors can have different priority rankings for the same product lines.

The customer selects which authorized distributor to send their spec-complete RFQ to. The platform does not process payment and does not bypass the distribution channel.

### Business Takeaway
**Routing decisions should be data-driven and auditable, not relationship-driven and opaque.** When RFQ routing is determined by who the sales rep knows, which distributor has the best current relationship, or which system was built by which party, customers lose confidence in the process and channel integrity erodes. Authorization data that drives routing creates accountability and allows all parties to understand why a request went where it went.

**Applied to RFQ/service workflows:**
- Document the routing logic for every type of incoming request: what determines which team, person, or partner handles it?
- Build routing rules into your system rather than relying on tribal knowledge. "Requests for product line X go to distributor Y in region Z" is a data rule, not a memory.
- Provide customers visibility into where their request was routed and why. This is a trust-building mechanism, not a liability.
- When routing logic changes (new distributor, new territory, new authorization), update the data and notify all affected parties — don't rely on word-of-mouth.

---

## 7. Status Tracking Across the RFQ Lifecycle

The `rfq_status_log` table tracks state transitions per RFQ through four explicit stages: `submitted → viewed → responded → closed`. Each transition is a discrete, timestamped event — not an inferred state from the absence of another event. Customer sessions are ephemeral by design but can be upgraded to authenticated accounts to unlock request tracking.

### Business Takeaway
**RFQ status should be a fact, not an inference.** A request that was "sent" is not the same as one that was "viewed." One that was "responded to" is not the same as one that is "closed to the customer's satisfaction." Systems that collapse these distinctions into a single "status" field produce inaccurate reporting, missed follow-ups, and unresolved customer expectations.

**Applied to RFQ/service workflows:**
- Define every status your RFQ process can be in, and what event triggers each transition.
- Each status transition should be a logged event with timestamp, actor, and any relevant data change — not just an overwrite of a status field.
- Build customer-facing status visibility: a customer who can see that their request was received, viewed, and responded to does not need to call for an update.
- Use status log data to identify bottlenecks: requests that sit in "submitted" without moving to "viewed" indicate a routing or notification failure, not a slow customer.

---

## 8. Role-Based Data Access: Who Sees What and Why

The platform defines five distinct data access roles: anonymous public, customer session, distributor, sales rep, and admin. Each role has a defined set of read and write permissions tied to specific tables. Anonymous users can browse catalog and distributor data but cannot write to workflow tables. Distributors can only read requests routed to them and write status updates for those requests.

Admin access is gated by a JWT `app_metadata` claim — not just a role assignment — requiring an explicit, auditable credential.

### Business Takeaway
**Data access rights should match the business relationship, not the technical convenience.** Giving all users access to all data because "it's easier to set up" is a governance failure that becomes a liability when something goes wrong. The discipline of defining who can read and write what — and enforcing it at the database level, not just the application level — protects data integrity and creates a defensible audit trail.

**Applied to RFQ/service workflows:**
- Define a data access matrix for every role that touches your RFQ process: what can they see, what can they change, and what requires escalation?
- Customers should be able to see the status of their own requests. They should not be able to see other customers' requests, internal pricing, or distributor margin data.
- Distributors should be able to see requests routed to them. They should not be able to see requests routed to competing distributors.
- Enforce access controls at the data layer, not just the UI layer. Application-level access controls can be bypassed; database-level row security policies cannot.

---

## 9. Data Integrity at the Database Level

The architecture specifies a comprehensive set of integrity rules enforced at the database level: all foreign keys enforced, controlled unit vocabulary, valid product type / category relationships, audit columns on all mutable tables, soft delete via `is_active` flag (no hard deletion of reference data), and automatic session expiry.

### Business Takeaway
**Data integrity rules that exist only in application code will eventually be violated.** Every integration, import, bulk update, or emergency fix that bypasses the application layer will skip those rules. Rules enforced at the database level survive every bypass scenario.

**Applied to RFQ/service workflows:**
- Identify the five data integrity rules your business depends on most (e.g., every order must have a valid customer, every quote must reference an active product) and enforce them as database constraints, not application validations.
- Never hard-delete reference data. Use soft delete (`is_active`, `archived_at`) so that historical records remain queryable and audit trails remain intact.
- Audit columns (`created_at`, `updated_at`, `created_by`, `updated_by`) should be on every mutable table. This is not optional overhead — it is the minimum required to answer "what changed and who did it" when something goes wrong.
- Controlled vocabulary tables (like `spec_units`) prevent free-text proliferation. "inches," "in," "IN," and "inch" are the same unit but four different strings. Controlled vocabulary collapses them into one.

---

## 10. Two Workflows, One Data Model

The platform supports two distinct intake paths — sales-rep-initiated and customer-initiated — that converge at the same match engine and catalog data. The difference is who initiates and who has visibility, not what data is collected or how matching works.

This is the same principle as finfolio's multiple intake paths (manual entry, CSV, document parser) converging into a single state object: **the intake mechanism is a UI concern; the data model is a business concern.**

### Business Takeaway
**Your data model should not be designed around who initiates a transaction — it should be designed around what the transaction is.** A quote request initiated by a sales rep on behalf of a customer and a quote request initiated by the customer directly are the same business event. Modeling them identically at the data layer, while varying the intake UI and visibility rules, is the correct architecture.

**Applied to RFQ/service workflows:**
- Audit your current RFQ data model: do sales-rep-initiated requests and customer-initiated requests live in the same tables or different ones? If different, reconcile them.
- Build intake UIs for every channel you receive requests through (phone, email, web form, EDI, customer portal) but ensure all channels write to the same canonical request record.
- Reporting and analytics should work across all intake channels without requiring separate queries or reconciliation steps.

---

## Key Principles Summary

| Principle | Parts Spec Matcher Pattern | Business Application |
|-----------|--------------------------|----------------------|
| Close information asymmetry | Customer gets same catalog logic as seller | Invest in customer-facing spec intake tools |
| Schema isolation | Four distinct entity groups with separate governance | Separate reference, catalog, and transactional data |
| Vendor vs. distributor | Explicit separate entities with authorization table | Model every supply chain role distinctly |
| Guided spec intake | Conditional plain-language questions | Replace blank forms with product-type-specific intake |
| Transparent matching | JSONB spec delta notes surfaced to customer | Show match rationale, not just match result |
| Authorization-driven routing | Manufacturer auth table drives distributor selection | Routing rules are data, not memory |
| Explicit status lifecycle | `submitted → viewed → responded → closed` log | Every RFQ status transition is a logged event |
| Role-based access | Five roles with table-level read/write rights | Data access matrix enforced at database layer |
| Database-level integrity | FK constraints, controlled vocab, soft delete, audit cols | Integrity rules must survive application bypass |
| Single data model, multiple UIs | Both workflow types use same match engine | Intake channel is a UI concern; data model is not |
