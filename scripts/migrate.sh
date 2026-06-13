#!/bin/bash
# Migration / refactoring guidé par prompt, avec vérification automatique.
set -euo pipefail
cd /project
. /usr/local/bin/detect-stack.sh

PROMPT="${1:-}"
if [ -z "$PROMPT" ]; then
    echo "Usage: migrate.sh 'Description de la migration'"
    echo "Exemples:"
    echo "  migrate.sh 'Passe les @Autowired en injection par constructeur'"
    echo "  migrate.sh 'Migre les composants Angular vers le mode standalone + signals'"
    exit 1
fi

MODEL="${AIDER_MODEL:-ollama/qwen2.5-coder:14b}"
WEAK_MODEL="${AIDER_WEAK_MODEL:-$MODEL}"

build_read_args   # remplit READ_ARGS

echo "🔄 Migration : $PROMPT"

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
    --message "Migration : $PROMPT. Assure-toi que la vérification (tests + build) passe ensuite."
