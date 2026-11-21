#!/usr/bin/env bash
# check-context.sh — drift checks: fail when quality context and code disagree.
# Installed by tack-constrain as scripts/check-context.sh; run locally and in CI.
# Exit 0 = no drift; exit 1 = findings printed (one DRIFT: line each).
#
# Checks: (1) paths referenced in AGENTS.md/README exist
#         (2) every GLOSSARY.md term maps to an identifier present in code
#         (3) TODO project-specific: run each command block from AGENTS.md
#         (4) TODO project-specific: compile/run code examples in docs
set -u
cd "$(dirname "$0")/.."

findings=0
bad() { printf 'DRIFT: %s\n' "$*"; findings=$((findings + 1)); }

# --- 1. Path check -----------------------------------------------------------
for doc in AGENTS.md README.md; do
  [ -f "$doc" ] || continue
  refs=$(grep -oE '`[^`]+\.(md|sh|bash|yml|yaml|toml|json|cfg|ini|py|js|ts|go|rb|rs|java|kt|swift|c|h|hpp)`' "$doc" \
         | tr -d '`' | sort -u)
  for p in $refs; do
    [ -e "$p" ] || bad "$doc references missing path: $p"
  done
done

# --- 2. Term check -----------------------------------------------------------
if [ -f GLOSSARY.md ]; then
  terms=$(grep -oE '`[A-Za-z_][A-Za-z0-9_]*`' GLOSSARY.md | tr -d '`' | sort -u)
  for id in $terms; do
    if ! grep -rqE "(class|def|func|function|module|struct|interface|type|enum|trait|const|let|var|fn|sub|impl)[[:space:]]+$id([^A-Za-z0-9_]|$)|(^|[^A-Za-z0-9_])$id[[:space:]]*[:=]" \
         --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=.venv . 2>/dev/null; then
      bad "GLOSSARY.md term has no matching identifier in code: $id"
    fi
  done
fi

# --- 3. Command check (project-specific TODOs) -------------------------------
# Run each command block from AGENTS.md and compare exit codes, e.g.:
#   if ! npm run build --if-present >/dev/null 2>&1; then
#     bad "AGENTS.md command fails: npm run build"
#   fi

# --- 4. Example check (project-specific TODOs) -------------------------------
# Compile or run the code examples embedded in docs.

if [ "$findings" -eq 0 ]; then
  echo "context OK: no drift findings"
else
  echo "context drift found: $findings finding(s)"
fi
exit "$([ "$findings" -eq 0 ] && echo 0 || echo 1)"
