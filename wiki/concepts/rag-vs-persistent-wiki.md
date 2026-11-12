```yaml
type: concept
created: 2026-11-07
updated: 2026-11-07
sources: [raw/llm-wiki.md]
tags: [pattern, rag, comparison]
```

# RAG vs. persistent wiki

The LLM wiki pattern is explicitly contrasted with retrieval-augmented generation (RAG) and its commercial forms (NotebookLM, ChatGPT file uploads):

| | RAG | LLM-maintained wiki |
|---|---|---|
| Where knowledge lives | Raw documents, retrieved at query time | Persistent, interlinked wiki pages |
| Per-query behavior | Find and piece together relevant fragments each time | Read already-integrated pages |
| Accumulation | None — knowledge is rediscovered from scratch per question | Compounds with every source and query |
| Synthesis across documents | Re-derived on every question | Precomputed and kept current |
| Infrastructure | Embeddings, vector index | Index file + grep at moderate scale |

The RAG failure mode: a question that requires synthesizing five documents must be re-solved every time, and "nothing is built up." The wiki failure mode: maintenance cost — addressed by making the LLM, not the human, the maintainer ([knowledge-compounding](knowledge-compounding.md)).

The contrast is not entirely one-sided: RAG scales to unbounded corpora without per-document processing cost, and it is a document-search pattern, not a knowledge-base pattern. The wiki pattern is recommended for moderate scale — the source cites ~100 sources / hundreds of pages as workable without embedding-based infrastructure — and relies on [index-and-logging](index-and-logging.md) as its navigation mechanism. Source: [llm-wiki](../sources/llm-wiki.md).
