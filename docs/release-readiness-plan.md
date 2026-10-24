# Recovery and release-readiness plan

Date: 2026-10-25  
Planning rule: finish each gate before expanding scope. Estimates are focused engineering days, not calendar commitments.

Version milestones and tag rules are defined in `docs/versioning.md` and ADR 0005. This documentation baseline is version `0.1.0+1` and tag `v0.1.0-baseline.1`.

## Gate 0 — owner decisions and legal clearance (parallel, blocking public beta)

- Choose legal publisher name and permanent reverse-DNS application ID.
- Confirm Apple/Google developer-account ownership and signing-key custodian.
- Create an asset/source provenance ledger; resolve title, BASIC listing, fonts, art, audio, and screenshot rights.
- Choose support and privacy-policy URLs.

Exit: no placeholder identity and no unknown-rights production asset. If title/source rights are unclear, ship a clean-room original-inspired implementation with replacement branding/assets after appropriate legal review.

## Gate 1 — reproducible green baseline (1–2 days)

- Pin a current stable Flutter SDK compatible with current store targets.
- Correct Dart SDK constraints, resolve dependencies, and commit `pubspec.lock`.
- Repair/remove misleading tests; make format, analyze, and tests green.
- Add CI and one documented local verification command.
- Record baseline Android debug build; validate the iOS project on supported Xcode.

Exit: fresh checkout to successful checks/debug run in under 15 minutes.

## Gate 2 — deterministic playable core (3–5 days) — complete

- Implement `Ruleset`, `GameSession`, commands, events, clock/random ports, and invariants. The dependency-free rules engine is in `lib/domain/game_session.dart`, and the Flame adapter now projects its active-balloon, catch, bank, miss, and terminal events.
- Cover all gameplay-spec examples, seeded full win/loss, pause, restart isolation, and race candidates.
- Keep presentation out; simulations must run with plain Dart tests.

Exit: deterministic seeded rules tests pass without invariant violation and no Flutter/Flame dependency in domain tests. The full 100-run soak remains a Gate 3 hardening task.

## Gate 3 — vertical slice and controls (3–5 days) — implementation complete; device validation pending

- Project the domain's active balloon into Flame with stable entity IDs.
- Implement one balloon, stack/player height, fixed-viewport input mapping,
  swept catch/miss detection, row progression, bank, and result.
- Cover small/tall phone and tablet letterbox coordinate mapping and large
  frame collision crossings with automated tests.
- Conduct five-person first-play testing using existing art on physical devices.

Implementation exit: automated mapping/collision tests pass and the Android
debug artifact builds. Final Gate 3 exit remains five consecutive full
physical-device sessions without stale state; at least four of five players
must explain bank risk after one play.

## Gate 4 — game feel, local product, and assets (3–5 days)

- Add approved catch/bank/miss/win effects, audio, haptics, reduced-motion handling, pause, tutorial, settings.
- Unify win/game-over results; inject resilient versioned local leaderboard storage and reset.
- Generate/curate the missing sprite set only now, using `docs/asset-plan.md`.
- Bundle fonts and complete attribution/provenance.

Exit: game is understandable and satisfying with sound on or off, survives malformed preferences, and starts fully offline.

## Gate 5 — mobile hardening (2–4 days)

- Lock portrait/safe-area policy and validate lifecycle interruptions.
- Configure permanent identifiers, release signing, icons, splash, versions, and production build settings.
- Add golden/layout, asset-load, persistence migration, and focused Flame integration tests.
- Run 30-minute soak and profile representative low/mid hardware.

Exit: no P0/P1 issues; stable 60 Hz target under normal play; no leaked components/timers; signed internal artifacts accepted.

## Gate 6 — store candidate (2–4 days plus review time)

- Complete privacy/support pages and store data/privacy declarations.
- Prepare real-device screenshots, description, keywords, age/content ratings, attribution, and review notes.
- Run Android/iPhone release checklist and distribute through Play internal testing/TestFlight.
- Collect structured feedback from at least ten full sessions; fix release blockers without expanding rules.

Exit: both candidates pass internal testing and owner signs off on legal, product, privacy, and store metadata.

## Quality measures

- Same ruleset/seed/input trace always yields the same event trace and result.
- No mutation after pause, terminal state, or restart from prior session work.
- Crash-free internal sessions target ≥99.5% before public release.
- All controls remain inside safe areas with readable HUD and ≥44–48 logical-pixel interactive targets in the Flutter shell.
- Cold start and full play work in airplane mode.
- No protected permission, unexpected network call, debug signing, placeholder identity, or unknown-license production asset.

## First implementation backlog

1. Resolve/pin toolchain and lockfile.
2. Establish green CI and truthful tests.
3. Implement pure ruleset/session/event model.
4. Implement atomic transitions and session/effect identity.
5. Attach one Flame projection/input transform.
6. Finish deterministic row/catch/bank/miss/win flow.
7. Add unified result and resilient local leaderboard.
8. Add lifecycle/settings/accessibility and game feedback.
9. Complete sprite/audio/font curation.
10. Configure signed internal builds and execute store checklist.

Do not start levels, colored powers, online services, monetization, or large art production while any earlier gate is open.
