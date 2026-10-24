# Plugins, packages, and tooling

Date: 2026-10-25

## Bottom line

No additional Codex plugin is required to begin implementation, and the game does not need a backend or broad Flutter architecture package. Keep the dependency surface deliberately small.

## Flutter packages

| Package/capability | Decision | Reason / condition |
|---|---|---|
| `flame` | Keep | Appropriate renderer/game-loop adapter; do not let it own domain rules |
| `shared_preferences` | Keep for v1 | Sufficient for small local settings/leaderboard behind a repository with schema validation |
| `flutter_animate` | Re-evaluate/remove | Simple overlay motion can use Flutter built-ins; retain only if it materially reduces code and supports reduced motion |
| `google_fonts` | Remove from runtime path | Bundle the cleared font for offline, deterministic startup and accurate licensing |
| `flame_audio` | Add when effects are implemented | Small, Flame-aligned audio bridge; verify pinned-SDK compatibility, license, lifecycle, and platform behavior first |
| `flutter_launcher_icons` | Optional dev dependency | Repeatable platform icon generation; generated output must be reviewed/committed |
| `flutter_native_splash` | Optional dev dependency | Repeatable launch-screen generation if it works cleanly with the chosen brand asset |
| State management (`bloc`, `riverpod`, etc.) | Do not add | Immutable snapshots plus the coordinator are enough at this scale |
| Dependency injection/service locator | Do not add | Manual composition root is clearer for this small app |
| Firebase/analytics/crash SDK | Defer | Changes privacy/network surface and is not required for a playable first release |
| Database package | Do not add | Data volume does not justify SQLite/Isar/Hive in v1 |

Exact versions are intentionally absent from this architecture document. Select versions compatible with the pinned stable Flutter toolchain, review changelogs/licenses, and commit the resolved lockfile.

## Build and quality tooling

- Existing `flutter_lints`, `flutter_test`, and SDK tools are sufficient initially.
- CI needs format, analysis, test, Android build, and release-candidate iOS validation jobs; this does not require an in-app plugin.
- Prefer Flutter golden tests and small custom fakes before adding screenshot/property-test packages.
- Use Play internal testing and TestFlight for distribution validation.

## Codex capabilities/plugins

| Capability | Need | Use |
|---|---|---|
| Image generation | Later, optional | Draft the missing sprite states from the approved brief; human review and provenance remain mandatory |
| In-app browser control | Later, optional | Local web/dev tooling smoke tests only if a browser surface is introduced; not required for the mobile game |
| Sites/hosting | Optional release task | Publish a minimal privacy policy/support page if the owner has no existing site |
| Azure/Figma/document/spreadsheet plugins | Not needed | They do not remove a current delivery blocker |

## Dependency admission checklist

Before adding any package:

1. Identify the concrete requirement that platform/SDK code cannot reasonably meet.
2. Confirm active maintenance, supported Flutter/platform versions, license, and release history.
3. Inspect native/transitive SDKs, permissions, network behavior, data collection, privacy manifests, and binary impact.
4. Document lifecycle/error behavior and an exit/replacement path.
5. Pin through `pubspec.lock`, add focused tests, and update store privacy declarations if relevant.
