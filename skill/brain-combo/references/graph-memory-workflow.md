# Brain Combo Graph Memory Workflow

## Status Check

Run:

```bash
bash ~/.codex/skills/brain-combo/scripts/check-codebase-memory.sh
```

Use the output to decide which graph assets are available:

- GitNexus available and indexed: use CLI commands or MCP tools when exposed.
- GitNexus available and stale: refresh with `gitnexus analyze --index-only` from the repo root, or use the project-local runner when present. Existing embeddings are retained by default; do not regenerate them merely to preserve them.
- Confirm the selected repository alias, indexed `branch`/`lastCommit`, and `staleness.status`. Refresh for `behind` or `diverged`; treat `unknown` as unmeasurable. A `current` result is relative to its indexed checkout, not the remote default branch.
- Respect external index settings in `GITNEXUS_STORAGE_PATH` or `GITNEXUS_STORAGE_ROOT`, and the `full`, `symbol`, or `none` content-retention profile. Raw source files remain the authority when stored text is unavailable.
- Graphify available and `graphify-out/` present: read/query the graph.
- Graphify available and `graphify-out/` absent: build it when the user wants persistent second-brain memory.

## GitNexus Commands

Source: https://github.com/abhigyanpatwari/GitNexus

List indexed repos:

```bash
gitnexus list
```

Check current repo status:

```bash
gitnexus status
```

Query concepts:

```bash
gitnexus query -r <repo-name> "auth flow"
```

Inspect one symbol:

```bash
gitnexus context -r <repo-name> <symbol-name>
```

Run blast-radius analysis before editing a symbol:

```bash
gitnexus impact -r <repo-name> <symbol-name>
```

Use explicit `-r <repo-name>` when more than one repository is indexed. Normal queries use the installed CLI to stay aligned with this skill's verified baseline. If the CLI is missing, treat installation as setup instead of silently fetching `@latest` for every command.

## Graphify Commands

Source: https://github.com/Graphify-Labs/graphify

Install the Graphify CLI:

```bash
uv tool install --upgrade graphifyy
graphify install --platform codex
graphify install --platform hermes
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
graphify-mcp graphify-out/graph.json
```

`graphify-mcp` uses the Graphify tool environment, so a separate system Python does not need the package installed. Graphify can also serve HTTP for a team-shared graph. Bind beyond localhost only with an API key.

## Shared Codex/Hermes Tool Data

Codex and Hermes intentionally share only the graph tooling and project graph data:

- Both resolve the same installed `gitnexus` CLI and global registry at `~/.gitnexus/registry.json`.
- Both resolve the same installed `graphify` CLI through the user tool path.
- Both read and write repository-local `graphify-out/` assets (`graph.json`, `GRAPH_REPORT.md`, and `graph.html`).
- This repository bundles a self-contained status helper. Local Codex/Hermes installations may delegate to `~/.config/brain-combo/check-codebase-memory.sh`; installing this repository does not require that local configuration.
- Hermes and Codex memory databases remain separate and are never copied by this workflow.

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

Install or upgrade GitNexus and its Codex skills:

```bash
npm install -g gitnexus@latest
gitnexus setup --coding-agent codex
```

Install Graphify when the user asks to add it:

```bash
uv tool install --upgrade graphifyy
graphify install --platform codex
graphify install --platform hermes
```

For MCP support:

```bash
uv tool install --upgrade "graphifyy[mcp]"
graphify-mcp graphify-out/graph.json
```

Graphify `0.9.74` also supports `graphify global add`, `graphify global list`, `graphify merge-graphs`, `graphify tree`, and `graphify export callflow-html` for larger second-brain workflows. Install the platform-specific bundle and its reference files together; verify the `.graphify_version` marker beside `SKILL.md` matches the CLI.

## Version Baseline

Brain Combo was re-verified against these upstream projects on October 2, 2026. GitNexus companion skills and the Codex/Hermes Graphify bundles were refreshed against their upstream sources:

```text
GitNexus: 1.6.12, https://github.com/abhigyanpatwari/GitNexus
Graphify: 0.9.74, https://github.com/Graphify-Labs/graphify
```

Use the local CLI version for behavior decisions in a repo. Use the upstream repositories and registries as upgrade context.
