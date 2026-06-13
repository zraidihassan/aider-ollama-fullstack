# 🤖 aider-ollama-fullstack

> Un agent de codage IA **100 % local et gratuit** pour développer des applications
> **Spring Boot 3 (Java 21) + Angular** — sans envoyer une ligne de code dans le cloud.

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
![Java](https://img.shields.io/badge/Java-21-orange)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.3-brightgreen)
![Angular](https://img.shields.io/badge/Angular-18-red)
![Aider](https://img.shields.io/badge/Aider-0.86.2-blue)
![Ollama](https://img.shields.io/badge/LLM-Ollama%20(local)-black)

---

## ✨ Pourquoi ce projet ?

[Aider](https://aider.chat) est un excellent agent de pair-programming en ligne de commande,
et [Ollama](https://ollama.com) fait tourner des LLM **en local**. Ce dépôt les emballe dans
un conteneur prêt à l'emploi, **outillé pour la stack Spring Boot + Angular** :

- 🔒 **Privé** : le LLM tourne sur ta machine, ton code ne sort jamais.
- 💸 **Gratuit** : aucune API payante, aucun abonnement.
- 📦 **Reproductible** : tout l'environnement (JDK 21, Maven, Node, Angular CLI, Aider) est dans une image Docker.
- 🧭 **Cadré** : des fichiers de conventions guident l'IA vers du code moderne et testé.
- 🪟 **Multiplateforme** : Linux, macOS et Windows (MobaXterm/Git-Bash), Docker **ou** Rancher Desktop.

> 💡 Tu travailles sur du **legacy** (Java 8, ExtJS…) ? Ce projet a un grand frère orienté
> migration. Ici, la cible est volontairement **moderne**.

---

## 🏗️ Architecture

```
┌─────────────────────┐        exec         ┌──────────────────────────────┐
│   Ton terminal      │  ./agent.sh ...     │   Conteneur ai-coding-agent  │
│  (Linux/Mac/Moba)   │ ─────────────────►  │  JDK 21 · Maven · Node/ng    │
└─────────────────────┘                     │  + Aider (CLI)               │
                                             └───────────────┬──────────────┘
        ┌────────────────────────────┐                       │ /project (volume)
        │  Ollama (sur l'HÔTE)        │  ◄── HTTP 11434 ──────┤
        │  qwen2.5-coder / qwen3 ...  │                       ▼
        └────────────────────────────┘            ┌──────────────────────┐
                                                   │ Ton projet           │
                                                   │ backend/ + frontend/ │
                                                   └──────────────────────┘
```

Le conteneur monte ton projet sur `/project`, détecte automatiquement le **backend Maven**
(`pom.xml`) et le **frontend Angular** (`package.json`), puis pilote Aider avec le LLM local.

---

## 📋 Prérequis

1. **Docker Desktop** ou **Rancher Desktop** (le lanceur détecte `docker` ou `nerdctl`).
2. **[Ollama](https://ollama.com)** installé et lancé **sur l'hôte**, avec au moins un modèle :
   ```bash
   ollama pull qwen2.5-coder:14b
   ```
3. Un terminal **bash** : natif sous Linux/macOS, **MobaXterm** ou **Git-Bash** sous Windows.

> **VRAM** : `qwen2.5-coder:14b` vise ~12 Go. Sur 8 Go, prends le profil `:7b` (voir `.env.example`).

---

## 🚀 Démarrage rapide

```bash
git clone git@github.com:zraidihassan/aider-ollama-fullstack.git
cd aider-ollama-fullstack

# 1. Configure le chemin de TON projet
cp .env.example .env
# édite .env -> PROJECT_PATH=/chemin/vers/ton/projet

# 2. (recommandé) copie les conventions à la racine de ton projet
cp CONVENTIONS-BACKEND.md CONVENTIONS-FRONTEND.md /chemin/vers/ton/projet/

# 3. Build + démarrage du conteneur
./agent.sh up

# 4. Au choix :
./agent.sh gui      # Web UI dans le navigateur  -> http://localhost:8501
./agent.sh chat     # session interactive en terminal
./agent.sh evolve "Ajoute un endpoint REST GET /api/users paginé + un composant Angular qui l'affiche"
```

---

## 🎮 Commandes (`./agent.sh`)

| Commande | Effet |
|---|---|
| `up` / `down` | build+démarre / arrête le conteneur |
| `gui` | Web UI Aider → http://localhost:8501 |
| `chat` | session interactive (`/ask`, `/code`, `/model`, `/test`…) |
| `skills` | liste les skills experts disponibles |
| `skill <nom> ["…"]` | charge un skill (guidance experte) dans Aider |
| `evolve "…"` | nouvelle feature (backend ou front), build vérifié |
| `migrate "…"` | refactoring / migration, vérification complète |
| `fix` | corrige en boucle les tests/builds en échec |
| `compile` | build sans tests (backend + front) |
| `test` | vérification complète (tests + lint + build) |
| `shell` | shell dans le conteneur |
| `logs` / `version` | logs / version d'Aider |

Préfixe **`--think`** pour basculer ponctuellement sur un modèle de raisonnement :
```bash
./agent.sh --think migrate "Migre les composants Angular vers standalone + signals"
```

---

## 🧭 Trois façons de travailler

| Mode | Pour qui | Commande |
|---|---|---|
| **Web UI** | confort visuel, suivi des diffs | `./agent.sh gui` |
| **Chat** | dialogue, `/ask` avant de coder | `./agent.sh chat` |
| **One-shot** | tâche précise, scriptable/CI | `./agent.sh evolve "…"` |

---

## 🧠 Modèles & autocomplétion (Continue.dev)

Le choix du modèle se fait dans `.env` (profils par VRAM). Pour de l'**autocomplétion**
directement dans l'IDE, installe le plugin **[Continue.dev](https://www.continue.dev)**
(VS Code ou [JetBrains](https://plugins.jetbrains.com/plugin/22707-continue)) et pointe-le
sur le même Ollama local (ex. `qwen2.5-coder:1.5b` pour la complétion).

---

## 🧩 Skills experts (`skills/`)

Le dossier [`skills/`](skills/) fournit une bibliothèque de **prompts experts réutilisables** :
des fichiers `SKILL.md` autoportants qui cadrent l'IA sur une bonne pratique précise
(revue de code, patterns Spring Boot, sécurité OWASP, tests JUnit 5, migration Java…).

| Catégorie | Skills |
|---|---|
| **Qualité de code** | `java-code-review`, `clean-code`, `solid-principles`, `design-patterns`, `test-quality` |
| **Spring / API / Données** | `spring-boot-patterns`, `api-contract-review`, `jpa-patterns`, `logging-patterns` |
| **Robustesse** | `security-audit`, `concurrency-review`, `performance-smell-detection`, `architecture-review` |
| **Migration / outillage** | `java-migration`, `maven-dependency-audit`, `git-commit`, `changelog-generator`, `issue-triage` |

### Comment ça marche avec Aider

Aider n'a pas de système de « skills » natif : un skill est simplement un fichier Markdown
chargé **en lecture seule** dans le contexte (flag `--read`). Le dossier `skills/` est monté sur
`/opt/skills` dans le conteneur (volume du `docker-compose.yml`), et le lanceur fait le reste :

```bash
./agent.sh skills                       # liste les skills disponibles
./agent.sh skill java-code-review       # session interactive, skill chargé en contexte
./agent.sh skill spring-boot-patterns "Crée un UserController CRUD avec validation"
./agent.sh --think skill design-patterns "Refactore ce service avec le pattern Strategy"
```

En session `chat`, on peut aussi charger un skill à la volée : `/read /opt/skills/test-quality/SKILL.md`.

> ♻️ **Bonus** : le format `SKILL.md` reste compatible **Claude Code** (`view skills/<nom>/SKILL.md`).
> Les skills servent donc aux deux outils. Détails dans [`skills/README.md`](skills/README.md).

```
skills/
├── README.md                     # catalogue + mode d'emploi
└── <nom-du-skill>/
    ├── SKILL.md                  # guidance chargée dans l'IA (--read / /read)
    └── README.md                 # doc humaine (cas d'usage, exemples)
```

## 📁 Structure du dépôt

```
aider-ollama-fullstack/
├── agent.sh                  # lanceur hôte (Docker/nerdctl, TTY auto, --think)
├── Dockerfile                # JDK 21 + Maven + Node/Angular CLI + Aider + Chromium
├── docker-compose.yml        # volume /project, Ollama via host.docker.internal
├── .env.example              # PROJECT_PATH + profils de modèles
├── CONVENTIONS-BACKEND.md    # règles Spring Boot 3 / Java 21 / REST (à copier dans ton projet)
├── CONVENTIONS-FRONTEND.md   # règles Angular moderne (à copier dans ton projet)
├── GUIDE-UTILISATION.md      # guide pas à pas
├── CONTRIBUTING.md           # comment contribuer
├── LICENSE                   # MIT
├── skills/                   # bibliothèque de skills Java/Spring Boot (SKILL.md)
└── scripts/                  # commandes exécutées DANS le conteneur
    ├── detect-stack.sh       #   détection backend/frontend + conventions
    ├── verify.sh             #   tests backend + lint/build front (= --test-cmd)
    ├── chat.sh  gui.sh       #   modes interactifs
    ├── skill.sh              #   charge un skill de skills/ dans Aider
    ├── evolve.sh migrate.sh  #   features / refactoring
    ├── correct-tests.sh      #   boucle de correction bornée
    └── compile.sh test.sh
```

---

## 🤝 Contribuer

Les contributions sont les bienvenues ! Voir **[CONTRIBUTING.md](CONTRIBUTING.md)**.
Idées : support Gradle, profils de modèles supplémentaires, exemples de projets, conventions par framework front.

## 📜 Licence

[MIT](LICENSE) — utilisation libre, y compris commerciale. Aucune garantie.

## 🙏 Remerciements

[Aider](https://aider.chat) · [Ollama](https://ollama.com) · [Qwen](https://github.com/QwenLM) · [Continue.dev](https://www.continue.dev)
