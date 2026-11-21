# Phase 3 — Migrate

Goal: move code and docs toward the target consistency — and keep the
quality context accurate — without breaking anything. Migration rides on the
Phase 1 safety net and the Phase 2 constraints.

## Working model

One slice = one small commit. A slice is a single consistency move applied
to a bounded part of the code (one module, one pattern, one directory).

Per slice:

1. Pick the gap from the consistency catalog (highest value first: public
   API naming/structure, then error handling, then logging, then tests, then
   docs accuracy).
2. Make the change. Behavior-preserving only.
3. Run the **full constraint suite** (format, lint, type, tests including
   characterization tests). It must be green relative to the Phase 1
   baseline.
4. Update quality context in the **same commit** if behavior, commands,
   structure, or conventions changed.
5. Mark the catalog row done (or split it if the slice was partial).
6. Commit with a message that says what moved and why it's safe.

## Commit hygiene

- **No behavior change in a consistency commit.** If a characterization test
  fails, the slice changed behavior — revert and split the commit. The only
  legitimate test edits in this phase are to characterization tests that
  were wrong about current behavior (record why).
- **No drive-by fixes.** Tempting cleanups outside the slice go on the
  backlog, not in the commit.
- **Context in the same commit.** Docs updated separately from code is how
  drift A starts.
- **Small enough to review, big enough to matter.** If a slice can't be
  reviewed in one sitting, split it.

## Running alongside product work (no interruption, no breakage)

Migration slices are deliberately shaped so they can interleave with feature
work on the same branch:

- **Small, independent commits.** One slice = one bounded area = one commit.
  Small surface means few merge collisions with in-flight product work; when
  a collision happens, it is a trivial rebase, not a project.
- **Green per commit, not per batch.** The constraint suite (characterization
  tests + lint + type + CI + drift checks) must pass on every commit. That
  is the guarantee that a migration commit broke nothing: if it had, the
  suite would be red and the commit would not merge.
- **No freeze, no big bang.** There is no migration window and no cutover.
  Product work continues; slices land as they become green. Rollback of any
  slice is `git revert` of one commit.
- **Context rides along.** Because context is plain text in the repo, the
  same-commit update rule means a migration commit leaves docs and code in
  agreement — the next agent (or human) never inherits drift.

## Ordering heuristic

1. Public API surface and module boundaries (biggest agent impact: agents
   read entry points first).
2. Error handling and logging (agents must follow the same failure paths).
3. Test conventions (agents write tests; make the pattern obvious).
4. Naming and file layout details.
5. Docs accuracy (READMEs, docstrings) — cheap, do it continuously.

## When behavior must change

Sometimes consistency requires behavior change (e.g. renaming a public API).
That is a feature/refactor of its own, not a migration slice: plan it,
communicate it, migrate callers in their own green commits, and record an
ADR. Never bundle it into a consistency commit.

## Refresh

After each slice (or batch of slices), re-run the Phase 1 measurements and
update `docs/agent-ready/characterization-report.md` and the catalog. The
report's drift metrics (the `tack-drift` skill's `references/drift.md`)
should trend down.

## Exit criteria

- [ ] No open high-priority rows in the consistency catalog — or each one is
      an owned backlog item / ADR with a plan
- [ ] Constraint suite green on every commit
- [ ] Drift checks green in CI
- [ ] Characterization report refreshed and committed
- [ ] `AGENTS.md` still accurate (same-commit rule held)
