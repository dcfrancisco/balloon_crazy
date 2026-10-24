# Gate 1 toolchain record

Date checked: 2026-10-25  
Project pin: Flutter 3.35.7 stable / bundled Dart 3.9.x  
Pin file: `.fvmrc`  
Verification entry point: `./tool/verify.sh`

## Why this version

The project previously required `Dart 3.44.0`, which is not a Dart SDK release. The installed Flutter SDK was Flutter 3.3.0 with Dart 3.3.4 and crashed before it could run project commands. Flutter 3.35.7 is a released stable patch whose minimum macOS version supports this host, and the project now requires Dart `>=3.9.0 <4.0.0` plus Flutter `>=3.35.7`. Flutter 3.47.x was rejected because it requires macOS 14 or newer. This managed runner still crashes inside the Dart VM (`cpuinfo_macos.cc:42`) before project commands can run, so final execution must be confirmed on a normal developer/CI runner.

The latest stable channel may move after this record. Do not silently change the pin: update `.fvmrc`, CI, this record, the lockfile, and the changelog together after a deliberate upgrade review.

## Local environment observed

| Tool | Observed | Gate 1 implication |
|---|---|---|
| Flutter/Dart | Flutter 3.3.0 / Dart 3.3.4; VM crashes with `cpuinfo_macos.cc:42 unreachable code` | Cannot use; replace/select pinned SDK |
| Java | OpenJDK 21.0.10 | Suitable for the current Gradle/Android setup unless build reports otherwise |
| Gradle wrapper | 8.12 | Keep project wrapper; let the pinned Flutter/AGP combination validate it |
| Android SDK/platform tools | ADB 36.0.0; compile/target values are Flutter defaults | Android build must confirm installed platform availability |
| CocoaPods | 1.16.2 | Available; terminal should use UTF-8 locale |
| Xcode | 14.2 | Environment-only blocker for current iOS store readiness; do not alter gameplay/code to compensate |

## iOS readiness note

The iOS project can be inspected and dependency setup can be attempted, but this machine's Xcode 14.2 is below the current store-era toolchain expected by the selected Flutter line and current App Store Connect requirements. Gate 1 records this as an environment blocker. A supported macOS/Xcode environment must run `flutter build ios --release` and archive validation before any iOS release candidate.

## Fresh checkout setup

1. Install Flutter 3.35.7 stable, or use an FVM-compatible workflow that reads `.fvmrc`.
2. Ensure `flutter` resolves to that SDK.
3. Run `flutter --version` and confirm Flutter 3.35.7 / Dart 3.9.x.
4. Run `./tool/verify.sh` from the repository root.

CI uses the same exact Flutter version and runs the same script.
