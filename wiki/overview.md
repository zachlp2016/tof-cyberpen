```yaml
type: overview
created: 2026-11-07
updated: 2026-11-07
tags: [synthesis]
```

# Overview

This workspace is an implementation of the LLM-maintained wiki pattern described in [llm-wiki.md](sources/llm-wiki.md), an idea file by [karpathy](entities/karpathy.md).

**The core idea.** Instead of retrieving chunks from raw documents at query time (RAG), the LLM incrementally builds and maintains a persistent, interlinked markdown wiki between the user and the raw sources. Knowledge is compiled once and kept current; it compounds instead of decaying. The human curates sources and asks questions; the LLM does all the summarizing, cross-referencing, filing, and reconciliation. See [llm-maintained-wiki](concepts/llm-maintained-wiki.md) and [rag-vs-persistent-wiki](concepts/rag-vs-persistent-wiki.md).

**Why it works.** The maintenance that kills human-maintained wikis — bookkeeping across many pages — costs the LLM almost nothing, so the wiki stays maintained and grows in value with every source and every question. See [knowledge-compounding](concepts/knowledge-compounding.md).

**How it is implemented here.** Three layers: `raw/` (immutable sources), `wiki/` (LLM-owned pages), and [AGENTS.md](../AGENTS.md) (the schema that disciplines the LLM). Navigation uses [index-and-logging](concepts/index-and-logging.md) rather than embedding-based RAG. New work is separated into `projects/`, one folder per work item, and durable knowledge is promoted from projects into the wiki.

**Lineage.** The pattern descends from Vannevar Bush's [memex](concepts/memex.md) ([vannevar-bush](entities/vannevar-bush.md)); the part of Bush's design that was never solved — who does the maintenance — is handled by the LLM.

## Current state

- One source ingested: [llm-wiki](sources/llm-wiki.md) (2026-11-07).
- Active project: [penetration](../projects/penetration/README.md) — the TOF penetration **gunship** is built and verified (2026-11-07): `tof-pentest/` (CLI + MCP orchestrator), 8 vendored tools under `tools/<tool>/`, agent references in `tool_usage/`, entry point [projects/penetration/agents.md](../projects/penetration/agents.md), Docker image `tof-ai-pentester` in `docker/`. See [projects/README.md](../projects/README.md).
- Timeline: [log.md](log.md).
