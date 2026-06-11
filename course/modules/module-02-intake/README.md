# Module 02: Intake and Minimum Viable Complete Record

## Purpose

Stop failures at the door.

Most data problems don't begin in the database or the warehouse — they begin in the form, the email, the phone call. This module rebuilds intake flows from first principles. The goal is a **minimum viable complete record**: the smallest set of fields that, when filled correctly, ensures every downstream process can proceed without ambiguity.

If Module 01 trained learners to *see* failures, Module 02 trains them to *prevent* the most common one: letting incomplete, ambiguous, or unvalidated data enter the system.

## Core Concepts

### The Minimum Viable Complete Record

A record is complete when every field required for downstream processing is present, validated, and unambiguous. Not every field needs to be filled — only the fields without which the next step cannot proceed correctly.

A minimum viable complete record has three properties:
1. **Authoritative fields** — values with a single designated source of truth
2. **Required fields** — fields that block submission if absent
3. **Validated fields** — values constrained to a controlled format or vocabulary

Any record missing one of these properties for a critical field is, by definition, incomplete.

### Controlled Vocabulary

Free-text fields are failure vectors. Every open field is an opportunity for five variants of the same value to enter the system (`Acme Inc.`, `ACME`, `Acme Incorporated`, `Acme, Inc.`, `acme`). Controlled vocabulary — dropdowns, lookups, validated formats — eliminates this class of failure at the point of entry.

The principle: **if a value must match something downstream, it must be constrained upstream.**

### Normalization Before Storage

Customer terminology rarely matches internal terminology. A customer calls it a "quote" — internally it may be a "proposal," a "bid," or an "RFQ." A vendor calls a part number `XZ-4421` — internally it's `SKU-887231`.

Normalization is the act of mapping incoming terms to internal standards **at the entry point**, before storage. A value that enters the system in the wrong format or vocabulary will never be easier to fix than it is at intake.

### Dirty State as a Feature

Not all data arrives complete. A quote may begin as an estimate. A vendor lead time may be preliminary. The mistake is not having incomplete data — the mistake is treating incomplete data as if it were complete.

Dirty state management means building explicit status lifecycles: `draft → pending → confirmed → fulfilled`. Each transition carries meaning. Each state communicates what is known, what is estimated, and what is still required.

## Lessons

| Lesson | Title | Concept |
|--------|-------|----------|
| [2.1](lesson-2-1.md) | What Makes a Record Complete | Required fields for quotes, orders, and vendor submissions |
| [2.2](lesson-2-2.md) | Controlled Vocabulary in Practice | Replace open fields with lookups, dropdowns, and validated formats |
| [2.3](lesson-2-3.md) | Normalization Before Storage | Map customer terms → internal terms at the entry point |
| [2.4](lesson-2-4.md) | Dirty State as a Feature, Not a Bug | Build draft → pending → confirmed → fulfilled status lifecycles |

## Work Lab

Learners receive a broken intake form — a realistic RFQ intake with open text fields, no required-field enforcement, and no status vocabulary. The task:

1. Tag every field as **authoritative**, **derived**, or **approximate**
2. Identify which free-text fields should become controlled vocabulary
3. Redesign the form with required-field logic and a draft/confirmed status lifecycle
4. Write a one-sentence intake rule for each field that was changed

## Failure Categories Addressed

- `intake-minimum-viable-record-failure`
- `no-single-source-of-truth`
- `dirty-state-visibility-missing`
- `naming-governance-confusion`

## Navigation

← [Module 01: Seeing the Failures](../module-01-seeing-failures/README.md)
→ [Module 03: Communication and Commitment Discipline](../module-03-communication/README.md)
