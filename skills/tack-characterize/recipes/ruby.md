# Characterization recipes — Ruby

Goal: pin current behavior fast with RSpec, before any migration slice.

## Approvals / goldens

- Golden files: compare to `spec/fixtures/golden/*.txt`; regenerate with
  `UPDATE_GOLDEN=1 bundle exec rspec`.
- Or the `approvals` gem: `verify { result }` — approve with a diff tool.
- Commit the goldens; they are the pinned behavior.

## Seams and fakes

- Time: `Timecop` or `ActiveSupport::Testing::TimeHelpers#travel_to`.
- HTTP: WebMock (stub) or VCR (record/replay cassettes in `spec/cassettes/`).
- Randomness: `srand(0)` in a `before` hook, or inject a `Random`.
- DB: real DB in CI (docker-compose) or transactional tests; snapshot query
  results.

## Gotchas

- Hashes are insertion-ordered in Ruby — fine, but pin fixture order when
  output depends on it.
- Timezone: `ENV['TZ'] = 'UTC'` in `spec_helper`; goldens must not embed
  local time.
- `puts`/logging output: capture `$stdout` or assert on log files in tmp.
- Gem/platform differences: record `Gemfile.lock`; goldens must not embed
  absolute paths (normalize with `gsub(Dir.pwd, '.')`).

## Baseline commands

```
bundle install
bundle exec rubocop            # if configured
bundle exec rspec              # record pass/fail as the baseline
```
