# Lesson 5.3 — Database as Contract

**Module:** 05 — Governance, Naming, and Data Architecture
**Concept:** Schema constraints are organizational commitments — enforce them at the data layer

---

## Context

Lessons 5.1 and 5.2 addressed how data is named and how schemas evolve safely. This lesson addresses what the database itself enforces — and what it leaves to application code, human discipline, or hope.

The database-as-contract principle holds that the schema is the most reliable place to encode the rules the organization has committed to. Application code can be bypassed. Human discipline fails under pressure. The database constraint does not.

---

## Concept: Database as Contract

Every constraint in the database schema is a statement about what the organization has decided is true. A `NOT NULL` constraint says: this field will always have a value — no exceptions. A `FOREIGN KEY` constraint says: this reference will always point to a real record. A `CHECK` constraint says: this value will always satisfy this condition.

When these constraints are absent, the organization has made a different statement: we will rely on something other than the database to enforce this rule. That something is usually application code — which is correct until it is not, and wrong in ways the database would have caught immediately.

### The Constraint Hierarchy

Constraints should be applied at the lowest possible layer — the layer closest to the data. From most to least reliable:

| Layer | Reliability | When to use |
|-------|-------------|-------------|
| **Database constraint** | Highest — cannot be bypassed by any application path | Structural rules that must always be true |
| **Database trigger** | High — fires on every write, but can be disabled | Rules that require dynamic computation |
| **Application validation** | Medium — only fires through the application path | UX-level feedback; not a substitute for DB constraints |
| **Manual process / checklist** | Low — depends on human execution | Rules that cannot be expressed in code; not a substitute for any of the above |

The failure pattern: rules that should be database constraints are implemented only at the application layer. A direct database write, a migration script, or a bulk import bypasses the application — and with it, the only enforcement of the rule.

### Constraints as Organizational Commitments

Each constraint type maps to a specific organizational commitment:

**`NOT NULL`** — We commit to always collecting this field at intake.
```sql
-- A required field is not optional with a note; it is NOT NULL at the schema level
ALTER TABLE rfq_requests ALTER COLUMN customer_id SET NOT NULL;
ALTER TABLE rfq_requests ALTER COLUMN required_ship_date SET NOT NULL;
```
If the organization later decides a field is not always required, that is a governance decision — not a schema cleanup.

**`FOREIGN KEY`** — We commit to referential integrity; orphaned records are not permitted.
```sql
-- Every order line references a real product
ALTER TABLE order_lines ADD CONSTRAINT fk_order_lines_product
  FOREIGN KEY (internal_sku) REFERENCES products(sku)
  ON DELETE RESTRICT;  -- 'RESTRICT' not 'CASCADE' — prevent silent data loss
```
`ON DELETE RESTRICT` is the governance-correct default: if a record has dependents, it cannot be deleted. `ON DELETE CASCADE` silently deletes all dependent records — a governance risk.

**`CHECK`** — We commit to the validity of this value.
```sql
-- Lead time days must be positive
ALTER TABLE vendor_quote_lines ADD CONSTRAINT chk_lead_time_positive
  CHECK (lead_time_days > 0);

-- Price must be non-negative
ALTER TABLE vendor_quote_lines ADD CONSTRAINT chk_price_non_negative
  CHECK (unit_price >= 0);

-- Effective range must be valid
ALTER TABLE vendor_parts ADD CONSTRAINT chk_effective_range
  CHECK (effective_to IS NULL OR effective_to > effective_from);
```

**`UNIQUE`** — We commit to the absence of duplicates on this key.
```sql
-- One active mapping per vendor part number per vendor
CREATE UNIQUE INDEX uq_vendor_part_active
  ON vendor_parts (vendor_id, vendor_part_number)
  WHERE effective_to IS NULL;  -- partial index: only enforced for active mappings
```

**Controlled vocabulary via `CHECK` or enum type** — We commit to the defined set of valid values.
```sql
-- Only defined certainty stages are permitted
ALTER TABLE vendor_quote_lines ADD CONSTRAINT chk_price_status
  CHECK (price_status IN ('catalog', 'estimated', 'quoted', 'confirmed', 'contracted'));
```

### What the Database Cannot Enforce

Not all business rules can be expressed as database constraints. Rules that cross record boundaries, require external data, or depend on business context must be enforced at the application layer — but the schema should still make them as difficult as possible to violate silently.

Examples of rules that require application-layer enforcement:
- "A customer commitment cannot be made against estimated vendor data" — requires reading two related records
- "A substitution requires customer authorization before fulfillment" — requires a workflow state check
- "A quote cannot be sent until all required fields are complete" — requires validating a set of fields as a unit

For these rules, the schema provides supporting structure (the certainty stage fields, the authorization flags, the required intake fields from Module 02), and the application enforces the cross-record logic. The two layers are complementary — neither alone is sufficient.

---

## Work Lab: Constraint Mapping

You are given a schema for a simplified RFQ system with 12 tables and no constraints beyond primary keys.

For each table:
1. Identify three fields that should have `NOT NULL` constraints and write the rationale
2. Identify all foreign key relationships and write `ADD CONSTRAINT` statements with the correct `ON DELETE` behavior
3. Write at least one `CHECK` constraint per table that encodes a business rule
4. Identify one rule that cannot be expressed as a database constraint and write the application-layer enforcement logic in pseudocode

> **Lab response recorded in:** `rfq_course_app.lesson_reflections`

---

## Reflection

1. **Past:** Has a rule your organization considered non-negotiable ever been violated because it was enforced only at the application layer? What bypassed the application?
2. **Present:** In your current schema, what is the ratio of rules enforced by constraints vs. rules enforced only by application code or process? Where are the highest-risk gaps?
3. **Future:** Write three constraints — one `NOT NULL`, one `FOREIGN KEY`, one `CHECK` — that would close the most consequential data integrity gap in your current environment.

> **Reflection recorded in:** `rfq_course_app.lesson_reflections`

---

## Key Principle

> The database is the organization's memory. Constraints are the organization's commitments encoded in that memory. Every rule that exists only in application code or human process is a rule that will eventually be violated by a path that bypasses them. Enforce at the lowest layer.

---

**Previous:** [Lesson 5.2 — The Append-Only Migration Principle](lesson-5-2.md)
**Next:** [Lesson 5.4 — AI Collaboration and the Three-Gate Review](lesson-5-4.md)
