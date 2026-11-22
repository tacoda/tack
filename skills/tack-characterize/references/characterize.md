# Phase 1 — Characterize

Goal: a truthful, measured map of the project **as it is**, not as its docs
claim it is. Characterization is the foundation: everything in constrain and
migrate is judged against this report.

## 1. Inventory

Detect and record:

- **Stack**: language(s), runtime versions, build tool, package manager,
  framework(s). Look for `package.json`, `go.mod`, `pyproject.toml`,
  `Gemfile`, `pom.xml`, `Cargo.toml`, `build.gradle`, `composer.json`, ...
- **Layout**: top-level directories, where source / tests / config / docs /
  scripts live, entry points (`main`, `cmd/`, `app/`, `src/index.*`, ...).
- **Dependency hotspots**: the most-imported modules; these anchor the
  architecture map later.
- **Existing agent context**: `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`,
  `.cursorrules`, `.windsurfrules`, `.github/copilot-instructions.md`,
  `docs/`. Note what exists, what is stale, what is missing.

## 2. Baseline

Run, in order, and record the exact command + result (exit code, summary line):

1. install/dependency resolution (only if needed and safe)
2. build
3. lint / format check
4. type check
5. full test suite

Rules:

- Failures are **known failures**. Record them verbatim; do not fix them in
  this phase. Fixing now would mix "what is" with "what should be".
- If a command cannot run in the current environment (missing service,
  credentials), record it as `unverifiable here` and say what is needed.
- The baseline is the reference point for Phase 3: "still green" means green
  *relative to this baseline*, including the known failures.

## 3. Characterization tests (the safety net)

Per-language recipes (snapshot/approval tooling, seams, fakes, gotchas) live
in `../recipes/` — pick the one for the repo's stack:
`python.md`, `javascript-typescript.md`, `go.md`, `ruby.md`, `jvm.md`,
`rust.md`.

Legacy code often lacks tests. Before migrating anything, pin current
behavior:

- For pure functions: record observed outputs for representative inputs.
- For modules with side effects: pin the observable effects (files written,
  messages sent, DB rows, HTTP calls) via test doubles / approval files.
- For end-to-end behavior: smoke tests against the real entry points.
- Name them clearly, e.g. `characterization/` or `*_characterization_test.*`,
  so Phase 3 can distinguish "behavior changed!" from "constraint tightened".

These tests must **pass on the unmodified code**. A characterization test that
fails on unmodified code is a bug in the test — fix the test, not the code.

## 4. Measure actual conventions

Catalog what the code *actually does*, with counts as evidence. Typical axes:

| Axis | How to measure |
|---|---|
| Naming | sample identifiers per layer; count snake_case vs camelCase vs PascalCase |
| Module structure | files per directory, max depth, co-location of tests |
| Error handling | count of `raise`/`throw`/`Result`/`except`/error returns; central vs local handling |
| Logging | logger setup locations, format strings, levels used |
| Testing | framework, test-to-src ratio, fixture style, naming of test files |
| Docs | docstring/comment density, README structure, ADRs present? |

Record each finding as: `area — observed convention — evidence (file:line, count)`
in the consistency catalog (the `tack-migrate` skill's
`templates/consistency-catalog.md`, column "actual").

## 5. Write the report

Fill in `templates/characterization-report.md` and commit it (suggested path:
`docs/agent-ready/characterization-report.md`). The report is a living
document: Phase 3 refreshes it after each slice.

## Exit criteria

- [ ] Report committed with stack, layout, baseline results, known failures
- [ ] Characterization tests exist and pass on unmodified code
- [ ] Consistency catalog has an "actual" column filled from measurements
- [ ] Existing context files inventoried with staleness notes
