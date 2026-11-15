# Audit

## 2026-11-15 - Findings

| Finding | State | Where |
| --- | --- | --- |
| A disabled workflow left a failed run on `main`. | Fixed: file deleted. | `.github/workflows/release-please.yml` (removed) |
| `CONTRIBUTING.md` still says the project uses release-please for versioning (line 158). | Open; upstream text, not edited. | `CONTRIBUTING.md:158` |
| The repository has none of QUICK_FACTS.md, FAQ.md, SUGGESTIONS.md or `docs/`, which the workspace rules require. | Open; out of scope here. | repository root |

No Rust code changed; the `test` workflow on the pull request is the test of record.

