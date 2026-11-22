# Agent-readiness evals: practice guide

## What a good canary looks like

- **Small** — completable in minutes, not hours.
- **Realistic** — the kind of task the team actually does (add a field,
  fix a bug, add an endpoint, rename a thing following conventions).
- **Verifiable** — pass/fail is mechanical: a test command, a diff property,
  a file that must exist. No vibes.
- **Context-dependent** — it must require the committed text to succeed
  (commands from `AGENTS.md`, conventions from the catalog, domain terms
  from `GLOSSARY.md`, decisions from ADRs). A task any agent can do from
  the code alone proves nothing about the context.

## Running canaries

- **Fresh agent, repo only.** No chat history, no oral briefing. The repo
  text is the entire brief.
- **Record the transcript summary**: pass/fail, the first file the agent
  could not find or trust, any command that failed, any convention it
  guessed wrong.
- **Failure = context gap.** Fix the SSOT file in the same PR. Never "just
  tell the agent next time" — that knowledge must live in text.
- **Regression guard**: canaries that once passed should keep passing;
  wire a subset into CI (e.g. on changes to `AGENTS.md`, `docs/`, or on a
  weekly schedule) so context rot is caught automatically.

## Scoring and trends

Score = passed / total canaries, recorded in the characterization report.
The trend matters more than the number: rising score = context is becoming
truth; flat/falling = drift is accumulating (run `tack-drift`).

## Anti-patterns

- Canaries that test the agent's general skill instead of the repo's
  context.
- Canaries so big they fail for many reasons at once — keep them small.
- Fixing failures by editing the *task* to match the context, instead of
  fixing the context to match reality.
- Running canaries only once at bootstrap — the score must be re-measured
  as the repo evolves.
