```yaml
type: source
created: 2026-11-07
updated: 2026-11-07
sources: [raw/llm-wiki.md]
tags: [pattern, knowledge-base, llm]
```

# LLM Wiki (source)

Source: [raw/llm-wiki.md](../../raw/llm-wiki.md) — idea file by [karpathy](../entities/karpathy.md), fetched 2026-11-07 from his GitHub gist. It is designed to be copy-pasted to an LLM agent (Codex, Claude Code, OpenCode/Pi, etc.), which then builds out the specifics in collaboration with the user. Intentionally abstract: it describes the pattern, not a specific implementation — the exact structure, conventions, and tooling are meant to be instantiated per domain.

## Key claims

1. **Anti-RAG stance.** Most LLM+document workflows (NotebookLM, ChatGPT file uploads, typical RAG) retrieve chunks at query time and rediscover knowledge from scratch on every question: "nothing is built up." The alternative is for the LLM to incrementally build and maintain a persistent, interlinked wiki between the user and the raw sources. → [rag-vs-persistent-wiki](../concepts/rag-vs-persistent-wiki.md)
2. **Compounding artifact.** Cross-references, contradiction flags, and synthesis already exist on every page; the wiki gets richer with every source and every question. Good answers to queries can be filed back into the wiki as new pages. → [knowledge-compounding](../concepts/knowledge-compounding.md)
3. **Division of labor.** The human handles sourcing, exploration, and asking the right questions; the LLM handles all the grunt work — summarizing, cross-referencing, filing, bookkeeping. The author works with the LLM agent on one side and [Obsidian](../entities/obsidian.md) on the other: "Obsidian is the IDE; the LLM is the programmer; the wiki is the codebase."
4. **Three-layer architecture.** Immutable raw sources (source of truth), the LLM-owned wiki, and the schema file (CLAUDE.md / AGENTS.md) that turns the LLM into a disciplined wiki maintainer. The schema is co-evolved over time.
5. **Three operations.** Ingest (a single source may touch 10–15 wiki pages), query (answer from the wiki; file good answers back), and lint (periodic health check: contradictions, stale claims, orphans, missing pages or references).
6. **Index and log.** `index.md` (content catalog; read first on every query) and `log.md` (append-only, grep-able entry prefixes). Claimed to work well at moderate scale (~100 sources, hundreds of pages) without embedding-based RAG infrastructure. → [index-and-logging](../concepts/index-and-logging.md)
7. **Use cases.** Personal goal/health tracking, long-running research, book companion wikis (citing Tolkien Gateway as the community-scale model), business/team wikis fed by Slack threads, meeting transcripts, and customer calls, plus competitive analysis, due diligence, trip planning, and course notes.
8. **Optional tooling.** [qmd](../entities/qmd.md) for search at scale; Obsidian Web Clipper for turning web articles into markdown; local image downloads into a fixed folder; graph view to see the shape of the wiki; Marp for slide decks; Dataview for frontmatter queries; the wiki as a git repository.
9. **Lineage.** Related in spirit to Bush's [memex](../concepts/memex.md); "the part he could not solve was who does the maintenance. The LLM handles that."

## Application in this workspace

This source bootstrapped the workspace: the three layers became `raw/`, `wiki/`, and [AGENTS.md](../../AGENTS.md); the three operations became documented workflows in the schema; new work is separated into `projects/` per the schema's work folder conventions. See [overview](../overview.md).
