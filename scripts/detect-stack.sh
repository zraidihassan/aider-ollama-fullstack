#!/bin/bash
# Module SOURCÉ par les autres scripts (pas exécuté directement).
# Détecte où se trouvent le backend Maven et le frontend Angular dans le
# projet monté sur /project, qu'il s'agisse d'un monorepo ou non.

# Renvoie le 1er dossier contenant un pom.xml (backend Spring Boot).
detect_backend() {
    local d
    for d in /project /project/backend /project/api /project/server; do
        [ -f "$d/pom.xml" ] && { printf '%s' "$d"; return 0; }
    done
    return 1
}

# Renvoie le 1er dossier contenant un package.json (frontend Angular).
detect_frontend() {
    local d
    for d in /project /project/frontend /project/webapp /project/client /project/ui; do
        [ -f "$d/package.json" ] && { printf '%s' "$d"; return 0; }
    done
    return 1
}

# Construit la liste --read des conventions présentes à la racine du projet.
build_read_args() {
    READ_ARGS=()
    local f
    for f in CONVENTIONS.md CONVENTIONS-BACKEND.md CONVENTIONS-FRONTEND.md; do
        if [ -f "/project/$f" ]; then
            READ_ARGS+=(--read "/project/$f")
            echo "📎 Conventions : $f"
        fi
    done
}
