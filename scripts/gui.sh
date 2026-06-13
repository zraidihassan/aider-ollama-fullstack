#!/bin/bash
# Lance le Web UI intégré d'Aider (Streamlit) -> http://localhost:8501
set -euo pipefail
cd /project
. /usr/local/bin/detect-stack.sh

MODEL="${AIDER_MODEL:-ollama/qwen2.5-coder:14b}"
WEAK_MODEL="${AIDER_WEAK_MODEL:-$MODEL}"

# Streamlit doit écouter sur toutes les interfaces pour être joignable depuis l'hôte.
export STREAMLIT_SERVER_ADDRESS=0.0.0.0
export STREAMLIT_SERVER_PORT=8501
export STREAMLIT_SERVER_HEADLESS=true

build_read_args   # remplit READ_ARGS

echo "🌐 Web UI Aider : ouvre http://localhost:8501 dans ton navigateur"
echo ""

aider --gui \
    --no-git \
    --no-auto-commits \
    --no-suggest-shell-commands \
    --model "$MODEL" \
    --weak-model "$WEAK_MODEL" \
    --edit-format diff \
    --test-cmd "verify.sh" \
    "${READ_ARGS[@]}"
