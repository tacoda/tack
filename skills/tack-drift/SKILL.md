---
name: tack-drift
description: Audit and repair drift between code and quality context in both directions — stale context (code moved, docs didn't) and off-standard code (standard set, code hasn't caught up). Run the check-context.sh checks, triage every finding as fix-code, fix-docs, or ADR, and keep the drift count trending down. Load when asked whether docs/context are still accurate, before releases, in CI on every PR, or anytime as part of the tack workflow.
license: MIT
metadata:
  author: tacoda
  version: "1.0.0"
---

# tack-drift: no silent disagreement between code and context

Drift has two directions:

```
code  <-- drift A: code moved, context stale ---->  quality context
drift B: standard set, code not yet conformant  ---->  (migration backlog)
```

- **Drift A (stale context)** is the dangerous one: agents trust the docs.
  Repair by updating the SSOT context — ideally in the same commit as the
  code change that caused it.
- **Drift B (off-standard code)** is the migration backlog from
  `tack-migrate`; repair by migrating a slice, or by an ADR if the standard
  was wrong.

## Procedure

1. Run `scripts/check-context.sh` (created by `tack-constrain`): path check,
   command check, example check, term check, catalog spot-checks.
2. For every finding, choose exactly one: **fix the code**, **fix the
   context**, or **change the standard via ADR**. Record the choice in the
   consistency catalog / report. No silent drift; never delete a check to
   make it pass.
3. Re-run characterization measurements and diff against the committed report;
   update drift metrics (open A-findings, open B-findings) — the trend must
   go down.
4. Triage drift found by CI in the same PR that exposed it.

Full taxonomy, check ideas, and playbook: `references/drift.md`.

## Exit criteria

- [ ] `scripts/check-context.sh` green (or every finding triaged with an owner)
- [ ] Each finding resolved as fix-code / fix-docs / ADR, recorded
- [ ] Drift metrics updated in the characterization report
