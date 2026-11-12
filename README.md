# TOF-Penetration-Testing

A "gunship" for agents: a CLI + MCP orchestrator that performs tiered penetration tests on IP:port targets, on any Linux/macOS box, directly or inside the `tof-ai-pentester` Docker container.

## Quick start

Local (requires Node 18+; nmap is picked up from PATH or installed by the tool installer):

    node tof-pentest/bin/tof-pentest.js install    # install all 13 tools into tools/<tool>/ for this platform
    node tof-pentest/bin/tof-pentest.js selftest   # sanity checks (manifest, parsers, MCP handshake)
    node tof-pentest/bin/tof-pentest.js scan --ip 192.168.10.500 --port 8000 --type basic

Docker (recommended for reproducible runs; all tools are installed and visible on PATH inside):

    docker build -f docker/Dockerfile -t tof-ai-pentester .
    docker run --rm tof-ai-pentester scan --ip 192.168.10.500 --port 8000 --type basic
    docker run --rm -it tof-ai-pentester bash      # shell with every tool on PATH
    docker run -i --rm tof-ai-pentester mcp        # MCP stdio server through docker

## For agents

Entry point: [projects/penetration/agents.md](projects/penetration/agents.md) — top-down hierarchy, tier model, and the redirect into `tool_usage/` for each application's shell commands.

MCP (preferred interface for agents in other applications):

    server: node tof-pentest/bin/tof-pentest.js mcp   (JSON-RPC over stdio)
    tools: pentest {ip, port, type}, plan {ip, port, type}, run_tool {tool, ip, port, command}, list_tools, get_report {run}

## Tiers (cumulative)

basic -> normal -> extensive -> hack. Each tier adds tools: reconnaissance (nmap), then full-scan/OS/NSE, then HTTP probe + nuclei vuln scan + TLS test, then ffuf dir enum + katana crawl + sqlmap + Nmap vuln suite. See `tof-pentest/src/manifest.json` for the exact per-step commands.

## Repository layout

| Path | Role |
|---|---|
| tof-pentest/ | The gunship app: CLI, MCP server, tier manifest, parsers, report builder, wordlists |
| tools/<tool>/ | One folder per vendored application (nmap, naabu, nuclei, ffuf, sqlmap, testssl.sh, httpx, katana): install.sh + bin/ |
| tool_usage/ | Per-tool agent-facing shell reference (the commands each application runs, manually and via the app) |
| projects/penetration/ | Project folder for this work; agents.md is the agent entry point |
| docker/ | Dockerfile + build/run helpers for the tof-ai-pentester image |
| runs/ | Per-run artifacts: report.md, report.json, raw tool outputs |
| wiki/ | LLM-maintained knowledge base (index.md, log.md) |
| raw/ | Immutable source documents |
| docs/ | Dated status/verification notes (e.g. [status-2026-11-07.md](docs/status-2026-11-07.md)) |

## Development

- `node tof-pentest/bin/tof-pentest.js selftest` — 10 checks: manifest integrity, wordlist, parsers (nmap/ffuf/testssl/sqlmap), live MCP handshake (initialize, tools/list, plan call).
- Tier plan is data: edit `tof-pentest/src/manifest.json` to add steps or tiers; selftest verifies referential integrity and cumulative ordering.
- Parsers live in `tof-pentest/src/parsers.js` (nmap XML + text, JSONL, ffuf, testssl, katana, sqlmap).