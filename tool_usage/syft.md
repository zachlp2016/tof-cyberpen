# tool_usage/syft.md — syft shell reference

## What it does / role in the gunship

Generates Software Bill of Materials (SBOMs) from container images, running containers, and filesystems: catalogs OS packages, language dependencies, and application metadata in CycloneDX or SPDX. Not in the tier plans — on-demand: the tiers target IP:port, while syft targets an image ref or a local path. Feeds grype (sbom: input) and any external SCA pipeline; the SBOM is the durable artifact — keep it with the run.

## Status and install

    node tof-pentest/bin/tof-pentest.js tools        # shows resolution + version per tool
    bash tools/syft/install.sh                       # latest release into tools/syft/bin/

## Direct shell commands (manual use)

    syft alpine:3.19 -o cyclonedx-json               # CycloneDX SBOM of a container image
    syft alpine:3.19 -o spdx-json                    # SPDX SBOM of a container image
    syft dir:/path/to/app -o cyclonedx-json          # SBOM of a directory/filesystem
    syft alpine:3.19 -o json > sbom.json             # syft JSON (input for grype sbom:)

Manual variants:

    syft alpine:3.19 -o cyclonedx-json --file-outputs sbom.cdx.json
    syft alpine:3.19 -o table                        # human-readable catalog (default output)
    syft dir:/path --only-packages npm,golang        # restrict to specific package ecosystems
    syft alpine:3.19 -o json --platform alpine       # select a specific distro platform
    syft container:myrunningcontainer -o cyclonedx-json    # scan a running container (needs docker)

## Run via the gunship

    node tof-pentest/bin/tof-pentest.js run-tool --tool syft --ip {ip} --port {port} -- {image-ref} -o cyclonedx-json
    node tof-pentest/bin/tof-pentest.js run-tool --tool syft --ip {ip} --port {port} -- dir:{path} -o cyclonedx-json
    # MCP: run_tool {tool: "syft", ip, port, command: ["{image-ref}", "-o", "cyclonedx-json"]}
    # {ip}/{port} are run metadata (the host the image runs on); the scan target is the first argument.

## Interpreting output

Table by default (name, version, type, license, digest); JSON/CycloneDX/SPDX for machine-readable
SBOMs. Feed the syft JSON to grype: grype sbom:./sbom.json. Raw output: <run-dir>/syft.out (or
syft-custom.out for custom args); keep the SBOM file with the run artifacts.

## Safety / cost

- Syft catalogs, it does not match CVEs — pair with grype for vulnerability results.
- Scanning a registry image pulls the image first (network + disk); prefer a local image tag or a local path when offline.
- Large monorepos produce large SBOMs; scope to the relevant directory with dir:.
- No vulnerability-DB download needed (faster first run than trivy/grype).
