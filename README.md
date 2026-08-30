# Brain Combo

Brain Combo is a global Codex skill that uses GitNexus and Graphify together as a practical codebase second brain.

It keeps the two tools separate and lets them coexist:

- GitNexus handles code intelligence: symbols, callers, callees, execution flows, refactor impact, and change blast radius.
- Graphify handles broad project memory: docs, specs, schemas, architecture reports, visual graphs, and cross-file concepts.
- Raw source files remain the final authority before changing behavior.

## Why This Exists

The base idea came from comparing an installed GitNexus workflow with Graphify:

- GitNexus source: https://github.com/abhigyanpatwari/GitNexus
- Graphify source: https://github.com/Graphify-Labs/graphify

GitNexus was already useful for impact-aware coding inside a repo, but its value is strongest around source symbols and execution flows. Graphify overlaps as a graph-based project memory tool, but it reaches wider: reports, visual maps, docs, schemas, and non-code artifacts. Brain Combo exists because those strengths fit together better than they replace each other.

This repo packages that combined workflow as one Codex skill named `brain-combo`, so future Codex sessions can orient quickly before editing a codebase.

## Version Baseline

Brain Combo was re-verified on August 29, 2026 with:

| Tool | Current verified version | Source |
| --- | --- | --- |
| GitNexus CLI | `1.6.10` | https://github.com/abhigyanpatwari/GitNexus |
| Graphify CLI | `0.9.52` | https://github.com/Graphify-Labs/graphify |

On August 29, 2026 the accompanying GitNexus skills (`gitnexus-impact-analysis`, `gitnexus-refactoring`, `gitnexus-debugging`, `gitnexus-exploring`, `gitnexus-taint-analysis`, `gitnexus-work`) and the Graphify skill were refreshed to their latest upstream versions alongside this skill.

Use your installed local versions for day-to-day behavior. Treat the table as the creation baseline, not a permanent compatibility ceiling.

## Install For Codex

### Option 1: Automatic

```bash
git clone https://github.com/sloppamadewithlove/brain-combo.git brain-combo
cd brain-combo
./install.sh
```

The installer copies the skill to:

```text
${CODEX_HOME:-$HOME/.codex}/skills/brain-combo
```

When replacing an existing installation, the installer preserves it under `${CODEX_HOME:-$HOME/.codex}/backups/brain-combo/`.

Restart Codex after installing so the new global skill appears in future sessions.

### Option 2: Manual

```bash
git clone https://github.com/sloppamadewithlove/brain-combo.git brain-combo
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills"
cp -R brain-combo/skill/brain-combo "${CODEX_HOME:-$HOME/.codex}/skills/brain-combo"
chmod +x "${CODEX_HOME:-$HOME/.codex}/skills/brain-combo/scripts/check-codebase-memory.sh"
```

Verify the skill file exists:

```bash
test -f "${CODEX_HOME:-$HOME/.codex}/skills/brain-combo/SKILL.md" && echo "brain-combo installed"
```

## Optional Tool Setup

Brain Combo can still help as instructions without both tools installed, but it works best when GitNexus and Graphify are available.

Check GitNexus:

```bash
gitnexus --version
npx -y gitnexus@latest --version
npx -y gitnexus@latest list
```

Install or upgrade GitNexus and its Codex skills:

```bash
npm install -g gitnexus@latest
gitnexus setup --coding-agent codex
```

Index a repo with GitNexus:

```bash
cd /path/to/your/repo
npx -y gitnexus@latest analyze
```

Install Graphify:

```bash
uv tool install --upgrade graphifyy
graphify install --platform codex
```

Build a Graphify graph for a repo:

```bash
cd /path/to/your/repo
graphify extract .
```

Refresh Graphify after code edits:

```bash
graphify update .
```

## Use

In Codex, ask:

```text
Use $brain-combo to orient on this repo before changing the optimizer.
```

Or:

```text
Use $brain-combo to compare what GitNexus and Graphify know about this project.
```

The skill starts with:

```bash
bash ~/.codex/skills/brain-combo/scripts/check-codebase-memory.sh
```

Then it uses GitNexus, Graphify, and raw file reads according to the task.

## Install With An AI Agent

Give the agent this repository and this instruction:

```text
Install Brain Combo as a global Codex skill. Copy skill/brain-combo to ${CODEX_HOME:-$HOME/.codex}/skills/brain-combo, preserve executable permissions on scripts/check-codebase-memory.sh, validate SKILL.md if a Codex skill validator exists, and run the status script from a target repository. Report the installed path, GitNexus version, Graphify version, and whether graphify-out/ exists. Leave project source files unchanged unless I explicitly ask for code edits.
```

For a repo that already uses GitNexus or Graphify, add:

```text
After installing Brain Combo, read the target repo's AGENTS.md or equivalent project instructions, then use $brain-combo before making any code changes.
```

## Repository Layout

```text
brain-combo/
├── README.md
├── install.sh
└── skill/
    └── brain-combo/
        ├── SKILL.md
        ├── agents/openai.yaml
        ├── references/graph-memory-workflow.md
        └── scripts/check-codebase-memory.sh
```

## What Brain Combo Is Not

Brain Combo is not a fork of GitNexus or Graphify. It is a small Codex skill that coordinates the two tools and gives future AI sessions a repeatable orientation workflow.
