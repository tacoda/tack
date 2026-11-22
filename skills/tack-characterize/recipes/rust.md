# Characterization recipes — Rust

Goal: pin current behavior fast with `cargo test`, before any migration slice.

## Snapshots

- `insta` crate: `assert_snapshot!(output)` — snapshots in `snapshots/`;
  regenerate from unmodified code with `INSTA_UPDATE=always cargo test`,
  review with `cargo insta review`, commit.
- Or golden files manually: `std::fs::read_to_string("tests/golden/x.txt")`
  with an env-var-gated update path.

## Seams and fakes

- Define traits at boundaries (`trait Clock`, `trait HttpClient`); fake with
  hand-written mocks or `mockall`.
- HTTP: `wiremock`.
- Time: `chrono::DateTime` behind a `Clock` trait; `tokio::time::pause()` for
  async time in `#[tokio::test(start_paused = true)]`.
- Randomness: inject `rand::rngs::StdRng::seed_from_u64(0)`.
- FS: `tempfile::tempdir()`.

## Gotchas

- `HashMap` iteration order is random: use `BTreeMap` or sort keys before
  snapshotting.
- Async: drive the runtime deterministically (paused time, `LocalSet`); never
  `sleep`.
- Error chains (`anyhow`/`eyre`): snapshot the `Display`, not the backtrace.

## Baseline commands

```
cargo build
cargo clippy -- -D warnings   # if configured
cargo test                    # record pass/fail as the baseline
```
