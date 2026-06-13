# Conventions frontend — Angular moderne (v17+/18+)

> À copier à la racine du projet cible. Les scripts l'injectent dans Aider via `--read`.
> Objectif : Angular moderne, typé strict, sans modules superflus.

## Socle technique
- **Angular 17+/18+**, **TypeScript strict** (`strict: true` dans `tsconfig`).
- **Composants `standalone`** (`standalone: true`) — **pas de `NgModule`** pour le nouveau code.
- Démarrage via `bootstrapApplication` + `app.config.ts` (pas d'`AppModule`).

## Réactivité & état
- **Signals** pour l'état local (`signal`, `computed`, `effect`) plutôt que des `BehaviorSubject` ad hoc.
- `input()` / `output()` (fonctions de signaux) pour les entrées/sorties de composant quand disponibles.
- RxJS pour les flux asynchrones (HTTP, événements) ; toujours gérer la désinscription (`takeUntilDestroyed`, `async` pipe).

## HTTP & API
- `HttpClient` injecté via `inject()`. `provideHttpClient(withFetch())` dans la config.
- **Services typés** : chaque appel renvoie un type/`interface` explicite, jamais `any`.
- URL d'API centralisée (environnement), pas d'URL en dur dans les composants.
- Intercepteurs (fonctionnels) pour l'auth et la gestion d'erreurs.

## Composants & templates
- Un composant = une responsabilité. Logique de présentation dans le composant, logique métier dans un service.
- **Nouveau control flow** : `@if`, `@for` (avec `track`), `@switch` — pas `*ngIf`/`*ngFor` pour le nouveau code.
- `ChangeDetectionStrategy.OnPush` par défaut.
- Formulaires **réactifs typés** (`FormGroup`/`FormControl` typés), validation côté front cohérente avec le backend.

## Style & structure
- Injection via la fonction `inject()` plutôt que le constructeur quand cela allège.
- Nommage : composants `XxxComponent`, services `XxxService`, fichiers en `kebab-case`.
- Pas de `any` ; activer/respecter ESLint. Accessibilité de base (labels, rôles).

## Tests
- Tests unitaires composants/services (Karma+Jasmine par défaut, ou Jest/Vitest si le projet les utilise).
- `ng test` doit tourner **headless** dans le conteneur : `--watch=false --browsers=ChromeHeadless`
  (la variable `CHROME_BIN` est déjà fournie par l'image).
- Le `npm run build` (type-check complet) doit toujours passer — c'est le filet de sécurité minimal.

## À éviter
- `NgModule` pour du nouveau code, `any`, abonnements RxJS non nettoyés.
- Manipuler le DOM directement (`document.querySelector`) au lieu des API Angular.
- URLs/secrets en dur dans le code.

## Style
- Commentaires en français possible, **identifiants/symboles en anglais**.
- Respecter le formatage existant ; ne pas reformater des fichiers non concernés.
