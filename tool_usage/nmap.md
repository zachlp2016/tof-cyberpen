# tool_usage/nmap.md — nmap shell reference

## What it does / role in the gunship

Network discovery, port scanning, service/version detection, OS fingerprinting, and NSE script scanning. Core engine of every tier: basic (ping, portscan, services), normal (+ fullscan, osdetect, scripts-default), hack (+ scripts-vuln).

## Status and install

    node tof-pentest/bin/tof-pentest.js tools        # shows resolution + version per tool
    bash tools/nmap/install.sh                        # ensure system nmap (brew/apt) + launcher in tools/nmap/bin/

## Direct shell commands (manual use)

The exact commands the gunship runs (placeholders: {ip} target IP, {port} requested port(s)):

    # host discovery (basic: ping)
    nmap -sn 192.168.10.500 -PE -PA -PS8000 -n

    # TCP connect scan of the requested port (basic: portscan)
    nmap -Pn -p 8000 -sT -n 192.168.10.500

    # service/version detection (basic: services)
    nmap -Pn -p 8000 -sV -n 192.168.10.500

    # top-1000 full scan (normal: fullscan)
    nmap -Pn -p -top 1000 -sT -n 192.168.10.500

    # OS fingerprinting (normal: osdetect)
    nmap -Pn -p 8000,53,80,443 -O --osscan-guess -n 192.168.10.500

    # default NSE scripts (normal: scripts-default)
    nmap -Pn -p 8000 -sC -n 192.168.10.500

    # NSE vuln suite (hack: scripts-vuln)
    nmap -Pn -p 8000 --script vuln -n 192.168.10.500

Useful manual variants: `-oX -` writes machine-readable XML to stdout (the report parser accepts both XML and the default text output); `-sU -p <ports>` for UDP; `-sS` SYN scan (needs root); `--open` to show only open ports; `-p 1-65535` full range (slow).

## Run via the gunship

    node tof-pentest/bin/tof-pentest.js run-tool --tool nmap -- 192.168.10.500 -- -Pn -p 8000 -sV -n 192.168.10.500
    # MCP: run_tool {tool: "nmap", ip, port, command: ["-Pn", "-p", "{port}", "-sV", "-n", "{ip}"]}

Placeholders substituted for run_tool: {ip} {port} {url} {runDir} {wordlist}.

## Interpreting output

The report parser extracts: host up/down state, per-port state (open/closed/filtered), service name/product/version, OS guesses, and NSE script output. In report.md see the "Open ports", "OS guess", and "Nmap script output" sections. Raw output per step: <run-dir>/<step>.out.

## Safety / cost

- Default steps use TCP connect (-sT) and -Pn (no ARP/ping dependency) — works unprivileged, low noise.
- Timeouts: ping 30s, portscan 120s, services 180s, fullscan 300s, osdetect 180s, scripts 300-600s (manifest).
- `-O` is a guess without root and can mislead; treat OS output as indicative.
- `--script vuln` is the noisiest NSE suite — expect it in the hack tier only.