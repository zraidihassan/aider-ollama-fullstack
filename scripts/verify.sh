#!/bin/bash
# Vérifie le projet de bout en bout. Sert de commande de test à Aider
# (--test-cmd) ET de cible pour `agent.sh test`.
#   - Backend  : mvn test
#   - Frontend : lint (si présent) + build (type-check complet)
# Code de sortie != 0 si une étape échoue -> Aider relance une correction.
set -uo pipefail
. /usr/local/bin/detect-stack.sh

rc=0
BACKEND="$(detect_backend || true)"
FRONTEND="$(detect_frontend || true)"

if [ -n "$BACKEND" ]; then
    echo "🔧 Backend : tests Maven ($BACKEND)"
    ( cd "$BACKEND" && mvn -q test ) || rc=1
fi

if [ -n "$FRONTEND" ]; then
    echo "🎨 Frontend : lint + build ($FRONTEND)"
    (
        cd "$FRONTEND"
        [ -d node_modules ] || npm ci --no-audit --no-fund || npm install --no-audit --no-fund
        npm run lint --if-present
        npm run build
    ) || rc=1
fi

if [ -z "$BACKEND" ] && [ -z "$FRONTEND" ]; then
    echo "⚠️  Ni pom.xml ni package.json trouvés sous /project." >&2
    exit 2
fi

[ "$rc" -eq 0 ] && echo "✅ Vérification OK" || echo "❌ Vérification en échec"
exit "$rc"
