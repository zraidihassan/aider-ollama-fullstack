#!/bin/bash
# Ajout d'une nouvelle feature guidé par prompt (build vérifié).
set -euo pipefail
cd /project
. /usr/local/bin/detect-stack.sh

PROMPT="${1:-}"
if [ -z "$PROMPT" ]; then
    echo "Usage: evolve.sh 'Ta demande'"
    echo "Exemples:"
    echo "  evolve.sh 'Ajoute un endpoint REST GET /api/users avec pagination'"
    echo "  evolve.sh 'Crée un composant Angular standalone UserListComponent qui consomme /api/users'"
    exit 1
fi

MODEL="${AIDER_MODEL:-ollama/qwen2.5-coder:14b}"
WEAK_MODEL="${AIDER_WEAK_MODEL:-$MODEL}"

build_read_args   # remplit READ_ARGS

echo "➕ Évolution : $PROMPT"

aider \
    --no-git \
    --no-auto-commits \
    --no-suggest-shell-commands \
    --yes-always \
    --model "$MODEL" \
    --weak-model "$WEAK_MODEL" \
    --edit-format diff \
    --test-cmd "compile.sh" \
    --auto-test \
    "${READ_ARGS[@]}" \
    --message "$PROMPT. Le code doit compiler et builder."
