# Contribuer

Merci de ton intérêt ! Ce projet est ouvert et les contributions sont bienvenues.

## Comment contribuer

1. **Fork** le dépôt, puis crée une branche depuis `main` :
   `git checkout -b feat/ma-contribution`
2. Fais tes modifications avec des commits clairs.
3. Ouvre une **Pull Request** décrivant le quoi et le pourquoi.

## Signaler un bug / proposer une idée

Ouvre une **Issue** en décrivant :
- ce que tu attendais vs ce qui se passe,
- ton OS, ton moteur de conteneurs (Docker/Rancher), ta version d'Ollama,
- les étapes pour reproduire.

## Style

- Scripts shell : `bash`, `set -euo pipefail`, compatibles MobaXterm/Git-Bash
  (pas de dépendance à winpty ; fins de ligne LF — l'image fait `dos2unix` par sécurité).
- Garde les scripts **idempotents** et **sans secret** en dur.
- Documentation en français (le projet est francophone), identifiants en anglais.

## Idées de contributions

- Support **Gradle** en plus de Maven.
- Profils de modèles supplémentaires (autres GPU / CPU only).
- Exemples de projets de démonstration (backend + front minimal).
- Conventions pour d'autres frameworks front (React, Vue).
- Intégration CI (GitHub Actions) lançant `verify.sh` sur un projet d'exemple.

## Licence

En contribuant, tu acceptes que ton code soit distribué sous licence **MIT**.
