#!/usr/bin/env bash
# scaffold.sh — drop tack's quality-context skeleton into a target repo.
#
# Usage:  ./scaffold.sh [target-dir]     (default: current directory)
#
# Idempotent and safe on brownfield repos: existing files are NEVER
# overwritten — they are reported as "kept". Run it once, fill in the TODO
# markers, then run tack-characterize and tack-migrate.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES="$SCRIPT_DIR/../templates"
TARGET="${1:-$PWD}"

if [ ! -d "$TARGET" ]; then
  echo "error: target dir does not exist: $TARGET" >&2
  exit 1
fi
if [ ! -d "$TARGET/.git" ]; then
  echo "warning: $TARGET is not a git repo — scaffold anyway? (Ctrl-C to abort)"
  read -r _
fi

created=0
kept=0

install_file() { # install_file <template> <dest-relative-path> [mode]
  local src="$TEMPLATES/$1" dest="$TARGET/$2" mode="${3:-0644}"
  if [ -e "$dest" ]; then
    echo "kept     $2 (already exists)"
    kept=$((kept + 1))
    return
  fi
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  chmod "$mode" "$dest"
  echo "created  $2"
  created=$((created + 1))
}

install_file AGENTS.md                 AGENTS.md
install_file GLOSSARY.md               GLOSSARY.md
install_file check-context.sh          scripts/check-context.sh 0755
install_file ci-agent-ready.yml        .github/workflows/agent-ready.yml
install_file pre-commit-config.yaml    .pre-commit-config.yaml

# ADR log: directory + scannable index (see the tack-adr skill).
if [ ! -e "$TARGET/docs/adr/README.md" ]; then
  mkdir -p "$TARGET/docs/adr"
  cat > "$TARGET/docs/adr/README.md" <<'EOF'
# ADR index

One line per ADR in `NNNN-title.md` (sequential, zero-padded; see the
`tack-adr` skill). Accepted ADRs are immutable — supersede, don't edit.

| ADR | Status | Title |
|---|---|---|
| — | — | (none yet) |
EOF
  echo "created  docs/adr/README.md"
  created=$((created + 1))
else
  echo "kept     docs/adr/README.md (already exists)"
  kept=$((kept + 1))
fi

# Home for the characterization report + consistency catalog.
if [ ! -e "$TARGET/docs/agent-ready/.gitkeep" ]; then
  mkdir -p "$TARGET/docs/agent-ready"
  touch "$TARGET/docs/agent-ready/.gitkeep"
  echo "created  docs/agent-ready/"
  created=$((created + 1))
fi

echo
echo "scaffold done: $created created, $kept kept  ->  $TARGET"
echo
echo "next steps:"
echo "  1. fill in the TODO markers in AGENTS.md, .github/workflows/agent-ready.yml,"
echo "     .pre-commit-config.yaml, scripts/check-context.sh for your stack"
echo "  2. commit the skeleton (green-first rule: constraints must pass as-is)"
echo "  3. run the tack-characterize skill: baseline + characterization tests + report"
echo "     -> docs/agent-ready/characterization-report.md"
echo "  4. run ./scripts/check-context.sh locally; fix any drift findings"
echo "  5. start tack-migrate slices; triage drift with tack-drift; record"
echo "     decisions with tack-adr; measure with tack-eval"
