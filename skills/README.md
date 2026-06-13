# Skills

Bibliothèque de **prompts experts réutilisables** (revue, patterns, sécurité, tests…) pour le
développement Java/Spring Boot. Chaque skill est un fichier Markdown autoportant que l'on charge
**en lecture seule dans Aider** pour cadrer la réponse de l'IA.

> ♻️ **Double compatibilité** : le format `SKILL.md` (frontmatter `name` + `description`) reste
> aussi reconnu par **Claude Code**. Ces skills fonctionnent donc avec Aider *et* avec Claude Code.

## Utilisation avec Aider

Les skills sont montés en lecture seule sur `/opt/skills` dans le conteneur
(volume `./skills` du `docker-compose.yml`). On les pilote via le lanceur :

```bash
./agent.sh skills                          # liste les skills disponibles
./agent.sh skill java-code-review          # session interactive avec le skill chargé
./agent.sh skill spring-boot-patterns "Crée un UserController CRUD avec validation"
./agent.sh --think skill design-patterns "Refactore ce service avec le pattern Strategy"
```

En session interactive Aider, on peut aussi charger un skill à la volée :
```text
/read /opt/skills/test-quality/SKILL.md
```

## Structure Convention

Each skill folder contains:

| File | Purpose | Audience |
|------|---------|----------|
| `SKILL.md` | Guidance experte chargée dans l'IA (`--read` / `/read`) | IA (Aider, Claude Code) |
| `README.md` | Documentation, exemples, astuces | Humains (onboarding) |

## Available Skills

### Workflow
| Skill | Description |
|-------|-------------|
| [git-commit](git-commit/) | Conventional commit messages for Java projects |
| [changelog-generator](changelog-generator/) | Generate changelogs from git commits |
| [issue-triage](issue-triage/) | GitHub issue triage and categorization |

### Code Quality
| Skill | Description |
|-------|-------------|
| [java-code-review](java-code-review/) | Systematic Java code review checklist |
| [api-contract-review](api-contract-review/) | REST API audit: HTTP semantics, versioning, compatibility |
| [concurrency-review](concurrency-review/) | Thread safety, race conditions, @Async, Virtual Threads |
| [performance-smell-detection](performance-smell-detection/) | Code-level performance smells (streams, boxing, regex) |
| [test-quality](test-quality/) | JUnit 5 + AssertJ testing patterns |
| [maven-dependency-audit](maven-dependency-audit/) | Audit dependencies for updates and vulnerabilities |
| [security-audit](security-audit/) | OWASP Top 10, input validation, injection prevention |

### Architecture & Design
| Skill | Description |
|-------|-------------|
| [architecture-review](architecture-review/) | Macro-level review: packages, modules, layers, boundaries |
| [solid-principles](solid-principles/) | S.O.L.I.D. principles with Java examples |
| [design-patterns](design-patterns/) | Factory, Builder, Strategy, Observer, Decorator, etc. |
| [clean-code](clean-code/) | DRY, KISS, YAGNI, naming, refactoring |

### Framework & Data
| Skill | Description |
|-------|-------------|
| [spring-boot-patterns](spring-boot-patterns/) | Spring Boot best practices |
| [java-migration](java-migration/) | Java version upgrade guide (8→11→17→21) |
| [jpa-patterns](jpa-patterns/) | JPA/Hibernate patterns (N+1, lazy loading, transactions) |
| [logging-patterns](logging-patterns/) | Structured logging (JSON), SLF4J, MDC, AI-friendly formats |

## Adding a New Skill

### Before You Start

Validate your skill idea against existing skills:

- [ ] **No significant overlap** - Check the table above for similar skills
- [ ] **Clear level** - Micro (functions) / Meso (classes) / Macro (packages) / Framework / Cross-cutting
- [ ] **Clear type** - Audit (review existing code) or Template (show how to write)
- [ ] **Unique value** - What does it add that doesn't exist?
- [ ] **Focused scope** - Can be applied in one session (<15 checklist items)

### Implementation Steps

1. Create folder: `skills/<skill-name>/`
2. Create `SKILL.md` (frontmatter `name` + `description`, puis la guidance experte)
3. Create `README.md` with human documentation (use existing READMEs as template)
4. Update this table
5. Update main README.md

## Learn More

- [Aider — documentation](https://aider.chat) · le flag `--read` charge un fichier en lecture seule
- [Claude Code — Skills](https://code.claude.com/docs/en/skills) · format `SKILL.md` (compatibilité)
