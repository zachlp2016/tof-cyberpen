# testssl

- **What:** TLS/SSL configuration and weakness testing (certs, protocols, ciphers, SNI).
- **Upstream:** https://github.com/testssl/testssl.sh
- **Role in the gunship:** step(s) tls-test — tier(s): extensive, hack.
- **Layout:** this folder is the tool's own location: install.sh (fetches the tool for the current platform), bin/ (installed binary/launcher), plus source/wordlists as applicable.
- **Shell reference (agent-facing):** [tool_usage/testssl.md](../../tool_usage/testssl.md) — the exact shell commands for using testssl manually.
- **Run via the app:** tof-pentest run-tool --tool testssl -- <args> or MCP tool run_tool.
