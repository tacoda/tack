---
name: tack
description: tack — the stuff that must be in order before your agent harness can run. Make a brownfield project agent-ready via a characterize -> constrain -> migrate workflow — pin current behavior with characterization tests, write quality context (root AGENTS.md plus single-source docs) and enforce it with pre-commit/CI/drift checks, then migrate code and docs into consistency in small verified steps. Load when the user wants to onboard an agent onto a legacy repo, set up AGENTS.md and coding standards, or make agent-driven changes to untested code. Companion skills in this distribution — tack-characterize, tack-constrain, tack-migrate, tack-drift.
license: MIT
metadata:
  author: tacoda
  version: "1.0.0"
---

# tack: make a project agent-ready

Agents are good at brownfield work when the repo gives them good patterns and
every change is mechanically verified — proof, not trust. An **agent-ready**
project has three things:

1. **Quality context** — machine-readable docs that tell the agent how this
   project wants work done (verified commands, architecture, conventions,
   glossary). Easy to update: one home per fact, updated in the same commit as
   the change it describes.
2. **Consistent code** — conventions applied uniformly and enforced by
   tooling, so agent-written edits blend in.
3. **No drift on either side** — docs match code, code matches the stated
   standards; drift is detected by CI and repaired deliberately.

tack gets a repo there with legacy-modernization discipline:

```
characterize  ->  constrain  ->  migrate
  (pin it)       (contract)      (move it, safely)
```

## Storage principle: plain text in the repo

All quality context lives as **plain-text Markdown committed in the repo** —
`AGENTS.md`, `GLOSSARY.md`, `docs/adr/`, `docs/agent-ready/` (report +
catalog). Nothing lives in an external system, a wiki, or someone's head.
These text files are the **source of truth** — for business decisions and
domain information as much as for code reality — and they are continually
updated (same-commit rule) so they keep representing the truth. **Drift**
(`tack-drift`) is the measure of where they stop. That is what lets
migrations run *alongside* product work instead of blocking it: a migration
slice is an ordinary commit — versioned, diffable, reviewable like any
other — and it cannot silently break anything, because characterization
tests + lint + CI + drift checks must stay green on every single commit.

## Incremental by design

tack is not a big-bang project. One person can run it alone, a team can apply
it a little at a time, or it can be one focused effort — same workflow, same
safety rules. Every phase stands alone and delivers value:

- **characterize alone** → a truthful map of the repo + a safety net
  (characterization tests) that makes any later agent change provable
- **constrain alone** → agents can onboard safely; drift becomes visible in CI
- **each migrate slice** → one more area consistent, shipped green on its own

And value keeps improving with every *new* change, not just during the
bootstrap: context is updated in the same commit as the change and drift
checks run on every PR, so each product change leaves the repo slightly more
agent-ready than before.

## The distribution

This skill is the orchestrator. The full procedures and templates live in the
companion skills of this same distribution (`npx skills add tacoda/tack`
installs all of them):

| Skill | Phase | Use it for |
|---|---|---|
| `tack-characterize` | 1 | baseline, characterization tests, measured conventions |
| `tack-constrain` | 2 | `AGENTS.md` quality context, pre-commit/CI, drift checks |
| `tack-migrate` | 3 | consistency migration in small green commits |
| `tack-drift` | anytime | audit and repair code<->context drift, both directions |
| `tack-adr` | anytime | record decisions as committed text — ADRs agents must not re-litigate |

## Phase 0 — Triage

- Stack and layout? (`package.json`, `go.mod`, `pyproject.toml`, `Gemfile`, ...)
- Existing agent context? (`AGENTS.md`, `CLAUDE.md`, `.cursorrules`, `.github/copilot-instructions.md`, `docs/`)
- Do build / lint / test commands pass today? Record exact results.
- Which agents is the context for?

## Phase 1 — Characterize (load `tack-characterize`)

Map the project **as it is**: inventory, exact baseline (failures recorded as
known failures, not fixed), characterization tests that pin current behavior
and pass on unmodified code, and conventions measured from the code with
evidence. Output: a committed characterization report.

Exit: report committed; safety-net tests pass; baseline recorded.

## Phase 2 — Constrain (load `tack-constrain`)

Make the current state the contract and make drift visible: root `AGENTS.md`
+ SSOT docs (`GLOSSARY.md`, ADRs, consistency catalog) with a how-to-update
section; format/lint/type/test wired into pre-commit and CI; drift checks
(`scripts/check-context.sh`) that fail when docs and code disagree.

Golden rule: constraints encode **current** behavior and are green on the
untouched repo first. Only then tighten.

Exit: context committed; CI green including drift checks.

## Phase 3 — Migrate (load `tack-migrate`)

Move code and docs toward target consistency one slice per small commit, each
green against the full constraint suite. Behavior-preserving only — if a
characterization test fails, the commit changed behavior; split it. Quality
context is updated in the **same commit** as any behavior/convention change.
Drift findings are triaged (fix code, fix docs, or ADR — see `tack-drift`).

Exit: no open high-priority catalog gaps (or each is an owned backlog
item/ADR); CI and drift checks green.

## Keeping it agent-ready (load `tack-drift` for audits)

- **Update rule**: any commit that changes behavior, commands, structure, or
  conventions updates the quality context in the same commit.
- **Drift watch**: drift checks run in CI on every PR; findings triaged in
  that PR.
- **Context budget**: `AGENTS.md` stays an index — point to files, don't
  inline them.

## Definition of done (agent-ready)

- [ ] Root `AGENTS.md` exists, is accurate, and says how to update it
- [ ] SSOT docs exist (glossary, ADRs, consistency catalog) — one home per fact
- [ ] Build / lint / type / test run in CI and pre-commit and are green
- [ ] Characterization tests pin current behavior
- [ ] Drift checks (docs <-> code) run in CI and are green
- [ ] Characterization report committed and current
