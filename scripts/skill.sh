#!/bin/bash
# Charge un SKILL.md (guidance experte) en lecture seule dans Aider.
#
#   skill.sh                  -> liste les skills disponibles
#   skill.sh <nom>            -> session interactive Aider avec le skill chargé
#   skill.sh <nom> "consigne" -> exécution one-shot avec le skill chargé
#
# Les skills sont montés en lecture seule sur /opt/skills (voir docker-compose.yml).
set -euo pipefail
cd /project
. /usr/local/bin/detect-stack.sh

SKILLS_DIR="/opt/skills"

list_skills() {
    echo "🧩 Skills disponibles (skill.sh <nom> [\"consigne\"]) :"
    if [ -d "$SKILLS_DIR" ]; then
        for d in "$SKILLS_DIR"/*/; do
            [ -f "$d/SKILL.md" ] || continue
            n="$(basename "$d")"
            # 1re ligne 'description:' du frontmatter, si présente
            desc="$(grep -m1 '^description:' "$d/SKILL.md" 2>/dev/null | sed 's/^description:[[:space:]]*//')"
            printf '   • %-28s %s\n' "$n" "${desc:0:70}"
        done
    else
        echo "   ⚠️  $SKILLS_DIR introuvable. Le volume ./skills est-il bien monté ? (agent.sh up)"
    fi
}

NAME="${1:-}"
if [ -z "$NAME" ]; then
    list_skills
    exit 0
fi

SKILL_FILE="$SKILLS_DIR/$NAME/SKILL.md"
if [ ! -f "$SKILL_FILE" ]; then
    echo "❌ Skill '$NAME' introuvable." >&2
    echo "" >&2
    list_skills >&2
    exit 1
fi
shift
PROMPT="${1:-}"

MODEL="${AIDER_MODEL:-ollama/qwen2.5-coder:14b}"
WEAK_MODEL="${AIDER_WEAK_MODEL:-$MODEL}"

build_read_args                 # conventions du projet
READ_ARGS+=(--read "$SKILL_FILE")
echo "🧩 Skill chargé : $NAME"

if [ -n "$PROMPT" ]; then
    # One-shot
    aider \
        --no-git --no-auto-commits --no-suggest-shell-commands --yes-always \
        --model "$MODEL" --weak-model "$WEAK_MODEL" \
        --edit-format diff --test-cmd "verify.sh" --auto-test \
        "${READ_ARGS[@]}" \
        --message "$PROMPT"
else
    # Interactif : le skill reste en contexte, tu pilotes avec /ask, /code...
    aider \
        --no-git --no-auto-commits --no-suggest-shell-commands \
        --model "$MODEL" --weak-model "$WEAK_MODEL" \
        --edit-format diff --test-cmd "verify.sh" \
        "${READ_ARGS[@]}"
fi
