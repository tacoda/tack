# Characterization Report

> Living document. Created by `tack-characterize`, refreshed by
> `tack-migrate` after every slice and at least once per release.
> Suggested committed path: `docs/agent-ready/characterization-report.md`.

## Stack

- Language(s) / runtime versions:
- Build tool / package manager:
- Frameworks:
- Entry points:

## Layout

```
(top-level tree with one-line purpose per directory)
```

- Source: …
- Tests: …
- Config: …
- Docs: …
- Scripts: …

## Baseline (recorded YYYY-MM-DD)

| Command | Result (exit code / summary) | Notes |
|---|---|---|
| install | | |
| build | | |
| lint | | |
| format check | | |
| type check | | |
| test | | |

Known failures (record verbatim; allowlisted in Phase 2, never fixed during
characterize):

1.

Unverifiable in this environment (and why):

1.

## Existing agent context

| File | Status (current / stale / missing) | Notes |
|---|---|---|
| `AGENTS.md` | | |
| `CLAUDE.md` / `.cursorrules` / `.github/copilot-instructions.md` | | |
| `docs/` | | |

## Measured conventions (actual — evidence: `file:line`, counts)

Filled from code measurements, not doc claims. Land in the consistency
catalog (`tack-migrate`'s `templates/consistency-catalog.md`, "actual" column):

- Naming:
- Module structure:
- Error handling:
- Logging:
- Tests:
- Docs/comments:

## Risks / hotspots

- Most-imported modules (dependency anchors):
- Areas with no test coverage:
- Known-failure clusters:

## Drift metrics

- Open drift A findings (stale context): n
- Open drift B findings (off-standard code): n

(Trend must go down across migration slices — see `tack-drift`.)
