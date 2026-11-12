# Penetration

- **Status:** active — gunship built and verified (2026-11-07)
- **Goal:** A CLI + MCP "gunship" that runs tiered penetration tests (basic → normal → extensive → hack) against IP:port targets on any Linux/macOS box, directly or inside the `tof-ai-pentester` Docker container, with 13 vendored open-source tools (nmap, naabu, nuclei, ffuf, sqlmap, testssl.sh, httpx, katana, subfinder, dnsx, trivy, grype, syft).
- **Entry point:** [agents.md](agents.md) — top-down hierarchy and redirect into `tool_usage/`.

## Working material

Files specific to this work live in this folder: checklists, target notes, scratch files, report drafts. Durable knowledge gets promoted to the wiki:

- Generalizable findings become concept or analysis pages under `wiki/`.
- Tools and targets become entity pages under `wiki/entities/`.
- Specs or references dropped as sources go in `raw/` and get ingested per the schema.

## Related wiki pages

- [overview](../../wiki/overview.md)
- [wiki index](../../wiki/index.md) (catalog of all pages)

## Log

- 2026-11-07 — Folder created as the active work folder for penetration work; see [wiki/log.md](../../wiki/log.md).
- 2026-11-07 — Gunship built: `tof-pentest/` (CLI + MCP server, tier manifest, parsers, report builder), 8 tools vendored under `tools/<tool>/` with installers, agent-facing shell references in `tool_usage/`, Docker layer in `docker/` (image `tof-ai-pentester`). Selftest + live scans verified; port-merge dedupe fixed in report builder.
