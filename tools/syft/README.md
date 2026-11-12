# syft

- **What:** Software Bill of Materials generation for container images, containers, filesystems, and archives; feeds grype for CVE matching.
- **Upstream:** https://github.com/anchore/syft
- **Role in the gunship:** step(s) not in tier plans — on-demand SBOM generation — tier(s): on demand.
- **Layout:** this folder is the tool's own location: install.sh (fetches the tool for the current platform), bin/ (installed binary/launcher), plus source/wordlists as applicable.
- **Shell reference (agent-facing):** [tool_usage/syft.md](../../tool_usage/syft.md) — the exact shell commands for using syft manually.
- **Run via the app:** tof-pentest run-tool --tool syft -- <args> or MCP tool run_tool.
