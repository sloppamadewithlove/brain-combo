#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_SRC="$ROOT_DIR/skill/brain-combo"
CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="$CODEX_HOME_DIR/skills"
TARGET_DIR="$SKILLS_DIR/brain-combo"

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
rm -rf "$TARGET_DIR"
mv "$TMP_DIR/brain-combo" "$TARGET_DIR"
chmod +x "$TARGET_DIR/scripts/check-codebase-memory.sh" 2>/dev/null || true

echo "Installed Brain Combo to $TARGET_DIR"
echo "Restart Codex so the global skill list refreshes."
