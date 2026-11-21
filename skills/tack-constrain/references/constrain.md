# Phase 2 — Constrain

Goal: make the **current, characterized** state the contract, and make drift
visible. Nothing migrates until the constraints are in place and green.

## 1. Write the quality context

Create a root `AGENTS.md` from `templates/AGENTS.md`. It is an **index**, not
a dump: it links to single-source-of-truth (SSOT) files and keeps every fact
in exactly one home.

Create the SSOT files it points to:

- `GLOSSARY.md` — domain terms, one definition each, with the code identifier
  each term maps to.
- `docs/adr/` (or `docs/decisions/`) — one file per architectural decision,
  with status (proposed / accepted / superseded).
- Consistency catalog — the `tack-migrate` skill's
  `templates/consistency-catalog.md`, the actual-vs-target tracker measured
  in Phase 1.

Quality-context rules (details in `references/quality-context.md`):

- Every fact has **one home**; everything else links to it.
- Only **verified** commands go in `AGENTS.md` — commands you ran in Phase 1
  with their real output.
- `AGENTS.md` carries a "How to update this file" section so future editors
  (human or agent) keep it accurate without reading this skill.
- Keep it small: point to files instead of inlining them.

## 2. Wire enforcement

Put the checks from the Phase 1 baseline into pre-commit and CI:

- format check, lint, type check, unit tests — whatever the stack already
  uses, configured via its standard config file (`.editorconfig`,
  `ruff.toml`, `.eslintrc`, `gofmt`, ...).
- Add a tool only if the project has none **and** the stack has an obvious
  standard choice. Record the choice as an ADR.
- Pre-commit should run the fast checks; CI runs everything including the
  slow suite. Use the project's existing CI if it has one; otherwise add a
  minimal workflow file for the stack's standard CI.

## 3. Add drift checks

Drift checks are CI jobs (or a script run by CI) that fail when docs and code
disagree. See the `tack-drift` skill's `references/drift.md` for the taxonomy
and playbook. Minimum set:

1. **Path check** — every file path mentioned in `AGENTS.md` / README exists.
2. **Command check** — every command block in `AGENTS.md` runs (or is marked
   `unverifiable here` with a reason).
3. **Example check** — code examples in docs still compile / pass.
4. **Term check** — every `GLOSSARY.md` term maps to an identifier that still
   exists in the code.

Implement them as a small script in the repo (e.g. `scripts/check-context.sh`
or the stack's equivalent) so any agent or human can run the same check
locally: `./scripts/check-context.sh`.

## 4. The green-first rule

Constraints must be **green on the unmodified repo** before any tightening:

1. Commit context files + enforcement config + drift checks.
2. Run the full constraint suite. It must pass, treating Phase 1 known
   failures as the accepted baseline (e.g. via an explicit allowlist file
   that names each known failure — never a blanket skip).
3. Only then start tightening, one rule at a time, in Phase 3.

If the suite cannot be green because a check is wrong, fix the check. A
constraint that cries wolf on day one will be ignored by day two.

## Exit criteria

- [ ] `AGENTS.md` + SSOT docs committed and accurate
- [ ] Pre-commit + CI run format/lint/type/test and are green (baseline-aware)
- [ ] `scripts/check-context.sh` (or equivalent) exists and passes
- [ ] Known failures are explicitly allowlisted, not silently skipped
