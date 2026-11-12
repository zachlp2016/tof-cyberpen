# tool_usage/dnsx.md — dnsx shell reference

## What it does / role in the gunship

Active subdomain brute-forcing (wordlist-driven: -d + -w) and multi-record DNS lookup/probing (-l) — the active complement to subfinder's passive enumeration. Not in the tier plans — on-demand recon: brute-force candidate subdomains for a target domain (before httpx/katana), or resolve/inspect DNS records (A/AAAA/CNAME/NS/TXT/SRV/PTR/MX/SOA/AXFR/CAA) for discovered hosts. Takes domains (brute) or hosts (lookup), not IPs.

## Status and install

    node tof-pentest/bin/tof-pentest.js tools        # shows resolution + version per tool
    bash tools/dnsx/install.sh                       # latest release into tools/dnsx/bin/

## Direct shell commands (manual use)

    dnsx -l example.com -a -j                        # A record lookup, JSONL output
    dnsx -l example.com -all -j -or                  # all record types, JSONL without raw response
    dnsx -l example.com -mx -txt -silent             # MX + TXT records only
    dnsx -d example.com -w tof-pentest/src/wordlists/common-paths.txt -a -j   # active subdomain brute (bundled wordlist)

Manual variants:

    dnsx -d example.com -w <bigger-wordlist> -a -silent -t 50 -timeout 5s      # own wordlist, lower thread count
    dnsx -d example.com -w <wordlist> -all -auto-wildcard -j                   # all record types per candidate, wildcard handling
    dnsx -l example.com -re                # include the DNS response in the output (-ro: response only)
    dnsx -l example.com -rcode noerror,servfail   # filter by DNS status code
    dnsx -l example.com -trace             # DNS trace (debug resolution path)

## Run via the gunship

    node tof-pentest/bin/tof-pentest.js run-tool --tool dnsx --ip {ip} --port {port} -- -l {domain} -a -silent -j
    # brute-force: node tof-pentest/bin/tof-pentest.js run-tool --tool dnsx --ip {ip} --port {port} -- -d {domain} -w {wordlist} -a -silent -timeout 3s
    # MCP: run_tool {tool: "dnsx", ip, port, command: ["-l", "{domain}", "-a", "-silent", "-j"]}
    # MCP brute: run_tool {tool: "dnsx", ip, port, command: ["-d", "{domain}", "-w", "{wordlist}", "-a", "-silent", "-timeout", "3s"]}
    # {wordlist} substitutes to the repo's bundled tof-pentest/src/wordlists/common-paths.txt

Important: the argument vector after -- must START WITH A FLAG (e.g. -l ... or -d ...). If a bare
positional target leads the vector (e.g. -- example.com -- -d ...), Go flag parsing stops at the
positional and dnsx falls back to reading stdin — it then hangs until the 300s budget kills it.
(Verified against dnsx v1.3.1.)

## Interpreting output

JSONL per resolved host: fields host, a/aaaa/cname/mx/txt/... (records), all (raw), status_code
(NOERROR/NXDOMAIN/...), query-time, ttl, resolver. Brute mode prints only candidates that resolve.
Feed surviving subdomains to httpx for live-host filtering, or to katana/nuclei as input.
Raw output: <run-dir>/dnsx-custom.out.

## Safety / cost

- Brute-forcing is ACTIVE: every wordlist entry is a DNS query (247-word bundled list ≈ 247+ queries per domain) — noisier than subfinder passive; use deliberately.
- Defaults: 100 threads, 3s per-query timeout, 2 retries; -t/-timeout/-retry tune it. Rate-limit with -rl on shared networks.
- Wildcard domains (e.g. *.foo.com) flood results; -auto-wildcard detects and filters them, or -wd <wildcard.domain> for manual filtering.
- Keep -j when running via the gunship so results are machine-readable.
