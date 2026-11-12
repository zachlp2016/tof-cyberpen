```yaml
type: entity
created: 2026-11-07
updated: 2026-11-07
sources: [raw/llm-wiki.md]
tags: [person]
```

# Andrew Karpathy

Author of the [LLM Wiki](../sources/llm-wiki.md) idea file, the pattern this workspace is built on. The file is designed to be copy-pasted to an LLM agent (OpenAI Codex, Claude Code, OpenCode/Pi, etc.), which then builds out the specifics in collaboration with the user.

Practices documented in the source:

- Works with the LLM agent open on one side and [Obsidian](obsidian.md) on the other — "Obsidian is the IDE; the LLM is the programmer; the wiki is the codebase."
- Prefers to ingest sources one at a time and stay involved — reading summaries, checking updates, guiding emphasis — rather than batch-ingest without supervision (batching is possible, but the workflow is meant to be developed and documented in the schema).
- Frames the LLM's value as maintenance: LLMs do not get bored, do not forget cross-references, and can touch 15 files in one pass (see [knowledge-compounding](../concepts/knowledge-compounding.md)).

Links: [llm-maintained-wiki](../concepts/llm-maintained-wiki.md), [memex](../concepts/memex.md) (the lineage he invokes).
