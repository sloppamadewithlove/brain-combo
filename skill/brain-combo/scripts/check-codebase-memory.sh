#!/usr/bin/env bash
set -u

echo "== Repository =="
printf "pwd: "
pwd

if git_root=$(git rev-parse --show-toplevel 2>/dev/null); then
  printf "git root: %s\n" "$git_root"
  printf "branch: "
  git branch --show-current 2>/dev/null || true
else
  echo "git root: unavailable"
fi

echo
echo "== GitNexus =="
if command -v npx >/dev/null 2>&1; then
  npx gitnexus --version 2>/dev/null || echo "gitnexus CLI not available through npx"
  npx gitnexus list 2>/dev/null || true
  npx gitnexus status 2>/dev/null || true
else
  echo "npx unavailable"
fi

echo
echo "== Graphify =="
if command -v graphify >/dev/null 2>&1; then
  graphify --version 2>/dev/null || graphify --help | sed -n '1,3p'
elif command -v uvx >/dev/null 2>&1; then
  uvx --from graphifyy graphify --version 2>/dev/null || echo "graphify CLI not found"
else
  echo "graphify CLI not found"
fi

if [ -d "graphify-out" ]; then
  echo "graphify-out: present"
  [ -f "graphify-out/GRAPH_REPORT.md" ] && echo "GRAPH_REPORT.md: present"
  [ -f "graphify-out/graph.json" ] && echo "graph.json: present"
  [ -f "graphify-out/graph.html" ] && echo "graph.html: present"
else
  echo "graphify-out: absent"
fi
