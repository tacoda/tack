# Characterization recipes — Python

Goal: pin current behavior fast with pytest, before any migration slice.

## Snapshots / approvals

- Golden files: compare output to `testdata/*.golden`; regenerate with
  `UPDATE_GOLDEN=1 pytest`. Commit the goldens — they are the pinned behavior.
- Or use `syrupy` (snapshot extension): `assert result == snapshot`.
- Keep goldens small; generate them from observed runs of the *unmodified*
  code, then eyeball-diff once before trusting.

## Seams and fakes

- Time: `time-machine` or `freezegun` (`freeze_time`); store all timestamps in UTC.
- HTTP: `responses` or `vcrpy` (record once, replay in tests).
- Randomness: seed (`random.seed(0)`) or inject a `Random` instance.
- IO/env: `monkeypatch` + `tmp_path`; never touch the real FS or env in tests.
- DB: run against a real throwaway DB (docker/testcontainers) or an in-memory
  sqlite; snapshot query results, not connections.

## Gotchas

- Sort before snapshotting anything built from `set` or multi-key dicts of
  unorderable data.
- Floats and UUIDs: round/normalize in the snapshot serializer.
- Timezone/locale: pin `TZ=UTC` in CI; golden files must not embed local time.
- Third-party call order: pin with `responses` ordering or a call log.

## Baseline commands

```
python -m venv .venv && . .venv/bin/activate   # or uv / poetry
pip install -e .[dev]                           # or uv sync
pytest -q                                       # record pass/fail as the baseline
```
