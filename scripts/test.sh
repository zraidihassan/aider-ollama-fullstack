#!/bin/bash
# Lance la vérification complète (tests backend + lint/build frontend).
set -uo pipefail
exec /usr/local/bin/verify.sh
