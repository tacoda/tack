---
name: tack-constrain
description: Phase 2 of tack — make the characterized current state the contract, and make drift visible. Write the quality context (root AGENTS.md plus single-source GLOSSARY.md, ADR directory, consistency catalog) including a how-to-update section, wire format/lint/type/test into pre-commit and CI, and add docs-vs-code drift checks via scripts/check-context.sh. Constraints must be green on the untouched repo before any tightening. Load when setting up AGENTS.md, coding standards, or CI guardrails for agent work on a repo.
license: MIT
metadata:
  author: tacoda
  version: "1.0.0"
---

# tack-constrain: quality context + enforcement + drift checks

The quality context is what an agent reads to do work that meets this
project's bar. It must be accurate *and* easy to keep accurate.

## Procedure

0. **Scaffold (optional but recommended)**: run this skill's
   `scripts/scaffold.sh [target-dir]` to drop all template files into the
   repo at once — `AGENTS.md`, `GLOSSARY.md`, `scripts/check-context.sh`,
   `.github/workflows/agent-ready.yml`, `.pre-commit-config.yaml`,
   `docs/adr/` — without overwriting anything that exists.
1. **Write root `AGENTS.md`** from `templates/AGENTS.md`: overview, verified
   commands (only ones you actually ran, with real output), architecture map
   as pointers, conventions pointer, glossary pointer, quality bar, and a
   "How to update this file" section.
2. **Create the SSOT files it points to**: `GLOSSARY.md` (template:
   `templates/GLOSSARY.md` — each term mapped to a code identifier),
   `docs/adr/` (one file per decision, with status — see `tack-adr`), and
   the consistency catalog (see `tack-migrate`). One home per fact; link,
   don't copy.
3. **Wire enforcement** into pre-commit and CI: format, lint, type check,
   tests — the tooling the project already uses, in its standard config.
   Copy-paste starters: `templates/pre-commit-config.yaml` and
   `templates/ci-agent-ready.yml`. Add a tool only if the stack has an
   obvious standard choice; record the choice as an ADR.
4. **Add drift checks**: install `templates/check-context.sh` as
   `scripts/check-context.sh` and run it in CI. Minimum set: referenced paths
   exist, AGENTS.md command blocks run, doc examples compile, glossary terms
   match code identifiers (taxonomy and repair playbook: `tack-drift`).
5. **Green-first rule**: constraints encode *current* behavior and must pass
   on the unmodified repo, with Phase 1 known failures explicitly allowlisted
   (named, never blanket-skipped). Then tighten in Phase 3.

Details: `references/constrain.md` (procedure), `references/quality-context.md`
(what belongs in context and the same-commit update rule).

## Exit criteria

- [ ] `AGENTS.md` + SSOT docs committed and accurate
- [ ] Pre-commit + CI run format/lint/type/test, green (baseline-aware)
- [ ] `scripts/check-context.sh` passes locally and in CI
- [ ] Known failures explicitly allowlisted
