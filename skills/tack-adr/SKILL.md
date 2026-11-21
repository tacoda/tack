---
name: tack-adr
description: Record Architecture Decision Records as durable, text-in-repo decisions that agents must not re-litigate. Use the ADR template for any decision that changes behavior, conventions, architecture, or standards — including drift triage that changes the standard and behavior changes found during migration. Lifecycle proposed -> accepted -> superseded; accepted ADRs are immutable and get superseded by a new linked ADR. Load when recording a decision, resolving drift by changing the standard, or setting up docs/adr/ in a repo. Part of the tack distribution.
license: MIT
metadata:
  author: tacoda
  version: "1.0.0"
---

# tack-adr: decisions as committed text

ADRs are where "we decided this, and here is why" lives: plain Markdown in
`docs/adr/`, versioned with the code, linked from `AGENTS.md`. In the tack
workflow they are the resolution tool for **drift B** ("the standard was
wrong — change it") and a required artifact for any **behavior change** found
during migration. If it isn't in an ADR, the next agent will re-litigate it.

## When to write an ADR

- A change in observable behavior (public API, semantics, data formats)
- A new target standard or convention (consistency catalog row)
- A tooling, dependency, or architecture choice
- A drift-triage outcome of "change the standard"
- Anything you do not want re-debated in six months

Not for: routine PRs, per-file explanations (those are code comments), or
one-off tasks. Details: `references/adr-practice.md`.

## How to write one

1. Take the next number `NNNN` (zero-padded, sequential) and create
   `docs/adr/NNNN-short-title.md` from `templates/adr.md`.
2. Fill in context (the forces and evidence — link the characterization
   report, catalog row, or drift finding that motivated it), the decision in
   one or two imperative sentences, consequences, and alternatives considered
   with rejection reasons.
3. Status starts as `proposed`; it is reviewed in the PR like code and
   becomes `accepted` on merge.
4. **Accepted ADRs are immutable.** To reverse or change one, write a new
   ADR that supersedes it and link both ways (`Supersedes` / `Superseded
   by`). Only the status field changes in place.
5. Link the ADR from the `AGENTS.md` architecture section so agents
   discover it.

## Exit criteria

- [ ] `docs/adr/` exists with the numbering convention
- [ ] `AGENTS.md` architecture section links to it
- [ ] Open decisions live in proposed ADRs, not in chat threads or PR comments
