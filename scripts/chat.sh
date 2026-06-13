#!/bin/bash
# Session Aider INTERACTIVE : tu discutes, poses des questions, changes de
# modèle à la volée — sans relancer de commande docker.
set -euo pipefail
cd /project
. /usr/local/bin/detect-stack.sh

MODEL="${AIDER_MODEL:-ollama/qwen2.5-coder:14b}"
WEAK_MODEL="${AIDER_WEAK_MODEL:-$MODEL}"

build_read_args   # remplit READ_ARGS

cat <<'EOF'
💬 Session Aider interactive. Commandes utiles (à taper dans le prompt) :
   /ask <question>            poser une question SANS modifier le code
   /code <consigne>           demander une modification de code
   /model ollama/qwen3:14b    basculer sur le modèle "thinking" à la volée
   /model ollama/qwen2.5-coder:14b   revenir au modèle d'édition
   /add <fichier>             ajouter un fichier au contexte
   /drop <fichier>            retirer un fichier du contexte
   /test                      lancer la vérification (verify.sh)
   /run <cmd>                 lancer une commande shell
   /diff   /undo              voir les changements / annuler le dernier
   /help                      liste complète
   Ctrl-D ou /exit            quitter
EOF
echo ""

aider \
    --no-git \
    --no-auto-commits \
    --no-suggest-shell-commands \
    --model "$MODEL" \
    --weak-model "$WEAK_MODEL" \
    --edit-format diff \
    --test-cmd "verify.sh" \
    "${READ_ARGS[@]}"
