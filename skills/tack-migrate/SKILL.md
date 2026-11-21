---
name: tack-migrate
description: Phase 3 of tack — migrate code and docs toward the target consistency in small commits, each green against the full constraint suite (characterization tests + lint + type + CI). One behavior-preserving slice per commit; update quality context in the same commit; triage drift findings (fix code, fix docs, or ADR). Load when refactoring legacy code toward the conventions catalog, or modernizing a codebase incrementally with agents.
license: MIT
metadata:
  author: tacoda
  version: "1.0.0"
---

# tack-migrate: move code and docs into consistency, safely

Migration rides on the Phase 1 safety net (characterization tests) and the
Phase 2 constraints (pre-commit/CI/drift checks). Every commit proves the
change was behavior-preserving: the suite stays green relative to the
recorded baseline.

## Working model

One slice = one small commit = one consistency move applied to a bounded part
of the code.

Per slice:

1. Pick the highest-value gap from `templates/consistency-catalog.md`
   (order: public API surface and module boundaries, error handling, logging,
   test conventions, naming/layout details, docs accuracy).
2. Make the change. Behavior-preserving only.
3. Run the full constraint suite. Green required.
4. If a characterization test fails, the slice changed behavior — revert and
   split the commit. Never edit a test to make a consistency commit pass.
5. Update quality context (AGENTS.md / glossary / catalog) in the **same
   commit** if behavior, commands, structure, or conventions changed.
6. Mark the catalog row done (or split it), refresh the characterization
   report, commit.

Never bundle a behavior change into a consistency commit — that gets its own
planned change with an ADR and caller migration.

Details: `references/migrate.md`.

## Exit criteria

- [ ] No open high-priority catalog rows — or each is an owned backlog item / ADR
- [ ] Constraint suite green on every commit
- [ ] Drift checks green in CI
- [ ] Characterization report refreshed; `AGENTS.md` still accurate
