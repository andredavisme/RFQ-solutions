# 07 — Data Cleaning Guide: Pipeline Architecture, Data Integrity Contracts, and Reproducible Transformation

**Source repo:** [andredavisme/data-cleaning-guide](https://github.com/andredavisme/data-cleaning-guide)  
**Completed:** 2026-06-10  
**Theme:** A practical reference guide for data cleaning, framed from the first sentence as an architecture problem rather than a tooling problem. Every transformation is a contract. Every pipeline has zones of trust. Every decision must be traceable. These principles are not academic — they directly determine whether business data remains reliable enough to drive operational decisions across lines of business and with external parties.

---

## 1. Data Cleaning Is Pipeline Architecture, Not a One-Time Task

The guide's opening statement is its most important: *"Every transformation you apply is a contract — it must be traceable, repeatable, and scoped. One undocumented transformation buried in a loop can silently corrupt downstream analysis."*

This reframes data cleaning from a remediation task ("clean up the mess") to an architectural discipline ("design the system so that data quality is maintained by construction"). The difference is whether data quality problems are discovered before they cause damage or after.

### Business Takeaway
**Every change to a business record is a transformation, and every transformation is a contract.** When a customer service rep updates a delivery date in the order system, that is a transformation. When a sales rep converts a quote to an order, that is a transformation. When an accounting team adjusts an invoice, that is a transformation. Each one must be traceable (who did it, when, why), repeatable (if done again under the same conditions, the result would be the same), and scoped (it changed exactly what it was supposed to change, nothing else).

**Applied to RFQ/service workflows:**
- Audit every place in your business where a record can be changed: order management, quoting tools, CRM, inventory, invoicing. Each is a transformation point.
- For each transformation point, ask: Is the change logged? Is the reason recorded? Is there a before/after record? If the answer to any of these is no, the transformation is undocumented and unaccountable.
- "Silent mutations" — changes that happen without logging — are the source of most data quality disputes: the customer says the delivery date was changed, your system shows no record. Prevent this by making every change to a committed record require an explicit reason and an audit entry.
- Design your forms, workflows, and system configurations to make undocumented changes impossible, not just discouraged.

---

## 2. Raw Data Is Sacred: The Inviolable Source Record

The guide states the rule absolutely: *"Never overwrite your source files. The raw zone is read-only. Always."* The pipeline zone architecture enforces this structurally — the raw zone flows in only one direction. Nothing flows back into it. Transformations happen in staging. Validated outputs land in the clean zone. Analysis is derived only from the clean zone, never from staging or raw.

The technical enforcement is explicit: make raw files read-only at the OS level. The architectural enforcement is the directory structure itself — raw, staging, clean, and analysis as separate zones with unidirectional data flow.

### Business Takeaway
**The original record of every transaction, commitment, and communication is a protected asset.** The original purchase order, the original quote, the original delivery promise, the original customer complaint — these are the raw zone of your business. They must never be overwritten. Every change, correction, or update belongs in a separate layer, linked to the original, not replacing it.

**Applied to RFQ/service workflows:**
- Never allow a quoting or order management system to overwrite the original record. All changes should create a new version, with the original preserved and accessible.
- If your current system overwrites records on update, every dispute you have with customers and vendors is operating without an evidence base. This is both a legal and operational risk.
- Define your business's zone architecture: what is the raw zone (original submissions, original commitments), what is the staging zone (working records under revision), what is the clean zone (confirmed, validated current state), and what is the analysis zone (reports and summaries derived from clean data)?
- Enforce zone boundaries procedurally even if your system does not enforce them technically: train staff that original records are read-only, and that changes go into a change log, not into the original.

---

## 3. Zones of Trust: Every Pipeline Needs a Defined Trust Boundary

The guide defines four explicit zones — Raw, Staging, Clean, and Analysis — and specifies what belongs in each and what flows between them. The key rule: analysis is derived only from the clean zone. Never from staging (incomplete transformations) or raw (untransformed, potentially corrupt source data).

This applies regardless of the tool: Python, SQL, a no-code platform, or a spreadsheet. The zones are an architectural concept, not a software feature.

### Business Takeaway
**Every business that generates reports has implicit data zones, but most have never made them explicit.** The spreadsheet where someone pulled raw data, made some adjustments, and built a chart is a pipeline with no zone separation. The report built from that spreadsheet is being driven by staging data masquerading as clean data. The business decisions made from that report are decisions made on uncertain data.

**Applied to RFQ/service workflows:**
- Map your current data flows explicitly: where does data come from (raw), where is it adjusted or transformed (staging), where does it land as the authoritative current record (clean), and what reports are derived from it (analysis)?
- Identify any place where reporting is being done directly from raw or staging data. These are the highest-risk points in your data distribution chain.
- Establish a formal definition of "clean data" for your most important data types: what does a clean customer record look like? A clean order record? A clean vendor record? What validations must pass before a record is considered clean?
- Reports and dashboards should have a documented lineage: what data source did this come from, what transformations were applied, and when was the underlying data last validated?

---

## 4. The Audit Trail: Every Decision Documented

The guide lists audit trails as a core principle: *"Document every decision: why a null was dropped, why a column was renamed, why a row was excluded. Future you will thank you."* The row count reconciliation pattern makes this mechanical: log input count, output count, and dropped count at every stage. Any unexplained drop is a bug.

The audit log structure is explicit: transform step name, timestamp, input row count, output row count, and rows dropped. This is not optional documentation — it is the evidence base for every downstream claim about data quality.

### Business Takeaway
**Every business data operation that changes the population of records — adding, removing, or modifying them — must be explainable.** If you run a report showing 847 open orders and a stakeholder asks why it was 892 last week, you need an audit trail that accounts for the 45-record difference. Without one, the answer is "I don't know," which is not an acceptable answer for operational decisions.

**Applied to RFQ/service workflows:**
- Implement row count reconciliation for every significant data operation: how many records entered the process, how many exited, and how many were dropped? Log this with a timestamp and a reason for any drop.
- For every exclusion rule in any report or dashboard, document the rule explicitly: "orders excluded from this report: cancelled orders, test orders, orders outside the current fiscal year." The exclusion rules are part of the report definition.
- When a report's numbers change unexpectedly, the audit trail is the investigation tool. Businesses without audit trails investigate data anomalies by asking people — which is slow, unreliable, and untraceable.
- Apply the same discipline to your customer and vendor master data: when a customer record is merged, archived, or deleted, log why, when, and by whom.

---

## 5. Null Handling: Not All Missing Data Is the Same

The guide establishes four categories of missing data, each requiring a different response:

| Type | Meaning | Correct Action |
|------|---------|----------------|
| MCAR (Missing Completely At Random) | No pattern | Safe to drop or simple impute |
| MAR (Missing At Random) | Pattern in other columns | Model-based imputation |
| MNAR (Missing Not At Random) | Absence IS the data | Flag it; don't impute blindly |
| Introduced | Created by a bad join or parsing error | Fix the upstream transform |

The most dangerous category is MNAR — where the absence of a value is itself meaningful information. Imputing a value for MNAR data destroys the signal.

### Business Takeaway
**A blank field is not always a missing value. Sometimes it is a deliberate signal.** A customer record with no email address may mean the customer declined to provide one (MNAR — the absence is meaningful), or it may mean the intake form didn't capture it (MAR — a process gap), or it may mean a bad import lost the value (Introduced — a system error). These three require different responses. Treating them all as "missing data to fill in" destroys information in the first and third cases.

**Applied to RFQ/service workflows:**
- For every field in your critical data records, define what a blank value means: is it "not collected," "not applicable," "declined to provide," or "system error"? These should be distinct values, not all represented as blank.
- Use explicit null reason codes where the distinction matters: `email_status: declined | not_collected | system_error | provided`. This preserves the signal in the absence.
- When integrating data from external parties (customers submitting RFQs, vendors providing price lists), document which fields are required, which are optional, and what a blank means for each. An optional field left blank is different from a required field that failed validation.
- Review your current blank-field population in key records: are the blanks uniformly distributed (MCAR) or concentrated in specific customer segments, time periods, or intake channels (MAR/MNAR)? The pattern tells you where your data collection process is failing.

---

## 6. Idempotency: Every Transformation Safe to Re-Run

The guide defines idempotency precisely: *"Every cleaning function must produce the same output no matter how many times it runs on the same input."* It provides a concrete counter-example: a function that appends "_processed" to a label every time it runs is not idempotent — it stacks on reruns. A function that normalizes email to lowercase is idempotent — running it ten times produces the same result as running it once.

The discipline also requires never mutating data in place: always work on a copy, never on the original.

### Business Takeaway
**Every business process that modifies data should be safe to re-run without producing a different result.** A nightly sync that re-imports yesterday's orders should not double-count them. A report refresh that re-applies discount rules should not compound them. A vendor price list update that re-processes existing quotes should not re-apply markups. Non-idempotent processes are the source of phantom duplicates, compounding discounts, and double-billing — all of which generate customer disputes.

**Applied to RFQ/service workflows:**
- Audit every automated or recurring data process for idempotency: if the process ran again right now, would the result be the same as if it ran once? If not, why not?
- Nightly or batch syncs between systems (CRM to ERP, order management to accounting, inventory to quoting) are the highest-risk area for non-idempotent operations. Test them by running them twice in sequence and comparing outputs.
- Use upsert logic (insert if new, update if exists) rather than blind insert logic for all recurring data loads. Blind inserts create duplicates on rerun; upserts are idempotent by design.
- The "never mutate in place" rule applies to business records too: never overwrite the record being processed. Work on a copy, validate the copy, then commit the copy as the new authoritative record.

---

## 7. Schema Assertions: Contracts at Every Stage Boundary

The guide uses Pandera schema validation to define what data should look like after each transformation: column types, value ranges, null allowability, and custom checks (e.g., email must contain '@', age must be between 0 and 120, revenue must be non-negative). These assertions run at every pipeline stage boundary. A schema violation is a pipeline failure — it should halt processing and surface the failure explicitly.

The `lazy=True` parameter collects all schema errors at once rather than stopping at the first one, enabling a complete quality report rather than serial debugging.

### Business Takeaway
**Every data record that passes from one business process to the next should be validated against a defined schema before it is accepted.** An order that enters the fulfillment process without a confirmed delivery address is a downstream problem disguised as an upstream omission. An invoice that enters the accounting system without a valid purchase order number is a payment dispute waiting to happen. Schema assertions are the checkpoints that catch these problems at the boundary, not at the consequence.

**Applied to RFQ/service workflows:**
- Define the minimum valid state for every record type that crosses a process boundary: what fields must be present, what types must they be, what value ranges are valid?
- Implement validation gates at each handoff: quote to order conversion, order to fulfillment, fulfillment to invoice, invoice to payment. A record that fails validation should not proceed until the failure is resolved.
- Report all validation failures, not just the first one. A record with five missing fields should surface all five failures at once, not require five sequential correction cycles.
- Build a validation failure rate metric for each process boundary: what percentage of records fail validation on entry? A high rate signals a systemic intake problem upstream. A low rate that suddenly spikes signals a process change or system error.

---

## 8. Scale Awareness: Right Tool for the Right Volume

The guide explicitly addresses scale: *"Working with 1.8M+ row raw files requires different tools than a 10K CSV. Know when to swap."* The tool comparison maps six options across use case, cost, and scale: Polars for speed at 1M+ rows, PySpark for distributed workloads, OpenRefine for inconsistent category clustering without code, dbt for SQL pipeline versioning, Power Query for business environments, and Alteryx/Tableau Prep for enterprise no-code pipelines.

The key principle: choosing a tool that cannot handle the scale of the data guarantees either failure or degraded quality (operations that time out, sample instead of process completely, or silently truncate).

### Business Takeaway
**A data process that works at current volume may fail silently or degrade visibly as volume grows.** A spreadsheet that handles 5,000 customer records adequately becomes unreliable at 50,000 and unusable at 500,000. A manual review process that works for 20 vendor invoices per week breaks at 200. Businesses that do not anticipate scale transitions get surprised by them at the worst possible time — during a growth period when reliability is most critical.

**Applied to RFQ/service workflows:**
- For every data process in your business, document the current volume and the volume at which the current approach would fail or degrade. This is your scale risk register.
- Identify the three processes most likely to be disrupted by a 5x increase in volume. These are your architectural priorities.
- When evaluating a new tool or system, include volume scalability as an explicit evaluation criterion: not just "can it do this today" but "can it do this at 5x our current volume?"
- The right tool is the one that handles current volume reliably, scales to projected volume without reengineering, and produces outputs that are traceable and auditable regardless of volume.

---

## 9. The Data Quality Report Before Analysis: Profile First

The guide identifies one habit that would save most projects: *"Write a data quality report before analysis begins — not after. Profile every column: null %, unique value counts, type distribution, min/max."* Tools like `ydata-profiling` or `sweetviz` generate this automatically.

This is the pre-analysis equivalent of the moratorium: a structured pause to understand what the data actually contains before drawing any conclusions from it.

### Business Takeaway
**Every significant data-driven business decision should be preceded by a data quality assessment of the underlying records.** A quarterly sales report built on unvalidated CRM data is not a quarterly sales report — it is a quarterly estimate with unknown error bounds. The profiling step makes the error bounds visible before the decision is made, not after.

**Applied to RFQ/service workflows:**
- Before any major operational report, business review, or strategic decision, run a data quality profile on the underlying records: What is the null rate for critical fields? What is the duplicate rate? Are there value ranges that suggest bad data (negative quantities, future dates in historical fields, unrealistically large values)?
- Build a recurring data quality dashboard for your most operationally critical data: customer master, order status, inventory, vendor pricing. It should surface null rates, duplicate counts, and out-of-range values automatically.
- When a new data source is introduced — a new vendor's price list, a customer's order format, an integration with a third-party system — run a full data quality profile before using it operationally. Unknown data quality is operational risk.
- Share data quality profiles with the teams that use the data. Data quality is not just an IT problem — it is a business operations problem, and the people closest to the data often know where the quality problems come from.

---

## Key Principles Summary

| Principle | Data Cleaning Pattern | Business Application |
|-----------|----------------------|----------------------|
| Transformation as contract | Traceable, repeatable, scoped | Every record change must be logged, reasoned, and bounded |
| Raw data is sacred | Raw zone is read-only, always | Original commitments and records are never overwritten |
| Zone architecture | Raw → Staging → Clean → Analysis | Define trust boundaries for every data flow in the business |
| Audit trail | Row count in/out/dropped at every step | Every record population change must be explainable |
| Null type classification | MCAR/MAR/MNAR/Introduced | Blank fields have different meanings; treat them differently |
| Idempotency | Same input always produces same output | Every recurring data process must be safe to re-run |
| Schema assertions | Validate at every stage boundary | Records that fail validation do not pass to the next process |
| Scale awareness | Right tool for right volume | Know the volume at which your current process degrades |
| Profile before analysis | Data quality report before drawing conclusions | Understand your data's error bounds before making decisions |
