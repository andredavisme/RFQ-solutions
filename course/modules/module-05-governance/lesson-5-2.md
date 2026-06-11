# Lesson 5.2 — The Append-Only Migration Principle

**Module:** 05 — Governance, Naming, and Data Architecture
**Concept:** Evolve schemas safely; never destroy history

---

## Context

Lesson 5.1 established naming conventions as a first-class governance artifact. This lesson addresses what happens when the schema needs to change — which it always does.

Schema migrations are one of the highest-risk operations in data governance. Done correctly, they preserve all existing data, maintain all existing integrations, and extend capability. Done incorrectly, they destroy history, break downstream consumers, and introduce the data integrity failures that Modules 01–04 were built to prevent.

---

## Concept: The Append-Only Migration Principle

The **append-only migration principle** states: when evolving a schema, prefer additions over modifications, and never delete data or columns that contain historical records.

This is not a technical limitation — it is a governance policy. It exists because:

1. **History is evidence.** Records in a database are the audit trail of business operations. Deleting a column deletes everything ever recorded in it.
2. **Downstream consumers break silently.** A query, a report, an API integration, or a downstream system that reads a column you renamed will not always fail loudly. Sometimes it fails quietly — returning nulls, wrong values, or stale cached results.
3. **You cannot predict all consumers.** In any mature system, a column has more readers than you know about. Migrations that modify or drop columns require complete consumer inventory — which is rarely complete.

### Safe Migration Patterns

**Pattern 1: Add, don't rename**

When a field needs a new name:
```sql
-- UNSAFE: rename destroys all references
ALTER TABLE orders RENAME COLUMN cust_ord_id TO customer_order_id;

-- SAFE: add new column, populate from old, deprecate old
ALTER TABLE orders ADD COLUMN customer_order_id text;
UPDATE orders SET customer_order_id = cust_ord_id;
-- Mark cust_ord_id as deprecated in schema comments
-- Remove only after all consumers have migrated (tracked in migration backlog)
COMMENT ON COLUMN orders.cust_ord_id IS 'DEPRECATED: use customer_order_id. Removal scheduled after [date].';
```

**Pattern 2: Add, don't modify type**

When a field's data type needs to change:
```sql
-- UNSAFE: type change may truncate or corrupt existing data
ALTER TABLE vendor_quotes ALTER COLUMN lead_time_days TYPE text;

-- SAFE: add new column with correct type
ALTER TABLE vendor_quotes ADD COLUMN lead_time_days_v2 integer;
UPDATE vendor_quotes SET lead_time_days_v2 = CAST(lead_time_days AS integer)
  WHERE lead_time_days ~ '^[0-9]+$';  -- only cast valid integers
-- Log rows where cast failed for manual review
```

**Pattern 3: Soft delete, don't hard delete**

When records need to be removed from active use:
```sql
-- UNSAFE: hard delete destroys history
DELETE FROM vendors WHERE is_active = false;

-- SAFE: soft delete preserves history
ALTER TABLE vendors ADD COLUMN IF NOT EXISTS deleted_at timestamptz;
UPDATE vendors SET deleted_at = now() WHERE is_active = false;
-- Application queries filter WHERE deleted_at IS NULL
-- Historical queries can still access deleted records
```

**Pattern 4: Versioned controlled vocab additions**

When a controlled vocabulary needs a new value:
```sql
-- SAFE: adding a new enum value
ALTER TYPE lead_time_status ADD VALUE IF NOT EXISTS 'contracted';

-- NEVER: removing an enum value that existing records use
-- Postgres does not support this directly — it requires rebuilding the type,
-- which will break any row that contains the removed value.
```

### The Migration Checklist

Every schema migration, before it is applied to production:

- [ ] **Consumer inventory completed** — all known readers of affected columns identified
- [ ] **Rollback plan documented** — if the migration must be reversed, what is the procedure?
- [ ] **Backfill plan for new columns** — if adding a NOT NULL column, what is the default or backfill strategy?
- [ ] **Deprecation notice issued** — for renamed/superseded columns, downstream consumers are notified with a removal date
- [ ] **Migration tested on a copy of production data** — not just on a synthetic test dataset
- [ ] **Audit log updated** — the migration is logged with author, date, rationale, and affected tables

### The Deprecation Period

Columns are never immediately removed after a rename or supersession. The deprecation period gives downstream consumers time to migrate:

```
migration_log
─────────────────────────────────────────────────────────────────
migration_id         uuid
applied_at           timestamptz
author_id            fk → users
table_name           text
change_type          controlled vocab  -- 'add_column' | 'rename_column' | 'deprecate_column' | 'remove_column' | 'add_table' | 'type_change'
column_name          text
rationale            text
deprecation_date     date              -- null if not a deprecation event
removal_eligible_at  date              -- earliest safe removal date
notes                text
```

---

## Work Lab: Migration Safety Review

You are given five proposed schema migrations written as SQL statements.

For each:
1. Identify whether the migration is safe or unsafe according to the append-only principle
2. If unsafe, write the safe alternative
3. Write the migration checklist entry for each migration
4. Identify which migration has the highest risk of silent downstream failure and explain why

> **Lab response recorded in:** `rfq_course_app.lesson_reflections`

---

## Reflection

1. **Past:** Has a schema change in your environment ever broken a downstream consumer — a report, an integration, or a query — without an obvious error? How was it discovered?
2. **Present:** In your current environment, is there a migration log? If yes, does it contain rationale for each change, or just the SQL? If no, how are schema changes tracked?
3. **Future:** Write the migration checklist item that would have prevented the most costly schema-related failure you have observed in your environment.

> **Reflection recorded in:** `rfq_course_app.lesson_reflections`

---

## Key Principle

> A schema migration that destroys data is not a technical problem — it is an irreversible governance failure. History cannot be reconstructed after deletion. Append, deprecate, and version. Never silently remove.

---

**Previous:** [Lesson 5.1 — Naming Conventions as Governance](lesson-5-1.md)
**Next:** [Lesson 5.3 — Database as Contract](lesson-5-3.md)
