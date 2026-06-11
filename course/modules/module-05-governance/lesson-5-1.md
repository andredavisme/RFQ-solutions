# Lesson 5.1 — Naming Conventions as Governance

**Module:** 05 — Governance, Naming, and Data Architecture
**Concept:** Establish and enforce naming standards that make data self-documenting

---

## Context

Modules 01–04 built the conceptual and structural foundations: recognizing failure patterns, intake completeness, communication discipline, and vendor data integrity. Module 05 addresses the layer that holds all of it together long-term: **governance**.

Governance begins with naming. A database schema, a spreadsheet, an API response, or a shared drive with inconsistent naming conventions is a system that requires human interpretation at every interaction. A system with enforced naming conventions is a system that communicates its own structure.

---

## Concept: Naming Conventions as Governance

Naming conventions are not stylistic preferences. They are a form of documentation that lives inside the data itself — and unlike external documentation, they cannot fall out of sync with the data they describe.

A well-named field communicates:
- What the value represents
- What data type it holds
- How it relates to other fields
- Whether it is an identifier, a flag, a timestamp, or a measurement

A poorly named field communicates none of this. It requires a data dictionary, tribal knowledge, or trial and error to interpret.

### The Core Naming Rules

**1. Timestamps end in `_at`**

```
created_at          timestamptz     ✅
updated_at          timestamptz     ✅
confirmed_at        timestamptz     ✅

creation_date       date            ✗  (ambiguous type; date ≠ timestamptz)
date_created        text            ✗  (reversed convention; type not communicated)
time_stamp          text            ✗  (generic; communicates nothing)
```

Every field that records when something happened ends in `_at`. This makes timestamps scannable in any schema listing.

**2. Foreign keys end in `_id`**

```
vendor_id           fk → vendors    ✅
customer_id         fk → customers  ✅
assigned_user_id    fk → users      ✅

vendor              text            ✗  (is this an id or a name?)
the_vendor          integer         ✗  (no convention signal)
vendor_ref          text            ✗  (ambiguous)
```

Every foreign key ends in `_id`. When you see `_id`, you know immediately: this is a reference, not a value.

**3. Booleans begin with `is_` or `has_`**

```
is_active           boolean         ✅
has_substitution    boolean         ✅
is_confirmed        boolean         ✅

active              integer         ✗  (0/1? true/false? ambiguous)
confirmed           text            ✗  ("yes"/"no"? "confirmed"/"pending"?)
status_flag         boolean         ✗  (what status? which flag?)
```

Booleans that begin with `is_` or `has_` read as questions with yes/no answers. This also prevents the common error of using a text field or integer to represent a boolean.

**4. Collection tables use plural nouns**

```
vendors             table           ✅
orders              table           ✅
routing_rules       table           ✅

vendor              table           ✗  (ambiguous: a row or a table?)
order_list          table           ✗  (redundant; all tables are lists)
VENDOR_MASTER       table           ✗  (legacy all-caps convention; not self-documenting)
```

A plural noun names a set of things. When you see `vendors`, you know it is a collection. When you see `vendor`, you cannot tell.

**5. No abbreviations without a glossary**

```
unit_of_measure     column          ✅
customer_order_id   column          ✅

uom                 column          ✗  (requires knowledge of the abbreviation)
cust_ord_id         column          ✗  (multiple valid expansions)
co_id               column          ✗  (company? customer order? change order?)
```

Abbreviations save keystrokes and cost interpretability. The only acceptable abbreviations are those defined in a published, linked glossary that every system contributor can access.

### Enforcing Naming Conventions

Naming conventions without enforcement are aspirational. Enforcement mechanisms:

1. **Schema linting** — automated checks that reject migrations violating conventions
2. **Code review criteria** — naming violations are a blocking review comment, same as logic errors
3. **A published conventions document** — linked from the repository README; a new contributor's first read
4. **Retroactive audits** — existing fields that violate conventions are flagged in a backlog and corrected during relevant refactors

### The Conventions Document

The conventions document is itself a governed artifact:
- Version controlled (changes go through review)
- A living document (exceptions are documented with rationale, not silently introduced)
- Linked from every relevant repository and data dictionary

---

## Work Lab: Schema Audit

You are given a schema listing with 20 field names drawn from a real-world legacy system.

For each field:
1. Identify the naming violation(s) present
2. Write the corrected field name following the conventions above
3. Note what the original name fails to communicate that the corrected name does
4. Flag any field name that is ambiguous enough that you cannot determine its intended meaning without additional context

> **Lab response recorded in:** `rfq_course_app.lesson_reflections`

---

## Reflection

1. **Past:** Identify one field name in a system you use that requires explanation or context to interpret. What does a new team member have to learn to understand what it contains?
2. **Present:** Does your current environment have a published naming conventions document? If yes, is it enforced? If no, where do the most costly naming inconsistencies live today?
3. **Future:** Write five naming rules for your environment — not a complete standard, just the five rules that would eliminate the most confusion in your specific context.

> **Reflection recorded in:** `rfq_course_app.lesson_reflections`

---

## Key Principle

> A field name is documentation. Unlike a comment or a data dictionary entry, it cannot be deleted without deleting the field itself. Write field names as if the person reading them has no other reference — because eventually, they won't.

---

**Next:** [Lesson 5.2 — The Append-Only Migration Principle](lesson-5-2.md)
