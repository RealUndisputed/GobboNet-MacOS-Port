#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(/usr/bin/dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

GO="${GO:-}"
if [[ -z "$GO" ]] && [[ -x /opt/homebrew/bin/go ]]; then
	GO=/opt/homebrew/bin/go
fi
if [[ -z "$GO" ]] && [[ -x /usr/local/bin/go ]]; then
	GO=/usr/local/bin/go
fi
if [[ -z "$GO" ]]; then
	echo "Go is required. Install it with: brew install go" >&2
	exit 1
fi

echo "Staging Gobbonet web assets..."
/bin/bash ./stage-web.sh

echo "Downloading Go dependencies..."
"$GO" mod download

/bin/mkdir -p build
echo "Building Gobbonet for macOS Apple Silicon (darwin/arm64)..."
CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 \
	"$GO" build -trimpath -o build/gobbonet ./cmd/gobbonet

echo "Build completed: $ROOT_DIR/build/gobbonet"