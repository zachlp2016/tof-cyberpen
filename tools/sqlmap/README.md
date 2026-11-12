# sqlmap

- **What:** SQL injection detection and data extraction.
- **Upstream:** https://github.com/sqlmapproject/sqlmap
- **Role in the gunship:** step(s) sqli — tier(s): hack.
- **Layout:** this folder is the tool's own location: install.sh (fetches the tool for the current platform), bin/ (installed binary/launcher), plus source/wordlists as applicable.
- **Shell reference (agent-facing):** [tool_usage/sqlmap.md](../../tool_usage/sqlmap.md) — the exact shell commands for using sqlmap manually.
- **Run via the app:** tof-pentest run-tool --tool sqlmap -- <args> or MCP tool run_tool.
