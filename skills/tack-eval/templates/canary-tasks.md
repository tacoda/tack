# Canary tasks — agent-readiness eval

Pick 3–10 small tasks. Each must be verifiable mechanically and must require
the committed text (`AGENTS.md`, `GLOSSARY.md`, catalog, ADRs) to succeed.

| # | Task | Verify by | Context it exercises |
|---|---|---|---|
| 1 | Run the documented install/build/test commands from `AGENTS.md` | commands exit 0 | verified commands |
| 2 | Add a small change following the repo's naming/structure conventions (e.g. add one field + test) | tests green; naming matches catalog | conventions, catalog |
| 3 | Explain a domain term using `GLOSSARY.md`, then find the code it maps to | identifier exists; explanation matches code | glossary |
| 4 | Make a behavior-preserving refactor of one module | characterization tests stay green | safety net |
| 5 | State which ADR governs a given area and what it decided | correct ADR cited | ADRs |
| 6 | Run `scripts/check-context.sh` and explain any finding | exit 0, or finding triaged correctly | drift checks |
| 7 | <project-specific task a new team member would be given> | <mechanical check> | product/domain docs |

Record results (pass/fail + first broken file) in
`docs/agent-ready/characterization-report.md` under "Context eval score".
