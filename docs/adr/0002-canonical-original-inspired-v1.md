# ADR 0002: Canonicalize Original Inspired v1

- Status: Accepted for recovery
- Date: 2026-10-25
- Owners: Product and game engineering
- Related: `docs/gameplay-rules-v1.md`, `docs/product-boundaries.md`

## Context

The repository currently contains mutually incompatible rules. Literal BASIC emulation also preserves apparent errors and machine-dependent timing, while the current Flutter prototype changes the defining risk/reward loop.

A playable recovery needs one authoritative game before it needs modes or features.

## Decision

The first public release contains one ruleset, `original_inspired_v1`:

- four rows × fifteen balloons, lowest row first;
- one falling balloon at a time;
- four lives;
- catches build an unbanked visible stack and increase speed;
- thresholds are 4, 5, 6, and 7 by source tier;
- catches do not score; banking awards 10 per balloon;
- a miss loses the held stack and one life;
- speed and catch height reset after bank/miss;
- the final remainder banks before win;
- maximum clear score is 600;
- both win and game over create a local result.

Touch movement, lifecycle pause, reduced motion, settings, continuous collision, deterministic elapsed-time simulation, and session isolation are deliberate modernizations.

The exact contract and examples in `docs/gameplay-rules-v1.md` are part of this decision.

## Boundaries

No colored powers, bounce/fire action, levels, infinite play, online leaderboard, accounts, ads, IAP, or live operations enter v1. A new mode requires an ADR and cannot silently alter this ruleset ID.

## Options considered

### Ship current runtime behavior

Rejected. Concurrent random drops, 40 balloons, double scoring, and disconnected difficulty do not express a coherent version of the original.

### Emulate the BASIC listing instruction-for-instruction

Rejected. It carries CPU-dependent timing, joystick assumptions, a probable speed-reset typo, and a row-transition threshold ambiguity.

### Expand into a modern multi-level game first

Rejected. It multiplies tuning, art, UX, persistence, and QA before the core loop is proven.

### Original-inspired single mode

Chosen. It preserves the distinctive mechanic, is small enough to finish, and gives product/tests one stable contract.

## Consequences

- README and the historical gameplay reference must be corrected or clearly marked non-authoritative.
- Current tests that lock in double scoring or component-owned banking will be replaced.
- Existing green/multi-red assets are not gameplay variants in v1.
- Tuning can change feel values, but changing score, counts, thresholds, or progression creates a new ruleset version.

## Acceptance criteria

- Every example in `docs/gameplay-rules-v1.md` is executable as a domain test.
- Five first-time players can describe catch, risk, bank, miss, and win after one session.
- A seeded full win and full loss simulate without Flutter or Flame.
- Runtime UI, README, tutorial, tests, and store description make no contradictory rule claim.
