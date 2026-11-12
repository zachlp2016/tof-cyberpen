# Penetration Testing Stack — Software Availability Checklist

> **Audit date:** 2026-11-07 (11:45 ET) · **Re-verified:** 2026-11-07 (12:15 ET) after testssl.sh fix · **Re-verified:** 2026-11-07 (14:11 ET) after dnsx addition · **Re-verified:** 2026-11-07 (15:50 ET) after trivy/grype/syft addition + installer asset-selection fix · **Re-verified:** 2026-11-10 (12:20 ET) after image rebuild (prior image had been pruned from the Docker store) — all 13 tools re-probed in-container, versions current (sqlmap 1.10.11.9#dev, grype v0.121.3, syft v1.57.1) · **Audited image:** `tof-ai-pentester:latest` (rebuilt 2026-11-07, linux/arm64; previous audited ids f9afde2039cf, c5f60d5b7cfa, 49c0a6356bbb)
> **Stipulation source:** [raw/modern-penetration-testing.md](raw/modern-penetration-testing.md) (research snapshot dated 2026-11-07; §2–§4 tool lists, §7 appendix)
> **Method:** live probes executed inside the container (`docker run --rm --entrypoint sh tof-ai-pentester`) — every binary version-checked, not just presence-checked.

**Bottom line:** the container fully covers the gunship tier plan (13 of 13 vendored tools work — testssl.sh fixed, subfinder + dnsx added 2026-11-07, trivy + grype + syft added 2026-11-07, installer asset-selection bug fixed 2026-11-07, see §B/§C). Against the research's full stipulated stack: **11 of the 23 §4-table tools work (13 counting nmap + sqlmap per their §2.1/§2.2 cross-references); 12 remain** (Burp, BloodHound, Prowler, MobSF, Wazuh, Velociraptor, Falco, osquery, Zeek, Suricata, Semgrep, MISP).

## A. Installed & verified working (re-run probes to re-verify)

- [x] **nmap** — 7.93 (research: 7.9x series, §2.1)
- [x] **naabu** — 2.7.0 (research: v2.7.0, §2.1/§4)
- [x] **httpx** — v1.12.0 (research: v1.12.0, §2.1/§4)
- [x] **katana** — v1.8.0 (research: v1.8.0, §2.1/§4)
- [x] **nuclei** — v3.11.1 (research: v3.11.1, §2.2/§4)
- [x] **ffuf** — 2.3.0 (research: v2.3.0, §2.2/§4)
- [x] **sqlmap** — 1.10.11.9#dev (research: 1.10, EDGE §2.2)
- [x] **testssl.sh** — 3.3dev (research pins v3.2.5, §2.9/§4) — fixed & re-verified 2026-11-07
- [x] **subfinder** — v2.17.0 (research: v2.17.0, §2.1/§4) — added & re-verified 2026-11-07
- [x] **dnsx** — v1.3.1 (research: v1.3.1, §2.1/§4) — added & re-verified 2026-11-07
- [x] **trivy** — v0.76.2 (research: v0.76.2, §2.5/§4) — added & re-verified 2026-11-07
- [x] **grype** — v0.121.3 (research: v0.121.2, §3.4/§4) — added & re-verified 2026-11-07
- [x] **syft** — v1.57.1 (research: v1.57.0, §3.4/§4) — added & re-verified 2026-11-07

## B. Present but broken

- [x] **testssl.sh** — RESOLVED 2026-11-07 (now in §A): was on PATH, vendored 3.3dev (research pins v3.2.5, §2.9/§4); `--version` failed: "You need to install hexdump".
  - Cause: container lacked `bsdmainutils` (provides `hexdump`) **and** `procps` (provides `ps`). openssl 3.0.22, perl 5.36, python 3.11 all present.
  - Fix applied: added `bsdmainutils procps` to the apt line in [docker/Dockerfile](docker/Dockerfile), rebuilt, re-probed: `testssl.sh --version` now reports 3.3dev (OpenSSL 3.0.22, bash 5.2.15), exit 0.
  - Note: status doc's in-container verification ran `--type basic` (nmap only); `tls-test` is an `extensive`-tier step, so testssl was never exercised in the container.
- [x] **installer OS-asset selection bug** — RESOLVED 2026-11-07 (latent, caught while verifying trivy/grype/syft): the release-asset regex in all 9 binary installers allowed a cross-OS alternation (`linux|macOS|darwin`), and `head -n 1` took the first matching URL in the API listing order. Anchore lists `*_darwin_arm64*` assets first, so Linux builds fetched the darwin Mach-O binaries for grype/syft — `Exec format error` at runtime. Fix: same-OS spelling variants only (`OSALT`: darwin|macOS for darwin, exact OS otherwise), applied to all 9 installers; image rebuilt and re-verified (all 13 assets `linux_arm64`, all tools version-checked in-container).

## C. Stipulated by research — missing from image (Red/offensive)

- [x] **subfinder** — RESOLVED 2026-11-07 (now in §A): vendored v2.17.0 (released 2026-10-08, §2.1/§4); installer + tool_usage ref added, re-verified in rebuilt image.
- [x] **dnsx** — RESOLVED 2026-11-07 (now in §A): vendored v1.3.1 (released 2026-08-31, §2.1/§4); installer + tool_usage ref added, re-verified in rebuilt image.
- [ ] **Burp Suite Pro** — 2026.9.2 (§2.2/§4); Java runtime also absent
- [ ] **BloodHound CE** — v9.9.2 (released 2026-11-06, §2.4/§4)
- [ ] **Prowler** — 5.48.0 (released 2026-11-06, §2.5/§4)
- [ ] **MobSF** — v4.6.4 (released 2026-10-31, §2.7/§4)
- [ ] **Frida** — 17.26.x (§2.3)
- [ ] **Impacket** — 0.13.1 (EDGE, §2.3); no psexec.py/secretsdump.py on the python path

## D. Stipulated by research — missing from image (Blue/defensive, §3/§4)

- [ ] **Wazuh** — v4.14.9 (§3.1)
- [ ] **Velociraptor** (Velocidex) — current, vctl (§3.2)
- [ ] **Falco** — 0.45.2 (§3.2)
- [ ] **osquery** — 5.24.1 (§3.2)
- [ ] **Zeek** — v9.0.1 (§3.3)
- [ ] **Suricata** — 8.0.8 (§3.3)
- [ ] **Semgrep** — v1.184.0 (§3.5)
- [ ] **MISP** — v2.5.50 (§3.6)

## E. Appendix/§2 extras — also missing

- [ ] **aircrack-ng** — 1.7 (EDGE, §2.6)
- [ ] **gobuster** — v3.8.2 (out-of-window, §7)
- [ ] **Metasploit** — msfconsole (EDGE, §2.3)
- [ ] **kscan** (NCC Group) — §2.5/§7

## F. Recommended next actions

- [x] 1. Patch [docker/Dockerfile](docker/Dockerfile): add `bsdmainutils` (hexdump) + `procps` (ps) → rebuild → re-run testssl probe. *(done 2026-11-07 — 2-line fix; testssl.sh 3.3dev verified working)*
- [ ] 2. Decide on §4 coverage gap: install the remaining in-window CLI tools (Prowler, Semgrep, Impacket, Frida) vs. keep the container at its current 13-tool scope. *(subfinder, dnsx, Trivy, Grype, Syft added 2026-11-07.)*
- [ ] 3. Platform services (Wazuh, MISP, Falco, Zeek, Suricata, BloodHound) are heavyweight — better run as separate containers than baked into this image.
- [ ] 4. Re-verify quarterly per research §8 (release-window snapshot is 2026-11-07).

## Re-verification probe (run from the repo root)

```sh
docker run --rm -i --entrypoint sh tof-ai-pentester <<'EOF'
for t in nmap naabu httpx katana nuclei ffuf sqlmap testssl.sh subfinder dnsx trivy grype syft; do
  printf '%-12s ' "$t"; command -v "$t" >/dev/null 2>&1 && echo present || echo MISSING
done
nmap --version | head -1
naabu -version 2>&1 | grep -i version
httpx -version 2>&1 | grep -i version
katana -version 2>&1 | grep -i version
nuclei -version 2>&1 | grep -i version
ffuf -V
sqlmap --version | head -1
testssl.sh --version 2>&1 | head -2
subfinder -version 2>&1 | grep -i version
dnsx -version 2>&1 | grep -i version
trivy --version 2>&1 | head -1
grype version 2>&1 | grep -iE '^\s*Version' | head -1
syft version 2>&1 | grep -iE '^\s*Version' | head -1
EOF
```
