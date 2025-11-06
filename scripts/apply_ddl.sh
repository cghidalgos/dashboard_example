#!/usr/bin/env bash
set -euo pipefail

# Requiere variables de entorno de PostgreSQL:
#   PGHOST, PGPORT, PGUSER, PGPASSWORD, PGDATABASE
# Ejemplo de uso:
#   PGHOST=localhost PGUSER=postgres PGPASSWORD=xxx PGDATABASE=estudiantes_videojuegos \
#   ./scripts/apply_ddl.sh

if ! command -v psql >/dev/null 2>&1; then
  echo "Error: psql no está instalado o no está en el PATH" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="${SCRIPT_DIR%/scripts}"

psql \
  --set=ON_ERROR_STOP=1 \
  --file="${REPO_DIR}/DDL.sql"

echo "DDL aplicado correctamente."
