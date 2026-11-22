# Characterization recipes — JavaScript / TypeScript

Goal: pin current behavior fast with vitest or jest, before any migration slice.

## Snapshots / approvals

- `expect(x).toMatchSnapshot()` (vitest/jest) — stored in `__snapshots__/`,
  committed; regenerate with `vitest -u` only from unmodified code.
- Inline snapshots for tiny outputs; file snapshots for big ones.
- Prefer explicit assertions for behavior you *understand*; snapshots for
  behavior you are pinning *as-is*.

## Seams and fakes

- Time: `vi.useFakeTimers()` + `vi.setSystemTime(...)` (vitest), or
  `jest.useFakeTimers()` with `jest.setSystemTime`.
- HTTP: `msw` (node) — record real responses once, replay in tests.
- Randomness: seed (`faker.seed(123)`, `chance.seed`) or inject.
- FS: `memfs` (`vi.mock('node:fs')`).
- Env: set `process.env` in `beforeEach`, restore in `afterEach`.

## Gotchas

- Async ordering: await everything; never snapshot floating promises.
- Map/Set iteration order is insertion order in JS — fine, but pin insertion
  in fixtures if output depends on it.
- Serializer: add a snapshot serializer for Dates/URLs so goldens are stable
  across machines/timezones (store UTC).
- Deterministic test order: `vitest --sequence.shuffle` off; seed if shuffled.

## Baseline commands

```
npm ci            # or pnpm install --frozen-lockfile / yarn --frozen-lockfile
npm run lint
npx tsc --noEmit  # if typed
npm test          # record pass/fail as the baseline
```
