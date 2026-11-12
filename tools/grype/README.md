# grype

- **What:** Vulnerability matching for container images, containers, and filesystems against the Anchore vulnerability database; SBOM scanning via syft.
- **Upstream:** https://github.com/anchore/grype
- **Role in the gunship:** step(s) not in tier plans — on-demand image/container/SBOM CVE matching — tier(s): on demand.
- **Layout:** this folder is the tool's own location: install.sh (fetches the tool for the current platform), bin/ (installed binary/launcher), plus source/wordlists as applicable.
- **Shell reference (agent-facing):** [tool_usage/grype.md](../../tool_usage/grype.md) — the exact shell commands for using grype manually.
- **Run via the app:** tof-pentest run-tool --tool grype -- <args> or MCP tool run_tool.
