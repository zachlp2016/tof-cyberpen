# Wiki Index

Catalog of every page in this wiki, with a one-line summary each. Updated on every ingest and page creation. Read this first when answering a query.

## Overview

- [overview](overview.md) — Current synthesis: the LLM-maintained wiki pattern and how this workspace instantiates it.

## Sources

- [llm-wiki](sources/llm-wiki.md) — Karpathy's idea file for LLM-maintained personal knowledge bases; the pattern this workspace is built on. Ingested 2026-11-07.

## Concepts

- [llm-maintained-wiki](concepts/llm-maintained-wiki.md) — Core pattern: the LLM incrementally builds and maintains a persistent, interlinked wiki instead of re-deriving knowledge per query.
- [rag-vs-persistent-wiki](concepts/rag-vs-persistent-wiki.md) — Contrast with RAG: retrieval-time knowledge assembly versus a compiled, maintained knowledge base.
- [knowledge-compounding](concepts/knowledge-compounding.md) — Why the pattern works: near-zero maintenance cost for the LLM makes the knowledge base compound instead of decay.
- [index-and-logging](concepts/index-and-logging.md) — The two special files (content index, chronological log) that keep a wiki navigable and auditable as it grows.
- [memex](concepts/memex.md) — Vannevar Bush's 1945 vision of a curated knowledge store with associative trails; the conceptual ancestor of the pattern.

## Entities

- [karpathy](entities/karpathy.md) — Author of the source pattern.
- [vannevar-bush](entities/vannevar-bush.md) — Originator of the memex concept.
- [qmd](entities/qmd.md) — Local markdown search engine (hybrid BM25/vector, LLM re-ranking), with CLI and MCP interfaces.
- [obsidian](entities/obsidian.md) — Markdown knowledge base app; the browsing/IDE side of the workflow.

## Analyses

No analyses filed yet. Filed answers to substantial queries will appear here.
