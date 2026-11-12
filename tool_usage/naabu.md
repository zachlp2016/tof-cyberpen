# tool_usage/naabu.md — naabu shell reference

## What it does / role in the gunship

Very fast parallel port scanner (no service detection). Not part of the tier plans — used on demand for quick full-range sweeps where speed matters more than detail.

## Status and install

    node tof-pentest/bin/tof-pentest.js tools        # shows resolution + version per tool
    bash tools/naabu/install.sh                       # latest release into tools/naabu/bin/

## Direct shell commands (manual use)

    naabu -host 192.168.10.500 -p 8000               # scan the requested port(s) fast
    naabu -host 192.168.10.500 -p 1-1000             # quick first 1000 ports
    naabu -host 192.168.10.500 -p all -rate-limit 150  # full range (slower, still much faster than nmap)

Manual variants: `-s tcp,udp`, `-p- 80,443,8000` port-list syntax, `-json` for machine-readable output, `-o out.txt`, `-exclude-closed`.

## Run via the gunship

    node tof-pentest/bin/tof-pentest.js run-tool --tool naabu -- 192.168.10.500 -- -host {ip} -p {port}
    # MCP: run_tool {tool: "naabu", ip, port, command: ["-host", "{ip}", "-p", "{port}"]}

## Interpreting output

Plain list of open ports (or JSON with -json). No service names — pair with `nmap -sV` on discovered ports for identification. The gunship report does not auto-parse naabu; read the raw .out in the run directory.

## Safety / cost

- Noisy at `-p all`; keep -rate-limit <= 150 on shared networks.
- Suggest a 120-300s timeout for wide sweeps when using run_tool (default 300s).