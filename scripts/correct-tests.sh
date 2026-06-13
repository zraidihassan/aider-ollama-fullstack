#!/bin/bash
# Corrige automatiquement les tests/builds en échec, en boucle bornée.
set -euo pipefail
cd /project
. /usr/local/bin/detect-stack.sh

MODEL="${AIDER_MODEL:-ollama/qwen2.5-coder:14b}"
WEAK_MODEL="${AIDER_WEAK_MODEL:-$MODEL}"
MAX_ITER="${MAX_ITER:-3}"

build_read_args   # remplit READ_ARGS

# Extrait les échecs : d'abord les rapports surefire du backend (structurés),
# avec repli sur la fin du log de vérification.
extract_failures() {
    local out=""
    local backend
    backend="$(detect_backend || true)"
    if [ -n "$backend" ] && compgen -G "$backend/target/surefire-reports/*.txt" > /dev/null; then
        out=$(grep -rhA 15 -E "<<< (FAILURE|ERROR)!" "$backend"/target/surefire-reports/*.txt 2>/dev/null | head -120 || true)
    fi
    if [ -z "$out" ]; then
        out=$(tail -n 80 /tmp/verify-output.log 2>/dev/null || true)
    fi
    printf '%s' "$out"
}

echo "🧪 Analyse du projet..."

iter=0
while [ "$iter" -lt "$MAX_ITER" ]; do
    iter=$((iter + 1))

    if verify.sh > /tmp/verify-output.log 2>&1; then
        echo "✅ Tout passe (itération $iter)."
        exit 0
    fi

    FAILURES=$(extract_failures)
    echo "🔴 Échecs détectés (itération $iter/$MAX_ITER) :"
    echo "$FAILURES"
    echo ""
    echo "🤖 Aider corrige..."

    aider \
        --no-git \
        --no-auto-commits \
        --no-suggest-shell-commands \
        --yes-always \
        --model "$MODEL" \
        --weak-model "$WEAK_MODEL" \
        --edit-format diff \
        --test-cmd "verify.sh" \
        --auto-test \
        "${READ_ARGS[@]}" \
        --message "Corrige les tests/erreurs sans modifier le comportement métier attendu. Détails :
$FAILURES"
done

echo "⚠️  Toujours en échec après $MAX_ITER itérations — intervention manuelle requise."
exit 1
