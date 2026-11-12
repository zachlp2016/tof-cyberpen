# naabu

- **What:** Very fast parallel port scanner (no service detection).
- **Upstream:** https://github.com/projectdiscovery/naabu
- **Role in the gunship:** step(s) not in tier plans — on-demand fast sweeps — tier(s): on demand.
- **Layout:** this folder is the tool's own location: install.sh (fetches the tool for the current platform), bin/ (installed binary/launcher), plus source/wordlists as applicable.
- **Shell reference (agent-facing):** [tool_usage/naabu.md](../../tool_usage/naabu.md) — the exact shell commands for using naabu manually.
- **Run via the app:** tof-pentest run-tool --tool naabu -- <args> or MCP tool run_tool.
