# Migration patterns: change behavior without breaking anything

For the changes that migration surfaces but must not bundle into a
consistency slice (see "When behavior must change" in `migrate.md`). Every
pattern shares two rules: **each step is green** against the constraint
suite, and **each step is revertable** (one commit, or one flag flip).

## Branch by abstraction

1. Introduce an abstraction seam at the boundary you will change.
2. Migrate callers to the seam (green commits).
3. Implement the new behavior behind the seam.
4. Remove the old implementation and the seam if it has no remaining callers.

## Strangler fig

Route traffic around the legacy component piece by piece — new paths go to
the new implementation, old paths keep working — until nothing calls the
legacy code and it can be deleted. Each routing change is one green commit.

## Parallel run

Run old and new implementations side by side on the same inputs; compare
outputs (characterization tests are the comparator). Divergences are either
bugs or intended changes (ADR). Cut over when divergence is fully explained.

## Expand–migrate–contract (data)

1. **Expand**: add the new schema/field alongside the old; write both.
2. **Migrate**: backfill existing rows/records in small batches.
3. **Contract**: remove the old schema/field once nothing reads it.

## Feature flags

Ship the new path disabled, enable per cohort, keep a one-flag revert. The
flag is removed in its own green commit once the new path is proven — flags
are scaffolding, not ADR material.

## Choosing

- Small, local behavior change → branch by abstraction.
- Whole component replacement → strangler fig.
- Output must be provably identical → parallel run.
- Schema/data change → expand–migrate–contract.
- Risky user-facing change → feature flag behind a parallel run.

All of them: propose the ADR first (`tack-adr`), keep every step green, and
update the quality context in the same commit as each step.
