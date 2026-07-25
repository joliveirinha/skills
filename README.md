# João Oliveirinha skills

A personal collection of [Claude Code](https://claude.com/claude-code) skills, installable
via [`npx skills`](https://skills.sh). Skills are grouped into **categories** under
`skills/<category>/`, and each category is self-contained — it ships its own README, docs,
and any agents it needs.

## Install

```bash
npx skills@latest add joliveirinha/skills
```

This adds the skills into your current project. See each category's README for what to run
next.

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
