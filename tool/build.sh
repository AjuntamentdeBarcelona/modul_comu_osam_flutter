#!/bin/bash
set -e

# Determine flutter executable (fvm if available)
if command -v fvm &> /dev/null; then
  FLUTTER_BIN="fvm flutter"
else
  FLUTTER_BIN="flutter"
fi

echo "==> Resolving plugin dependencies..."
$FLUTTER_BIN pub get

echo "==> Resolving example dependencies..."
cd example
$FLUTTER_BIN pub get

echo "==> Verifying iOS build configuration..."
$FLUTTER_BIN build ios --config-only --no-codesign
cd ..

echo "==> Build verification completed successfully!"
