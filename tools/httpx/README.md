# httpx

- **What:** HTTP probe with status, title, web server and technology detection.
- **Upstream:** https://github.com/projectdiscovery/httpx
- **Role in the gunship:** step(s) http-probe — tier(s): extensive, hack.
- **Layout:** this folder is the tool's own location: install.sh (fetches the tool for the current platform), bin/ (installed binary/launcher), plus source/wordlists as applicable.
- **Shell reference (agent-facing):** [tool_usage/httpx.md](../../tool_usage/httpx.md) — the exact shell commands for using httpx manually.
- **Run via the app:** tof-pentest run-tool --tool httpx -- <args> or MCP tool run_tool.
