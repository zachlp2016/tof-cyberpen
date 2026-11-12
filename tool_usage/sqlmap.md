# tool_usage/sqlmap.md — sqlmap shell reference

## What it does / role in the gunship

SQL injection detection and data extraction. Hack-tier step sqli. Requires an HTTP-like target URL with at least one parameter (or uses heuristic injection).

## Status and install

    node tof-pentest/bin/tof-pentest.js tools        # shows resolution + version per tool
    bash tools/sqlmap/install.sh                      # clones source into tools/sqlmap/source + launcher in bin/

## Direct shell commands (manual use)

The exact command the gunship runs (hack: sqli):

    sqlmap -u http://192.168.10.500:8000/ --batch --level=1 --risk=1 --timeout=15 --output-dir=<run-dir>

Escalation ladder (manual, after the gunship's level-1 pass):

    sqlmap -u http://192.168.10.500:8000/?id=1 --batch --level=2 --risk=2            # try more vectors
    sqlmap -u <url> -D <db> -T <table> --batch                                       # enumerate schema
    sqlmap -u <url> -D <db> -T <table> -C <col> --dump --batch                        # dump data

Manual variants: `--forms` (POST), `--cookie=...`, `--data="id=1&x=2"`, `--technique=BEUSTQ`, `--time=5` for time-based blind.

## Run via the gunship

    node tof-pentest/bin/tof-pentest.js run-tool --tool sqlmap -- 192.168.10.500 -- -u {url} --batch --level=2 --risk=2
    # MCP: run_tool {tool: "sqlmap", ip, port, command: ["-u", "{url}", "--batch", "--level=2", "--risk=2"]}

## Interpreting output

The report parser flags "injection point" lines and lists Database/Table/GET/POST findings in report.md "SQL injection (sqlmap)". sqlmap writes its own session logs under --output-dir. Raw output: <run-dir>/sqli.out.

## Safety / cost

- Hack tier: 600s budget, level=1 risk=1 (conservative). Higher levels multiply request volume.
- `--batch` is required for non-interactive (agent) runs — never let sqlmap wait on stdin.
- Time-based techniques are slow; keep --timeout <= 15 for agent runs.