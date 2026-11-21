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

## Placement

Root `AGENTS.md` is the cross-agent standard (read by Claude Code, Codex,
Cursor, Copilot, Gemini CLI, and more). Agent-specific locations
(`.claude/`, `.cursor/`, `.github/copilot-instructions.md`) should either
symlink to it or contain a one-line pointer to it, so there is still one
home per fact. Project-local skills can live in `.agents/skills/` /
`.vibe/skills/` and be referenced from `AGENTS.md`.
