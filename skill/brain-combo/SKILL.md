---
name: brain-combo
description: Use GitNexus and Graphify together as a codebase second brain for future Codex sessions. Use when the user asks to understand a repo, onboard to a codebase, compare GitNexus and Graphify, build or refresh project memory, perform impact-aware edits, debug across execution flows, package this combined workflow, or preserve context for future AI coding sessions.
---

# Brain Combo

Goal: Build repo understanding from persistent graph memory before spending tokens on raw file search.

Success means:
- Project memory files are read before code edits.
- GitNexus answers symbol, caller, impact, refactor, and execution-flow questions.
- Graphify answers broad architecture, docs, schemas, cross-file concepts, reports, and visual graph questions when available.
- Plain file reads verify the exact code before changing behavior.

Stop when the current task has a clear source-of-truth answer, an edit plan with blast radius, or a concise status report that names missing graph assets.

## Quick Start

Run the bundled status check first when orienting in an unfamiliar repo:

```bash
bash ~/.codex/skills/brain-combo/scripts/check-codebase-memory.sh
```

Then keep the graphs current before trusting them. Check the repository alias and index identity before querying. Refresh once when GitNexus reports `staleness.status` as `behind` or `diverged`, or its status command proves the index differs from the target checkout's HEAD. `current` describes that indexed checkout, not the remote default branch; `unknown` means freshness could not be measured and does not justify repeatedly rebuilding:

```bash
node .gitnexus/run.cjs analyze --index-only
# fallback: gitnexus analyze --index-only
```

Verify that Graphify output covers the source tree being questioned, including uncommitted changes; timestamps alone do not prove coverage. Refresh code extraction when its inputs changed. A semantic rebuild of documents or media can require model calls, so follow the task's existing authorization before starting it. If this directory is not a Git repository, report that GitNexus freshness cannot be measured here and use available Graphify assets or raw files.

Read `references/graph-memory-workflow.md` when the task needs a full workflow, setup, refresh, packaging, or troubleshooting path.

## Version Baseline

This skill coordinates GitNexus from https://github.com/abhigyanpatwari/GitNexus and Graphify from https://github.com/Graphify-Labs/graphify. It was re-verified on October 2, 2026 with GitNexus CLI `1.6.12` and Graphify CLI `0.9.74`. GitNexus companion skills and the platform-specific Graphify bundles were refreshed against their upstream sources. Check installed versions at runtime because both tools can change independently. Use the installed CLI for normal queries; package upgrades and skill installation belong to an explicitly requested setup/update task.

## Paid Cursor CLI Worker Route

Slava has paid Cursor CLI access. When Slava asks Hermes to direct or orchestrate a Cursor agent for repository work, use the authenticated Cursor Agent CLI (`agent`, bills to the paid Cursor account at `api2.cursor.sh`) as the default execution route rather than a separate model API. Two confirmed worker models from this account: **Grok 4.6 Reasoning High** (default, quality-first) and **Composer 2.5** (with a Fast tier). Any agent may be asked for either:

```bash
agent status
agent models | grep -iE 'grok|composer'     # confirm current model IDs at runtime
# Grok 4.6 Reasoning High (default)
agent -p --force --trust --model cursor-grok-4.6-high --workspace /absolute/repo/path '<bounded task prompt>'
# Higher tier available if Slava asks for it: cursor-grok-4.6-xhigh (Extra High)
# Composer 2.5 (alternative) / Composer 2.5 Fast
agent -p --force --trust --model composer-2.5       --workspace /absolute/repo/path '<bounded task prompt>'
agent -p --force --trust --model composer-2.5-fast  --workspace /absolute/repo/path '<bounded task prompt>'
```

- `-p/--print` = non-interactive output suitable for Hermes to capture. Add `--output-format json` (or `stream-json` for deltas) for structured, parseable results.
- `--trust` skips the workspace-trust prompt so scripted runs start immediately.
- `--force`/`--yolo` auto-approves all tool calls; `~/.cursor/cli-config.json` already allows `Shell(.)`, so agented builds proceed without approval stalls.
- Verify the requested model (`cursor-grok-4.6-*`, `composer-2.5*`) is present in `agent models` at runtime; Cursor model IDs change independently of the family name.
- Treat the route as model + Cursor provider endpoint + Cursor Agent harness + workspace permissions, not as raw model inference.
- The paid Cursor account covers this route; do not silently switch to a separately billed API.
- Keep Hermes as the supervisor: constrain file and side-effect scope, require observed diff/test evidence, and independently review and verify Cursor's changes.
- If sandboxing fails in Hermes service contexts (macOS nesting limits), add `--sandbox disabled` and rely on git diff review + targeted tests as the safety layer.
- Use a clean canonical checkout when project policy requires it. If the tree is dirty, preserve unrelated work with a reviewed worktree or the safe Git isolation workflow instead of letting the worker overwrite ambient changes.

## Tool Roles

Use GitNexus as the code intelligence layer:
- Query concepts and execution flows.
- Inspect symbol context, callers, callees, and process participation.
- Run upstream impact analysis before editing functions, classes, methods, or exported values.
- Run change detection before finishing code-modification work.

Use Graphify as the broad project memory layer:
- Read `graphify-out/GRAPH_REPORT.md` for architecture highlights and surprising connections.
- Query `graphify-out/graph.json` with `graphify query`, `graphify path`, or `graphify explain`.
- Use `graph.html` for human visual inspection when the user wants a map.
- Include docs, SQL, schemas, infrastructure, PDFs, and other non-code artifacts in the project memory when Graphify has indexed them.

Use raw files as the final authority:
- Read the implementation before editing it.
- Read current product memory files before applying older specs.
- Treat graph output as navigation and risk discovery, then confirm exact behavior in source.

GitNexus refresh safety:
- Prefer `analyze --index-only` for an index refresh; it suppresses context-file and skill injection. Existing embeddings are retained unless `--drop-embeddings` is explicitly requested.
- Respect `GITNEXUS_STORAGE_PATH` and `GITNEXUS_STORAGE_ROOT`; an index can live outside the checkout. Check `storagePath`, `contentRetention`, and `sourceAvailable` before assuming graph responses include complete source text.
- Capture `git status --short` before and after `analyze`; some GitNexus versions append generated guidance to `AGENTS.md` and create `CLAUDE.md` even when only an index refresh was requested.
- Treat those as tooling side effects unless the project explicitly wants them. Restore tracked context files to their pre-analysis content, and preserve any newly generated untracked file outside the checkout rather than deleting it when file preservation is required.
- Verify the intended index commit with `node .gitnexus/run.cjs status` after handling side effects.

## RefRoute Defaults

For `/Users/slava/Downloads/vibework/refroute`, start each coding session with:

```bash
pwd
git rev-parse --show-toplevel
git branch --show-current
```

Read these files before code edits:

```text
CLAUDE.md
REFROUTEREVISED.md
docs/decisions/001-optimizer-ranking-and-status-semantics.md
```

Prefer the active repo at `/Users/slava/Downloads/vibework/refroute`. Use `.claude/worktrees/*` only when the user explicitly chooses that worktree.

Because multiple GitNexus repos can be indexed on this machine, pass the repo name explicitly:

```bash
gitnexus query -r refroute "optimizer"
gitnexus context -r refroute optimizeForDate
gitnexus impact -r refroute optimizeForDate
```

## Decision Ladder

For architecture or onboarding:
1. Read project memory files.
2. Run GitNexus `status` and `query` (refresh the index first if `status` reports it stale — see Quick Start).
3. Read Graphify report/query results if `graphify-out/` exists; verify input coverage before refreshing it under the current task authorization.
4. Open exact files that own the behavior.

For code edits:
1. Identify the symbol or route to change.
2. Ensure the index is current (refresh-if-stale per Quick Start), then run GitNexus `context` and upstream `impact`.
3. Report the blast radius when risk is meaningful.
4. Edit source after reading exact code.
5. Run targeted tests/checks.
6. Run GitNexus `detect_changes` or the closest available CLI equivalent before finishing.

For broad “what does this repo know?” questions:
1. Use Graphify report/query for concepts across code, docs, schemas, and media.
2. Use GitNexus query/context for code execution details.
3. Summarize where the two graphs agree, where they differ, and what raw files confirm.
