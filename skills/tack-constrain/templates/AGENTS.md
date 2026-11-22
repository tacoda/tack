# <Project> — agent context

<!-- How to update this file:
     - One home per fact: link to the SSOT file, don't copy content here.
     - Same-commit rule: any commit that changes behavior, commands,
       structure, or conventions updates this file in the same commit.
     - Before pushing, run: scripts/check-context.sh  (must pass)
     - Keep this file small: point to files, don't inline them. -->

## Commands (verified YYYY-MM-DD)

- install: `…`
- build: `…`
- lint: `…` / format: `…`
- type check: `…`
- test: `…`
- run: `…`

Only commands that were actually executed and their real output belong here.

## Architecture

Two-paragraph map of the system: major components, data flow, key seams and
invariants. Pointers, not detail:

- Decisions (ADRs): `docs/adr/`
- Deep dives: `docs/…`

## Conventions

- Target standards: `docs/agent-ready/consistency-catalog.md`
- Files that embody them (examples to imitate): `path/to/example.ext`

## Glossary

- `GLOSSARY.md` — each domain term mapped to the code identifier it refers to.

## Agent operating rules

- Read this file and the linked SSOT docs before editing.
- Run the documented lint/type/test commands before and after every change; all must stay green.
- One behavior-preserving slice per commit; never edit a test to make a change pass.
- Update this file and the linked docs in the **same commit** as any change to behavior, commands, structure, or conventions.
- Run `scripts/check-context.sh` before pushing; triage any drift finding in the same PR.

## Quality bar (definition of done for any change)

- [ ] format / lint / type check / tests green in pre-commit and CI
- [ ] characterization tests still pass (behavior preserved)
- [ ] `scripts/check-context.sh` passes (no docs<->code drift)
- [ ] this file and the linked SSOT docs updated in the same commit
