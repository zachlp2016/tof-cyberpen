# trivy

- **What:** Comprehensive security scanner for container images, filesystems, directories, and git repos: OS + language dependency vulnerabilities, misconfigurations, secrets, licenses.
- **Upstream:** https://github.com/aquasecurity/trivy
- **Role in the gunship:** step(s) not in tier plans — on-demand image/filesystem scanning — tier(s): on demand.
- **Layout:** this folder is the tool's own location: install.sh (fetches the tool for the current platform), bin/ (installed binary/launcher), plus source/wordlists as applicable.
- **Shell reference (agent-facing):** [tool_usage/trivy.md](../../tool_usage/trivy.md) — the exact shell commands for using trivy manually.
- **Run via the app:** tof-pentest run-tool --tool trivy -- <args> or MCP tool run_tool.
