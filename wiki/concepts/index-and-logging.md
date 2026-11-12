```yaml
type: concept
created: 2026-11-07
updated: 2026-11-07
sources: [raw/llm-wiki.md]
tags: [pattern, navigation, bookkeeping]
```

# Index and logging

The source pattern prescribes two special files that keep a wiki navigable and auditable as it grows. They serve different purposes:

- **`index.md` — content-oriented.** A catalog of everything in the wiki: each page listed with a link, a one-line summary, and optionally metadata such as date or source count. Updated on every ingest. When answering a query, the LLM reads the index first, then drills into the relevant pages. The source claims this works well at moderate scale (~100 sources, hundreds of pages) and avoids embedding-based RAG infrastructure.
- **`log.md` — chronological.** An append-only record of what happened and when: ingests, queries, lint passes. Each entry starts with a consistent prefix (e.g. `## [2026-04-02] ingest | Article Title`) so the log is parseable with simple unix tools — `grep "^## \[" log.md | tail -5` gives the last five entries. The log records the timeline of the wiki's evolution.

Implementation in this workspace: [index.md](../index.md) and [log.md](../log.md), with the entry format fixed in the schema ([AGENTS.md](../../AGENTS.md)). Search tooling (e.g. [qmd](../entities/qmd.md)) is deferred until the index stops being sufficient. Source: [llm-wiki](../sources/llm-wiki.md).
