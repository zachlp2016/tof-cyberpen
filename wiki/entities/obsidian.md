```yaml
type: entity
created: 2026-11-07
updated: 2026-11-07
sources: [raw/llm-wiki.md]
tags: [tool, knowledge-base]
```

# Obsidian

A markdown knowledge-base app. In the [llm-wiki](../sources/llm-wiki.md) source it is the browsing/IDE side of the workflow: the human keeps it open alongside the LLM agent, following links, checking the graph view, and reading updated pages in real time while the LLM makes edits. "Obsidian is the IDE; the LLM is the programmer; the wiki is the codebase."

Features highlighted in the source:

- **Web Clipper** extension — converts web articles to markdown for the raw collection.
- **Local image downloads** — bind the "Download attachments for current file" hotkey and set a fixed attachment folder (e.g. `raw/assets/`) so clipped articles' images land on local disk and the LLM can view them directly. Note: the LLM reads the text first, then views referenced images separately.
- **Graph view** — the best way to see the shape of the wiki: hubs, orphans, what connects to what (complements the lint operation).
- **Marp plugin** — slide decks generated directly from wiki content.
- **Dataview plugin** — queries over page frontmatter (tags, dates, source counts).

Status in this workspace: optional. The wiki is plain git-versioned markdown; pointing Obsidian at this directory gives the browsing side without any change to the schema.
