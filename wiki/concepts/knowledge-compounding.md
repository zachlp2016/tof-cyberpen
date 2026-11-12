```yaml
type: concept
created: 2026-11-07
updated: 2026-11-07
sources: [raw/llm-wiki.md]
tags: [pattern, maintenance, knowledge-base]
```

# Knowledge compounding

Why LLM-maintained wikis work where human wikis die: the tedious part of maintaining a knowledge base is not the reading or the thinking — it is the bookkeeping. Updating cross-references, keeping summaries current, flagging contradictions, maintaining consistency across many pages. Humans abandon wikis because the maintenance burden grows faster than the value. LLMs do not get bored, do not forget to update a cross-reference, and can touch 15 files in one pass, so the cost of maintenance is near zero and the wiki stays maintained.

Two compounding loops:

1. **Ingest loop.** Each new source enriches not just its own summary page but also entity, concept, and synthesis pages — a single source can touch 10–15 pages.
2. **Query loop.** Good answers (comparisons, analyses, discovered connections) are filed back into the wiki as new pages instead of disappearing into chat history, so exploration compounds exactly like ingested sources do.

The human's role in the loop: curate sources, direct the analysis, ask good questions, and think about what it all means. The LLM's role: everything else. This is the maintenance problem that the [memex](memex.md) could not solve. See [llm-maintained-wiki](llm-maintained-wiki.md) and the source [llm-wiki](../sources/llm-wiki.md).
