# ADR 0005: Adopt release versioning and immutable milestone tags

- Status: Accepted
- Date: 2026-10-25
- Owners: Product owner and mobile engineering
- Related: `docs/versioning.md`, `docs/release-readiness-plan.md`

## Context

The prototype claims version `1.0.0+1` despite being pre-alpha, has no Git tags, and has no rule connecting source commits to Android/iOS store artifacts. This makes builds difficult to identify and gives the false impression of a public-quality release.

## Decision

- Reset the recovery baseline to `0.1.0+1` before any public release exists.
- Use `MAJOR.MINOR.PATCH+BUILD` in `pubspec.yaml` as the application-version source of truth.
- Keep store build numbers positive, globally monotonic, and never reused.
- Use numeric product versions for store compatibility and annotated semantic milestone tags for human release stage (`baseline`, `alpha`, `beta`, `rc`).
- Reserve `1.0.0` for the first public version that passes every release gate.
- Tag the documented starting point as `v0.1.0-baseline.1`, explicitly noting its unverified/broken toolchain state.
- Do not move published tags. Corrections receive a new build and tag.

## Consequences

- Product maturity is visible without pretending the prototype is 1.0.
- Any installed/internal artifact can be traced to a source commit and store build.
- Build numbers can advance more quickly than product versions during internal testing.
- The first public version may still start at `1.0.0`; resetting before publication avoids a migration promise to existing store users.

If evidence later shows that `1.0.0+1` was already publicly shipped under the final application identifier, this decision must be revisited because store version/build history cannot be reset.

## Acceptance criteria

- `pubspec.yaml` reads `0.1.0+1` on the baseline commit.
- The annotated baseline tag resolves to that commit.
- Future milestone tags and store uploads follow `docs/versioning.md`.
- Release notes identify the exact product version, build, commit, and tag.
