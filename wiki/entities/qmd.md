```yaml
type: entity
created: 2026-11-07
updated: 2026-11-07
sources: [raw/llm-wiki.md]
tags: [tool, search]
```

# qmd

A local search engine for markdown files (GitHub: tobi/qmd), named in the [llm-wiki](../sources/llm-wiki.md) source as the recommended option once a wiki outgrows index-file navigation: hybrid BM25/vector search and LLM re-ranking, all on-device, with both a CLI (so an LLM can shell out to it) and an MCP server (so an LLM can use it as a native tool). A simpler home-grown search script is the fallback option as the need arises.

Status in this workspace: deferred. The schema ([AGENTS.md](../../AGENTS.md)) defers search tooling until the wiki stops being navigable via [index.md](../index.md) + grep (roughly 100+ pages). See [index-and-logging](../concepts/index-and-logging.md).
