#!/bin/bash
# Lanceur côté HÔTE. Fonctionne sous Linux/macOS et sous Windows via
# MobaXterm/Git-Bash : pas besoin de winpty ni de PowerShell, le TTY est
# détecté automatiquement.
#
# Usage : ./agent.sh [--think] <commande> [arguments]
set -euo pipefail

# Se placer dans le dossier du script (où se trouve docker-compose.yml).
cd "$(dirname "$0")"

CONTAINER="ai-coding-agent"

# Détection du moteur : Docker Desktop / Rancher(dockerd) -> "docker",
# Rancher Desktop avec containerd -> "nerdctl".
if command -v docker >/dev/null 2>&1; then
    RUNTIME="docker"
elif command -v nerdctl >/dev/null 2>&1; then
    RUNTIME="nerdctl"
else
    echo "❌ Ni 'docker' ni 'nerdctl' trouvé dans le PATH." >&2
    echo "   Démarre Docker Desktop ou Rancher Desktop puis réessaie." >&2
    exit 1
fi

# Détection TTY : -it si terminal interactif, sinon -i (pipe). C'est ce qui
# rend les commandes interactives utilisables SANS winpty sous MobaXterm.
EXEC="-i"
if [ -t 0 ] && [ -t 1 ]; then
    EXEC="-it"
fi

# Option --think : bascule sur un modèle de raisonnement pour cet appel.
MODEL_ENV=()
if [ "${1:-}" = "--think" ]; then
    MODEL_ENV=(-e AIDER_MODEL=ollama/qwen3:14b -e AIDER_WEAK_MODEL=ollama/qwen3:14b)
    shift
fi

CMD="${1:-help}"
shift || true

case "$CMD" in
    up)       $RUNTIME compose up -d --build ;;
    down)     $RUNTIME compose down ;;
    logs)     $RUNTIME logs -f "$CONTAINER" ;;
    shell)    $RUNTIME exec $EXEC "$CONTAINER" bash ;;
    gui)      $RUNTIME exec $EXEC "${MODEL_ENV[@]}" "$CONTAINER" gui.sh "$@" ;;
    chat)     $RUNTIME exec $EXEC "${MODEL_ENV[@]}" "$CONTAINER" chat.sh ;;
    skills)   $RUNTIME exec $EXEC "$CONTAINER" skill.sh ;;
    skill)    $RUNTIME exec $EXEC "${MODEL_ENV[@]}" "$CONTAINER" skill.sh "$@" ;;
    fix)      $RUNTIME exec $EXEC "${MODEL_ENV[@]}" "$CONTAINER" correct-tests.sh ;;
    migrate)  $RUNTIME exec $EXEC "${MODEL_ENV[@]}" "$CONTAINER" migrate.sh "$@" ;;
    evolve)   $RUNTIME exec $EXEC "${MODEL_ENV[@]}" "$CONTAINER" evolve.sh "$@" ;;
    compile)  $RUNTIME exec $EXEC "$CONTAINER" compile.sh ;;
    test)     $RUNTIME exec $EXEC "$CONTAINER" test.sh ;;
    version)  $RUNTIME exec $EXEC "$CONTAINER" aider --version ;;
    help|*)
        cat <<'EOF'
Usage : ./agent.sh [--think] <commande> [arguments]

  up                 build + démarre le conteneur
  down               arrête le conteneur
  logs               affiche les logs du conteneur
  shell              ouvre un shell dans le conteneur
  gui [skill...]     Web UI Aider (http://localhost:8501), skills pré-chargés en option
  chat               session interactive Aider (/ask, /model, /test...)
  skills             liste les skills disponibles
  skill <nom> ["…"]  charge un skill (guidance experte) dans Aider
  fix                corrige les tests/builds en échec
  migrate "texte"    migration / refactoring
  evolve  "texte"    nouvelle feature (backend ou front)
  compile            build sans tests (backend + front)
  test               vérification complète (tests + lint + build)
  version            version d'Aider

Option --think : utilise un modèle de raisonnement (qwen3:14b) pour l'appel.
  ex : ./agent.sh --think migrate "Migre les composants vers les signals Angular"
EOF
        ;;
esac
