#!/usr/bin/env bash
# Claude Code statusLine command
# Mirrors key elements from p10k prompt: cwd, git branch, model, context

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Color codes using $'...' so escapes are interpreted when stored in variables
reset=$'\e[0m'
green=$'\e[1;32m'
blue=$'\e[1;34m'
yellow=$'\e[0;33m'
cyan=$'\e[0;36m'
magenta=$'\e[0;35m'

# Shorten home directory to ~
home="$HOME"
short_cwd="${cwd/#$home/\~}"

# Git branch (skip optional locks)
git_branch=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" -c core.hooksPath=/dev/null symbolic-ref --short HEAD 2>/dev/null \
    || git -C "$cwd" -c core.hooksPath=/dev/null rev-parse --short HEAD 2>/dev/null)
  if [[ -n "$branch" ]]; then
    git_branch=" ${yellow}(${branch})${reset}"
  fi
fi

# Context usage
ctx=""
if [[ -n "$used_pct" ]]; then
  ctx_int=$(printf '%.0f' "$used_pct")
  ctx=" ${cyan}ctx:${ctx_int}%${reset}"
fi

# Model
model_str=""
if [[ -n "$model" ]]; then
  model_str=" ${magenta}${model}${reset}"
fi

printf "%s%s%s%s%s%s\n" \
  "$blue" "$short_cwd" "$reset" \
  "$git_branch" "$model_str" "$ctx"
