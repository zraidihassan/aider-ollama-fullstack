# 📣 Kit LinkedIn — aider-ollama-fullstack

Ce fichier regroupe tout ce qu'il faut pour valoriser le projet (et son auteur) sur LinkedIn :
posts prêts à publier, version « article LinkedIn », idées de série, et suggestions pour
améliorer le profil. Copiez-collez, adaptez le ton, publiez.

> 💡 L'algorithme LinkedIn pénalise les liens externes dans le corps du post :
> mettez le lien GitHub **dans le premier commentaire**, pas dans le post.

---

## 1. Post d'annonce (version longue, ~1 200 caractères)

À publier avec l'image `docs/architecture.png` (ou `docs/quickstart.png`).

```
Votre assistant de code IA peut tourner à 100 % sur votre machine. Sans cloud. Sans abonnement.

Les assistants de code cloud posent 3 problèmes récurrents en entreprise :
🔒 Confidentialité — votre code part sur des serveurs tiers
💸 Coût — un abonnement par siège
🔌 Dépendance — à une connexion et à un fournisseur

Pour du code propriétaire ou réglementé, c'est souvent rédhibitoire.

Alors j'ai construit une alternative open-source : un agent de codage IA 100 % local
pour la stack Spring Boot 3 (Java 21) + Angular.

Sous le capot :
▸ Aider — un agent CLI qui édite vraiment vos fichiers, lance les tests et itère
▸ Ollama — des LLM ouverts (qwen2.5-coder) qui tournent sur un GPU de portable
▸ Docker — tout l'environnement (JDK 21, Maven, Node, Angular CLI) figé dans une image

Ce qui rend l'agent fiable au quotidien :
▸ des fichiers de CONVENTIONS toujours chargés (DTO en record, Angular signals, JUnit 5…)
▸ 18 SKILLS experts à la demande : revue de code, patterns Spring Boot, audit OWASP, qualité de tests…
▸ une boucle de vérification : tests Maven + lint/build Angular, correction automatique bornée

Résultat : un pair-programmeur privé, gratuit et reproductible — en 4 commandes.

Le projet est open-source (MIT), lien en premier commentaire. Retours et PR bienvenus 🙌

#Java #SpringBoot #Angular #IA #OpenSource #LLM #DevTools
```

**Premier commentaire :**

```
👉 Le dépôt : https://github.com/zraidihassan/aider-ollama-fullstack
Démarrage en 4 commandes, guide complet dans le README. Une ⭐ aide beaucoup !
```

---

## 2. Post d'annonce (version courte, ~500 caractères)

```
J'ai empaqueté Aider + Ollama dans une image Docker prête à l'emploi pour
Spring Boot 3 + Angular.

Résultat : un agent de codage IA qui tourne 100 % en local.
🔒 Privé — le code ne quitte jamais la machine
💸 Gratuit — aucune API payante
📦 Reproductible — JDK 21, Maven, Node, Angular CLI dans une image
🧭 Cadré — conventions + 18 skills experts (revue de code, OWASP, tests…)

Open-source (MIT), lien en premier commentaire.

#Java #SpringBoot #Angular #IA #OpenSource
```

---

## 3. Article LinkedIn (format long)

LinkedIn a un format « Article » (blog intégré). `ARTICLE.md` est directement réutilisable :

- **Titre** : *Un agent de codage IA 100 % local et gratuit pour Spring Boot + Angular*
- **Contenu** : reprendre `ARTICLE.md` en remplaçant le bloc ASCII de l'architecture par
  l'image `docs/architecture.png` (LinkedIn ne rend pas bien les blocs de code larges).
- **Image de couverture** : `docs/architecture.png`.
- Publier l'article, puis **faire un post court qui pointe vers l'article** (les articles
  seuls ont peu de portée organique ; c'est le post qui amène les lecteurs).

---

## 4. Idées de série (1 post / semaine)

Un lancement unique s'essouffle vite ; une série installe une expertise. Chaque post = un
angle, une image ou un GIF de démo, le lien en commentaire.

| # | Angle | Accroche possible |
|---|---|---|
| 1 | Annonce du projet | (posts ci-dessus) |
| 2 | Les skills | « Un LLM local sans cadre produit du code inégal. Voici comment je le canalise avec 18 prompts experts versionnés dans Git. » |
| 3 | Conventions | « Le fichier le plus rentable de mon repo fait 80 lignes : CONVENTIONS-BACKEND.md. » |
| 4 | Quel modèle pour quelle machine | « 8 Go de VRAM suffisent pour un assistant de code. La preuve. » |
| 5 | Retour d'expérience | « 1 mois avec un agent IA 100 % local sur une vraie stack Spring Boot + Angular : ce qui marche, ce qui coince. » |
| 6 | Démo vidéo | Screencast de `./agent.sh evolve "…"` qui ajoute un endpoint + composant Angular, tests verts. |

---

## 5. Améliorer le profil LinkedIn

### Titre (headline) — 220 caractères max

Le titre est le texte le plus lu du profil (il suit chaque commentaire). Quelques variantes :

```
Développeur Full-Stack Java/Angular · Spring Boot 3 · IA appliquée au dev
Créateur d'aider-ollama-fullstack (agent de codage IA 100 % local, open-source)
```

```
Full-Stack Java 21 / Spring Boot 3 / Angular · J'outille les équipes avec des
agents de codage IA locaux et privés · Open-source (MIT)
```

### Section « À propos »

```
Développeur full-stack Java/Angular, je conçois des applications d'entreprise sur une
stack moderne : Spring Boot 3, Java 21, Angular.

Ma conviction : l'IA générative doit servir les équipes SANS compromettre la
confidentialité du code. C'est pourquoi j'ai créé aider-ollama-fullstack, un agent de
codage IA open-source (MIT) qui tourne 100 % en local — Aider + Ollama dans Docker,
outillé pour Spring Boot + Angular : conventions de code, 18 skills experts (revue de
code, sécurité OWASP, qualité de tests…), vérification automatique des builds.

Ce que j'apporte à une équipe :
▸ du code moderne et testé (constructor injection, records, standalone components, signals)
▸ une culture de la qualité outillée : revues, conventions, CI
▸ une approche pragmatique de l'IA : locale, privée, reproductible

📂 Projet open-source : github.com/zraidihassan/aider-ollama-fullstack
```

### Section « Projets » (ou expérience dédiée)

```
aider-ollama-fullstack — Agent de codage IA 100 % local (open-source, MIT)

Empaquetage d'Aider (agent de pair-programming) et d'Ollama (LLM locaux) dans une image
Docker outillée pour Spring Boot 3 / Java 21 + Angular.

▸ Lanceur multiplateforme (Docker/nerdctl, Linux/macOS/Windows) avec Web UI et CLI
▸ Bibliothèque de 18 skills experts versionnés (revue de code, OWASP, patterns Spring…)
▸ Boucle de vérification automatique : tests Maven + lint/build Angular + correction bornée
▸ Compatible Claude Code (format SKILL.md partagé)

Stack : Docker · Aider · Ollama · qwen2.5-coder · Java 21 · Maven · Angular · Bash
```

### Compétences à mettre en avant

`Java` · `Spring Boot` · `Angular` · `Docker` · `Génie logiciel` · `LLM` /
`IA générative` · `Open Source` · `CI/CD` · `Clean Code`

### Checklist profil

- [ ] Photo de profil nette + bannière (réutiliser `docs/architecture.png` retravaillée)
- [ ] Titre avec mots-clés (les recruteurs cherchent « Spring Boot », « Angular », « IA »)
- [ ] Le dépôt GitHub en « lien » de la section Coordonnées ET dans « Sélection » (Featured)
- [ ] Épingler le post d'annonce dans « Sélection »
- [ ] Mode créateur activé, sujets : #Java #IA #OpenSource
- [ ] URL personnalisée (linkedin.com/in/prenom-nom)

---

## 6. Bonnes pratiques de publication

- **Lien en premier commentaire**, jamais dans le post (portée ÷2 sinon).
- **Accroche en 1re ligne** : seuls ~210 caractères s'affichent avant « … voir plus ».
- **Image ou GIF de démo** : un screencast de l'agent qui code vaut mieux qu'un schéma.
- **3 à 5 hashtags** maximum, mélange large (#IA) et niche (#SpringBoot).
- **Répondre à chaque commentaire dans la première heure** : c'est le signal le plus fort
  pour l'algorithme.
- Publier **mardi–jeudi, 8h–10h** (heure de votre audience).
- Croiser les canaux : le même contenu existe déjà pour dev.to (`ARTICLE.md`) — publier
  LinkedIn d'abord, dev.to ensuite avec `canonical_url`.
