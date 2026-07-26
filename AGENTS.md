# AGENTS.md

Guidance for AI agents working in this repository. (`CLAUDE.md` points here.)

## What this repo is

A collection of **Claude Code skills**, published for installation via
[`npx skills`](https://skills.sh) (the `vercel-labs/skills` CLI). There is **no build,
lint, or test step** — the deliverable is Markdown: `SKILL.md` files plus a manifest.
"Testing" means confirming the CLI discovers and lists the skills correctly.

## Commands

```bash
# List what the CLI discovers from the published repo (the main sanity check)
npx skills add joliveirinha/skills --list

# Validate LOCAL working-tree changes without committing/pushing — `add` accepts a path
npx skills add /Users/neo/work/personal/skills --list

# Install into a project / globally
npx skills add joliveirinha/skills            # project scope
npx skills add joliveirinha/skills -g         # global

# Scaffold a new skill file
npx skills init <name>
```

After editing skills, always run the local `--list` and confirm the expected **skill count**
before committing.

## Layout & the discovery rule (critical)

```
skills/<category>/<skill>/SKILL.md      # the required "catalog" layout
```

The CLI walks `skills/` only **two levels deep** — flat `skills/<name>/SKILL.md` or catalog
`skills/<category>/<name>/SKILL.md`. **Anything nested deeper is silently NOT discovered.**
This repo previously grouped management skills under `skills/management/<group>/<skill>/`
(depth 3) and the CLI found none of them — do not reintroduce intermediate group folders.
Keep every skill at exactly `skills/<category>/<skill>/`.

Categories today: `management` (engineering-leadership toolkit) and `personal` (currently one
travel-planning skill). Each category is **self-contained**: its own `README.md`, and for
`management` also `doc/`, `design/`, and `.agents/`.

### Listing has no category headers
`npx skills --list` shows a flat list; it does **not** render category/folder headers. The only
grouping the CLI does is "declared in a manifest (under the plugin name)" vs an undeclared
**"General"** bucket. Folder names are invisible in the CLI output (they only show in GitHub's
file browser). Don't spend effort trying to make categories appear as headers — it isn't a
supported feature here.

## Skill & manifest conventions

- **Frontmatter** (`SKILL.md`): `name` (must match the folder), `description` (front-loaded —
  lead with the action word), and `disable-model-invocation: true` for user-invoked skills
  (everything here except `refresh-summaries` and `sync-signals`, which other skills chain to).
- **Manifest**: `.claude-plugin/plugin.json` enumerates every skill path and the agent. When you
  add, rename, or move a skill, update this array — and re-run the local `--list`.
- **Cross-references** inside skills use the **skill name** (e.g. "invoke `refresh-summaries`"),
  never a file path. References to shared docs use **repo-root-relative** paths
  (e.g. `skills/management/doc/conventions.md`).

## The `management` category — the part that needs multiple files to understand

`management` is a "management operating system" for an engineering leader. Its skills do **not**
operate on this repo — they read/write a **separate, private data repo** the user installs them
into. Before changing these skills, read `skills/management/doc/architecture.md` (data model +
roll-up flow) and `skills/management/doc/conventions.md` (exact file/frontmatter shapes). Key
ideas that span skills:

- **Entities**: `people/` (reports), `teams/`, `projects/`, `stakeholders/` (peers/cross-org).
  Each entity has an append-only raw `log/` plus a rolling `summary.md`.
- **Bottom-up roll-up**: `refresh-summaries` folds raw log entries into summaries
  person → team → org. It's **idempotent** via a `last_rolled_up:` frontmatter marker — it reads
  only entries newer than that date. `log-1-1` auto-refreshes just the one person it touched.
- **Meeting scope**: directly-managed teams' meetings feed via `log-meeting`; EM-led teams'
  visibility comes through the EM's `log-1-1`. Stakeholders never roll into team/person summaries
  but surface cross-org risk at the org level (via the `org-analyst` agent).
- **Tool-agnostic MCP model**: skills reference *capabilities* (`service-catalog`,
  `issue-tracker`, `wiki`, `chat`, `code`), never products; the data repo's `mcp-map.md` binds
  them. Some data is **required** (roster pull — block/ask if unavailable), most is
  **enrichment** (pull when available, degrade gracefully) — see `sync-signals`.

## Git

Default branch `main`, remote `origin` = `git@github.com:joliveirinha/skills.git`. Commit/push
only when asked. End commit messages with:
`Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>`
