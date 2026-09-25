#!/usr/bin/env bash
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
folder=$(basename "$cwd")

branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)

model=$(echo "$input" | jq -r '.model.id // ""')
effort=$(echo "$input" | jq -r '.effort.level // ""')

used=$(echo "$input" | jq -r '.context_window.used_percentage // 0')

five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_resets_at=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# Build progress bar (10 chars wide)
build_bar() {
  local pct="$1"
  local filled=$(awk "BEGIN {printf \"%.0f\", $pct / 10}")
  local empty=$((10 - filled))
  local bar=""
  for ((i=0; i<filled; i++)); do bar+="▓"; done
  for ((i=0; i<empty; i++)); do bar+="░"; done
  echo "$bar"
}

# Git dirty status (only inside a git repo)
git_block=""
if git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  modified=$(git -C "$cwd" --no-optional-locks diff --name-only 2>/dev/null | wc -l | tr -d ' ')
  staged=$(git -C "$cwd" --no-optional-locks diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
  if [ "$modified" -eq 0 ] && [ "$staged" -eq 0 ]; then
    git_block="✅"
  else
    git_dirty=""
    [ "$modified" -gt 0 ] && git_dirty="~${modified}"
    [ "$staged" -gt 0 ] && git_dirty="${git_dirty:+$git_dirty }+${staged}"
    git_block="📝 $git_dirty"
  fi
fi

# Build status line
parts=()

[ -n "$folder" ] && parts+=("📁 $folder")
[ -n "$branch" ] && parts+=("🌿 $branch")
[ -n "$git_block" ] && parts+=("$git_block")
[ -n "$model" ] && parts+=("🤖 $model${effort:+ ($effort)}")

  bar=$(build_bar "$used")
  pct_int=$(printf '%.0f' "$used")
  parts+=("🔋 $bar ${pct_int}%")

  plan_parts=()
  [ -n "$five_pct" ] && plan_parts+=("5h:$(printf '%.0f' "$five_pct")%")
  [ -n "$week_pct" ] && plan_parts+=("7d:$(printf '%.0f' "$week_pct")%")

  # Countdown until 5-hour window resets
  if [ -n "$five_resets_at" ]; then
    now=$(date +%s)
    diff=$(( five_resets_at - now ))
    if [ "$diff" -gt 0 ]; then
      h=$(( diff / 3600 ))
      m=$(( (diff % 3600) / 60 ))
      plan_parts+=("⏱ ${h}h$(printf '%02d' $m)m")
    fi
  fi

  plan_str=""
  for part in "${plan_parts[@]}"; do
    [ -n "$plan_str" ] && plan_str="$plan_str | "
    plan_str="$plan_str$part"
  done

  [ -n "$plan_str" ] && parts+=("📊 $plan_str")

printf '%s' "$(IFS='  '; echo "${parts[*]}")"
