# tool_usage/testssl.md — testssl.sh shell reference

## What it does / role in the gunship

TLS/SSL configuration and weakness testing: certificate details, protocol/cipher support, SNI behavior, and an overall rating. Extensive-tier step tls-test. Best on 443 or any TLS port.

## Status and install

    node tof-pentest/bin/tof-pentest.js tools        # shows resolution + version per tool
    bash tools/testssl.sh/install.sh                  # clones source into tools/testssl.sh/source + launcher in bin/

## Direct shell commands (manual use)

The exact command the gunship runs (extensive: tls-test):

    testssl.sh 192.168.10.500:8000

Manual variants:

    testssl.sh --color 192.168.10.500:443            # colored terminal output
    testssl.sh --port 8000 192.168.10.500            # explicit port flag
    testssl.sh --server 192.168.10.500 --start-tls   # STARTTLS services (SMTP etc.)

## Run via the gunship

    node tof-pentest/bin/tof-pentest.js run-tool --tool testssl -- 192.168.10.500 -- 192.168.10.500:443
    # MCP: run_tool {tool: "testssl", ip, port, command: ["{ip}:{port}"]}

## Interpreting output

The report parser extracts the RATING line and severity-tagged issue lines into report.md "TLS findings". Look for: protocol support (TLS 1.0/1.1 = weak), certificate chain validity, and the overall rating. Raw output: <run-dir>/tls-test.out.

## Safety / cost

- Extensive tier: 300s budget. Full run probes many protocol/cipher combos — expect real traffic on the TLS port.
- Skipped automatically by the engine unless the port is TLS-like or the tier is hack.