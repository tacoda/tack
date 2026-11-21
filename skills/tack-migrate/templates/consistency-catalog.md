# Consistency Catalog

One row per convention area. **Actual** = measured by `tack-characterize`
(evidence required). **Target** = the standard agents and humans should
follow. Status: `open` | `migrating` | `done` | `adr-<n>` (standard changed).

| Area | Actual (evidence) | Target | Status | Owner |
|---|---|---|---|---|
| Naming (per layer) | | | open | |
| Module structure / file layout | | | open | |
| Public API surface | | | open | |
| Error handling | | | open | |
| Logging | | | open | |
| Test framework / style / file naming | | | open | |
| Config & secrets handling | | | open | |
| Docs / comments | | | open | |

Rules:

- A row may be marked `done` only when the code is uniformly conformant
  (spot-checked by `tack-drift`'s catalog check), not when one slice landed.
- If the target turns out wrong, change it via an ADR and set status
  `adr-<n>` — never silently leave drift.
- New rows appear as new drift findings are triaged.
