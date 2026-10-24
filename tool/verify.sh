#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_root"

expected_flutter="3.35.7"
flutter_bin="${FLUTTER_BIN:-flutter}"

if ! command -v "$flutter_bin" >/dev/null 2>&1; then
  echo "Flutter is not installed or FLUTTER_BIN is invalid." >&2
  exit 1
fi

actual_flutter="$($flutter_bin --version 2>/dev/null | sed -n '1p')"
if [[ "$actual_flutter" != *"Flutter $expected_flutter"* ]]; then
  echo "Expected Flutter $expected_flutter but found: $actual_flutter" >&2
  echo "Install/select the version recorded in .fvmrc, or set FLUTTER_BIN." >&2
  exit 1
fi

echo "== Flutter =="
$flutter_bin --version

echo "== Dependencies =="
$flutter_bin pub get

echo "== Formatting =="
$flutter_bin dart format --output=none --set-exit-if-changed lib test

echo "== Static analysis =="
$flutter_bin analyze

echo "== Tests =="
$flutter_bin test

echo "== Android debug build =="
$flutter_bin build apk --debug

echo "Gate 1 verification passed."
