---
title: "Un agent de codage IA 100 % local et gratuit pour Spring Boot + Angular"
subtitle: "Aider + Ollama dans Docker : votre code ne quitte jamais votre machine"
tags: java, springboot, angular, ai
canonical_url: https://github.com/zraidihassan/aider-ollama-fullstack
published: false
---

# Un agent de codage IA 100 % local et gratuit pour Spring Boot + Angular

> **TL;DR** — J'ai empaqueté [Aider](https://aider.chat) (agent de pair‑programming) et
> [Ollama](https://ollama.com) (LLM local) dans une image Docker prête à l'emploi, outillée pour
> la stack **Spring Boot 3 / Java 21 + Angular**. Résultat : un assistant de code qui tourne
> **entièrement sur votre machine**, sans abonnement et sans envoyer une ligne de code dans le cloud.
> Le projet est open‑source (MIT) : **https://github.com/zraidihassan/aider-ollama-fullstack**

## Le problème

Les assistants de code dans le cloud sont puissants, mais ils posent trois soucis récurrents en
entreprise : **la confidentialité** (votre code part sur des serveurs tiers), **le coût** (abonnement
par siège), et **la dépendance** à une connexion et à un fournisseur. Pour beaucoup d'équipes — surtout
sur du code propriétaire ou réglementé — c'est rédhibitoire.

La bonne nouvelle : on peut aujourd'hui faire tourner un assistant de code **localement**, avec des
modèles ouverts qui tiennent sur un GPU de portable.

## Les ingrédients

- **[Ollama](https://ollama.com)** : fait tourner des LLM ouverts en local (ici `qwen2.5-coder`).
- **[Aider](https://aider.chat)** : un agent CLI qui édite vraiment vos fichiers, lance les tests et
  itère — pas juste un chat.
- **Docker** : pour figer tout l'environnement (JDK 21, Maven, Node, Angular CLI) une fois pour toutes.

## L'architecture

```
┌─────────────────────┐        exec         ┌──────────────────────────────┐
│   Votre terminal    │  ./agent.sh ...     │   Conteneur ai-coding-agent  │
│  (Linux/Mac/Moba)   │ ─────────────────►  │  JDK 21 · Maven · Node/ng    │
└─────────────────────┘                     │  + Aider (CLI)               │
                                             └───────────────┬──────────────┘
        ┌────────────────────────────┐                       │ /project (volume)
        │  Ollama (sur l'HÔTE)        │  ◄── HTTP 11434 ──────┤
        │  qwen2.5-coder / qwen3 ...  │                       ▼
        └────────────────────────────┘            ┌──────────────────────┐
                                                   │ Votre projet         │
                                                   │ backend/ + frontend/ │
                                                   └──────────────────────┘
```

![Architecture — aider-ollama-fullstack](https://raw.githubusercontent.com/zraidihassan/aider-ollama-fullstack/main/docs/architecture.png)

Le conteneur monte votre projet sur `/project`, détecte automatiquement le **backend Maven**
(`pom.xml`) et le **frontend Angular** (`package.json`), puis pilote Aider avec le modèle local.

## Démarrage en 4 commandes

Prérequis : Docker (ou Rancher Desktop) et Ollama installé sur l'hôte.

![Démarrage en quelques commandes](https://raw.githubusercontent.com/zraidihassan/aider-ollama-fullstack/main/docs/quickstart.png)

```bash
# 0. Récupérer un modèle de code
ollama pull qwen2.5-coder:14b

# 1. Cloner le projet
git clone https://github.com/zraidihassan/aider-ollama-fullstack.git
cd aider-ollama-fullstack

# 2. Pointer vers VOTRE projet
cp .env.example .env
#   éditez .env -> PROJECT_PATH=/chemin/vers/votre/projet

# 3. Démarrer
./agent.sh up
```

Et on travaille, au choix :

```bash
./agent.sh gui                 # Web UI dans le navigateur (http://localhost:8501)
./agent.sh chat                # session interactive en terminal
./agent.sh evolve "Ajoute un endpoint REST GET /api/users paginé + le composant Angular qui l'affiche"
```

## Ce qui rend l'agent fiable : conventions + skills

Un LLM local laissé sans cadre produit du code inégal. Deux mécanismes le canalisent :

- **Conventions** (`CONVENTIONS-BACKEND.md`, `CONVENTIONS-FRONTEND.md`) : des règles **toujours**
  chargées (injection par constructeur, DTO en `record`, Angular standalone + signals, JUnit 5…).
- **Skills** : des prompts experts **à la demande** (revue de code, patterns Spring Boot, audit de
  sécurité OWASP, qualité de tests…), chargés en lecture seule :

```bash
./agent.sh skills                                   # liste
./agent.sh skill spring-boot-patterns "Crée un UserController CRUD avec validation"
./agent.sh skill test-quality "Écris les tests JUnit 5 manquants pour UserService"
```

Astuce : le format `SKILL.md` reste compatible **Claude Code**, donc la même bibliothèque sert aux
deux outils.

## Pensé pour le terrain (y compris Windows/MobaXterm)

Le lanceur `agent.sh` détecte automatiquement le moteur de conteneurs (**Docker** ou **nerdctl**
pour Rancher Desktop) et le **TTY**, ce qui rend les sessions interactives utilisables sous
MobaXterm **sans winpty ni PowerShell**. La vérification (`verify.sh`) lance les tests Maven *et*
le lint/build Angular ; la commande `fix` corrige les échecs en boucle bornée.

## Quel modèle pour quelle machine ?

| VRAM | Modèle | Usage |
|---|---|---|
| ~12 Go | `qwen2.5-coder:14b` | édition quotidienne (défaut) |
| ~8 Go | `qwen2.5-coder:7b` | machine modeste |
| réflexion | `qwen3:14b` | refactos délicats (`--think`) |

## Conclusion

Un assistant de code local, ce n'est plus un compromis : sur une stack Spring Boot + Angular
moderne, avec des conventions et des skills bien posés, on obtient un agent **privé, gratuit et
reproductible**. Le projet est ouvert aux contributions (support Gradle, autres frameworks front,
CI…).

👉 **Le dépôt : https://github.com/zraidihassan/aider-ollama-fullstack**

*Si l'idée vous plaît, une ⭐ sur le repo aide beaucoup. Retours et PR bienvenus.*
