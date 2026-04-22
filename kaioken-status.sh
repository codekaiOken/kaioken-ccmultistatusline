#!/bin/sh
#
# kaioken-status.sh
#
# Kaioken Multistatus — a single-line Claude Code statusline that shows
# model, project, git branch, context usage, and rate limits at a glance.
#
# Usage: Configure in ~/.claude/settings.json (see README.md)
#
# Output:
#   🤖 Opus 4.6  📂 myproject  🌿 main  🧠 40%  ⚡ 60%  🔄 38%
#
# Colors: green (<50%), yellow (50-79%), red (80%+)

input=$(cat)

# Color-coded percentage — green/yellow/red based on usage
color_pct() {
  pct=$1
  if [ "$pct" -ge 80 ]; then
    printf '\033[31m%d%%\033[0m' "$pct"
  elif [ "$pct" -ge 50 ]; then
    printf '\033[33m%d%%\033[0m' "$pct"
  else
    printf '\033[32m%d%%\033[0m' "$pct"
  fi
}

# --- Gather data from Claude Code JSON ---

# Model name
model=$(echo "$input" | jq -r '.model.display_name // empty')

# Project directory
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // empty')
[ -z "$current_dir" ] && current_dir=$(pwd)
dir_name=$(basename "$current_dir")

# Git branch
branch=""
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
fi

# 🧠 Context window usage
ctx=""
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used_pct" ] && [ "$used_pct" != "null" ]; then
  used_int=$(printf '%.0f' "$used_pct" 2>/dev/null || echo 0)
  ctx="🧠 $(color_pct "$used_int")"
fi

# ⚡ 5-hour rolling rate limit
five=""
five_hr_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
if [ -n "$five_hr_pct" ] && [ "$five_hr_pct" != "null" ]; then
  five_int=$(printf '%.0f' "$five_hr_pct" 2>/dev/null || echo 0)
  five="⚡ $(color_pct "$five_int")"
fi

# 🔄 7-day rolling rate limit
seven=""
seven_day_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
if [ -n "$seven_day_pct" ] && [ "$seven_day_pct" != "null" ]; then
  seven_int=$(printf '%.0f' "$seven_day_pct" 2>/dev/null || echo 0)
  seven="🔄 $(color_pct "$seven_int")"
fi

# --- Assemble single line ---
line=""
[ -n "$model" ]    && line="🤖 \033[1m${model}\033[0m"
[ -n "$dir_name" ] && line="${line}  📂 ${dir_name}"
[ -n "$branch" ]   && line="${line}  🌿 ${branch}"
[ -n "$ctx" ]      && line="${line}  ${ctx}"
[ -n "$five" ]     && line="${line}  ${five}"
[ -n "$seven" ]    && line="${line}  ${seven}"

printf '%b\n' "$line"
