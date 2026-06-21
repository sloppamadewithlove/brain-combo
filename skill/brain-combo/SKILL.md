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

Read `references/graph-memory-workflow.md` when the task needs a full workflow, setup, refresh, packaging, or troubleshooting path.

## Version Baseline

This skill coordinates GitNexus from https://github.com/abhigyanpatwari/GitNexus and Graphify from https://github.com/safishamsi/graphify. It was re-verified on June 21, 2026 with GitNexus CLI `1.6.8` and Graphify CLI `0.8.44`. Check installed versions at runtime because both tools can change independently.

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
npx -y gitnexus@latest query -r refroute "optimizer"
npx -y gitnexus@latest context -r refroute optimizeForDate
npx -y gitnexus@latest impact -r refroute optimizeForDate
```

## Decision Ladder

For architecture or onboarding:
1. Read project memory files.
2. Run GitNexus `status` and `query`.
3. Read Graphify report/query results if `graphify-out/` exists.
4. Open exact files that own the behavior.

For code edits:
1. Identify the symbol or route to change.
2. Run GitNexus `context` and upstream `impact`.
3. Report the blast radius when risk is meaningful.
4. Edit source after reading exact code.
5. Run targeted tests/checks.
6. Run GitNexus `detect_changes` or the closest available CLI equivalent before finishing.

For broad “what does this repo know?” questions:
1. Use Graphify report/query for concepts across code, docs, schemas, and media.
2. Use GitNexus query/context for code execution details.
3. Summarize where the two graphs agree, where they differ, and what raw files confirm.
