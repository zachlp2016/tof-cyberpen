# tool_usage/trivy.md — trivy shell reference

## What it does / role in the gunship

Comprehensive security scanning of container images, filesystems, directories, and git repos: vulnerability scanning (OS packages + language dependencies), misconfiguration checks, secret detection, and license checks. Not in the tier plans — on-demand: the tiers target IP:port, while trivy targets an image ref (e.g. alpine:3.19, a registry image) or a local path. Typical use: scan the image that the scanned host runs, or scan a local directory/deployment bundle.

## Status and install

    node tof-pentest/bin/tof-pentest.js tools        # shows resolution + version per tool
    bash tools/trivy/install.sh                      # latest release into tools/trivy/bin/

## Direct shell commands (manual use)

    trivy image alpine:3.19                          # vulnerability scan of a container image
    trivy image --format json --output trivy.json alpine:3.19   # machine-readable results
    trivy fs /path/to/app                            # scan a directory/filesystem (vulns, misconfigs, secrets)
    trivy image --severity HIGH,CRITICAL --ignore-unfixed alpine:3.19

Manual variants:

    trivy image --scanners vuln alpine:3.19          # vulnerabilities only
    trivy image --scanners misconfig,secret alpine:3.19    # IaC/config + hardcoded secrets only
    trivy image --scanners license --license-severity MIT,Apache-2.0 alpine:3.19
    trivy config Dockerfile                          # misconfiguration of a specific IaC file
    trivy image --list-all-pkgs alpine:3.19          # inventory (no DB needed)
    trivy image --db-repository ghcr.io/aquasecurity/trivy-db:2 alpine:3.19

## Run via the gunship

    node tof-pentest/bin/tof-pentest.js run-tool --tool trivy --ip {ip} --port {port} -- image {image-ref} --format json
    node tof-pentest/bin/tof-pentest.js run-tool --tool trivy --ip {ip} --port {port} -- fs {path}
    # MCP: run_tool {tool: "trivy", ip, port, command: ["image", "{image-ref}", "--format", "json"]}
    # {ip}/{port} are run metadata (the host the image runs on); the scan target is the argument after the tool name.

## Interpreting output

Table by default (VULN ID, status, package, installed/fixed version, severity); --format json for
machine-readable results with vulnerability detail and CVSS data. --exit-code 1 fails the command
on HIGH+ findings, useful in CI. Raw output: <run-dir>/trivy.out (or trivy-custom.out for custom args).

## Safety / cost

- First run downloads the vulnerability DB (~100–300 MB) into the tool's cache dir; keep the cache warm in the container.
- Scanning a registry image pulls the image first (network + disk); prefer a local image tag or trivy fs on an extracted bundle when offline.
- trivy fs on a large tree is slow; scope to the relevant directory.
- --ignore-unfixed hides CVEs without a fixed version (noisy on distro packages that are only fixed in newer releases).
