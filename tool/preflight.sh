#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# preflight.sh — every check a change must pass before a screen is "done" or a
# build is submitted, in order: format → analyze → test → project rules.
#
#   bash tool/preflight.sh         # check only (what CI runs)
#   bash tool/preflight.sh --fix   # apply `dart format` first, then check
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail
cd "$(dirname "$0")/.."

step() { printf '\n▶ %s\n' "$1"; }

if [[ "${1:-}" == '--fix' ]]; then
  step 'dart format (apply)'
  dart format lib test
fi

step 'dart format (verify)'
dart format --output=none --set-exit-if-changed lib test

step 'flutter analyze'
flutter analyze

step 'flutter test'
flutter test --timeout 60s

step 'project rules'
bash tool/check_rules.sh

printf '\n✓ Preflight passed\n'
