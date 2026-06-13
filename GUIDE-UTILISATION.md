# Guide d'utilisation — pas à pas

Ce guide détaille l'installation et les usages courants de `aider-ollama-fullstack`.
Pour une vue d'ensemble, voir le [README](README.md).

---

## 1. Installer les prérequis

### a. Moteur de conteneurs
- **Docker Desktop** (Windows/macOS) **ou** **Rancher Desktop**.
- Sous Rancher Desktop : si tu utilises le moteur *containerd*, c'est `nerdctl` qui sera détecté
  automatiquement par `agent.sh` ; avec le moteur *dockerd (moby)*, c'est `docker`.

### b. Ollama (sur l'hôte, pas dans le conteneur)
```bash
# https://ollama.com/download
ollama pull qwen2.5-coder:14b     # modèle d'édition recommandé
ollama pull qwen3:14b             # (optionnel) réflexion / --think
ollama pull qwen2.5-coder:1.5b    # (optionnel) autocomplétion Continue.dev
```
Vérifie qu'Ollama écoute : `curl http://localhost:11434/api/tags`.

### c. Terminal bash
- Linux/macOS : terminal natif.
- **Windows** : **MobaXterm** ou **Git-Bash**. Pas besoin de winpty ni de PowerShell —
  `agent.sh` détecte le TTY tout seul.

---

## 2. Configurer le projet

```bash
cp .env.example .env
```
Édite `.env` :
- `PROJECT_PATH` = chemin **absolu** vers ton projet (obligatoire).
  - Windows : `C:\Users\moi\dev\mon-projet`
  - Mac/Linux : `/home/moi/dev/mon-projet`
- Choisis un **profil de modèle** selon ta VRAM (commentaires dans le fichier).

Le projet cible peut être :
- un **monorepo** : `mon-projet/backend` (pom.xml) + `mon-projet/frontend` (package.json) ;
- ou deux dossiers séparés montés tour à tour.

Les scripts cherchent `pom.xml` dans `/project`, `/project/backend`, `/project/api`, `/project/server`
et `package.json` dans `/project`, `/project/frontend`, `/project/webapp`, `/project/client`, `/project/ui`.

---

## 3. Copier les conventions (recommandé)

```bash
cp CONVENTIONS-BACKEND.md CONVENTIONS-FRONTEND.md "$PROJECT_PATH/"
```
Quand elles sont présentes à la racine du projet, **tous les scripts les chargent
automatiquement** dans Aider (`--read`) pour orienter le style du code généré.

---

## 4. Démarrer

```bash
./agent.sh up        # build de l'image puis démarrage en arrière-plan
./agent.sh version   # vérifie qu'Aider répond
```

---

## 5. Les trois modes de travail

### Web UI (le plus visuel)
```bash
./agent.sh gui
```
Ouvre **http://localhost:8501**. Idéal pour suivre les diffs et discuter.

### Chat interactif
```bash
./agent.sh chat
```
Commandes utiles dans le prompt :
- `/ask <question>` — pose une question **sans** modifier le code.
- `/code <consigne>` — demande une modification.
- `/add <fichier>` / `/drop <fichier>` — gère le contexte.
- `/model ollama/qwen3:14b` — bascule vers le modèle « thinking » à la volée.
- `/test` — lance la vérification (`verify.sh`).
- `/diff`, `/undo` — voir / annuler.

### One-shot (scriptable)
```bash
./agent.sh evolve  "Ajoute un endpoint REST GET /api/products avec pagination et tri"
./agent.sh migrate "Passe les services Angular aux signals et au control flow @if/@for"
./agent.sh fix       # corrige en boucle les tests/builds en échec (MAX_ITER)
```

---

## 6. Stratégie de modèles

| Profil | Modèle | Usage |
|---|---|---|
| Équilibré (défaut) | `qwen2.5-coder:14b` | édition quotidienne, diffs fiables |
| Léger | `qwen2.5-coder:7b` | ~8 Go VRAM ou machine chargée |
| Réflexion | `qwen3:14b` | refactos délicats (`--think` ou `/model`) |
| Puissant | `qwen3-coder:30b` | grosse VRAM / offload CPU |

- Override par appel : `./agent.sh --think migrate "…"`.
- Override durable : décommente le profil voulu dans `.env`, puis `./agent.sh down && ./agent.sh up`.

### Réglages Ollama utiles (côté hôte)
```bash
OLLAMA_FLASH_ATTENTION=1
OLLAMA_KV_CACHE_TYPE=q8_0
OLLAMA_MAX_LOADED_MODELS=1
```

---

## 7. Bonnes pratiques

- **Travaille sur une branche git** dans ton projet cible : les scripts utilisent `--no-git`
  (Aider ne committe pas), donc tu gardes la main sur l'historique et tu peux relire/annuler.
- Donne des consignes **petites et précises** : un endpoint, un composant, un refactor à la fois.
- Laisse les conventions faire le cadrage plutôt que de tout répéter dans chaque prompt.
- Utilise `/ask` pour faire expliquer le code avant de le modifier.

---

## 8. Dépannage

| Symptôme | Piste |
|---|---|
| `Ni 'docker' ni 'nerdctl'…` | démarre Docker/Rancher Desktop |
| Aider ne joint pas le modèle | Ollama lancé sur l'hôte ? `extra_hosts host.docker.internal` OK ? |
| `PROJECT_PATH` requis | renseigne le chemin absolu dans `.env` |
| Tests Angular qui ouvrent un navigateur | utilise `ng test --watch=false --browsers=ChromeHeadless` (CHROME_BIN fourni) |
| Diffs cassés / réponses bavardes | repasse sur un modèle *coder* (le « thinking » est pour la réflexion, pas l'édition de masse) |
