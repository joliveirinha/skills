#!/usr/bin/env bash
#
# install.sh — install the subagents that `npx skills` can't.
#
# `npx skills add joliveirinha/skills` installs the SKILL.md files (it clones over
# SSH, so it works for a private repo you own). What it does NOT do is install the
# subagents these skills delegate to (e.g. org-analyst). This script fills that gap,
# and can optionally run the skills install too.
#
# It sources agent files from its OWN location (your local clone) and installs them
# into a DESTINATION that is separate from the clone:
#
#   ./install.sh --target ~/my-mgmt-repo   # into a specific project
#   ./install.sh --global                  # user-level (~/.claude, ~/.config/opencode)
#   cd ~/my-mgmt-repo && /path/to/install.sh   # into the current project
#
# Options:
#   --global | -g          Install to user-level directories
#   --target <dir>         Install into <dir> (a project)
#   --agent <name>         Install a specific agent (repeatable)
#   --all                  Install all discovered agents
#   --list                 List available agents and exit
#   --with-skills          Also run `npx skills add <source>` for the skills
#   --source <path|slug>   Source for the skills install (default: this clone)
#   -h | --help            Show this help
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE="$SCRIPT_DIR"

SCOPE="project"          # project | global
TARGET=""                # explicit --target dir
declare -a WANT_AGENTS=()
SELECT_ALL=false
DO_LIST=false
WITH_SKILLS=false

while [ $# -gt 0 ]; do
  case "$1" in
    --global|-g)   SCOPE="global" ;;
    --target)      SCOPE="target"; TARGET="${2:?--target needs a dir}"; shift ;;
    --agent)       WANT_AGENTS+=("${2:?--agent needs a name}"); shift ;;
    --all)         SELECT_ALL=true ;;
    --list)        DO_LIST=true ;;
    --with-skills) WITH_SKILLS=true ;;
    --source)      SOURCE="${2:?--source needs a path or slug}"; shift ;;
    -h|--help)     grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done

# --- discover agents (skills/*/.agents/*.md) --------------------------------
declare -a AGENT_FILES=()
while IFS= read -r f; do AGENT_FILES+=("$f"); done < <(find "$SCRIPT_DIR/skills" -type f -path '*/.agents/*.md' 2>/dev/null | sort)

agent_desc() { sed -n 's/^description: //p' "$1" | head -1; }
agent_name() { local b; b="$(basename "$1")"; echo "${b%.md}"; }

if [ "${#AGENT_FILES[@]}" -eq 0 ]; then
  echo "No agents found under $SCRIPT_DIR/skills/*/.agents/ — nothing to do." >&2
  exit 0
fi

if $DO_LIST; then
  echo "Available agents:"
  for f in "${AGENT_FILES[@]}"; do printf '  %-18s %s\n' "$(agent_name "$f")" "$(agent_desc "$f")"; done
  exit 0
fi

# --- resolve which agents to install ----------------------------------------
find_agent_file() { local want="$1" f; for f in "${AGENT_FILES[@]}"; do [ "$(agent_name "$f")" = "$want" ] && { echo "$f"; return 0; }; done; return 1; }

declare -a SELECTED=()
if [ "${#WANT_AGENTS[@]}" -gt 0 ]; then
  for want in "${WANT_AGENTS[@]}"; do
    if f="$(find_agent_file "$want")"; then SELECTED+=("$f"); else
      echo "Unknown agent: $want (see --list)" >&2; exit 2
    fi
  done
elif $SELECT_ALL; then
  SELECTED=("${AGENT_FILES[@]}")
elif [ -t 0 ]; then
  echo "Select agents to install (space-separated numbers, or 'a' for all):"
  i=1; for f in "${AGENT_FILES[@]}"; do printf '  %d) %s — %s\n' "$i" "$(agent_name "$f")" "$(agent_desc "$f")"; i=$((i+1)); done
  printf '> '; read -r reply
  if [ "$reply" = "a" ] || [ "$reply" = "A" ]; then SELECTED=("${AGENT_FILES[@]}")
  else for n in $reply; do idx=$((n-1)); [ "$idx" -ge 0 ] && [ "$idx" -lt "${#AGENT_FILES[@]}" ] && SELECTED+=("${AGENT_FILES[$idx]}"); done
  fi
  [ "${#SELECTED[@]}" -eq 0 ] && { echo "Nothing selected." >&2; exit 1; }
else
  echo "No agent selected. Pass --agent <name>, --all, or --list." >&2; exit 2
fi

# --- resolve destination and guard against the clone ------------------------
case "$SCOPE" in
  global) DEST="$HOME" ;;
  target) mkdir -p "$TARGET"; DEST="$(cd "$TARGET" && pwd)" ;;
  project) DEST="$(pwd)" ;;
esac

if [ "$SCOPE" != "global" ] && [ "$DEST" = "$SCRIPT_DIR" ]; then
  echo "Refusing to install into the skills repo itself ($DEST)." >&2
  echo "Use --global, or --target <your-project>, or run this from your project directory." >&2
  exit 1
fi

# --- detect installed tools -------------------------------------------------
have_claude=false; have_opencode=false
command -v claude   >/dev/null 2>&1 && have_claude=true
command -v opencode >/dev/null 2>&1 && have_opencode=true
echo "Detecting tools:"
$have_claude   && echo "  ✓ Claude Code"  || echo "  ✗ Claude Code not found — skipping"
$have_opencode && echo "  ✓ OpenCode"      || echo "  ✗ OpenCode not found — skipping"
if ! $have_claude && ! $have_opencode; then
  echo "Neither Claude Code nor OpenCode is installed. Install one and re-run." >&2; exit 1
fi

# --- optional: install the skills too ---------------------------------------
if $WITH_SKILLS; then
  agent_args=(); $have_claude && agent_args+=(-a claude-code); $have_opencode && agent_args+=(-a opencode)
  echo; echo "Installing skills from $SOURCE…"
  case "$SCOPE" in
    global) npx -y skills add "$SOURCE" "${agent_args[@]}" -g -y ;;
    *)      ( cd "$DEST" && npx -y skills add "$SOURCE" "${agent_args[@]}" -y ) ;;
  esac
fi

# --- install the selected agents into each detected tool --------------------
# Map a Claude-style `tools:` CSV to an OpenCode tools map (enable listed, disable the rest).
# bash 3.2 safe (macOS) — no associative arrays.
opencode_tools_block() {
  local csv; csv=",$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr -d ' '),"
  echo "tools:"
  local t
  for t in write edit bash read grep glob webfetch; do
    case "$csv" in *",$t,"*) echo "  $t: true" ;; *) echo "  $t: false" ;; esac
  done
}

claude_dir() { echo "$DEST/.claude/agents"; }
opencode_dir() {
  local base; [ "$SCOPE" = "global" ] && base="$DEST/.config/opencode" || base="$DEST/.opencode"
  if [ -d "$base/agents" ]; then echo "$base/agents"; else echo "$base/agent"; fi
}

install_one_claude() {
  local src="$1" name; name="$(agent_name "$src")"; local dir; dir="$(claude_dir)"
  mkdir -p "$dir"; cp "$src" "$dir/$name.md"; echo "  Claude Code: $dir/$name.md"
}
install_one_opencode() {
  local src="$1" name; name="$(agent_name "$src")"; local dir; dir="$(opencode_dir)"
  mkdir -p "$dir"
  local desc tools body
  desc="$(agent_desc "$src")"
  tools="$(sed -n 's/^tools: //p' "$src" | head -1)"
  body="$(awk 'f{print} /^---[[:space:]]*$/{c++; if(c==2){f=1}}' "$src")"
  {
    echo "---"; echo "description: $desc"; echo "mode: subagent"
    opencode_tools_block "$tools"
    echo "---"; printf '%s\n' "$body"
  } > "$dir/$name.md"
  echo "  OpenCode: $dir/$name.md"
}

echo; echo "Installing ${#SELECTED[@]} agent(s) into: $DEST ($SCOPE scope)"
for src in "${SELECTED[@]}"; do
  echo "- $(agent_name "$src")"
  $have_claude   && install_one_claude "$src"
  $have_opencode && install_one_opencode "$src"
done

echo; echo "Done. Restart your tool (or reload agents) to pick them up."
