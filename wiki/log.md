# Log

Append-only chronological record of wiki operations. Entry format: `## [YYYY-MM-DD] <operation> | <subject>` (see [AGENTS.md](../AGENTS.md)).

## [2026-11-07] init | Bootstrap wiki from LLM Wiki pattern

- Created workspace structure: `raw/` (with `raw/assets/`), `wiki/` (sources, concepts, entities, analyses), `projects/`.
- Wrote the schema: [AGENTS.md](../AGENTS.md).
- Saved the first raw source: [raw/llm-wiki.md](../raw/llm-wiki.md) (fetched from Karpathy's gist, with a provenance header).

## [2026-11-07] ingest | LLM Wiki (Karpathy idea file)

- Read [raw/llm-wiki.md](../raw/llm-wiki.md) in full.
- Created the source page: [sources/llm-wiki.md](sources/llm-wiki.md).
- Created concept pages: [llm-maintained-wiki](concepts/llm-maintained-wiki.md), [rag-vs-persistent-wiki](concepts/rag-vs-persistent-wiki.md), [knowledge-compounding](concepts/knowledge-compounding.md), [index-and-logging](concepts/index-and-logging.md), [memex](concepts/memex.md).
- Created entity pages: [karpathy](entities/karpathy.md), [vannevar-bush](entities/vannevar-bush.md), [qmd](entities/qmd.md), [obsidian](entities/obsidian.md).
- Created [overview](overview.md); updated [index.md](index.md).
- Instantiated the pattern in this workspace itself (three layers, operations, index, log) and separated new work into `projects/`.

## [2026-11-07] schema | Add agent guide rails and project operation

- Added the "Agent guide rails" section to [AGENTS.md](../AGENTS.md): standing discipline for any agent operating in this workspace.
- Extended the log operation set with `project` (project folder creation / status change).

## [2026-11-07] project | Start penetration work folder

- Created [projects/penetration/](../projects/penetration/README.md) as the active work folder for penetration work.
- Updated [overview](overview.md) current state and [projects/README.md](../projects/README.md).

## [2026-11-07] lint | Fix relative link depth in log

- Integrity pass caught 7 broken links in [log.md](log.md): paths from `wiki/` to root-level files used `../../` instead of `../`. All fixed; link integrity re-verified clean.

## [2026-11-07] project | TOF penetration gunship built and verified

- Built the gunship app `tof-pentest/`: CLI + MCP server (stdio JSON-RPC; tools `pentest`, `plan`, `run_tool`, `list_tools`, `get_report`), tier manifest (`src/manifest.json`), step engine, output parsers, report builder (markdown + JSON).
- Vendored 8 tools under `tools/<tool>/` (nmap, naabu, nuclei, ffuf, sqlmap, testssl.sh, httpx, katana), each with an idempotent platform-aware `install.sh`; all installed for the host platform.
- Wrote the agent-facing shell references `tool_usage/<tool>.md` and the top-down agent entry point [projects/penetration/agents.md](../projects/penetration/agents.md).
- Added the Docker layer (`docker/`): image `tof-ai-pentester` installs all tools at build time and exposes every tool + the gunship on PATH.
- Tiers are cumulative: basic (nmap recon) < normal (+full scan, OS, NSE) < extensive (+httpx, nuclei, testssl.sh) < hack (+ffuf, katana, sqlmap, NSE vuln). Non-HTTP ports skip web steps automatically.
- Verified: 10-check selftest passes; live scans produce `runs/<run>/report.md|json` with per-step raw output; fixed a port-merge bug (dangling else) that duplicated open ports across steps. Durable knowledge (tier model, tool roles) lives in `tool_usage/` and the project folder rather than this wiki.

## [2026-11-07] project | Fix testssl.sh, rename image, make build layer-cached

- Fixed testssl.sh in the Docker image: added `bsdmainutils` (hexdump) and `procps` (ps) to the apt line in [docker/Dockerfile](../docker/Dockerfile); rebuilt and re-verified — `testssl.sh --version` reports 3.3dev (OpenSSL 3.0.22, bash 5.2.15). Checklist §B item resolved; bottom line now 8 of 8 vendored tools working.
- Renamed the Docker image `tof-penetration-testing` → `tof-ai-pentester` (retagged live image, removed old tag; all repo references updated — scripts, README, docs, wiki, project notes).
- Restructured [docker/Dockerfile](../docker/Dockerfile) for layer caching: the expensive tool-vendoring layer now runs on minimal stable inputs (`tof-pentest/` + `tools/` installers) before the bulk repo copy, so routine repo edits no longer force tool re-downloads.
- Verified MCP server in the renamed image (handshake, protocol 2025-03-26, tools: pentest, run_tool, list_tools, plan, get_report).

## [2026-11-07] project | Add subfinder + dnsx; audit tool availability

- Vendored subfinder v2.17.0 and dnsx v1.3.1 (both projectdiscovery, released inside the research window) as [tools/subfinder/](../tools/subfinder/README.md) and [tools/dnsx/](../tools/dnsx/README.md) with idempotent platform-aware installers; registered both in the tier manifest ([manifest.json](../tof-pentest/src/manifest.json)) so they resolve via `run_tool`/`list_tools`.
- Agent references: [tool_usage/subfinder.md](../tool_usage/subfinder.md) and [tool_usage/dnsx.md](../tool_usage/dnsx.md), incl. the dnsx gotcha that the post-`--` vector must start with a flag or dnsx falls back to stdin and hangs.
- Both are domain-based on-demand recon (subfinder passive enum, dnsx active brute/lookup) — deliberately not added to the IP:port tier plans; tiers unchanged.
- Rebuilt the image (`tof-ai-pentester`, id f9afde2039cf, 1.27 GB) and re-verified in-container: all 10 vendored tools present, each version-checked.
- Added [checklist.md](../checklist.md) — availability audit of the image against the stipulated stack in [raw/modern-penetration-testing.md](../raw/modern-penetration-testing.md) (release window 2026-11-07): 10/10 vendored tools working; 9 of the 24 §4 research tools covered, 15 missing (checklist §C–E); quarterly re-verification recommended.

