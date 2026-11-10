#!/usr/bin/env bash
# Build the desktop half and deploy it where Hermes Desktop loads it.
# Usage: scripts/deploy-local.sh   (ESBUILD=/path/to/esbuild to override)
set -euo pipefail
cd "$(dirname "$0")/.."

ESBUILD="${ESBUILD:-$HOME/.hermes/hermes-agent/apps/desktop/node_modules/.bin/esbuild}"
if [ ! -x "$ESBUILD" ]; then
  echo "esbuild not found at $ESBUILD (set ESBUILD=...)" >&2
  exit 1
fi

"$ESBUILD" src/plugin.jsx --bundle --format=esm --jsx=automatic \
  --external:react --external:react/jsx-runtime --external:@hermes/plugin-sdk \
  --outfile=desktop/plugin.js

# The app loads this copy; the package copy keeps the installed plugin in sync.
cp desktop/plugin.js "$HOME/.hermes/desktop-plugins/hermes-session-diff/plugin.js"
cp desktop/plugin.js "$HOME/.hermes/plugins/hermes-session-diff/desktop/plugin.js"

echo "deployed $(date '+%Y-%m-%d %H:%M:%S') -> ~/.hermes/desktop-plugins/hermes-session-diff/plugin.js"
