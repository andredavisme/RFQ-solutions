# RFQ-Solutions Project Tracker

**Purpose:** Assemble knowledge and philosophies from source repositories into a standalone, in-depth business knowledge guide — focused on improving data flow, preservation, accessibility, and accuracy across lines of business and with external parties (customers, vendors, transportation logistics).

**Space Context:** Communication Essential for Requests for Service

**Last Updated:** 2026-06-11

---

## 🗂️ Source Repositories

| # | Repo | Status | Output File | Notes |
|---|------|--------|-------------|-------|
| 1 | [finfolio](https://github.com/andredavisme/finfolio) | ✅ Complete | `guide/01-finfolio.md` | Data ownership, single source of truth, intake normalization, dirty-state visibility, round-trip fidelity |
| 2 | [underdog-war-room](https://github.com/andredavisme/underdog-war-room) | ✅ Complete | `guide/02-underdog-war-room.md` | Competitive intelligence as data, battlecard model, proof over declarations, pilot as proof, objection handling as structured data |
| 3 | [parts-spec-matcher](https://github.com/andredavisme/parts-spec-matcher) | ✅ Complete | `guide/03-parts-spec-matcher.md` | RFQ information asymmetry, schema isolation, vendor/distributor distinction, guided spec intake, transparent matching, authorization-driven routing, status lifecycle, role-based access, database integrity |
| 4 | [tech-debt-explorer](https://github.com/andredavisme/tech-debt-explorer) | ✅ Complete | `guide/04-tech-debt-explorer.md` | Expectation gaps, survivable governance, naming conventions, documentation debt, standard-before-custom, time-to-change as health signal, data quality amplification, rebuild vs. refactor |
| 5 | [data-solutions-for-me](https://github.com/andredavisme/data-solutions-for-me) | ✅ Complete | `guide/05-data-solutions-for-me.md` | Expectation-deviation-adaptation framework, automatic vs. manual events, two-stage event pipeline, context isolation, realtime visibility, annotation discipline, portfolio-ready scoping, exception documentation |
| 6 | [westbrook-datacenter-informed](https://github.com/andredavisme/westbrook-datacenter-informed) | ✅ Complete | `guide/06-westbrook-datacenter-informed.md` | Moratorium as decision discipline, taxonomy before evaluation, findings of fact, vision gap, risk register, opportunity list as negotiating positions, buyer-built comparison table, countdown forcing function, template principle |
| 7 | [data-cleaning-guide](https://github.com/andredavisme/data-cleaning-guide) | ✅ Complete | `guide/07-data-cleaning-guide.md` | Transformation as contract, raw data sacred, zone architecture, audit trails, null type classification, idempotency, schema assertions, scale awareness, profile before analysis |
| 8 | [field-tech-blueprint](https://github.com/andredavisme/field-tech-blueprint) | ✅ Complete | `guide/08-field-tech-blueprint.md` | Talent as infrastructure, PAE model, coachability over credentials, LOTO calm assertion, manual before instinct, root cause over symptom, documentation over verbal, PAE scenario stress-testing |
| 9 | [sales-scenario-training-portal](https://github.com/andredavisme/sales-scenario-training-portal) | ✅ Complete | `guide/09-sales-scenario-training-portal.md` | Dual-deliverable design, schema as minimum viable record, explicit access control vs. friction, voice discipline, stateless design as feature, migration convention, post-mortem + rule change, non-negotiable constraints |
| 10 | [internationally-tribal](https://github.com/andredavisme/internationally-tribal) | ✅ Complete | `guide/10-internationally-tribal.md` | AI as hammer not artist, creative brief before prompt, direction vs. execution model, inventory of human authorship, 5-phase build, judgment as asset to protect |
| 11 | [fork-in-the-road](https://github.com/andredavisme/fork-in-the-road) | ✅ Complete | `guide/11-fork-in-the-road.md` | Story-first positioning as evidence inventory, segment-specific data design, constraints as architecture inputs, pay-it-forward data integrity, request operations as data asset, templates as data contracts, actionable-only metrics, lean stack as risk management |
| 12 | [alexandria](https://github.com/andredavisme/alexandria) | ✅ Complete | `guide/12-alexandria.md` | Database as ecosystem single source of truth, append-only migration history, RLS by default, schema separation as domain enforcement, contribution workflow as change control, secrets in Vault never in code, governance before data, foundation discipline |

**Status Key:** ⬜ Not Started · 🔄 In Progress · ✅ Complete

---

## 🏁 All Source Repos Complete — Next Step: Build MASTER-GUIDE.md

All 12 source repositories have been processed. The next and final step is to synthesize all 12 guide files into a single `MASTER-GUIDE.md` that serves as the standalone, in-depth business knowledge guide.

To begin the synthesis session, paste the following into a new conversation:

> **"I'm continuing the RFQ-solutions project. The repo is at https://github.com/andredavisme/RFQ-solutions. All 12 source repos are complete. Please read all 12 guide files in the guide/ directory and synthesize them into MASTER-GUIDE.md — a standalone, in-depth business guide for improving data flow, preservation, accessibility, and accuracy across lines of business and with external parties (customers, vendors, transportation logistics)."**

---

## 📁 Output Structure

```
RFQ-solutions/
├── PROJECT-TRACKER.md        ← This file
├── README.md                 ← Project overview
├── guide/
│   ├── 01-finfolio.md
│   ├── 02-underdog-war-room.md
│   ├── 03-parts-spec-matcher.md
│   ├── 04-tech-debt-explorer.md
│   ├── 05-data-solutions-for-me.md
│   ├── 06-westbrook-datacenter-informed.md
│   ├── 07-data-cleaning-guide.md
│   ├── 08-field-tech-blueprint.md
│   ├── 09-sales-scenario-training-portal.md
│   ├── 10-internationally-tribal.md
│   ├── 11-fork-in-the-road.md
│   └── 12-alexandria.md
└── MASTER-GUIDE.md           ← Final synthesized guide (build next)
```

---

## 📝 Session Log

| Date | Session Summary |
|------|-----------------|
| 2026-06-10 | Project initialized. Repo created. Tracking document added. Ready to begin with repo #1: finfolio. |
| 2026-06-10 | Completed repos #1–10. Wrote guide files 01 through 10 covering: data ownership & round-trip fidelity (finfolio); competitive intelligence as data (underdog-war-room); RFQ data architecture & transparent matching (parts-spec-matcher); technical debt as governance problem (tech-debt-explorer); expectation-deviation-adaptation framework (data-solutions-for-me); informed decision-making & negotiation under time pressure (westbrook-datacenter-informed); pipeline zone architecture & data integrity contracts (data-cleaning-guide); workforce pipeline ROI & PAE model (field-tech-blueprint); scenario-based training design & post-mortem discipline (sales-scenario-training-portal); AI as creative collaborator, direction vs. execution, human authorship as asset (internationally-tribal). Next: repo #11 fork-in-the-road. |
| 2026-06-11 | Completed repo #11 fork-in-the-road. Wrote guide/11-fork-in-the-road.md covering: story-first positioning as evidence inventory, segment-specific data design, constraints as architecture inputs, pay-it-forward data integrity model, request operations as data asset, outreach templates as data contracts, actionable-only metrics, lean stack as risk management. One repo remaining: #12 alexandria. |
| 2026-06-11 | Completed repo #12 alexandria. Wrote guide/12-alexandria.md covering: database as ecosystem single source of truth, append-only migration history, RLS by default (security as architecture), schema separation as domain boundary enforcement, contribution workflow as change control process, secrets in Vault never in code, governance before data, foundation discipline as ecosystem maturity signal. ALL 12 SOURCE REPOS COMPLETE. Next step: synthesize MASTER-GUIDE.md. |
