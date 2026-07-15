#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_SRC="$ROOT_DIR/skill/brain-combo"
CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="$CODEX_HOME_DIR/skills"
TARGET_DIR="$SKILLS_DIR/brain-combo"
BACKUP_ROOT="$CODEX_HOME_DIR/backups/brain-combo"
BACKUP_DIR=""

if [ ! -f "$SKILL_SRC/SKILL.md" ]; then
  echo "Missing skill source at $SKILL_SRC" >&2
  exit 1
fi

mkdir -p "$SKILLS_DIR"

TMP_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

cp -R "$SKILL_SRC" "$TMP_DIR/brain-combo"

if [ -d "$TARGET_DIR" ]; then
  BACKUP_DIR="$BACKUP_ROOT/$(date +%Y%m%d-%H%M%S)-$$"
  mkdir -p "$BACKUP_ROOT"
  cp -R "$TARGET_DIR" "$BACKUP_DIR"
fi

rm -rf "$TARGET_DIR"
mv "$TMP_DIR/brain-combo" "$TARGET_DIR"
chmod +x "$TARGET_DIR/scripts/check-codebase-memory.sh" 2>/dev/null || true

echo "Installed Brain Combo to $TARGET_DIR"
if [ -n "$BACKUP_DIR" ]; then
  echo "Preserved previous installation at $BACKUP_DIR"
fi
echo "Restart Codex so the global skill list refreshes."
