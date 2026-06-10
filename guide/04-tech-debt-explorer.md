# 04 — Tech Debt Explorer: Technical Debt as a Data Governance and Business Communication Problem

**Source repo:** [andredavisme/tech-debt-explorer](https://github.com/andredavisme/tech-debt-explorer)  
**Completed:** 2026-06-10  
**Theme:** A 35-question reflective tool on technical debt in business applications (CRM, ERP, and beyond) that encodes deep principles about expectation gaps, data quality, governance models, and the hidden costs of deferred decisions — all directly applicable to any business managing data flow across lines of business and with external parties.

---

## Overview of the Question Set

The 35 questions are organized into six thematic clusters, each of which surfaces a distinct dimension of how technical debt forms, grows, and is managed in business systems:

1. **Expectation gap** — misaligned definitions of value between vendor, buyer, and user
2. **Small-team reality** — survivable governance under constrained resources
3. **Preventing debt** — naming, documentation, ownership, and pre-change discipline
4. **Measuring debt** — signals, metrics, and time-to-change
5. **Success and outcomes** — what healthy looks like at 2 years, constrained vs. resourced
6. **Broader ecosystem** — data quality, adoption, AI, rebuild vs. refactor, governance models

Each cluster maps directly onto challenges in RFQ and service data workflows. The principles below draw from the questions directly.

---

## 1. The Expectation Gap Is a Data Problem

The first cluster asks: *How do you think the goals of a software vendor's sales team differ from the goals of the business buying the system?* And: *If sales messaging drives the implementation, what risks does that create for the long-term health of the system?*

These questions name a structural problem: the entity that sells a system is optimized for closing the sale, not for long-term data quality. When sales messaging drives implementation, the system is configured to demonstrate features, not to support the actual data flows the business will depend on for years.

### Business Takeaway
**Every system implementation that is driven by vendor demos rather than business data requirements accumulates technical debt before go-live.** The demo shows what the system can do. The implementation question is what the system must do, in what sequence, with what data, for which users, every day.

**Applied to RFQ/service workflows:**
- Before selecting any platform (CRM, ERP, quoting tool, order management system), document your required data flows in plain language, independent of any vendor's feature set.
- Evaluate vendor claims against your documented data requirements — not against the demo's impressiveness.
- When a vendor's implementation team arrives, give them your data flow documentation as the primary input, not their own implementation template.
- Post-implementation, audit whether the system actually supports the data flows you documented, or whether the flows were adapted to the system's convenience.

---

## 2. End Users Define Whether a System Succeeds or Fails

Two questions make this explicit: *What role do end users play in defining whether a business application succeeds or fails?* and *If end users are not represented strongly in the implementation process, what problems tend to emerge over time?*

The answer is structural: end users are the people who generate the data the system depends on. If they find the system cumbersome, they route around it — entering data elsewhere, skipping steps, or maintaining parallel records. Every workaround is a data flow that exists outside the system, which means it is invisible to reporting, unauditable, and unmaintainable.

### Business Takeaway
**A system that end users avoid is a system that produces incomplete, inaccurate data.** The problem is not user resistance — it is system design that failed to account for how users actually work. Technical debt in user-facing systems manifests as data quality debt: missing fields, inconsistent entries, and workaround records that never make it into the canonical system.

**Applied to RFQ/service workflows:**
- Include the people who will actually enter RFQ data — customer service reps, sales reps, logistics coordinators — in the design of every intake form, status workflow, and reporting view.
- When you observe workarounds (people using email instead of the system, maintaining separate spreadsheets, re-entering data by hand), treat each one as a signal that the system failed to meet a real need.
- Measure user adoption as a data quality metric, not just a change management metric. Low adoption means low data completeness. Low data completeness means unreliable reporting.

---

## 3. How Value Should Be Defined: Buyer, Seller, or User?

The question *How should the value of a business application be defined — by the buyer, the seller, or the user?* is not rhetorical. The answer the tool implicitly proposes: by the outcomes the system produces for the people who depend on it, measured against the data quality and process efficiency it enables.

Vendors measure value by license revenue and renewal rates. Buyers measure value by cost and feature coverage. Users measure value by whether the system makes their work easier or harder. Only users have direct, daily feedback on whether the system is producing good data.

### Business Takeaway
**Define system value in terms of data outcomes, not feature counts.** A system with 200 features but poor data quality is less valuable than a system with 20 features and clean, complete, accurate data.

**Applied to RFQ/service workflows:**
- Define success metrics for every system in your data flow in terms of data quality: quote data completeness rate, order accuracy rate, status field fill rate, duplicate record rate.
- Review these metrics at regular intervals — not just after go-live.
- When evaluating whether to renew, expand, or replace a system, lead with the data quality metrics, not the feature roadmap.

---

## 4. Survivable Governance for Small Teams

The small-team reality cluster asks: *What does 'survivable governance' mean to you?* and *If a small team can only spend 10–15 minutes per month on a specific system component, what does that tell you about that component's complexity?*

"Survivable governance" is the explicit acknowledgment that most businesses do not have a dedicated data governance team. They have 1–3 people who also do everything else. The governance model must fit that reality or it will not be followed. A component that requires more than 15 minutes per month of maintenance attention per person available is a component whose complexity exceeds the team's capacity to govern it.

### Business Takeaway
**Governance that cannot be maintained by the team that actually exists is governance that will fail.** Every data standard, naming convention, review process, and audit procedure must be designed for the staff and time that are actually available — not for an idealized team.

**Applied to RFQ/service workflows:**
- Audit every data governance practice currently in your organization against the actual time budget available to maintain it.
- Eliminate or simplify governance procedures that require more time than is available. A lightweight, consistently-followed process produces better data quality than a rigorous process that is never followed.
- For each system component, document the minimum maintenance activity required to keep it healthy. If that activity cannot be performed with available resources, the component is too complex.
- Design your RFQ data fields and status workflows to be self-maintaining where possible: required fields, dropdown validation, and automated status transitions reduce the manual governance burden.

---

## 5. Poor Naming Conventions Are a Data Debt Generator

The question *How do poor naming conventions contribute to technical debt over time?* surfaces a specific, underestimated form of data degradation. When fields, records, statuses, and categories are named inconsistently — or named by the person who created them for their own purposes — the names become meaningless to everyone else. Over time, no one knows what a field means, so it gets filled inconsistently, reported incorrectly, or abandoned.

### Business Takeaway
**Every ambiguous field name is a future data quality incident.** When a field called "Notes" accumulates 47 different types of information over 5 years, it cannot be reported on, searched reliably, or migrated cleanly. The naming decision made on day one determines the data quality ceiling for the lifetime of that field.

**Applied to RFQ/service workflows:**
- Establish a naming standard for every field in your RFQ and order management data model before implementation. Names should describe what the field contains, not who created it or when.
- Apply the same naming standard to status values, categories, tags, and record types. "Open," "In Progress," "Pending," and "Active" are not the same — define each precisely and use them consistently.
- Conduct an annual naming audit: identify fields that are being used inconsistently and either rename them, split them, or deprecate them.
- When onboarding new team members, naming conventions should be documented and explained, not just demonstrated by example.

---

## 6. Documentation Debt Is Technical Debt

*What is the relationship between documentation and technical debt? Can too little documentation itself be a form of debt?*

The answer is yes, explicitly. Undocumented decisions accumulate as institutional knowledge held by specific individuals. When those individuals leave, change roles, or are unavailable, the knowledge is gone. The system continues to run, but no one knows why it is configured the way it is, which means no one can safely change it.

### Business Takeaway
**Every undocumented configuration decision is a future maintenance liability.** The cost of documentation is small and one-time. The cost of undocumented systems is recurring and compounding: every change takes longer, every new team member requires more onboarding time, and every error is harder to diagnose.

**Applied to RFQ/service workflows:**
- Document the purpose of every custom field, workflow step, and status value in your RFQ system. "Why does this field exist and what should be in it?" should have a written answer.
- Document integration points between systems: what data flows from the CRM to the ERP, what triggers it, and what happens if it fails.
- Maintain a change log: every modification to a system configuration should be recorded with the date, the person, and the reason.
- Treat documentation as a deliverable, not an afterthought. No configuration change is complete until it is documented.

---

## 7. Standard Before Custom

*Why is 'standard before custom' a useful principle in business application management?*

Customizations are debt by definition. Every custom field, workflow, or integration is a deviation from the vendor's tested, supported baseline. It requires maintenance when the platform updates, documentation to explain it, and expertise to modify it. Standard features survive platform upgrades. Custom features often don't.

### Business Takeaway
**Every customization you add is a future maintenance obligation you are accepting.** The discipline of exhausting standard options before customizing is not conservatism — it is debt management. Standard features are maintained by the vendor. Custom features are maintained by you.

**Applied to RFQ/service workflows:**
- Before adding a custom field to your quoting or order management system, confirm that the business need cannot be met by an existing standard field used correctly.
- Maintain a register of all customizations in each system: what was customized, why, when, and by whom.
- Review the customization register annually and identify customizations that can be retired (the business need no longer exists), replaced by a standard feature (the platform has evolved), or simplified (the original implementation was more complex than necessary).

---

## 8. Measuring Debt: Time-to-Change as a Health Signal

*How does time-to-change — the time it takes to implement a new request — reflect the underlying state of a system?*

This is one of the most actionable metrics in the question set. In a healthy system, a straightforward change takes a predictable, short amount of time. In a debt-laden system, every change requires understanding dependencies, testing for unintended side effects, and navigating undocumented configurations. Time-to-change increases as debt accumulates — even if the change itself is simple.

### Business Takeaway
**Time-to-change is a leading indicator of system health, not a lagging one.** By the time data quality degrades visibly, the debt that caused it has been accumulating for months or years. Time-to-change is detectable earlier: when simple requests start taking longer than expected, debt is growing.

**Applied to RFQ/service workflows:**
- Track how long it takes to make standard types of changes to your quoting and order management systems: adding a new product category, changing a status value, modifying a routing rule. Establish baselines.
- When time-to-change for routine requests increases, investigate the cause before it compounds.
- Use time-to-change data to prioritize debt reduction work: the components where changes are slowest are the components where debt is highest.

---

## 9. Data Quality Amplifies Technical Debt

*How do data quality issues interact with and amplify technical debt in a business application?*

The relationship is bidirectional and compounding. Technical debt makes data quality harder to maintain: undocumented fields get filled inconsistently, complex workflows get bypassed, naming ambiguity produces duplicate records. Poor data quality then makes debt harder to address: you cannot safely refactor a system if you don't understand the data it contains, and you cannot migrate data you can't trust.

### Business Takeaway
**Data quality debt and technical debt are the same problem viewed from different angles.** You cannot solve one without addressing the other. A data cleaning initiative that doesn't address the system configurations that produced the dirty data will produce dirty data again. A system refactoring that doesn't account for the data quality implications of the change will produce new data quality problems.

**Applied to RFQ/service workflows:**
- Every data quality initiative should include a root cause analysis: why is the data dirty? Is it an intake problem (fields not required, no validation), a process problem (steps are bypassed), or a system problem (fields are ambiguous or redundant)?
- Fix the cause, not just the symptom. Cleaning data without fixing the intake process is maintenance, not improvement.
- Track data quality metrics over time: field completion rates, duplicate record rates, status field accuracy. If metrics improve after a cleaning initiative and then degrade again, the root cause was not addressed.

---

## 10. The Rebuild vs. Refactor Decision

*At what point should a business consider rebuilding rather than refactoring a struggling application?*

The question frames the decision correctly: it is not a technical decision, it is a business decision. Rebuild when the cost of continued maintenance (in time, errors, and opportunity cost) exceeds the cost of replacement. The challenge is that accumulated debt obscures the true cost of continued maintenance — each individual problem seems manageable, while the aggregate is not.

### Business Takeaway
**The decision to rebuild is the decision that debt accumulation was allowed to make for you.** Businesses that maintain rigorous debt awareness — tracking time-to-change, data quality metrics, and customization registers — make the rebuild decision at the right time, with data. Businesses that don't make it reactively, in crisis, with less information and more urgency.

**Applied to RFQ/service workflows:**
- Establish a system health review cadence: annually at minimum, quarterly for high-volume systems. Include data quality metrics, time-to-change trends, and customization register review.
- When a system reaches a debt threshold (define this in advance: e.g., time-to-change has doubled, data quality metrics have declined for 3 consecutive quarters), trigger a formal evaluation of refactor vs. replace.
- Do not make the rebuild decision in response to a specific failure. Make it in response to accumulated trend data.

---

## Key Principles Summary

| Principle | Tech Debt Explorer Question | Business Application |
|-----------|----------------------------|----------------------|
| Sales-driven implementations accumulate debt | Vendor goals vs. buyer goals | Document data requirements before evaluating vendors |
| End users define data quality | User role in system success | Include users in design; treat workarounds as signals |
| Value = data outcomes | How should value be defined? | Measure system success by data quality metrics |
| Survivable governance | What does survivable governance mean? | Design governance for the team that actually exists |
| Naming conventions are data integrity | How do poor names create debt? | Name standards before implementation; audit annually |
| Documentation is not optional | Documentation and debt relationship | Every config decision has a written explanation |
| Standard before custom | Why standard before custom? | Maintain a customization register; review annually |
| Time-to-change as health signal | Time-to-change and system state | Track change turnaround time as a leading indicator |
| Data quality and tech debt are linked | How do they interact? | Fix intake causes, not just data symptoms |
| Rebuild decision requires trend data | Rebuild vs. refactor threshold | Annual health reviews with defined debt thresholds |
