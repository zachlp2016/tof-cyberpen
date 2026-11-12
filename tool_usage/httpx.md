# tool_usage/httpx.md — httpx shell reference

## What it does / role in the gunship

HTTP probing with status code, page title, web server, and technology/framework detection. Extensive-tier step http-probe. Requires an HTTP-like target URL.

## Status and install

    node tof-pentest/bin/tof-pentest.js tools        # shows resolution + version per tool
    bash tools/httpx/install.sh                       # latest release into tools/httpx/bin/

## Direct shell commands (manual use)

The exact command the gunship runs (extensive: http-probe):

    httpx -u http://192.168.10.500:8000/ -title -tech-detect -status-code -json -silent -timeout 10

Manual variants:

    httpx -u <url> -path -content-length -json -silent           # path + size
    httpx -l hosts.txt -status-code -title                        # batch from host list
    httpx -u <url> -follow-redirects -json -silent                # follow redirects

## Run via the gunship

    node tof-pentest/bin/tof-pentest.js run-tool --tool httpx -- 192.168.10.500 -- -u {url} -title -tech-detect -status-code -json -silent
    # MCP: run_tool {tool: "httpx", ip, port, command: ["-u", "{url}", "-title", "-tech-detect", "-status-code", "-json", "-silent"]}

## Interpreting output

JSONL (input, status_code, title, web_server, tech) is parsed into report.md "Web tech detection" — the tech list (frameworks, WAFs, servers) is key for choosing later vuln templates. Raw output: <run-dir>/http-probe.out.

## Safety / cost

- Extensive tier: 120s budget, 10s per-request timeout. Low noise (single probe).
- Keep -json for report parsing; -silent keeps stdout clean.