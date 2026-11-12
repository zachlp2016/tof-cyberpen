# ffuf

- **What:** Web brute-forcer (directories, paths, params, vhosts).
- **Upstream:** https://github.com/ffuf/ffuf
- **Role in the gunship:** step(s) dir-enum — tier(s): hack.
- **Layout:** this folder is the tool's own location: install.sh (fetches the tool for the current platform), bin/ (installed binary/launcher), plus source/wordlists as applicable.
- **Shell reference (agent-facing):** [tool_usage/ffuf.md](../../tool_usage/ffuf.md) — the exact shell commands for using ffuf manually.
- **Run via the app:** tof-pentest run-tool --tool ffuf -- <args> or MCP tool run_tool.
