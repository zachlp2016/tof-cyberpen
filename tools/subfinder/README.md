# subfinder

- **What:** Very fast subdomain enumeration tool (passive + active sources).
- **Upstream:** https://github.com/projectdiscovery/subfinder
- **Role in the gunship:** step(s) not in tier plans — on-demand subdomain enumeration — tier(s): on demand.
- **Layout:** this folder is the tool's own location: install.sh (fetches the tool for the current platform), bin/ (installed binary/launcher), plus source/wordlists as applicable.
- **Shell reference (agent-facing):** [tool_usage/subfinder.md](../../tool_usage/subfinder.md) — the exact shell commands for using subfinder manually.
- **Run via the app:** tof-pentest run-tool --tool subfinder -- <args> or MCP tool run_tool.
