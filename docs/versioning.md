# Release versioning

Status: active  
Date: 2026-10-25  
Source of truth: `version:` in `pubspec.yaml`

## Version format

Flutter uses:

```text
MAJOR.MINOR.PATCH+BUILD
```

Example: `0.2.0+7` means product version 0.2.0 and store build 7.

- `MAJOR`: compatibility/product generation. Remains `0` until the first public release, then becomes `1`.
- `MINOR`: meaningful pre-1.0 milestone or backward-compatible feature release.
- `PATCH`: fixes within an already released milestone.
- `BUILD`: positive integer that increases for every artifact uploaded to either store. Never reuse or decrease it.

Android receives `BUILD` as `versionCode`; iOS receives it as `CFBundleVersion`. The numeric product version becomes Android `versionName` and iOS `CFBundleShortVersionString`.

## Recovery milestones

| Product version | Meaning | Required state |
|---|---|---|
| `0.1.0+1` | Pre-recovery baseline | Architecture/rules recorded; prototype preserved; checks may be red/blocked |
| `0.2.0+N` | Playable alpha | Deterministic core and physical-device vertical slice complete |
| `0.3.0+N` | Feature-complete alpha | Results, local leaderboard, lifecycle, settings, and core feedback complete |
| `0.5.0+N` | Internal beta | Production assets/identity/signing integrated; no known P0/P1 issue |
| `0.9.0+N` | Release candidate | Store metadata and both signed internal-track builds approved |
| `1.0.0+N` | First public release | Product/legal/privacy/store sign-off complete |

Versions are gates, not dates. Do not bump because time passed.

## Git tags

Annotated tags identify immutable milestones:

```text
v0.1.0-baseline.1
v0.2.0-alpha.1
v0.5.0-beta.1
v0.9.0-rc.1
v1.0.0
```

Rules:

1. A tag points to the exact reviewed commit used for the milestone.
2. Never move, delete, or reuse a published tag. Correct mistakes with a new tag/build.
3. Except for the explicitly unverified baseline tag, create a tag only after required checks pass.
4. Store submissions also record the full `pubspec.yaml` version/build in release notes.
5. Push the commit before or with its tag; verify the remote tag after pushing.
6. Patch releases increment `PATCH`; new uploads always increment `BUILD` even when the product version is unchanged.

## Day-to-day examples

- First alpha artifact: change `0.1.0+1` to `0.2.0+2`, pass Gate 3, tag `v0.2.0-alpha.1`.
- Rebuild the same alpha after a signing fix: use `0.2.0+3`, tag `v0.2.0-alpha.2` if it is distributed.
- Fix a shipped 1.0 defect: use `1.0.1+N`, tag `v1.0.1` after release gates pass.
- Begin a backward-compatible post-launch feature: use `1.1.0+N`.

## Release procedure

1. Confirm the target gate and update `pubspec.yaml`.
2. Add a `CHANGELOG.md` entry with product changes, migrations, known issues, and privacy/dependency changes.
3. Run the required automated and physical-device checks.
4. Commit using `chore(release): prepare X.Y.Z+N`.
5. Create an annotated tag and include check/store status in its message.
6. Push the commit and tag only after local verification. Store upload follows the pushed tag.

The baseline is the exception: its purpose is to preserve the known broken starting point before repair. Its annotation must say that Flutter commands were blocked by the configured Dart VM/toolchain.
