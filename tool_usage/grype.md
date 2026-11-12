# tool_usage/grype.md — grype shell reference

## What it does / role in the gunship

Vulnerability matching for container images, containers, and filesystems: matches OS packages and language dependencies (npm, Go, Python, Java, Ruby, PHP, .NET, Rust) against the Anchore vulnerability DB. Not in the tier plans — on-demand: the tiers target IP:port, while grype targets an image ref, a running container, or a local path. The lighter-weight companion to trivy for pure CVE matching; pair with syft to scan an SBOM directly.

## Status and install

    node tof-pentest/bin/tof-pentest.js tools        # shows resolution + version per tool
    bash tools/grype/install.sh                      # latest release into tools/grype/bin/

## Direct shell commands (manual use)

    grype alpine:3.19                                # vulnerability scan of a container image
    grype alpine:3.19 -o json                        # machine-readable results
    grype dir:/path/to/app                           # scan a directory/filesystem
    grype sbom:./sbom.json                           # scan an SBOM produced by syft

Manual variants:

    grype alpine:3.19 --only-fixed                  # only CVEs with a known fix
    grype alpine:3.19 --ignore-vuln CVE-2022-1234   # exclude specific CVEs
    grype alpine:3.19 --only-updates --update-within 14d   # fixes available within 14 days
    grype alpine:3.19 --output table --file table.txt
    grype container:myrunningcontainer              # scan a running container (needs docker)
    grype alpine:3.19 --db autoupdate=true          # keep the vulnerability DB fresh (default)

## Run via the gunship

    node tof-pentest/bin/tof-pentest.js run-tool --tool grype --ip {ip} --port {port} -- {image-ref} -o json
    node tof-pentest/bin/tof-pentest.js run-tool --tool grype --ip {ip} --port {port} -- dir:{path} -o json
    # MCP: run_tool {tool: "grype", ip, port, command: ["{image-ref}", "-o", "json"]}
    # {ip}/{port} are run metadata (the host the image runs on); the scan target is the first argument.

## Interpreting output

Table by default (VULN ID, TRUSTSCORE, PKG NAME, INSTALLED, FIXED-IN, TYPE, SEVERITY, MATCH TYPE);
-o json for machine-readable results including match details and package PURLs. Raw output:
<run-dir>/grype.out (or grype-custom.out for custom args).

## Safety / cost

- First run downloads the vulnerability DB (hundreds of MB) into the tool's cache dir; keep the cache warm in the container.
- Scanning a registry image pulls the image first (network + disk); prefer a local image tag or a local path when offline.
- grype matches what is present; it does not check misconfigs or secrets — use trivy for those.
- TrustScore reflects evidence quality for the CVE match; low scores warrant manual review.
