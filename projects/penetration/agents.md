# agents.md — TOF Penetration-Testing gunship (agent entry point)

Read this file first when operating the penetration-testing stack in this repo. It is the top of the documentation hierarchy and redirects you to everything underneath.

## What this is

A command-line + MCP orchestrator (the "gunship") that runs tiered penetration tests against an IP:port target using vendored open-source tools. It runs on any Linux/macOS box, directly in a shell or inside the `tof-ai-pentester` Docker container. Agents operate it via MCP (preferred) or the CLI.

## Running a penetration test (primary interface)

Request format:

    perform a penetration test on:
    ip address:  192.168.10.500
    port:        8000
    type:        basic | normal | extensive | hack

Via MCP (tool `pentest` on the `tof-pentest` server):

    server command: node tof-pentest/bin/tof-pentest.js mcp
    tool: pentest   args: { "ip": "192.168.10.500", "port": "8000", "type": "basic" }

Via CLI:

    node tof-pentest/bin/tof-pentest.js scan --ip 192.168.10.500 --port 8000 --type basic

Via Docker (image `tof-ai-pentester`; all tools are on PATH inside):

    docker run --rm tof-ai-pentester scan --ip 192.168.10.500 --port 8000 --type normal
    docker run --rm -it tof-ai-pentester bash    # interactive shell, every tool visible on PATH

## Tiers (cumulative — higher tiers tack on more tools)

| Tier | Adds on top of the previous tier |
|---|---|
| basic | host discovery, TCP port scan, service/version detection (nmap) |
| normal | top-1000 full port scan, OS fingerprinting, Nmap default NSE scripts |
| extensive | HTTP probe + tech detection (httpx), vulnerability scan (nuclei), TLS testing (testssl.sh) |
| hack | web directory brute-force (ffuf), aggressive crawl (katana), SQL injection (sqlmap), Nmap vuln script suite |

## Hierarchy map (what lives where)

- Per-application shell commands — read these for each tool: `tool_usage/<tool>.md`
  - tool_usage/nmap.md  tool_usage/naabu.md  tool_usage/nuclei.md  tool_usage/ffuf.md
  - tool_usage/sqlmap.md  tool_usage/testssl.md  tool_usage/httpx.md  tool_usage/katana.md
  - tool_usage/subfinder.md  tool_usage/dnsx.md  tool_usage/trivy.md  tool_usage/grype.md  tool_usage/syft.md
  - (subfinder/dnsx/trivy/grype/syft are on-demand — not part of the IP:port tier plans; see their references)
- Vendored applications (one folder per tool: bin/, install.sh, README.md): `tools/<tool>/`
- The gunship app itself: `tof-pentest/` — `src/manifest.json` (tier -> step plan, exact commands), `src/mcp.js` (MCP server), `src/engine.js` (runner), `src/report.js` (report builder)
- Run artifacts: `runs/<run-id>/` — report.md (human/agent report), report.json (machine-readable), plus raw .out/.err per step
- Docker: `docker/Dockerfile` (+ build/run helper scripts in `docker/`)
- Knowledge base: `wiki/` (index: wiki/index.md, log: wiki/log.md); project notes: `projects/penetration/`

## Agent workflow

1. Optional: preview the plan without executing — MCP tool `plan` or `node tof-pentest/bin/tof-pentest.js plan --ip <ip> --port <port> --type <tier>`.
2. Run the scan — MCP tool `pentest` (or `scan` / Docker command above). Use the lowest tier that answers the question; escalate only if more signal is needed. Web steps (http-probe, vuln-scan, tls-test, dir-enum, crawl, sqli) are skipped automatically when the port is not HTTP-like.
3. Read the results — MCP tool `get_report` (run dir or id) or open `runs/<run-id>/report.md` + `report.json`.
4. Drill down if needed — MCP tool `run_tool` / `node tof-pentest/bin/tof-pentest.js run-tool --tool <tool> -- <args...>` for a single tool with explicit arguments; raw step outputs are in the run directory.
5. Check tool availability any time — MCP tool `list_tools` or `node tof-pentest/bin/tof-pentest.js tools`.

## Operating notes

- Every step has a timeout budget (see manifest); a timed-out step is marked and the scan continues.
- Exit codes from `scan`: 0 = ok, 1 = host down or no open ports, 2 = some steps failed, 3 = all steps skipped.
- No root needed for default TCP connect scans; OS detection is a guess without root.
- The bundled wordlist for ffuf: `tof-pentest/src/wordlists/common-paths.txt` (extend it as needed; it is the `{wordlist}` placeholder value).
- Reports are cumulative per run directory; re-running creates a new `runs/<timestamp>-...` directory — old runs are kept for comparison.
- Install/vendor all tools for the current platform: `node tof-pentest/bin/tof-pentest.js install` (runs each `tools/<tool>/install.sh`).
- Selftest (manifest, wordlist, parsers, MCP handshake): `node tof-pentest/bin/tof-pentest.js selftest`.