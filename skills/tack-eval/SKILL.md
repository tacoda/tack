---
name: tack-eval
description: Prove the repo's committed context actually makes agents effective — run canary tasks that a fresh agent must complete using only the text files (AGENTS.md, docs, ADRs), measure pass/fail, and feed every failure back into the context in the same PR. Load when you want evidence a brownfield repo is agent-ready, want to measure whether context quality improves over time, or want CI to catch when the text stops representing the truth. Part of the tack distribution.
license: MIT
metadata:
  author: tacoda
  version: "1.0.0"
---

# tack-eval: prove the context works

"Agent-ready" should be measured, not asserted. A **canary task** is a small,
realistic, verifiable piece of work an agent must complete using *only* the
committed text — no oral context. If agents pass the canaries, the text
represents the truth well enough to work from; if they fail, the failure
points at exactly which file is stale or missing.

## Procedure

1. Pick canaries from `templates/canary-tasks.md` — small, realistic, and
   mechanically checkable (commands to run, tests that must pass, files that
   must exist with expected properties).
2. Run each canary with a fresh agent that sees only the repo (plus its
   normal harness). Record pass/fail + where it got stuck.
3. Every failure is a context gap: fix the SSOT text file in the same PR
   (same-commit rule), not the agent's memory.
4. Re-run the failed canaries until green.
5. Track the score (passed/total) in the characterization report
   (`docs/agent-ready/characterization-report.md`) — it should trend up.
   Optionally run a canary subset in CI on a schedule or on changes to
   `AGENTS.md`/docs.

Details: `references/eval-practice.md`. Canary template:
`templates/canary-tasks.md`.

## Exit criteria

- [ ] A canary set exists and is run on demand (and ideally in CI)
- [ ] Current score recorded in the characterization report
- [ ] Every known failure has a same-PR context fix or an owned backlog item
