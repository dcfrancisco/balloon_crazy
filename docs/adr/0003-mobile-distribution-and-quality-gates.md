# ADR 0003: Define mobile distribution and quality gates

- Status: Accepted for recovery
- Date: 2026-10-25
- Owners: Product owner and mobile engineering
- Decision horizon: first Android/iOS release

## Context

The project has placeholder identifiers, Android debug release signing, permissive iOS orientations, no pinned/reproducible toolchain, no CI, and no store/privacy delivery record. “Runs locally” is not a publishable definition.

## Decision

### Distribution and support

- Ship Android phone and iPhone from one production application target.
- Use portrait on phones. Tablets may use a centered/letterboxed portrait playfield; tablet-specific layout is not a v1 commitment.
- Choose one permanent owner-controlled reverse-DNS identifier before the first internal-store upload and use its platform-appropriate equivalent consistently.
- Use semantic versioning for marketing version and monotonically increasing store build numbers.
- Use Google Play App Signing with a separately protected upload key. Use the owning Apple team and App Store Connect record for iOS.
- Keep secrets, keystores, API keys, and provisioning material outside Git. CI receives least-privilege protected secrets.

The owner must supply the legal publisher name, identifier namespace, Apple/Google accounts, signing custody, support URL, and privacy-policy URL. Engineering must not invent these values.

### Privacy and connectivity

- v1 is offline-first and intentionally includes no ads, analytics, crash-reporting SDK, account, or network leaderboard.
- Player name and scores remain on device. A user-visible reset action deletes them.
- Do not request protected-device permissions.
- Store privacy declarations must reflect all transitive SDK behavior and be revalidated for every dependency update.
- A public privacy policy/support page is required even for the intended “no data collected” posture.

### Toolchain and reproducibility

- Pin one current stable Flutter SDK using a repository-readable version mechanism and commit `pubspec.lock` for the app.
- CI and local documentation use the same toolchain and commands.
- Upgrade deliberately on a scheduled dependency lane; do not float the release branch across SDK versions.
- At release, verify current store SDK/target requirements instead of freezing them in source forever. As checked on 2026-10-25, Google Play requires new phone apps/updates to target Android 16/API 36, and App Store Connect lists Xcode 26 or later for iOS builds.

### Required gates

Pull request:

- format check, static analysis, unit/widget tests;
- deterministic domain simulations and invariant tests;
- Android debug build;
- license/provenance check for newly added assets/dependencies.

Release candidate:

- signed Android App Bundle and signed iOS archive from a clean checkout;
- store validation/internal-track upload;
- golden/layout checks for small phone, tall phone, and tablet letterbox;
- physical Android and iPhone smoke test for cold/warm start, touch, pause/background, interruption, sound/haptics, win, loss, score save/reset, and replay;
- 30-minute soak with no stale-session mutation or unbounded component growth;
- all P0/P1 defects closed and no known data-loss/crash defect.

Public submission:

- asset provenance cleared; privacy/support URLs live; declarations complete;
- permanent identifiers, signing, icon, splash, screenshots, descriptions, age/content rating, attribution, and review notes approved;
- internal testing meets the exit measures in `docs/release-readiness-plan.md`.

## Official references

- Google Play target API requirement: https://developer.android.com/google/play/requirements/target-sdk
- Flutter Android signing/release: https://docs.flutter.dev/deployment/android
- Apple build upload requirements: https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds
- Apple app privacy: https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy/
- Apple SDK privacy manifests: https://developer.apple.com/documentation/bundleresources/adding-a-privacy-manifest-to-your-app-or-third-party-sdk

These are operational references, not timeless values; recheck them at each release.

## Consequences

- Analytics/crash SDKs are not a prerequisite for launch; structured local diagnostics and store crash consoles are sufficient for the first internal tests.
- Adding a network/data-collecting SDK changes the privacy posture and requires an ADR amendment plus store disclosure review.
- Release work begins during recovery, not after gameplay is “finished.”

## Acceptance criteria

- A fresh checkout reaches a running debug build using documented commands in under 15 minutes.
- CI produces repeatable evidence for every gate.
- Both store internal tracks accept signed artifacts with permanent identity.
- The shipping binary starts and completes a game with networking disabled.
