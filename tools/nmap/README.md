# nmap

- **What:** Network/port scanner and OS fingerprinter (the core recon engine).
- **Upstream:** https://github.com/nmap/nmap
- **Role in the gunship:** step(s) ping, portscan, services, fullscan, osdetect, scripts-default, scripts-vuln — tier(s): all tiers.
- **Layout:** this folder is the tool's own location: install.sh (fetches the tool for the current platform), bin/ (installed binary/launcher), plus source/wordlists as applicable.
- **Shell reference (agent-facing):** [tool_usage/nmap.md](../../tool_usage/nmap.md) — the exact shell commands for using nmap manually.
- **Run via the app:** tof-pentest run-tool --tool nmap -- <args> or MCP tool run_tool.
