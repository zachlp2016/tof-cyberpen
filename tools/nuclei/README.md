# nuclei

- **What:** Template-based vulnerability scanner (CVEs, misconfigs, exposures, tech detection).
- **Upstream:** https://github.com/projectdiscovery/nuclei
- **Role in the gunship:** step(s) vuln-scan — tier(s): extensive, hack.
- **Layout:** this folder is the tool's own location: install.sh (fetches the tool for the current platform), bin/ (installed binary/launcher), plus source/wordlists as applicable.
- **Shell reference (agent-facing):** [tool_usage/nuclei.md](../../tool_usage/nuclei.md) — the exact shell commands for using nuclei manually.
- **Run via the app:** tof-pentest run-tool --tool nuclei -- <args> or MCP tool run_tool.
