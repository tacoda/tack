# tack

**tack — the stuff that must be in order before your agent harness can run.**

Agents are good at brownfield work when the repo gives them good patterns and
every change is mechanically verified — proof, not trust. `tack` is a skill
distribution that makes a legacy project **agent-ready** in three phases:

```
characterize  ->  constrain  ->  migrate
  (pin it)       (contract)      (move it, safely)
```

1. **characterize** — record an exact build/lint/test baseline and pin current
   behavior with characterization tests; catalog the conventions the code
   *actually* follows. After this phase, any behavior change an agent makes is
   detectable.
2. **constrain** — write the quality context (root `AGENTS.md` + single-source
   `GLOSSARY.md`, ADRs, consistency catalog) with a how-to-update section, and
   enforce it: pre-commit, CI, and docs-vs-code drift checks
   (`scripts/check-context.sh`). Green on the untouched repo first, then
   tighten.
3. **migrate** — bring code and docs into consistency one small commit at a
   time, each green against the full constraint suite, with context updated in
   the same commit. Drift in either direction is triaged: fix code, fix docs,
   or change the standard via ADR.

All of it is **plain text committed in the repo** (`AGENTS.md`, `GLOSSARY.md`,
`docs/adr/`, `docs/agent-ready/`) — so migrations are ordinary, diffable,
reviewable commits that run alongside product work (no freeze windows, no
big-bang), and every commit must stay green against the constraint suite, so
nothing breaks silently.

## Install (skills.sh)

Any public GitHub repo with `SKILL.md` files is installable via the skills CLI
and shows up on skills.sh:

```sh
npx skills add tacoda/tack                     # all tack skills
npx skills add tacoda/tack@tack                # just the orchestrator
npx skills add tacoda/tack --skill tack-drift  # one phase skill
npx skills add tacoda/tack -g                  # install globally
```

## Skills in this distribution

| Skill | Phase | Load it when |
|---|---|---|
| `tack` | all | "make this repo agent-ready" — orchestrates the workflow |
| `tack-characterize` | 1 | before touching untested legacy code: baseline + characterization tests + measured conventions |
| `tack-constrain` | 2 | setting up `AGENTS.md`, coding standards, pre-commit/CI, drift checks |
| `tack-migrate` | 3 | migrating code toward the conventions catalog in small green commits |
| `tack-drift` | anytime | "are the docs still accurate?" — audit/repair code<->context drift, both directions |

## Repo layout

```
skills/
├── tack/                  orchestrator: pillars, workflow, definition of done
├── tack-characterize/     phase 1 + references + report template
├── tack-constrain/        phase 2 + quality-context guide + AGENTS.md & check-context.sh templates
├── tack-migrate/          phase 3 + catalog template
└── tack-drift/            drift taxonomy, detection, repair playbook
```

Each skill is a standard agentskills.io folder (`SKILL.md` with `name` +
`description` frontmatter) plus `references/` and `templates/` support files.

## License

MIT — see [LICENSE](LICENSE).
