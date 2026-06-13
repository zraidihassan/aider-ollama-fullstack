#!/bin/bash
# Build rapide sans tests : compile le backend et build le frontend.
set -uo pipefail
. /usr/local/bin/detect-stack.sh

rc=0
BACKEND="$(detect_backend || true)"
FRONTEND="$(detect_frontend || true)"

if [ -n "$BACKEND" ]; then
    echo "🔨 Backend : mvn compile ($BACKEND)"
    ( cd "$BACKEND" && mvn -q clean compile -DskipTests ) || rc=1
fi
if [ -n "$FRONTEND" ]; then
    echo "🔨 Frontend : npm build ($FRONTEND)"
    (
        cd "$FRONTEND"
        [ -d node_modules ] || npm ci --no-audit --no-fund || npm install --no-audit --no-fund
        npm run build
    ) || rc=1
fi

[ "$rc" -eq 0 ] && echo "✅ OK" || echo "❌ Échec build"
exit "$rc"
