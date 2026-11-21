# Quality context: what it is and how to keep it updated

**Quality context** is the machine-readable material an agent needs to do
work that meets this project's quality bar: verified commands, architecture
map, conventions, glossary, and the rules for changing any of them.

## What belongs in quality context

- **Verified commands** — install, build, lint, format, type check, test,
  run, deploy — each one actually executed, with the observed result.
- **Architecture map** — a short overview plus pointers to ADRs and deeper
  docs. Describe seams and invariants, not file-by-file detail.
- **Conventions** — the target standards (from the consistency catalog),
  with pointers to example files that embody them.
- **Glossary** — domain terms mapped to code identifiers.
- **Business truth** — product and domain decisions, requirements, and
  domain knowledge as text files (ADRs, product briefs, JTBD/domain docs),
  continually updated so they still represent the truth. Agents act on this
  text; the drift checks defend it.
- **Quality bar** — definition of done for a change: which checks must be
  green, review expectations, commit hygiene.
- **How to update this context** — the meta-rules below, written into
  `AGENTS.md` itself.

## What does not belong

- Copies of source code or large doc bodies (link instead — context budget).
- Changelogs and histories (git has them).
- Per-file explanations (they live next to the file and rot; prefer ADRs for
  decisions that must persist).
- Aspirational standards the code doesn't follow yet — those go in the
  consistency catalog as targets with a migration plan, not in `AGENTS.md`
  as if they were current.

## Keeping it easy to update (the point of the exercise)

1. **One home per fact.** If two files can disagree, they will. `AGENTS.md`
   links to the SSOT; it never restates a fact in its own words.
2. **Same-commit rule.** Any commit that changes behavior, commands,
   structure, or conventions updates the quality context in the same commit.
   Context is versioned with the code — there is no separate update process
   to forget.
3. **Update triggers are explicit.** Write them into `AGENTS.md`: "when you
   add a command, add it here and run it; when you rename an identifier in
   the glossary, update `GLOSSARY.md` in the same commit; when you change an
   architecture decision, add an ADR."
4. **Drift checks enforce it.** The CI drift checks
   (`scripts/check-context.sh`) fail when docs and code disagree, so a
   missed update is caught in the PR, not discovered by the next agent.
5. **Review context in PRs like code.** Reviewers check that context changes
   accompany the code changes they describe.
6. **Keep it small.** `AGENTS.md` should fit comfortably in an agent's
   context window. Point, don't paste. If a linked doc grows huge, split it
   and link the index.

## Where context lives: plain text, in the repo

All quality context is stored as plain-text Markdown committed in the
repository, versioned with the code:

- `AGENTS.md` — root index (cross-agent standard)
- `GLOSSARY.md` — terms mapped to code identifiers
- `docs/adr/` — one file per architectural decision
- `docs/agent-ready/` — characterization report + consistency catalog

Why text-in-repo rather than a wiki or external tool:

- **Migrations never interrupt product work.** A migration slice is an
  ordinary commit on the same branch flow as feature work — diffable,
  reviewable, revertable. No freeze windows, no big-bang cutover, no
  separate process to run.
- **Nothing breaks silently.** Every commit (product or migration) must
  stay green against the constraint suite — characterization tests, lint,
  type check, CI, drift checks — so a breaking change fails loudly in the
  PR, not in production.
- **Diffs are the review.** Context changes are reviewed in the same PR as
  the code change that caused them, which is what keeps drift A rare.

## Placement

Root `AGENTS.md` is the cross-agent standard (read by Claude Code, Codex,
Cursor, Copilot, Gemini CLI, and more). Agent-specific locations
(`.claude/`, `.cursor/`, `.github/copilot-instructions.md`) should either
symlink to it or contain a one-line pointer to it, so there is still one
home per fact. Project-local skills can live in `.agents/skills/` /
`.vibe/skills/` and be referenced from `AGENTS.md`.
