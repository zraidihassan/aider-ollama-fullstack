# Conventions backend — Spring Boot 3 / Java 21 / API REST

> À copier à la racine du projet cible. Les scripts l'injectent dans Aider via `--read`.
> Objectif : produire du code moderne, idiomatique et testable.

## Socle technique
- **Java 21** (LTS). Utilise les fonctionnalités modernes quand elles clarifient le code : `record`, `switch` expressions, `var` local, `text blocks`, `Optional`, `Stream`.
- **Spring Boot 3.3+** (Jakarta EE, `jakarta.*` et non `javax.*`).
- **Build Maven**, packaging exécutable Spring Boot. Java 21 dans `maven.compiler.release`.
- **JUnit 5** (Jupiter) + AssertJ + Mockito. Pas de JUnit 4.

## Architecture
- Découpage en couches : `controller` (web) → `service` (métier) → `repository` (données). Pas de logique métier dans les contrôleurs.
- **DTO en `record`** pour les entrées/sorties d'API ; ne jamais exposer les entités JPA directement.
- Mapping entité ↔ DTO explicite (MapStruct ou méthodes dédiées), jamais de fuite d'entité dans le JSON.

## Injection de dépendances
- **Injection par constructeur uniquement** (pas de `@Autowired` sur les champs). Champs `private final`.
- Une seule responsabilité par classe ; favorise l'immuabilité.

## API REST
- `@RestController`, routes versionnées sous `/api/...`.
- Codes HTTP corrects : 200/201/204, 400 (validation), 404, 409, 422 ; jamais 200 pour une erreur.
- **Validation** via `jakarta.validation` (`@Valid`, `@NotNull`, `@Size`...) sur les DTO d'entrée.
- **Gestion d'erreurs centralisée** avec `@RestControllerAdvice` renvoyant un corps structuré (idéalement `ProblemDetail`, RFC 7807).
- Pagination/tri via `Pageable` quand une collection peut grossir.

## Persistance
- Spring Data JPA. Requêtes dérivées ou `@Query` ; pas de SQL concaténé.
- Transactions : `@Transactional` au niveau service, lecture seule (`readOnly = true`) quand pertinent.

## Tests
- **Tests unitaires** de la couche service avec Mockito (pas de contexte Spring).
- **Tests web** avec `@WebMvcTest` + `MockMvc` pour les contrôleurs.
- **Tests d'intégration** avec `@SpringBootTest` + **Testcontainers** pour la vraie base, jamais une base de prod.
- Nommage : `methode_condition_resultatAttendu`. Assertions avec **AssertJ** (`assertThat(...)`).
- Tout nouveau endpoint ou règle métier vient avec son test.

## À éviter
- `javax.*` (utiliser `jakarta.*`), `@Autowired` sur champ, `RestTemplate` pour du nouveau code (préférer `RestClient`/`WebClient`).
- Exceptions silencieuses, `printStackTrace`, `System.out` (utiliser SLF4J).
- Exposer des entités JPA dans l'API, logique métier dans les contrôleurs.

## Style
- Code et commentaires en français possible, mais **noms d'API/identifiants en anglais**.
- Respecter le formatage existant ; ne pas reformater des fichiers non concernés.
- Modifier le moins de fichiers possible par changement.
