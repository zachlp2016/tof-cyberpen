# tool_usage/katana.md — katana shell reference

## What it does / role in the gunship

Aggressive web crawler/spider: maps the client-side attack surface (pages, endpoints, links, forms). Hack-tier step crawl. Requires an HTTP-like target URL.

## Status and install

    node tof-pentest/bin/tof-pentest.js tools        # shows resolution + version per tool
    bash tools/katana/install.sh                      # latest release into tools/katana/bin/

## Direct shell commands (manual use)

The exact command the gunship runs (hack: crawl):

    katana -u http://192.168.10.500:8000/ -d 3 -jc -silent -json -timeout 10

Manual variants:

    katana -u <url> -d 4 -kf cookies.txt -silent -json        # deeper crawl with auth cookies
    katana -u <url> -H "Accept-Encoding: gzip, deflate" -silent
    katana -u <url> -f js -silent -json                        # focus on JS files

## Run via the gunship

    node tof-pentest/bin/tof-pentest.js run-tool --tool katana -- 192.168.10.500 -- -u {url} -d 3 -jc -silent -json
    # MCP: run_tool {tool: "katana", ip, port, command: ["-u", "{url}", "-d", "3", "-jc", "-silent", "-json"]}

## Interpreting output

JSON lines (data = URL) are parsed into report.md "Crawled URLs" (capped at 200). The URL list reveals endpoints, admin paths, and assets to feed into ffuf/nuclei/sqlmap. Raw output: <run-dir>/crawl.out.

## Safety / cost

- Hack tier: 300s budget, depth 3. Depth 4+ multiplies requests — raise -d only when needed.
- -jc keeps the cookie jar per host (session-aware crawling).