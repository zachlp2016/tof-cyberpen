# tool_usage/nuclei.md — nuclei shell reference

## What it does / role in the gunship

Template-based vulnerability scanning: CVEs, misconfigurations, exposures, technology detection. Extensive-tier step vuln-scan. Requires an HTTP-like target URL. Templates are fetched at install time (auto-fetched on first run if missing).

## Status and install

    node tof-pentest/bin/tof-pentest.js tools        # shows resolution + version per tool
    bash tools/nuclei/install.sh                      # latest release into tools/nuclei/bin/ + templates
    nuclei -update-templates                          # refresh templates (best effort)

## Direct shell commands (manual use)

The exact command the gunship runs (extensive: vuln-scan):

    nuclei -u http://192.168.10.500:8000/ -t exposures,misconfig,technologies,cves,vulnerabilities,http/ -severity info,low,medium,high,critical -jsonl -stats -timeout 10 -c 25

Manual variants:

    nuclei -u <url> -t cves/ -severity high,critical -jsonl        # CVEs only, high severity
    nuclei -u <url> -t exposures/ -silent                          # exposure checks only
    nuclei -u <url> -tt -author projectdiscovery                   # filter by tag/author

## Run via the gunship

    node tof-pentest/bin/tof-pentest.js run-tool --tool nuclei -- 192.168.10.500 -- -u {url} -t cves/ -severity high -jsonl
    # MCP: run_tool {tool: "nuclei", ip, port, command: ["-u", "{url}", "-t", "cves/", "-severity", "high", "-jsonl"]}

## Interpreting output

JSONL lines (template, info.name, severity, match, url) are parsed into report.md "Vulnerabilities". Prioritize critical/high; low/info are often informational. Raw output: <run-dir>/vuln-scan.out.

## Safety / cost

- Extensive tier: 600s budget, 25 concurrent connections. Template count drives request volume — narrow -t for faster, lower-noise runs.
- Always keep -jsonl so the report parser can consume results.