# Lesson 5.4 — AI Collaboration and the Three-Gate Review

**Module:** 05 — Governance, Naming, and Data Architecture
**Concept:** Use AI tools safely in data governance workflows — apply the three-gate review to every AI-generated artifact

---

## Context

Modules 01–05 have built a framework for data integrity that depends on disciplined human judgment at key decision points: classifying failures (Module 01), validating intake completeness (Module 02), enforcing communication precision (Module 03), verifying vendor data certainty (Module 04), and encoding rules as schema constraints (Lessons 5.1–5.3).

AI tools are now embedded in most data and operations workflows. They accelerate schema drafting, query generation, documentation writing, and data transformation. This lesson addresses how to use them without undermining the governance framework you have built.

---

## Concept: The Three-Gate Review

The **three-gate review** is a structured evaluation applied to every AI-generated artifact before it enters a governed system. It does not prohibit AI contribution — it ensures AI output is treated as a first draft, not a final decision.

The three gates:

### Gate 1: Accuracy

*Does the output correctly represent the facts, rules, and constraints of this specific environment?*

AI models generate plausible output — output that is coherent, well-structured, and frequently correct in general terms but wrong in context-specific ones. The accuracy gate catches:

- **Field names that don't match your conventions** — an AI-generated schema may use `creation_date` instead of `created_at`, or `vendor` instead of `vendor_id`
- **Constraints that don't reflect your rules** — an AI may generate a `CHECK` constraint based on common patterns that doesn't match your controlled vocabulary
- **Logic errors in generated queries** — a query that looks correct but filters on the wrong join condition, uses the wrong aggregation window, or misses a `WHERE deleted_at IS NULL` for soft-deleted records
- **Invented fields or tables** — AI models may generate field names that sound reasonable but don't exist in your schema

**Gate 1 process:** Read the output line by line against the actual schema, actual controlled vocabularies, and actual business rules. Do not skim.

### Gate 2: Completeness

*Does the output include everything required, or does it omit constraints, edge cases, or required fields that the review process would catch?*

AI output is often correct as far as it goes but incomplete in ways that matter:

- **Missing constraints** — a generated migration that adds columns without adding `NOT NULL` or `CHECK` constraints
- **Missing edge cases** — a generated query that handles the happy path but not null values, empty sets, or records at boundary conditions
- **Missing governance fields** — a generated table that omits `created_at`, `created_by`, `updated_at`, or soft-delete fields that your conventions require
- **Missing deprecation handling** — a generated migration that renames a column without adding the deprecation comment or the new column alongside the old one (violating the append-only principle from Lesson 5.2)

**Gate 2 process:** Apply the relevant checklist from this course (the intake checklist from Module 02, the migration checklist from Lesson 5.2, the constraint mapping from Lesson 5.3) to the generated output. Checklists catch omissions; reading alone does not.

### Gate 3: Consistency

*Is the output consistent with all existing artifacts in the governed system — schemas, conventions, controlled vocabularies, and documented decisions?*

AI tools operating on a single prompt do not have full context of your governed system. They may generate output that is internally consistent but inconsistent with:

- **Your naming conventions** — generating `cust_id` in a system that uses `customer_id`
- **Your controlled vocabularies** — generating `status: 'active'/'inactive'` in a system that uses `is_active: boolean`
- **Your existing schema** — referencing a table that exists under a different name, or using a data type different from your standard for that kind of value
- **Previously documented decisions** — generating a routing rule that contradicts a governance decision made in a prior migration or documented in the conventions file

**Gate 3 process:** Cross-reference the generated output against the conventions document (Lesson 5.1), the migration log (Lesson 5.2), and any relevant existing schema sections. A diff against existing artifacts makes inconsistencies visible.

---

## Where AI Is Most Useful (and Most Risky)

| Task | AI contribution | Primary risk | Gate emphasis |
|------|----------------|--------------|---------------|
| Schema drafting | High — generates structural scaffolding quickly | Naming violations, missing constraints | Gates 1 + 2 |
| Query generation | High — handles complex SQL patterns | Logic errors, missing filters, wrong joins | Gate 1 |
| Documentation | High — generates clear prose from structured input | Inaccurate descriptions of business rules | Gate 1 |
| Migration scripting | Medium — generates correct SQL patterns | Violating append-only principle, missing checklist items | Gates 2 + 3 |
| Controlled vocabulary expansion | Low — requires deep organizational context | Introducing values inconsistent with existing vocab | Gates 1 + 3 |
| Routing rule definition | Low — requires organizational authorization context | Rules that contradict existing governance decisions | All three gates |

### The Prompt as Governance Input

The quality of AI output in governed contexts is directly proportional to the governance context provided in the prompt. A prompt that includes:
- The naming convention rules
- The relevant existing schema sections
- The specific controlled vocabularies
- The business rule being encoded

...will produce output that requires less Gate 1 and Gate 3 review than a prompt that says only "write a schema for vendor quotes."

Maintaining a **prompt library** — a set of tested, governance-aware prompts for common tasks — reduces review burden and produces more consistent AI output over time.

---

## Work Lab: Three-Gate Review

You are given three AI-generated artifacts: a schema migration, a SQL query, and a documentation section.

For each artifact:
1. Apply Gate 1: identify every accuracy error
2. Apply Gate 2: identify every omission against the relevant checklist
3. Apply Gate 3: identify every inconsistency with the naming conventions and existing schema provided
4. Write the corrected version of the artifact after all three gates have been applied

> **Lab response recorded in:** `rfq_course_app.lesson_reflections`

---

## Reflection

1. **Past:** Has AI-generated code or documentation ever introduced an error into your environment that was caught late — after it had propagated into production or into a customer-facing output? What gate would have caught it?
2. **Present:** In your current workflow, what review process (if any) is applied to AI-generated artifacts before they enter the governed system? Is it consistent?
3. **Future:** Write the three-gate checklist for the AI use case most common in your environment. What specific checks belong in each gate for that context?

> **Reflection recorded in:** `rfq_course_app.lesson_reflections`

---

## Key Principle

> AI output is a first draft, not a decision. The three-gate review is the process that turns a fast first draft into a governed artifact. Speed without review is not acceleration — it is debt with a delayed due date.

---

**Previous:** [Lesson 5.3 — Database as Contract](lesson-5-3.md)
**Next:** [Lesson 5.5 — Capstone: The Complete RFQ Data Architecture](lesson-5-5.md)
