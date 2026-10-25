# Balloon Crazy recovery documentation

This directory is the decision and delivery baseline for turning the current prototype into a playable, publishable mobile game. The BASIC listing remains historical evidence; these documents define the product to be built.

## Read in this order

1. [Architecture and product review](architecture-review.md) — current condition and principal risks.
2. [Product boundaries](product-boundaries.md) — what v1 is, is not, assumes, and must prove.
3. [Gameplay rules v1](gameplay-rules-v1.md) — executable game contract and acceptance examples.
4. [Recovery and release plan](release-readiness-plan.md) — staged backlog and release gates.
5. [Asset plan](asset-plan.md) — existing asset disposition and sprite brief.
6. [Plugins and dependencies](plugins-and-dependencies.md) — what to keep, add, defer, or avoid.
7. [Version 2 proposal](version-2-proposal.md) — product direction and storyboard.
8. [Version 2 game design](version-2-game-design.md) — mechanics, sprites, objectives, levels, difficulty, and build plan.
9. [Architecture decision records](adr/) — durable decisions and their consequences.

## Decision status

| ADR | Status | Decision |
|---|---|---|
| [0001](adr/0001-deterministic-domain-first-game-architecture.md) | Accepted for recovery | Pure deterministic game domain with Flame as an adapter |
| [0002](adr/0002-canonical-original-inspired-v1.md) | Accepted for recovery | One original-inspired, bank-to-score ruleset for v1 |
| [0003](adr/0003-mobile-distribution-and-quality-gates.md) | Accepted for recovery | Offline-first mobile release with explicit store and quality gates |
| [0004](adr/0004-asset-and-dependency-policy.md) | Accepted for recovery | Curated, licensed assets and a minimal dependency surface |
| [0005](adr/0005-release-versioning.md) | Accepted | Pre-1.0 milestones, monotonic builds, and immutable release tags |
| [0006](adr/0006-deterministic-rules-engine-and-gate-progression.md) | Accepted | Deterministic rules engine before presentation expansion |
| [0007](adr/0007-fixed-viewport-and-swept-collision.md) | Accepted | Fixed-viewport input and swept vertical collision |
| [0008](adr/0008-gate-4-game-feel-and-lifecycle.md) | Accepted | Gate 4 feedback and Android lifecycle-safe pause |
| [0009](adr/0009-android-github-release-scope.md) | Accepted | Android-only downloadable APK release on GitHub |
| [0010](adr/0010-version-2-scope-and-compatibility.md) | Accepted for planning | V2 adds content around the stable V1 ruleset |
| [0011](adr/0011-deterministic-level-content-and-balance.md) | Accepted for planning | Level counts, speeds, sway, hazards, and seeds are data-driven |
| [0012](adr/0012-objectives-and-progression-contract.md) | Accepted for planning | Explicit objectives and three-star offline progression |
| [0013](adr/0013-sprite-pipeline-and-asset-provenance.md) | Accepted for planning | Versioned, provenance-cleared sprites with stable collision contracts |
| [0014](adr/0014-v2-screen-flow-and-visibility-rules.md) | Accepted for planning | The balloon board exists only during play and pause |
| [0015](adr/0015-playtest-led-balance-and-release-evidence.md) | Accepted for planning | Expand V2 from measured playtest evidence |
| [0016](adr/0016-v2-visual-identity-and-board-art.md) | Accepted for implementation | Bright arcade-adventure identity with readable layered boards |
| [0017](adr/0017-freeze-v1-and-use-feature-first-v2-architecture.md) | Accepted for implementation | Freeze V1 and build V2 with feature-first boundaries |

## Authority order

When sources disagree, use this order:

1. Accepted ADRs.
2. `docs/gameplay-rules-v1.md`.
3. Tests that directly exercise the production domain.
4. `assets/BALLOON.BAS` as historical evidence.
5. README, screenshots, and the older gameplay reference.

The existing `assets/GAMEPLAY_REFERENCE.md` is useful research but is not authoritative: it incorrectly awards points on catch and describes the source row order inaccurately.
