# dnsx

- **What:** Fast multi-purpose DNS toolkit: active subdomain brute-forcing (wordlist-driven) and DNS record lookup/probing (A, AAAA, CNAME, NS, TXT, SRV, PTR, MX, SOA, AXFR, CAA).
- **Upstream:** https://github.com/projectdiscovery/dnsx
- **Role in the gunship:** step(s) not in tier plans — on-demand active subdomain brute-forcing and DNS record lookups — tier(s): on demand.
- **Layout:** this folder is the tool's own location: install.sh (fetches the tool for the current platform), bin/ (installed binary/launcher), plus source/wordlists as applicable.
- **Shell reference (agent-facing):** [tool_usage/dnsx.md](../../tool_usage/dnsx.md) — the exact shell commands for using dnsx manually.
- **Run via the app:** tof-pentest run-tool --tool dnsx -- <args> or MCP tool run_tool.
