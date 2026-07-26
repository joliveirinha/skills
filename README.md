# João Oliveirinha skills

A personal collection of [Claude Code](https://claude.com/claude-code) skills, installable
via [`npx skills`](https://skills.sh). Skills are grouped into **categories** under
`skills/<category>/`, and each category is self-contained — it ships its own README, docs,
and any agents it needs.

## Install

**Skills** — run from the project you want them in (works for this private repo via your SSH access):

```bash
npx skills@latest add joliveirinha/skills
```

This adds the skills into your current project. See each category's README for what to run next.

**Subagents** — `npx skills` does **not** install subagents (e.g. `org-analyst`, used by
`weekly-report` and `prep-boss-1-1`). They're optional — the skills fall back to analyzing inline —
but to install them, use `install.sh` from your local clone. It reads the agent files from the clone
and installs them into a **separate destination** (never the clone itself), translating each agent to
Claude Code and/or OpenCode format for whichever tools you have:

```bash
./install.sh --list                       # see available subagents
./install.sh --global --all               # install all, user-level (~/.claude, ~/.config/opencode)
./install.sh --target ~/my-project --agent org-analyst   # into a specific project
cd ~/my-project && /path/to/install.sh --agent org-analyst   # into the current project
```

Add `--with-skills` to also run the `npx skills` step in the same command.

## Categories

| Category | What it's for | Guide |
|----------|---------------|-------|
| **management** | An operating system for engineering leaders: 1:1 logs, rolling person/team/org summaries, meeting prep, and upward reporting. | [`skills/management/README.md`](skills/management/README.md) |
| **personal** | Personal-life skills. Starts with an expert, interactive travel planner. | [`skills/personal/README.md`](skills/personal/README.md) |

_More categories will be added over time._

## Repository layout

```
.claude-plugin/plugin.json   # package manifest: enumerates every skill + agent (drives npx skills)
package.json                 # package metadata
README.md                    # this file — the category index
skills/
  <category>/
    README.md                # category guide
    doc/                     # category reference docs
    design/                  # forward-looking designs
    .agents/                 # subagents this category's skills delegate to
    <group>/<skill>/SKILL.md # the skills themselves
```

Each skill is a `SKILL.md` with `name` / `description` frontmatter (plus
`disable-model-invocation: true` for skills meant to be invoked explicitly). The
`.claude-plugin/plugin.json` manifest lists every skill and agent path in the repo.
