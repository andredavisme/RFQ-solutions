# 12. Alexandria — Database Architecture, Migration Discipline, and Data Governance

> **Source repo:** [andredavisme/alexandria](https://github.com/andredavisme/alexandria)  
> **Ecosystem context:** The database and data pipeline foundation for the Warrior X ecosystem — all schemas, migrations, and data architecture decisions live here. It is the layer that all other projects are built on.

---

## Core Philosophy

alexandria exists because data architecture is not an afterthought — it is the foundation. Every frontend feature, every outreach template, every operational workflow described in this guide series ultimately depends on structured, reliable, governed data at the storage layer. If the database is wrong, everything built on top of it is wrong. Alexandria's philosophy is: **get the foundation right once, and maintain it with discipline forever.**

The principles here apply to any organization — large or small — that stores data in a relational database and must maintain that data across multiple projects, contributors, and time.

---

## Principle 1: The Database Is the Ecosystem's Single Source of Truth

alexandria is named for the library of Alexandria — a deliberate statement that this repository is where knowledge is stored, organized, and protected. In the Warrior X ecosystem, all structured data storage originates here. No other repo defines tables. No other repo decides RLS policy. No other repo names schemas. [cite:13]

**Business application:**
- **One repo, one authority:** When data structure questions arise — what columns exist, what the access policy is, what a field means — the answer lives in one place. Distributed schema definitions create contradictions; centralized schema definitions create clarity.
- **The database is a contract:** Every table and every column is a promise made to every application that reads or writes it. Changing that contract without a formal migration is a breaking change, even if the application "still works for now."
- **Naming the repo matters:** Calling the database repo "alexandria" instead of "db" or "backend" signals intent. It tells every contributor that this is a library to be curated, not a utility to be modified casually.
- **Concrete rule:** Establish one authoritative repository for all schema definitions before writing your first production table. Schemas defined in application code, ad hoc in a Supabase dashboard, or spread across multiple repos will drift and conflict.

---

## Principle 2: Migration Files Are Append-Only History

The most important rule in the training manual is stated without qualification: **never edit a migration file once it has been applied to production.** [cite:13] This is not a preference — it is a data integrity guarantee.

**Business application:**
- **Migration files are immutable records.** Editing an applied migration destroys the ability to reconstruct the database state from history. If a migration has a mistake, the fix is a new migration — not an edit to the old one.
- **The naming convention is a timestamp ledger:** The format `YYYYMMDD_NNN_description.sql` creates a chronological, ordered record of every change ever made to the database. This is the database equivalent of a git commit log — it tells you what changed, when, and in what order.
- **Migrations as audit trail:** For regulated industries, compliance requirements, or any business where data provenance matters (RFQ traceability, vendor record integrity, logistics chain of custody), a complete, immutable migration history is not just good practice — it may be legally required.
- **Concrete rule:** Store all migration files in a versioned directory (`/migrations`). Name them with the full `YYYYMMDD_NNN_description.sql` convention from day one. Never rename, edit, or delete an applied migration. If a mistake was made, document it and fix it forward.

---

## Principle 3: RLS Is Not Optional — Security by Default

Row Level Security (RLS) must be enabled on every table — no exceptions. [cite:13] The minimum policy set (public read for non-sensitive data, write restricted to authenticated users or service role) is a floor, not a ceiling. This is not just a Supabase convention; it is a data governance principle applicable to any system with multi-tenant or multi-role access.

**Business application:**
- **Default to least privilege:** Every table starts locked. Access is explicitly granted, never assumed. This prevents the most common class of data exposure: a table that was accidentally left open because no one thought about who should see it.
- **Public read is a deliberate decision, not a default:** Community data (civic reference tables, publicly visible content) can be read by anyone — but that is a deliberate policy choice, documented in a migration, not an accident of omission.
- **Write access is the high-risk surface:** Anonymous write access is the source of most data integrity problems in production systems — spam, corruption, unauthorized record creation, and overwriting. The rule is simple: no public write access without explicit justification and review.
- **RLS as business rule enforcement:** RLS policies are not just security — they encode business rules. "Only the assigned account manager can update this record." "Only authenticated users from this organization can read these vendor quotes." These are business logic decisions, and they belong in the database, not scattered across application code.
- **Concrete rule:** Every `CREATE TABLE` migration must be followed by an RLS enable and policy migration before the table is used in production. Make this a checklist item in every PR review.

---

## Principle 4: Schema Separation as Domain Boundary Enforcement

alexandria uses two schemas with distinct purposes: `public` for general app data (Skunk Works projects) and `alexandria` for reference data, training content, and civic data. [cite:13] This separation is not cosmetic — it enforces domain boundaries at the database level.

**Business application:**
- **Schema boundaries prevent domain bleed:** When all tables live in `public`, transactional data, reference data, and operational data intermingle. Queries become complex. Access policies become harder to reason about. Schema separation makes domain ownership visible and enforceable.
- **Reference data is different from transactional data:** Reference data (civic data, training content, lookup tables) changes slowly, is read-heavy, and is often shared across multiple applications. Transactional data (orders, sessions, user events) changes frequently, is write-heavy, and is often application-specific. Storing them in the same schema with the same access model is a governance mistake.
- **Schema as communication:** When a new contributor sees `alexandria.locations` vs. `public.rfq_requests`, they immediately understand which domain each belongs to, who owns it, and how it is likely used. Schema names are documentation.
- **Concrete rule:** Before creating a new table, decide which domain it belongs to. If it represents stable reference data shared across multiple applications, it belongs in a reference schema. If it represents operational records for a specific application, it belongs in that application's schema. Document this decision in the migration file header comment.

---

## Principle 5: The Contribution Workflow Is a Change Control Process

The contribution workflow for alexandria — issue first, branch from main, write migration, add RLS, commit with semantic prefix, PR, review, no merge without review, never apply to production without staging — is a formal change control process. [cite:13] For a database repo, this rigor is not bureaucracy; it is protection.

**Business application:**
- **Issue before branch:** Requiring a GitHub issue before starting schema work ensures that every change has a documented rationale. This creates a searchable record of *why* each table was created, not just *what* was created.
- **Staging before production:** No migration goes to production without testing on a staging environment. For businesses managing vendor data, customer records, or financial information, an untested migration that corrupts production data is a business-stopping event.
- **Review is not optional:** Schema changes affect every application that reads or writes the changed tables. A single reviewer who understands the downstream impact can catch breaking changes that the author, focused on their immediate task, may have missed.
- **Semantic commit prefixes:** Using `schema:` as a commit prefix for migrations makes the git log scannable. A quick `git log --oneline | grep schema:` shows the complete history of database changes. This is especially valuable during incident response when you need to know what changed recently.
- **Concrete rule:** Treat every schema change — even "small" ones like adding a nullable column — as a production deployment. Require an issue, a PR, a reviewer, and a staging test before merging. The cost of this discipline is low; the cost of skipping it is high.

---

## Principle 6: Secrets Belong in Vault, Never in Code

The security rules are unambiguous: no secrets, passwords, or API keys in any SQL file or commit; the service role key goes in Supabase Vault only; never expose write access to anonymous users. [cite:13] These rules apply universally, not just to database repos.

**Business application:**
- **A secret in a commit is a permanent exposure:** Git history is forever. Even if a secret is removed in a subsequent commit, it remains in the history and must be considered compromised. The only safe policy is to never commit secrets in the first place.
- **Vault as the single secrets location:** Using Supabase Vault (or an equivalent secrets manager) as the only place where service credentials live means there is one place to rotate, audit, and revoke access. Credentials scattered across environment files, config files, and application code cannot be managed coherently.
- **The service role key is the master key:** In Supabase, the service role key bypasses RLS entirely. It must never appear in frontend code, never be committed to any repo, and never be shared outside of server-side or automated pipeline contexts.
- **Concrete rule:** Before any repo is made public (or before any contributor is added), run a secret scan on the full commit history. Treat any detected secret as compromised immediately, rotate it, and document the incident.

---

## Principle 7: The Empty Repo Is the Hardest Phase

alexandria was initialized with structure and conventions but no active schemas yet. [cite:11] The training manual, migration convention, RLS standard, and contribution workflow were all established before the first table was written. This sequencing is intentional and instructive.

**Business application:**
- **Governance before data:** The most common database mistake is writing tables first and establishing governance after. By the time governance arrives, there are already tables without RLS, migrations with inconsistent names, and schemas with no domain logic. Retrofitting governance is ten times harder than starting with it.
- **Convention documentation is a forcing function:** Writing the naming convention, the contribution workflow, and the security rules before writing any migrations forces the team to agree on standards before disagreements arise from conflicting implementations.
- **The empty repo as invitation:** An initialized repo with clear conventions and an open "what is the first table to build?" question is an invitation for structured participation. It signals that contributions are expected, that standards exist, and that the work is ready to begin when the business need is clear.
- **Concrete rule:** Before writing the first migration in any database project, document three things: the naming convention for migration files, the RLS policy standard, and the schema organization logic. These three decisions shape every future contribution.

---

## Principle 8: Database Architecture Reflects Ecosystem Maturity

alexandria is the foundation that all other Warrior X repos are built on. [cite:13] The fact that it was initialized with care, given a dedicated repo, named deliberately, and equipped with a training manual before any schemas were written reflects a level of ecosystem maturity that directly determines the reliability of every application built on top of it.

**Business application:**
- **The database reveals organizational discipline:** A database with consistent naming, complete RLS, clean migration history, and documented schema decisions is the product of organizational discipline that extends far beyond the database itself. Conversely, a chaotic database — inconsistent names, missing policies, undocumented tables — reflects broader organizational patterns.
- **Foundation investment pays forward:** The time spent establishing alexandria's conventions before writing the first table will be repaid every time a contributor asks "where does this table go?" or "how do I name this migration?" and finds the answer already documented.
- **Cross-repo dependency is a governance responsibility:** When the sales-scenario-training-portal, parts-spec-matcher, or any other Warrior X project needs persistent storage, it will reach into alexandria. That dependency makes alexandria's governance a shared responsibility across the ecosystem, not just a database concern.
- **Concrete rule:** Review your database architecture the same way you review your org chart: regularly, with an eye toward whether the current structure still reflects how the business actually works. As the business grows, schema boundaries, access policies, and domain definitions may need to evolve — and that evolution should be deliberate, documented, and migration-driven.

---

## Summary of Principles

| # | Principle | Core Idea |
|---|-----------|----------|
| 1 | Database as ecosystem single source of truth | One repo owns all schema definitions; distributed schema creates contradiction |
| 2 | Migration files are append-only history | Never edit an applied migration; fix forward with a new migration |
| 3 | RLS is not optional | Default to least privilege; write access is the high-risk surface |
| 4 | Schema separation as domain boundary enforcement | Reference data and transactional data belong in separate schemas |
| 5 | Contribution workflow as change control | Issue → branch → migrate → RLS → PR → review → staging → production |
| 6 | Secrets in Vault, never in code | A secret in a commit is a permanent exposure; rotate immediately if found |
| 7 | Governance before data | Establish conventions before writing the first table |
| 8 | Database architecture reflects ecosystem maturity | Foundation discipline determines the reliability of everything built on top |

---

*Guide section derived from: [alexandria](https://github.com/andredavisme/alexandria) — training manual, PROGRESS log, and README.*
