# 01 — FinFolio: Data Flow, Preservation, and Accuracy in Client-Side Financial Tools

**Source repo:** [andredavisme/finfolio](https://github.com/andredavisme/finfolio)  
**Completed:** 2026-06-10  
**Theme:** How a zero-dependency, browser-only financial portfolio app encodes deep principles about data ownership, flow integrity, and accurate state management — directly applicable to any business managing structured data across lines of business and with external parties.

---

## 1. The Core Philosophy: Data Stays Where It Is Trusted

FinFolio's foundational design decision is that **data never leaves the user's device** unless the user explicitly exports it. There is no server, no account, no background sync. All state lives in a single JSON file (`finfolio-data.json`) on the user's own device.

### Business Takeaway
For organizations distributing information across departments, vendors, and logistics partners, the instinct is often to centralize everything. FinFolio demonstrates a complementary principle: **the owner of the data should also be its custodian.** When data leaves its origin — through sync, handoff, or transmission — that is a deliberate, auditable act, not a passive background process.

**Applied to RFQ/service workflows:**
- A customer's request-for-quote data should not be automatically copied or shared until the business has validated it.
- Vendor pricing data should not flow downstream to logistics until it has been reviewed at the source.
- Every data handoff is an opportunity for error; minimizing automatic handoffs minimizes data corruption.

---

## 2. A Single Canonical Data Structure

FinFolio represents all financial state in one object:

```js
const state = {
  transactions: [ /* { id, date, amount, category, type, status, tag, description, sample? } */ ],
  notes:        [ /* { id, title, tag, body, createdAt, sample? } */ ],
  parsedRows:   [],   // transient staging
  csvRows:      []    // transient staging
};
```

All views — Dashboard, Transactions, Planner, Documents, Notes — read from and write to this one structure. There is no secondary store, no hidden cache, no shadow copy.

### Business Takeaway
**One source of truth eliminates reconciliation cost.** When multiple departments or external parties each maintain their own copy of the same data (e.g., a customer's shipping address in the CRM, the ERP, the carrier portal, and a spreadsheet), any update requires touching all four. FinFolio's model proves this is unnecessary complexity at the design level.

**Applied to RFQ/service workflows:**
- Maintain a single authoritative record for each quote, order, or service request — not one per system.
- Downstream views (finance sees costs, logistics sees delivery details, customer sees status) should all read from the same record, not their own copy.
- Transient staging areas (like `parsedRows` and `csvRows` in FinFolio) are fine for *in-progress* data, but must be collapsed into the canonical record before any handoff.

---

## 3. Explicit, Structured Data Types

Every transaction in FinFolio carries a defined `type` (`income | expense | goal`) and `status` (`actual | expected`). These aren't free-text fields — they are enforced enumerations. The distinction between `actual` and `expected` data is central to the Planner view's budget-vs-actual analysis.

### Business Takeaway
**Data that distinguishes between confirmed and anticipated state is more useful than data that doesn't.** A purchase order that has been sent is different from one that has been confirmed. An invoice that is due is different from one that has been paid. Systems that blur these distinctions create false confidence.

**Applied to RFQ/service workflows:**
- Every record in an RFQ system should carry a status that clearly distinguishes: *Requested → Quoted → Accepted → Ordered → Shipped → Delivered → Invoiced → Paid.*
- Each status transition should require an explicit action and create an audit trail — not be inferred from the absence of something else.
- Reporting views should always clarify whether figures include expected/pending items or only actuals.

---

## 4. Multiple Intake Paths, One Destination

FinFolio supports three independent ways to get data into the system:
1. **Guided intake** (`intake.html`) — a structured multi-step onboarding flow
2. **Manual entry** — individual transaction records entered directly
3. **CSV import** — bulk import from a standardized template
4. **Document parser** — free-text paste parsed by heuristics into structured rows

All four paths converge into the same `state.transactions` array.

### Business Takeaway
**Different data sources have different shapes and quality levels.** A customer submitting an RFQ over email, through a web form, or via EDI are all delivering the same underlying information — but with different fidelity, format, and error risk. A well-designed intake process normalizes all three into the same canonical structure *before* the data enters the workflow.

**Applied to RFQ/service workflows:**
- Build intake pipelines for each channel you accept data from (email, phone, web form, EDI, API).
- Each pipeline should validate and normalize before the data is committed — not downstream.
- Free-text and unstructured inputs (like FinFolio's document parser) require the most validation; build explicit review steps before they enter the main record.
- A staging/preview step (like FinFolio's import preview table) gives operators a final confirmation gate before data is committed.

---

## 5. The Dirty-State Pattern: Know When Data Has Changed

FinFolio tracks whether unsaved changes exist using a "dirty state" flag. The Save button turns teal when there are uncommitted changes. The browser's `beforeunload` event fires a warning if the user tries to close the tab with unsaved data.

### Business Takeaway
**Data systems should make the state of changes visible, not invisible.** The most common cause of data loss in business workflows is not technical failure — it is operators not knowing whether their changes were saved, submitted, or propagated.

**Applied to RFQ/service workflows:**
- Any form used to edit a quote, order, or customer record should clearly indicate whether changes have been saved.
- Handoff workflows should require explicit confirmation — not just a click-through — before a record moves from one status to the next.
- Audit logs should record *who changed what and when*, not just the final state of the record.
- "Draft" and "Submitted" are fundamentally different states and must be treated as such by the system.

---

## 6. Export as Preservation: The JSON Round-Trip

FinFolio's save mechanism exports a `finfolio-data.json` file. The full save/export/import round-trip is the centerpiece of the testing checklist — the test verifies that after export and re-import, record count, goal count, and note count are identical. Nothing is lost in translation.

### Business Takeaway
**Data preservation is not just about backups — it is about fidelity through transfer.** When a record moves from a CRM to an ERP, from an order management system to a carrier portal, or from a vendor's quote to your internal cost tracking, the data must survive intact. Testing that fidelity explicitly is as important as building the transfer mechanism.

**Applied to RFQ/service workflows:**
- Any data integration between systems should have a defined round-trip test: export a record, import it elsewhere, confirm all fields are present and correct.
- Identify which fields are lossy in each integration (fields that get dropped, truncated, or defaulted). Document and remediate them.
- Never assume a system integration is working because no errors appeared. Test that the data *arrived correctly* — not just that it *left without error*.

---

## 7. Graceful Degradation and Edge Case Handling

FinFolio's CSV import does not crash on malformed data. When an unknown `type` value is encountered, it defaults to `expense`. When an unknown `status` is found, it defaults to `actual`. The testing checklist explicitly validates these edge cases.

### Business Takeaway
**Incoming data from external parties — customers, vendors, carriers — will always be imperfect.** A business data system that fails on unexpected input is brittle. One that applies sensible defaults and flags the anomaly for review is robust.

**Applied to RFQ/service workflows:**
- Define a default handling rule for every field that could arrive in an unexpected format or be missing entirely.
- Log and surface anomalies for human review rather than silently dropping or corrupting data.
- Communicate expected data formats clearly to external parties (e.g., provide a CSV template, as FinFolio does, so they know exactly what you expect).
- Run periodic audits of defaulted values to identify upstream data quality problems before they compound.

---

## 8. Deployment Integrity: The ZIP Download Gap

FinFolio's architecture notes document a known deployment gap: the "Download FinFolio (ZIP)" button points to a file (`finfolio.zip`) that does not yet exist in the repository. The documentation explicitly flags this, describes the steps to resolve it, and notes that the ZIP must be rebuilt whenever either HTML file changes.

### Business Takeaway
**Known gaps in data distribution should be documented, not hidden.** When a report, export, or data feed that recipients rely on is out of date, missing, or not yet operational, that fact should be communicated explicitly — not discovered when the recipient tries to use it.

**Applied to RFQ/service workflows:**
- Maintain a living document of known data gaps, pending integrations, and temporary workarounds in all data distribution workflows.
- When a data feed or report is delayed, notify downstream recipients proactively rather than waiting for them to report errors.
- Treat data distribution artifacts (exports, reports, feeds) with the same versioning discipline as the source data — if the source changes, the artifact must be updated.

---

## 9. Money Management Philosophies as a Model for Data Governance

FinFolio's README documents six personal finance philosophies (Zero-Based Budgeting, Pay Yourself First, 50/30/20, Envelope Method, Cash Flow–First, Values-Based Spending). Each philosophy represents a different mental model for allocating and tracking resources — and FinFolio supports all of them without prescribing one.

### Business Takeaway
**Data governance frameworks, like money management philosophies, should match the organization's actual operating model.** A rigid top-down data governance policy will fail in a decentralized company the same way zero-based budgeting fails for someone with irregular income.

**Applied to RFQ/service workflows:**
- Audit how data actually flows in your organization before designing how it *should* flow.
- Match data management tools and processes to the team's actual behavior patterns, not an idealized model.
- Build flexibility into data workflows: the same underlying information (a quote, an order) may need to be viewed through different lenses by different stakeholders (finance, logistics, customer service).
- Start with what you know is true, then let the data reveal where the gaps are — as FinFolio's own philosophy states.

---

## Key Principles Summary

| Principle | FinFolio Pattern | Business Application |
|-----------|-----------------|----------------------|
| Data ownership | Local-only; no involuntary sync | Each data owner controls release of their records |
| Single source of truth | One `state` object, all views read from it | One canonical record per quote/order/customer |
| Typed, enumerated fields | `type` and `status` are enforced enumerations | Status fields must be structured, not free-text |
| Multiple intake paths | Manual, CSV, parser — all normalize to same structure | All intake channels normalize before commit |
| Dirty-state visibility | Save button + beforeunload guard | UI and workflow must surface uncommitted changes |
| Round-trip fidelity | Export/import test is a first-class test case | All data integrations must be round-trip tested |
| Graceful degradation | Bad CSV data defaults and flags, not crashes | Malformed incoming data → default + flag, not fail |
| Document known gaps | ZIP file gap explicitly documented | Known data distribution gaps must be communicated |
| Philosophy-matched governance | Supports any budgeting approach | Data workflows must match actual org behavior |
