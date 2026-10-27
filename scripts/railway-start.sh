#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATA_DIR="${RAILWAY_VOLUME_MOUNT_PATH:-/app/data}"
mkdir -p "$DATA_DIR"

# Never overwrite an existing persistent database.
if [ ! -f "$DATA_DIR/bot.db" ]; then
  if [ -f "$ROOT_DIR/data-seed/bot.db" ]; then
    cp "$ROOT_DIR/data-seed/bot.db" "$DATA_DIR/bot.db"
    echo "Initialized persistent database from the included backup."
  else
    echo "ERROR: No database found at $DATA_DIR/bot.db and no seed database exists." >&2
    exit 1
  fi
else
  echo "Using existing persistent database: $DATA_DIR/bot.db"
fi

# Use Railway's mounted volume for SQLite persistence unless explicitly configured.
if [ -z "${DATABASE_URL:-}" ]; then
  export DATABASE_URL="sqlite+aiosqlite:////${DATA_DIR#/}/bot.db"
fi

cd "$ROOT_DIR"
exec python -m bot.main
