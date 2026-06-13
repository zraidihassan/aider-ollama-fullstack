#!/bin/bash
# Lance le Web UI intégré d'Aider (Streamlit) -> http://localhost:8501
#
#   gui.sh                         -> conventions du projet pré-chargées
#   gui.sh <skill> [<skill> ...]   -> conventions + ces skills pré-chargés
#
# Le Web UI n'a pas de bouton "charger un skill" : on les passe donc ici,
# au lancement, et ils restent en contexte (lecture seule) pour la session.
set -euo pipefail
cd /project
. /usr/local/bin/detect-stack.sh

MODEL="${AIDER_MODEL:-ollama/qwen2.5-coder:14b}"
WEAK_MODEL="${AIDER_WEAK_MODEL:-$MODEL}"

# Streamlit doit écouter sur toutes les interfaces pour être joignable depuis l'hôte.
export STREAMLIT_SERVER_ADDRESS=0.0.0.0
export STREAMLIT_SERVER_PORT=8501
export STREAMLIT_SERVER_HEADLESS=true

build_read_args   # remplit READ_ARGS avec les conventions du projet

# Skills passés en arguments -> ajoutés en lecture seule.
for name in "$@"; do
    skill_file="/opt/skills/$name/SKILL.md"
    if [ -f "$skill_file" ]; then
        READ_ARGS+=(--read "$skill_file")
        echo "🧩 Skill pré-chargé : $name"
    else
        echo "⚠️  Skill '$name' introuvable (ignoré). Liste : ./agent.sh skills" >&2
    fi
done

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
