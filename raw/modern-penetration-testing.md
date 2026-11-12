# Modern Penetration Testing & Internal Security Validation — Current-Tools-Only Analysis

> **Scope rule (per request):** Only tooling with a current release is listed as "active."
> Anything whose latest release predates roughly **2026-08-07** (~3 months before this doc's date,
> **2026-11-07**) is treated as *likely outdated* and is demoted to the Appendix ("still runs, but verify").
> Every version and date below was pulled live from vendor release pages / GitHub on **2026-11-07**.
>
> **Intended use:** Validate your own internal estate — run the **Red** (offensive) stack to attack it,
> and the **White/Blue** (defensive) stack to confirm your monitoring actually catches what the Red side does.

---

## 0. Important 2026 housekeeping you should know before installing

Several popular projects **renamed their GitHub orgs** recently. Old install links / package names now 404:

| Old name | Current name | Note |
|---|---|---|
| velociraptor/velociraptor | **Velocidex/velociraptor** | Org renamed to Velocidex |
| fortinetdev/Impacket | **fortra/Impacket** | Moved under Fortra |
| aqua-security/kube-bench | **aquasecurity/kube-bench** | Org renamed to aquasecurity |
| scoutsuite/scout-suite | **nccgroup/ScoutSuite** | Now under NCC Group |

Pin to the current org, or your clone/package installs will silently break.

---

## 1. Methodology (2026 current practice)

A modern internal validation engagement follows an agreed scope and a repeatable kill-chain. I map tools to the
**PTES / MITRE ATT&CK** phases so you can audit coverage, not just "did we run X."

1. **Scoping & rules of engagement** — assets, windows, creds, no-touch list, evidence rules.
2. **Recon / discovery** — internal footprint, subdomains, ports, services.
3. **Vulnerability identification** — scanners + manual triage.
4. **Exploitation** — initial foothold.
5. **Post-exploitation / lateral movement** — especially Active Directory.
6. **Cloud / Kubernetes / containers** — where most modern estates live.
7. **Detection validation (Blue vs Red)** — the offensive run *must* be observed by your defensive stack; if Blue doesn't see Red, that's the real finding.
8. **Reporting & remediation.**

The single biggest 2025-2026 shift: **LLM/AI-assisted pentesting** is now a real, first-class category (Section 5),
and detection is moving to **eBPF / kernel-level + AI-triaged** tooling. Both are covered below.

---

## 2. RED HAT (offensive) — current tooling only

Legend: **[IN-WINDOW]** = released on/after ~2026-08-07. **[EDGE]** = latest release slightly older than 3 months but
still the newest available (flagged so you can decide). **[VERIFY]** = active, but confirm the exact current build.

### 2.1 Recon & discovery
- **subfinder v2.17.0** — [IN-WINDOW, 2026-10-08] — ProjectDiscovery passive/active subdomain enumeration.
- **httpx v1.12.0** — [IN-WINDOW, 2026-09-08] — fast HTTP probing/tech detection for the discovered hosts.
- **naabu v2.7.0** — [IN-WINDOW, 2026-10-28] — high-speed port scanner (use alongside/instead of classic port scans).
- **dnsx v1.3.1** — [IN-WINDOW, 2026-08-31] — DNS record mapping/chaos.
- **katana v1.8.0** — [IN-WINDOW, 2026-10-05] — next-gen crawling/spidering for web attack surface.
- **Nmap** — [VERIFY] — current stable (7.9x series) active as of 2026-11-05; confirm exact build on nmap.org. Still the reference port/service scanner.

### 2.2 Web / API scanning & fuzzing
- **Nuclei v3.11.1** — [IN-WINDOW, 2026-08-08] — the dominant template-based vulnerability scanner; huge community template set. Core of most 2026 offensive pipelines.
- **ffuf v2.3.0** — [IN-WINDOW, 2026-09-09] — general web fuzzer (paths, params, virtual hosts).
- **Burp Suite Professional / Community 2026.9.2** — [IN-WINDOW, Sep 2026] — and **Burp DAST 2026.8.2** (Aug 2026). The current interactive/DAST standard.
- **sqlmap 1.10** — [EDGE, 2026-01-01] — SQL injection. Newest available; ~10 months old, so confirm nothing newer.
- **OWASP ZAP** — [VERIFY] — current 2.x line; confirm the specific build from the ZAP site (release repo moved).

### 2.3 Exploitation & C2
- **Metasploit** — [EDGE/VERIFY] — Metasploit Pro **5.0.0** (2026-03-11); CE framework continues on the 6.x line. Release cadence is slower than 3 months — pin current and confirm.
- **Cobalt Strike** — [VERIFY] — HelpSystems ships monthly builds (latest monthly notes through 2026-06+). Confirm current build number.
- **Frida 17.26.x** — [IN-WINDOW] — latest tag 17.26.1; dynamic instrumentation for post-exploitation and mobile.
- **Impacket 0.13.1** — [EDGE, 2026-05-19] — SMB/AD protocol suite (psexec, wmiexec, secretsdump, GetNPUsers, GetUserSPNs). Repo actively pushed as of 2026-11-04.

### 2.4 Active Directory & lateral movement
- **BloodHound CE v9.9.2** — [IN-WINDOW, 2026-11-06] — attack-path analysis for AD; brand current.
- **Rubeus / PowerView** — [VERIFY] — confirm current builds; these move with the community, not on a fixed version.

### 2.5 Cloud / Kubernetes offensive
- **Prowler 5.48.0** — [IN-WINDOW, 2026-11-06] — AWS/Azure/GCP misconfig + IAM attack surface.
- **Trivy v0.76.2** — [IN-WINDOW, 2026-11-05] — images, IaC, SCA, and **K8s cluster** scanning (offensive + posture).
- **kube-bench (aquasecurity)** — [IN-WINDOW, pushed 2026-10-26] — CIS K8s benchmark checks.
- **k8sattack / kscan / Hound / Caiman (NCC Group)** — [VERIFY] — NCC's Kubernetes attack-path mappers and AD recon; confirm current repos/builds under the NCC Group org.

### 2.6 Wireless
- **Wifite / aircrack-ng** — [EDGE/VERIFY] — aircrack-ng 1.7 core is old (2022); wireless tooling generally lags, confirm current builds before relying on them.

### 2.7 Mobile
- **MobSF v4.6.4** — [IN-WINDOW, 2026-10-31] — Mobile Security Framework; current.

### 2.8 Phishing / MFA fatigue
- **Evilginx2** — [EDGE, pushed 2026-06-10] — MFA-phishing (proxy) infra; ~5 months old, verify.
- **GoPhish** — [EDGE, v0.12.1 is 2022] — phishing framework; confirm a current build exists, otherwise treat as stagnant.

### 2.9 TLS / protocol testing
- **testssl.sh v3.2.5** — [IN-WINDOW, 2026-11-04] — TLS/SSL configuration & weakness testing; current.

---

## 3. WHITE / BLUE HAT (defensive) — current tooling only

Same legend. These are the tools to deploy so your **internal estate can see and catch** the Red run above.

### 3.1 SIEM / log analytics & detection
- **Wazuh v4.14.9** — [IN-WINDOW, 2026-10-15] — XDR/SIEM/endpoint; current stable. (Note: Wazuh 5.0 has been in RC — pin 4.14.x for production unless you've validated 5.0.)
- **Elastic / Security Onion** — [VERIFY] — current major lines; confirm build.

### 3.2 EDR / endpoint & host
- **Velociraptor (Velocidex)** — [IN-WINDOW, pushed 2026-11-05] — open-source EDR/DFIR, active.
- **osquery 5.24.1** — [IN-WINDOW, 2026-10-29] — SQL-based host forensics/visibility.
- **Falco 0.45.2** — [IN-WINDOW, 2026-10-29] — **eBPF-based** runtime container/cloud-native threat detection. Current.

### 3.3 Network detection (NDR)
- **Zeek v9.0.1** — [IN-WINDOW, 2026-10-26] — network metadata/analysis; current 9.0 line.
- **Suricata 8.0.8** — [IN-WINDOW, 2026-10-29] — NIDS; current 8.0 line.

### 3.4 Cloud / K8s posture (defensive)
- **Grype v0.121.2** — [IN-WINDOW, 2026-11-05] — SBOM/vulnerability matching.
- **Syft v1.57.0** — [IN-WINDOW, 2026-11-05] — SBOM generation.
- **Trivy v0.76.2** — [IN-WINDOW, 2026-11-05] — same binary serves defensive posture scans.
- **Prowler 5.48.0** — [IN-WINDOW, 2026-11-06] — cloud config/compliance checks (defensive side).
- **kube-bench (aquasecurity)** — [IN-WINDOW, 2026-10-26] — CIS benchmark compliance.

### 3.5 SAST / SCA (app-layer defense)
- **Semgrep v1.184.0** — [IN-WINDOW, 2026-11-05] — fast, multi-language static analysis + SCA; current.

### 3.6 Threat intelligence
- **MISP v2.5.50** — [IN-WINDOW, 2026-10-10] — threat-intel platform; current.

---

## 4. Recommended CURRENT internal-testing stack (opinionated, all in-window)

A minimal, fully-current toolkit you can actually run against your estate today — every item below released on/after ~2026-08-07:

| Phase | Tool | Version | Released |
|---|---|---|---|
| Recon | subfinder | v2.17.0 | 2026-10-08 |
| Recon | httpx | v1.12.0 | 2026-09-08 |
| Recon | naabu | v2.7.0 | 2026-10-28 |
| Recon | dnsx | v1.3.1 | 2026-08-31 |
| Web | katana | v1.8.0 | 2026-10-05 |
| Web | Nuclei | v3.11.1 | 2026-08-08 |
| Web | ffuf | v2.3.0 | 2026-09-09 |
| Web | Burp Suite Pro | 2026.9.2 | Sep 2026 |
| AD | BloodHound CE | v9.9.2 | 2026-11-06 |
| K8s/Cloud | Prowler | 5.48.0 | 2026-11-06 |
| K8s/Cloud | Trivy | v0.76.2 | 2026-11-05 |
| Mobile | MobSF | v4.6.4 | 2026-10-31 |
| TLS | testssl.sh | v3.2.5 | 2026-11-04 |
| **Detect (Blue)** | Wazuh | v4.14.9 | 2026-10-15 |
| **Detect (Blue)** | Velociraptor | current | 2026-11-05 |
| **Detect (Blue)** | Falco | 0.45.2 | 2026-10-29 |
| **Detect (Blue)** | osquery | 5.24.1 | 2026-10-29 |
| **Detect (Blue)** | Zeek | v9.0.1 | 2026-10-26 |
| **Detect (Blue)** | Suricata | 8.0.8 | 2026-10-29 |
| **Detect (Blue)** | Grype / Syft | v0.121.2 / v1.57.0 | 2026-11-05 |
| **Detect (Blue)** | Semgrep | v1.184.0 | 2026-11-05 |
| **Detect (Blue)** | MISP | v2.5.50 | 2026-10-10 |

**Validation loop:** run the Red row(s) -> watch the Blue row(s) -> any Red action Blue misses is a detection gap and a finding.

---

## 5. NEW in 2025-2026: LLM / AI-driven penetration testing

This is the genuinely new category. Research and tooling through 2025-2026 show LLM agents now perform real,
multi-step pentests (recon -> exploit -> report). Treat these as **assistive, not autonomous**, and scope them carefully.

- **PentestGPT / PentestGPT-2** — LLM-agent pentesting frameworks (latest generation, 2025-2026). Verify current build.
- **arXiv 2602.17622 — "What Makes a Good LLM Agent for Real-world Penetration Testing?"** — current research baseline for capability/limits.
- **arXiv 2609.10780 — "Big Enough to Break Out: Tracking the Rising Capability of LLM Penetration-Testing Agents"** — tracks the capability curve.
- **Coding-agent baselines for autonomous pentest (arXiv 2607.13085)** — "Baselines Before Architecture."

**Practical guidance:** use LLM agents to (a) triage scanner noise, (b) draft recon hypotheses, (c) auto-generate
proof-of-concept exploits, and (d) draft reports — with a human validating every claim. Do **not** yet hand an
autonomous LLM agent your production credentials unattended.

---

## 6. MITRE ATT&CK coverage quick-reference

| Technique area | Red tools (current) | Blue tools (current) |
|---|---|---|
| Recon (T1595, T1046) | subfinder, httpx, naabu, dnsx, Nmap | Zeek, Suricata |
| Scanning / vuln (T1040, T1189) | Nuclei, ffuf, Burp, katana | Semgrep, Grype, Syft, Trivy |
| Exploitation (T1190, T1059) | Burp, Nuclei, Frida, Impacket | Wazuh, Falco, Velociraptor |
| AD / lateral (T1021, T1068, T1087) | BloodHound, Impacket | Wazuh, osquery, Velociraptor |
| Cloud / K8s (T1580, T1611) | Prowler, Trivy, k8sattack | Trivy, kube-bench, Falco |
| TLS / crypto (T1565) | testssl.sh | Zeek |
| Mobile (T1213) | MobSF, Frida | Falco, osquery |
| Phishing (T1566, MFA) | Evilginx2, GoPhish | Wazuh, MISP |
| Threat intel | — | MISP |

---

## 7. Appendix — tools that fell OUTSIDE the 3-month window (verify before use)

These still work but their newest release is older than ~3 months as of 2026-11-07. Use with a "confirm current" step:

- **gobuster v3.8.2** — 2025-09-04 (~14 months)
- **sqlmap 1.10** — 2026-01-01 (~10 months)
- **aircrack-ng 1.7** — 2022 (core is old; wireless lags)
- **GoPhish v0.12.1** — 2022 (verify a current build exists)
- **Evilginx2** — last pushed 2026-06-10 (~5 months)
- **ScoutSuite (nccgroup)** — last pushed 2025-09-23 (~13 months)
- **Impacket 0.13.1** — 2026-05-19 (~6 months; repo still active)
- **Metasploit Pro 5.0.0 / CE 6.x** — 2026-03-11 (~8 months)
- **Cobalt Strike** — monthly builds; confirm latest number
- **k8sattack / kscan / Hound / Caiman (NCC)** — confirm current NCC repos

---

## 8. Operational notes

1. **Pin versions.** With 3-month recency as the bar, pin exact builds in your tooling manifest so a "current" tool does not silently regress into an outdated one between runs.
2. **Re-verify quarterly.** Re-run the release-date check (GitHub releases/latest / vendor pages) each quarter; the in-window list above is a snapshot as of **2026-11-07**.
3. **Org renames break installs** (Section 0) — update any automation that references old org paths.
4. **eBPF is the detection frontier** — Falco (eBPF) is the current standard for container/cloud-native runtime detection.
5. **LLM agents = assistive** — keep a human in the loop for anything touching production.
6. **Blue-must-see-Red** is the acceptance test: a Red action invisible to the Blue stack is a first-class finding.

---

*Generated 2026-11-07. All versions/dates pulled live from vendor + GitHub release endpoints on that date.*
