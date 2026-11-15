# Maintenance report

## 2026-11-15 - Removed the disabled Release Please workflow

`.github/workflows/release-please.yml` was disabled in the repository's Actions settings (`disabled_manually`) but its last run on `main` (2026-09-19, push of `e9f2466`) had failed ("RELEASE_PLEASE_TOKEN is not set"), so `main` showed a red status for a workflow that never runs. Deleted the file. This is a fork of OscillateLabsLLC/ovos-rust-messagebus; the change is one deleted file in the Thalovant fork and will conflict with upstream only if upstream edits that file. `release-build.yml` (on `release: created`) and `test.yml` are unchanged, so releases are cut by hand in this fork.

### Transparency report

- **AI model**: Claude Sonnet 5.5 (Claude Code).
- **Actions taken**: listed the workflows and runs through the GitHub CLI, deleted one workflow file.
- **Oversight**: requested by the owner; CI (`test`) runs on the pull request.

