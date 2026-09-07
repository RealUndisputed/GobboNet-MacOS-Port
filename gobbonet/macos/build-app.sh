#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(/usr/bin/dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

"$ROOT_DIR/macos/build.sh"

SWIFTC="$(/usr/bin/xcrun --find swiftc)"
SDK="$(/usr/bin/xcrun --sdk macosx --show-sdk-path)"
APP="$ROOT_DIR/build/GobboNet.app"
CONTENTS="$APP/Contents"
RESOURCES="$CONTENTS/Resources/GobboNet"

/bin/rm -rf "$APP"
/bin/mkdir -p "$CONTENTS/MacOS" "$RESOURCES/build" "$RESOURCES/macos" "$RESOURCES/installer"

"$SWIFTC" \
    -O \
    -target arm64-apple-macos13.0 \
    -sdk "$SDK" \
    -framework AppKit \
    -framework Foundation \
    -framework Network \
    -framework WebKit \
    "$ROOT_DIR/macos/GobboNetApp.swift" \
    -o "$CONTENTS/MacOS/GobboNet"

/bin/cp "$ROOT_DIR/build/gobbonet" "$RESOURCES/build/gobbonet"
/bin/cp -R "$ROOT_DIR/web" "$RESOURCES/web"
/bin/cp "$ROOT_DIR/installer/models.ini" "$RESOURCES/installer/models.ini"
/bin/cp "$ROOT_DIR/macos/run.sh" "$RESOURCES/macos/run.sh"
/bin/chmod +x "$RESOURCES/build/gobbonet" "$RESOURCES/macos/run.sh"

/bin/cat > "$CONTENTS/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDisplayName</key>
    <string>GobboNet</string>
    <key>CFBundleExecutable</key>
    <string>GobboNet</string>
    <key>CFBundleIdentifier</key>
    <string>com.gobbonet.app</string>
    <key>CFBundleName</key>
    <string>GobboNet</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
PLIST

/usr/bin/codesign --force --deep --sign - "$APP"
/bin/echo "Created $APP"
