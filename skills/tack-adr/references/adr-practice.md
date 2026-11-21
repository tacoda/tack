# ADR practice: what earns a record, and how to keep the log honest

## What earns an ADR

An ADR records a decision that is **costly to reverse** or **expensive to
re-debate**. In a tack-managed repo that means:

- behavior changes (public API, semantics, data formats, error contracts)
- target standards and conventions (rows in the consistency catalog)
- tooling, dependency, and architecture choices
- drift-triage outcomes of "change the standard"
- security, privacy, and operational-safety decisions

It does **not** mean: routine PRs (the PR description is the record),
per-file explanations (code comments), or one-off tasks (backlog items).

Rule of thumb: if an agent six months from now could reasonably argue the
opposite and you would want them to stop and read why — write the ADR.

## Lifecycle

```
proposed  ->  accepted  ->  deprecated / superseded by ADR-MMMM
   |            |
   |            +-- decision text immutable from here
   +-- changed only via PR review
```

- **proposed**: opened in a PR together with (or just before) the change it
  describes; reviewers challenge context and alternatives here.
- **accepted**: set on merge. The decision text is now immutable.
- **superseded / deprecated**: only the status line changes, in a PR; the
  replacement ADR links back via `Supersedes` / `Superseded by`.

## Numbering and location

- `docs/adr/NNNN-short-kebab-title.md`, sequential zero-padded numbers.
  Never reuse a number.
- `AGENTS.md`'s architecture section links to `docs/adr/` (and to the few
  ADRs that define current invariants), so agents discover decisions without
  reading the whole log.
- An index (`docs/adr/README.md`) with one line per ADR — status + title —
  keeps the log scannable.

## How ADRs fit the tack workflow

- **Drift B repair** (`tack-drift`): when triage concludes the standard was
  wrong, the fix is a new ADR + updated catalog target, then migration.
- **Behavior changes in migration** (`tack-migrate`): a change that alters
  behavior is not a migration slice; it gets a proposed ADR first, then
  caller migration in green commits.
- **New tooling in constrain** (`tack-constrain`): choosing a formatter,
  linter, or test runner when the project has none is an ADR.
- **Evidence links**: ADRs link to the characterization report and catalog
  rows that motivated them, so the decision stays auditable against the
  measured reality.

## Anti-patterns

- **ADR for everything** — noise buries the decisions that matter. If a PR
  description suffices, use that.
- **Editing accepted ADRs** — rewrites history and breaks the audit trail;
  supersede instead.
- **"Use X" with no context or alternatives** — an ADR without forces and
  rejected alternatives teaches nothing; it is a changelog entry.
- **Orphaned ADRs** — not linked from `AGENTS.md` or the index; agents will
  never find them and will re-litigate the decision.
