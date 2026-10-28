#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
flutter pub get
flutter analyze
flutter test
if [[ -n "${DEVICE_ID:-}" ]]; then
  flutter drive --driver=test_driver/integration_test.dart \
    --target=integration_test/app_test.dart -d "$DEVICE_ID"
fi
