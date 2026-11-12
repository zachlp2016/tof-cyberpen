# tool_usage/subfinder.md — subfinder shell reference

## What it does / role in the gunship

Subdomain enumeration for a target domain using passive online sources (crt.sh, DNS, certificate transparency, etc.); -all adds active sources (slower). Not in the tier plans — on-demand recon, e.g. to expand scope from an IP:port target's hostname or to build the domain list before web-tier steps. Takes a domain (not an IP).

## Status and install

    node tof-pentest/bin/tof-pentest.js tools        # shows resolution + version per tool
    bash tools/subfinder/install.sh                  # latest release into tools/subfinder/bin/

## Direct shell commands (manual use)

    subfinder -d example.com                         # passive subdomain enumeration
    subfinder -d example.com -all                    # passive + active sources (slow)
    subfinder -d example.com -oJ -o subs.jsonl       # JSONL output to file
    subfinder -dL domains.txt -oJ -o subs.jsonl      # enumerate many domains from a file

Manual variants:

    subfinder -d example.com -s crtsh,github         # specific sources only (-ls lists available)
    subfinder -d example.com -silent                 # subdomains only, no logs
    subfinder -d example.com -nW                     # active subdomains only
    subfinder -d example.com -mr 50                  # limit results per source

## Run via the gunship

    node tof-pentest/bin/tof-pentest.js run-tool --tool subfinder -- example.com -- -d {domain} -oJ
    # MCP: run_tool {tool: "subfinder", ip, port, command: ["-d", "{domain}", "-oJ"]}

## Interpreting output

One subdomain per line (plain) or JSONL with the domain field (-oJ). Feed results to httpx for live-host filtering, or to katana/nuclei as input. Raw output: <run-dir>/subfinder.out.

## Safety / cost

- Passive-only default is low-noise; -all adds active probes — noisier and slower, use deliberately.
- Defaults: 30s per-request timeout, 10 min max enumeration, 10 concurrent domains; -timeout/-max-time/-t tune it.
- Some passive sources (crt.sh, etc.) can be slow or rate-limited; -mr caps per-source results.
- Keep -oJ when running via the gunship so results are machine-readable.
