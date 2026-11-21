# Drift: taxonomy, detection, repair

The text files in a repo are supposed to represent the **truth** — about the
business (decisions, domain, requirements) and about the code (commands,
conventions, architecture). Drift is any disagreement that means a text file
no longer does. Agent-ready projects detect drift automatically and repair it
deliberately, so the text keeps representing the truth.

## The two directions of drift

```
code  <---- drift A: code moved, context didn't ---->  quality context
code  <---- drift B: standard set, code hasn't caught up ->  standards
```

- **Drift A — context is stale (code -> context).** The code changed; docs,
  glossary, or `AGENTS.md` still describe the old behavior. This is the
  classic "docs rot": the most dangerous kind, because agents trust the docs.
- **Drift B — code is off-standard (context -> code).** The standard exists
  but the code doesn't conform yet. This is the *migration backlog*: expected
  during Phase 3, tracked in the consistency catalog, and shrinking.

Both directions matter. A is repaired by updating context (or reverting the
code if the change was accidental). B is repaired by migrating code (or by an
ADR if the standard was wrong).

## Detection

Automated, in CI, via `scripts/check-context.sh` (or the stack equivalent):

| Check | Catches | Method |
|---|---|---|
| Path check | drift A | every path referenced in `AGENTS.md`/README exists |
| Command check | drift A | every command block in `AGENTS.md` executes successfully |
| Example check | drift A | doc code examples compile / tests pass |
| Term check | drift A | every `GLOSSARY.md` term maps to an existing identifier |
| Catalog check | drift B | consistency catalog rows marked "done" are actually uniform in code (spot-check via pattern counts) |
| Characterization diff | both | re-run Phase 1 measurements; diff against the committed report |

Manual cadence: re-run the full characterization (Phase 1) after each
migration slice and at least once per release, and refresh the report.

## Repair playbook

For every drift finding, choose exactly one:

1. **Fix the code** — the code is wrong relative to the standard.
   Migrate a slice (Phase 3); keep the constraint suite green.
2. **Fix the context** — the context is stale. Update the SSOT file in the
   same commit as the code change that caused it (or immediately, if the
   change already landed).
3. **Change the standard** — both are wrong. Record an ADR (the `tack-adr`
   skill's `templates/adr.md`) superseding the old decision, update the
   catalog target, then migrate.

Rules:

- **No silent drift.** Every finding becomes a catalog row, a backlog item,
  or an ADR — never just a comment that ages out.
- **Never "fix" drift by deleting the check.** If a drift check is noisy,
  fix the check or the doc; removing the check is itself an ADR-worthy
  decision.
- **Triage in the PR.** Drift found by CI is resolved before merge, in the
  same PR that introduced or exposed it.

## Metrics

Track in the characterization report: number of open drift findings (A and B
separately) per slice. The trend should be down. A rising A-count means the
same-commit update rule isn't being followed — address the process, not just
the findings.
