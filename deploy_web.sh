#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "Building Flutter web (release)..."
flutter build web --release

echo "Deploying to Firebase Hosting..."
firebase deploy --only hosting

echo ""
echo "Deploy finished. Open the Hosting URL from the output above (hard-refresh if you see an old build)."
