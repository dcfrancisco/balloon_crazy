# ADR 0004: Curate assets and keep dependencies minimal

- Status: Accepted for recovery
- Date: 2026-10-25
- Owners: Art/product and mobile engineering
- Related: `docs/asset-plan.md`, `docs/plugins-and-dependencies.md`

## Context

The repository packages several inconsistent balloon images, large raster art used at tiny sizes, unused sounds, duplicate gameplay reference files, and fonts whose claimed license files are absent. Runtime `google_fonts` behavior conflicts with fully offline/reproducible presentation.

The codebase also does not need a backend, generalized state framework, or broad plugin collection. Every native/plugin dependency increases store privacy, build, maintenance, and licensing work.

## Decision

- Preserve the existing visual essence: blue field, bright red balloon, colorful title, and cheerful pixel skater.
- Create one versioned sprite sheet/atlas with explicit frame names, logical dimensions, pivots, collision guides, palette, nearest-neighbor scaling, and provenance.
- New generated art is draft input, not automatically shippable. It must be visually reviewed, normalized to the brief, and recorded in the provenance ledger.
- Do not generate sprites during the architecture phase. First approve gameplay scale and states; then produce only the missing frames in `docs/asset-plan.md`.
- Bundle every production font. Do not rely on runtime font downloads.
- Every shipped asset and dependency needs origin, license, author/tool, modification history, and required attribution.
- Prefer Flutter/Dart/Flame built-ins. Add a package only when it removes material platform risk and has active maintenance, compatible license, supported platforms, and acceptable transitive privacy behavior.
- Do not add analytics, ads, remote config, cloud services, a service locator, or a state-management framework for v1.

## Required runtime additions

Only an audio integration package is anticipated (`flame_audio`, subject to compatibility/license review). Launcher-icon and native-splash generators may be development-only tools. Exact versions are chosen with the pinned Flutter SDK during implementation and committed in `pubspec.lock`.

## Consequences

- Existing assets are not deleted in this documentation pass, but production use is blocked until the asset ledger classifies them.
- Green and alternate red balloon art remain reference/orphan assets unless a later mode is approved.
- The player may be redrawn/re-exported for consistent pixel density without changing its recognizable silhouette and palette.
- Dependency proposals include a short decision note and privacy/license review in the same change.

## Acceptance criteria

- The asset manifest lists every production image, sound, and font with a verified license/provenance entry.
- No production asset is an unexplained duplicate or unused bundle entry.
- The game loads all required assets in an automated smoke test.
- Production starts offline with no font or content fetch.
- Dependency audit contains no unexplained native SDK or data collection.
