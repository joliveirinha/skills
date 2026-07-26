# João Oliveirinha skills

A personal collection of [Claude Code](https://claude.com/claude-code) skills, installable
via [`npx skills`](https://skills.sh). Skills are grouped into **categories** under
`skills/<category>/`, and each category is self-contained — it ships its own README and any
skills it needs.

## Install

Run from the project you want them in (works for this private repo via your SSH access):

```bash
npx skills@latest add joliveirinha/skills
```

This adds the skills into your current project. Each category's `SKILL.md` files are plain
Markdown — `npx skills` installs each one's own folder verbatim and nothing else, so any setup
a category needs beyond that (subagents, seeded reference docs) is handled by that category's own
setup skill, not by this install step. See each category's README for what to run next — for
`management`, that's `/setup-management-os`.

## Categories

| Category | What it's for | Guide |
|----------|---------------|-------|
| **management** | An operating system for engineering leaders: 1:1 logs, rolling person/team/org summaries, meeting prep, and upward reporting. | [`skills/management/README.md`](skills/management/README.md) |
| **personal** | Personal-life skills. Starts with an expert, interactive travel planner. | [`skills/personal/README.md`](skills/personal/README.md) |

_More categories will be added over time._

## Repository layout

```
README.md                     # this file — the category index
docs/specs/<category>/        # planning/design docs for evolving this repo — not shipped to users
skills/
  <category>/
    README.md                 # category guide
    <skill>/SKILL.md          # the skills themselves — npx skills installs each folder verbatim
```

Each skill is a `SKILL.md` with `name` / `description` frontmatter (plus
`disable-model-invocation: true` for skills meant to be invoked explicitly). `npx skills` only ever
installs the contents of one skill's own folder — it has no way to pull in files that live outside
it. So if a category needs shared reference docs or a subagent distributed alongside its skills,
those live bundled *inside* whichever skill is responsible for setting the category up (see
`skills/management/setup-management-os/` for the pattern: `doc/` and `agents/` bundled inside the
one skill, seeded into the user's own project when that skill runs).
