# Brain Combo Graph Memory Workflow

## Status Check

Run:

```bash
bash ~/.codex/skills/brain-combo/scripts/check-codebase-memory.sh
```

Use the output to decide which graph assets are available:

- GitNexus available and indexed: use CLI commands or MCP tools when exposed.
- GitNexus available and stale: refresh with `npx -y gitnexus@latest analyze` from the repo root. Preserve embeddings with `--embeddings` when `.gitnexus/meta.json` reports a positive `stats.embeddings` count.
- Graphify available and `graphify-out/` present: read/query the graph.
- Graphify available and `graphify-out/` absent: build it when the user wants persistent second-brain memory.

## GitNexus Commands

Source: https://github.com/abhigyanpatwari/GitNexus

List indexed repos:

```bash
npx -y gitnexus@latest list
```

Check current repo status:

```bash
npx -y gitnexus@latest status
```

Query concepts:

```bash
npx -y gitnexus@latest query -r <repo-name> "auth flow"
```

Inspect one symbol:

```bash
npx -y gitnexus@latest context -r <repo-name> <symbol-name>
```

Run blast-radius analysis before editing a symbol:

```bash
npx -y gitnexus@latest impact -r <repo-name> <symbol-name>
```

Use explicit `-r <repo-name>` when more than one repository is indexed.

## Graphify Commands

Source: https://github.com/safishamsi/graphify

Install the Graphify CLI:

```bash
uv tool install --upgrade graphifyy
graphify install --platform codex
```

Build a graph:

```bash
graphify extract .
```

Refresh code extraction after normal source edits:

```bash
graphify update .
```

Query the graph:

```bash
graphify query "show the auth flow"
graphify path "UserService" "DatabasePool"
graphify explain "RateLimiter"
graphify affected "UserService"
```

Open human-readable assets:

```text
graphify-out/GRAPH_REPORT.md
graphify-out/graph.html
graphify-out/graph.json
```

Serve Graphify through MCP when repeated structured graph calls are useful:

```bash
python3 -m graphify.serve graphify-out/graph.json
```

Graphify can also serve HTTP for a team-shared graph. Bind beyond localhost only with an API key.

## Coexistence Rules

Use GitNexus first for code execution semantics:

- Symbol definitions
- Direct and indirect callers
- Refactor blast radius
- Execution flows
- Change detection

Use Graphify first for broad semantic memory:

- Architecture summaries
- Cross-document concepts
- Specs, ADRs, README files, SQL, infrastructure, PDFs, and media
- Human-readable reports and visual graph browsing
- Questions that connect code to docs or external artifacts

Use both for high-risk changes:

1. Ask Graphify for the broad concept map.
2. Ask GitNexus for the exact symbols and impact.
3. Read raw files that own the implementation.
4. Run checks that match the blast radius.

## RefRoute Defaults

Active repo:

```text
/Users/slava/Downloads/vibework/refroute
```

Required memory files:

```text
CLAUDE.md
REFROUTEREVISED.md
docs/decisions/001-optimizer-ranking-and-status-semantics.md
```

GitNexus repo name:

```text
refroute
```

Known GitNexus CLI issue on this machine: more than one repository is indexed, so commands that omit `-r refroute` can fail with a multiple-repository error.

## Setup Notes

Install Graphify when the user asks to add it:

```bash
uv tool install --upgrade graphifyy
graphify install --platform codex
```

For MCP support:

```bash
uv tool install "graphifyy[mcp]"
python3 -m graphify.serve graphify-out/graph.json
```

Graphify `0.8.44` also supports `graphify global add`, `graphify global list`, `graphify merge-graphs`, `graphify tree`, and `graphify export callflow-html` for larger second-brain workflows.

## Version Baseline

Brain Combo was created from these upstream projects and re-verified on June 21, 2026:

```text
GitNexus: 1.6.8, https://github.com/abhigyanpatwari/GitNexus
Graphify: 0.8.44, https://github.com/safishamsi/graphify
```

Use the local CLI version for behavior decisions in a repo. Use the upstream repositories and registries as upgrade context.
