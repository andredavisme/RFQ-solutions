# Module 01: Seeing the Failures

## Purpose

Start here — observation and acknowledgment before any solution.

Most training jumps to fixes. This module doesn't. Learners must first develop the ability to **see** failures clearly, classify them accurately, and resist the instinct to jump to solutions before the root cause is named.

Each lesson follows this pattern:
1. **Scenario card** — a realistic business situation presented without a verdict
2. **Classification challenge** — learner selects the failure category from controlled vocabulary
3. **Expert lens reveal** — the authoritative classification with explanation
4. **Reflection** — what would need to be true for this failure not to happen?

## Why This Matters

You cannot fix what you cannot name. The seven failure categories in this course represent the most common, most costly, and most preventable breakdowns in RFQ communication and data flow. Naming them precisely is the first act of repair.

## Failure Classification Vocabulary

All scenario responses use the controlled vocabulary defined in [`_schema/failure-categories.json`](../../_schema/failure-categories.json).

| ID | Label |
|----|-------|
| `no-single-source-of-truth` | No single source of truth |
| `intake-minimum-viable-record-failure` | Intake / minimum viable complete record failure |
| `dirty-state-visibility-missing` | Dirty-state visibility missing |
| `vague-commitments-declarations-instead-of-proof` | Vague commitments / declarations instead of proof |
| `vendor-data-translation-failure` | Vendor data / translation failure |
| `transparent-substitution-failure` | Transparent substitution failure |
| `naming-governance-confusion` | Naming / governance confusion |

## Lessons

| Lesson | Title | Failure Category |
|--------|-------|------------------|
| [1.1](lesson-1-1.md) | Three Prices, Zero Truth | No single source of truth |
| [1.2](lesson-1-2.md) | The Vendor Lead Time That Wasn't | Dirty-state visibility missing |
| [1.3](lesson-1-3.md) | The Form That Let Anything Through | Intake / minimum viable complete record failure |
| [1.4](lesson-1-4.md) | We'll Look Into It | Vague commitments / declarations instead of proof |
| [1.5](lesson-1-5.md) | The Substitution Nobody Mentioned | Transparent substitution failure |
| [1.6](lesson-1-6.md) | The Status Field That Lied | Naming / governance confusion |

## Work Lab

After completing all six lessons, learners review a composite scenario that contains **multiple overlapping failure types** and must:
- Identify the primary failure category
- Identify any secondary contributing failures
- Describe one structural change that would prevent recurrence

## Next Module

→ [Module 02: Intake and Minimum Viable Complete Record](../module-02-intake/README.md)
