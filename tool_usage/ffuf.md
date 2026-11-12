# tool_usage/ffuf.md — ffuf shell reference

## What it does / role in the gunship

Web brute-forcer: directories, paths, parameters, vhosts. Hack-tier step dir-enum. Requires an HTTP-like target port.

## Status and install

    node tof-pentest/bin/tof-pentest.js tools        # shows resolution + version per tool
    bash tools/ffuf/install.sh                        # latest release into tools/ffuf/bin/ (already vendored on this platform)

## Direct shell commands (manual use)

The exact command the gunship runs (hack: dir-enum) — bundled wordlist at tof-pentest/src/wordlists/common-paths.txt:

    ffuf -u http://192.168.10.500:8000/FUZZ -w tof-pentest/src/wordlists/common-paths.txt -mc 200,204,301,302,307,401,403,500 -t 40 -timeout 15 -o <run-dir>/ffuf.json -of json

Manual variants:

    ffuf -u http://192.168.10.500:8000/FUZZ -w <bigger-wordlist> -mc 200,301,302 -t 20    # different wordlist / status filter
    ffuf -u http://192.168.10.500:8000/ -w <wordlist> -X GET -H "User-Agent: Mozilla/5.0"   # extra header
    ffuf -u http://FUZZ.192.168.10.500:8000 -w <subdomain-list>                            # vhost brute-force

## Run via the gunship

    node tof-pentest/bin/tof-pentest.js run-tool --tool ffuf -- 192.168.10.500 -- -u {url}/FUZZ -w {wordlist} -mc 200,301,302
    # MCP: run_tool {tool: "ffuf", ip, port, command: ["-u", "{url}/FUZZ", "-w", "{wordlist}", "-mc", "200,301,302"]}

## Interpreting output

JSON results (input.FUZZ = found path, output.status/length/position) are parsed into report.md "Discovered web paths". 403s with large length often hide interesting directories; 301/302 may indicate redirects to auth. Raw output: <run-dir>/dir-enum.out (JSON).

## Safety / cost

- Hack tier: 600s budget, 40 threads by default — this is aggressive; use on targets that tolerate load.
- `-mc` filters which HTTP statuses count as "found"; tune it to the target (default excludes 404).
- Always prefer -of json so the parser can consume results.