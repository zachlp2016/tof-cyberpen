```yaml
type: concept
created: 2026-11-07
updated: 2026-11-07
sources: [raw/llm-wiki.md]
tags: [pattern, llm, knowledge-base]
```

# LLM-maintained wiki

Core pattern: an LLM incrementally builds and maintains a persistent, interlinked collection of markdown pages that sits between the user and the raw sources. When a new source arrives, the LLM reads it, extracts the key information, and integrates it — updating entity pages, revising topic summaries, flagging contradictions, and strengthening the synthesis — instead of merely indexing it for later retrieval.

This is the opposite of retrieval-time knowledge assembly (see [rag-vs-persistent-wiki](rag-vs-persistent-wiki.md)). The wiki is a persistent, compounding artifact: cross-references, contradiction flags, and synthesis are precomputed and kept current. Knowledge is compiled once, not re-derived on every query.

**Division of labor.** The human curates sources, explores, and asks the right questions. The LLM does all the grunt work — summarizing, cross-referencing, filing, bookkeeping. In practice: the agent on one side, a markdown knowledge base (e.g. [obsidian](../entities/obsidian.md)) on the other, with the LLM editing and the human browsing the results in real time. "Obsidian is the IDE; the LLM is the programmer; the wiki is the codebase."

**Three-layer architecture.** Immutable raw sources (source of truth), the LLM-owned wiki, and the schema file that disciplines the LLM into a wiki maintainer rather than a generic chatbot. The schema is co-evolved as the workflow matures.

**Operations.** Ingest, query (with good answers filed back), and lint — details in the source [llm-wiki](../sources/llm-wiki.md) and in the workspace schema ([AGENTS.md](../../AGENTS.md)).

**Why it works:** the maintenance that kills human wikis is near-free for an LLM — see [knowledge-compounding](knowledge-compounding.md). **Lineage:** the [memex](memex.md).
