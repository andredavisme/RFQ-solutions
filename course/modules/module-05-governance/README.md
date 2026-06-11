# Module 05: Governance, Naming, and Data Architecture

## Purpose

Design decisions that make everything else easier.

The failures addressed in Modules 01–04 are often symptoms of missing governance. When naming conventions are absent, status fields drift. When schema design is ad hoc, data integrity erodes. When AI tools are used without a collaboration framework, judgment is outsourced instead of augmented.

This module addresses the foundational layer: the decisions made before data is collected, before tables are created, before the first form is built. These decisions are the hardest to fix retroactively and the most leveraged when made correctly.

## Core Concepts

### Names Are Documentation

Every field name is a claim about what the field contains. A field named `dt` documents nothing. A field named `order_confirmed_at` documents: this is a timestamp (`_at`), it records when an order (`order_`) was confirmed (`confirmed`). Anyone reading the schema for the first time has the information they need.

Naming conventions are not aesthetic preferences — they are a communication contract between the person who writes the schema and every person who will ever query it. Breaking the convention is breaking the contract.

**Standard conventions:**
- `snake_case` for all identifiers — never `camelCase`, `PascalCase`, or `kebab-case` in database objects
- `_at` suffix for timestamps (`created_at`, `confirmed_at`, `fulfilled_at`)
- `_id` suffix for foreign keys (`vendor_id`, `order_id`)
- `is_` prefix for booleans (`is_active`, `is_confirmed`)
- Plural table names (`orders`, `vendors`, `line_items`) — not `order`, `vendor`, `line_item`
- Never abbreviate unless the abbreviation is universally understood and documented (`uom` for unit of measure, with a glossary entry)

### Governance Before Data

Governance is the set of rules that determine how data is created, named, accessed, changed, and deprecated. It must exist before data does — because retrofitting governance onto existing data requires migrating every record that violated the rules you hadn't written yet.

The minimum governance decisions before building:
1. **Naming conventions** — documented and enforced in code review
2. **Schema domains** — which tables belong to which business domain (e.g., `rfq_`, `vendor_`, `logistics_`)
3. **Access policies** — who can read, write, and modify each domain
4. **Change control** — how schema changes are proposed, reviewed, and deployed
5. **Deprecation rules** — how old fields are retired without breaking dependents

### Migration as Append-Only History

Schema migrations are the version history of your data model. They record every structural change — table creation, column addition, constraint modification — in sequence. They are permanent and irreversible.

The principle: **fix forward, never backward.** If a field was named incorrectly, add a new correctly-named field and deprecate the old one. Do not rename the column in production — every query, view, and application that references the old name breaks. The migration log documents what was wrong and what replaced it. Future maintainers can trace the decision.

Append-only migrations also mean: never edit a deployed migration. If a migration was wrong, write a new migration that corrects it. The history is the contract.

### The Database as Contract

Every column in a database is a promise to every application that depends on it:
- This field exists
- It contains data of this type
- It will not be renamed, removed, or have its meaning changed without a formal process

Breaking changes — removing a column, changing a data type, altering a constraint — require a migration plan, a deprecation period, and coordination with all consumers. This is not bureaucracy: it is the minimum discipline required to maintain a shared data model that multiple systems and people depend on.

### AI as Collaboration, Not Delegation

AI tools accelerate capable judgment. They do not replace it.

The failure pattern: using AI to generate schemas, queries, or communications without reviewing the output against the governance rules established in this module. The AI does not know your naming conventions, your domain boundaries, your access policies, or your deprecation rules — unless you tell it. And it will not flag when its output violates them — unless you ask.

The collaboration framework:
1. **Brief before prompt** — specify conventions, constraints, and context before asking for output
2. **Review gate 1** — does the output conform to naming conventions?
3. **Review gate 2** — does the output respect schema domain boundaries and access policies?
4. **Review gate 3** — does the output create any breaking changes or implicit dependencies?

AI output that passes all three gates is a draft. Human judgment makes it a decision.

## Lessons

| Lesson | Title | Concept |
|--------|-------|----------|
| [5.1](lesson-5-1.md) | Names Are Documentation | Apply snake_case naming conventions; distinguish `dt` from `order_confirmed_at` |
| [5.2](lesson-5-2.md) | Governance Before Data | Establish naming conventions, access policies, and schema domains before writing tables |
| [5.3](lesson-5-3.md) | Migration as Append-Only History | Why you fix forward, never backward |
| [5.4](lesson-5-4.md) | The Database as Contract | Every column is a promise; breaking changes require a formal process |
| [5.5](lesson-5-5.md) | AI as Collaboration, Not Delegation | Brief before prompt; three review gates in every AI-assisted workflow |

## Work Lab

Learners receive a broken schema — five tables from a quote workflow with mixed naming conventions, missing constraints, poorly named columns, and no domain separation.

The task:
1. Identify every naming convention violation
2. Rename all fields to conform to the standards from Lesson 5.1
3. Assign each table to a schema domain
4. Identify which columns would require a formal breaking-change process to modify
5. Write a one-sentence governance rule that would have prevented each violation

## Failure Categories Addressed

- `naming-governance-confusion`
- `no-single-source-of-truth`
- `dirty-state-visibility-missing`

## Capstone

This is the final module. Learners who complete all five modules and their Work Labs have built a complete operational framework:

- **See** failures before they compound (Module 01)
- **Prevent** failures at intake (Module 02)
- **Communicate** commitments that can be verified (Module 03)
- **Translate** external data without corrupting internal standards (Module 04)
- **Govern** the data model so every decision is traceable (Module 05)

The capstone assessment presents a composite scenario — an end-to-end RFQ lifecycle with embedded failures across all five domains — and asks learners to produce a remediation plan that addresses each layer.

## Navigation

← [Module 04: Vendor and External Party Data Flows](../module-04-vendor-flows/README.md)
→ [Course Overview](../../README.md)
