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

### MCP usage

Start the server (JSON-RPC over stdio):

    Local:  node tof-pentest/bin/tof-pentest.js mcp
    Docker: docker run -i --rm tof-ai-pentester mcp

Register it in any MCP host (Claude Desktop, Cursor, harnesses — standard `mcpServers` config). Docker variant:

    {
      "mcpServers": {
        "tof-pentest": {
          "command": "docker",
          "args": ["run", "-i", "--rm", "tof-ai-pentester", "mcp"]
        }
      }
    }

Local variant (absolute path to this checkout):

    {
      "mcpServers": {
        "tof-pentest": {
          "command": "node",
          "args": ["/path/to/TOF-Penetration-Testing/tof-pentest/bin/tof-pentest.js", "mcp"]
        }
      }
    }

Tools and the argument JSON a host sends per call (`arguments` in tools/call — the host wraps it in JSON-RPC automatically):

    pentest      {"ip": "192.168.10.50", "port": "8000", "type": "extensive"}    # omit "port" for discovery mode
    plan         {"ip": "192.168.10.50", "port": "8000", "type": "basic"}        # exact step sequence, no execution
    run_tool     {"tool": "nmap", "ip": "192.168.10.50", "port": "8000", "command": ["-Pn", "-p", "{port}", "{ip}"]}
    list_tools   {}
    get_report   {"run": "2026-11-12T02-10-00-192.168.10.50-8000"}

`type` is basic | normal | extensive | hack (cumulative tiers). `run_tool` accepts nmap, naabu, nuclei, ffuf, sqlmap, testssl, httpx, katana; placeholders `{ip} {port} {url} {runDir}` are substituted. `get_report` takes a run dir path or the run id under runs/.

Raw JSON-RPC for manual stdio testing without a host (one request per line, in order):

    {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"probe","version":"0"}}}
    {"jsonrpc":"2.0","method":"notifications/initialized"}
    {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    {"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"plan","arguments":{"ip":"192.168.10.50","port":"8000","type":"basic"}}}

### MCP response contract

Every tool result uses the standard MCP result envelope, uniformly:

    result.content[0].text          human-readable summary (works in any client)
    result.structuredContent        machine-readable payload (declared per tool)
    result.isError                  true when the run/target did not come up clean

Each tool declares its `structuredContent` shape as `outputSchema` in tools/list, so any MCP host (harnesses, Claude Desktop, Cursor, SDK clients) can introspect and validate packets. The payload contract for `pentest`/`get_report`:

    runDir, target {ip, port, url, mode}, tier, mode (focus|discovery), hostUp,
    summary {runDir, tier, mode, ip, port, findingsCount, openPortCount, vulnCount, stepsRun, generatedAt},
    portTargeting {mode, cap, webTargets, webSkipped, deepScanned},
    reportMd, reportJson, openPorts [{port, protocol, service, product, version, state, extrainfo, deepTarget, sourceStep}],
    findings {vulnerabilities, techStack, webPaths, urls, sqli, tls, tlsIssues, osGuesses, nmapScripts},
    steps [{id, tool, status, exitCode, outFile, errFile, startedAt, finishedAt, durationSec, cmd, reason, raw {stdout, stderr, stdoutTruncated, stderrTruncated}}]

`raw` embeds each executed step's tool output (capped at 250KB stdout / 16KB stderr; full output stays in the run directory). Selftest gates enforce that emitted payloads stay within the declared schemas.

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

- `node tof-pentest/bin/tof-pentest.js selftest` — 18 gates: manifest integrity, wordlist, parsers (nmap/ffuf/testssl/sqlmap), live MCP handshake (initialize, tools/list, plan call), uniform response envelope, outputSchema contract compliance, runData raw-packet embedding.
- Tier plan is data: edit `tof-pentest/src/manifest.json` to add steps or tiers; selftest verifies referential integrity and cumulative ordering.
- Parsers live in `tof-pentest/src/parsers.js` (nmap XML + text, JSONL, ffuf, testssl, katana, sqlmap).