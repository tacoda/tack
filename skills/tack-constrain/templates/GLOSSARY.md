# Glossary

One row per domain term. The **Code** column must name the identifier that
implements the term — `scripts/check-context.sh` fails if it disappears
(drift A: term no longer maps to reality).

| Term | Definition | Code |
|---|---|---|
| … | one-sentence definition, in the business's words | `ClassName` / `module.function` |

Rules:

- Use the business's words, not the code's. When they diverge, that is drift —
  fix the mapping or record an ADR (`docs/adr/`).
- One term, one row. Synonyms get their own row pointing at the same code.
- Update this file in the same commit as any rename or semantic change.
