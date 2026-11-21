---
name: tack-characterize
description: Phase 1 of tack — pin the current behavior of a brownfield codebase before any agent changes it. Inventory stack and layout, record an exact build/lint/test baseline (failures become known failures, not fixes), write characterization tests that pass on the unmodified code, and measure the conventions the code actually follows into a committed report. Load before any refactor or migration of untested legacy code, or when asked to characterize a repo.
license: MIT
metadata:
  author: tacoda
  version: "1.0.0"
---

# tack-characterize: map the project as it is

Characterization is what makes agent work on brownfield *provable*: after
this phase, any behavior change an agent makes is detectable, because current
behavior is pinned by tests and the baseline is recorded.

## Procedure

1. **Inventory** — stack (lockfiles, manifests), layout, entry points,
   dependency hotspots, existing agent context files (`AGENTS.md`,
   `CLAUDE.md`, `.cursorrules`, `.github/copilot-instructions.md`, `docs/`)
   with staleness notes.
2. **Baseline** — run install/build/lint/type-check/test; record exact
   command + result. Failures are **known failures**: record verbatim, do not
   fix yet. Mark anything not runnable here as `unverifiable here` + reason.
3. **Characterization tests** — where tests are missing or thin, pin observed
   behavior: pure functions by input->output, side effects via doubles /
   approval files, entry points via smoke tests. They must **pass on the
   unmodified code**; a failing one is a bug in the test.
4. **Measure actual conventions** — count patterns in the code (naming case
   per layer, files per dir, error-handling style, logger setup, test
   framework and file naming, comment density). Record each finding with
   evidence (`file:line`, count) in the consistency catalog (see the
   `tack-migrate` skill's `templates/consistency-catalog.md`, column "actual").
5. **Write the report** — commit `templates/characterization-report.md`
   (suggested path `docs/agent-ready/characterization-report.md`).

Full details and measurement techniques: `references/characterize.md`.

## Exit criteria

- [ ] Report committed: stack, layout, baseline, known failures, context inventory
- [ ] Characterization tests exist and pass on unmodified code
- [ ] Catalog "actual" column filled from measurements, not doc claims
- [ ] Baseline results recorded so Phase 3 can prove "still green"
