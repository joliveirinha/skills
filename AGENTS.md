# AGENTS.md

Guidance for AI agents working in this repository. (`CLAUDE.md` points here.)

## What this repo is

A collection of **Claude Code skills**, published for installation via
[`npx skills`](https://skills.sh) (the `vercel-labs/skills` CLI). There is **no build,
lint, or test step** — the deliverable is Markdown: `SKILL.md` files. "Testing" means
confirming the CLI discovers and lists the skills correctly.

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
`skills/<category>/<name>/SKILL.md`. **Anything nested deeper is silently NOT discovered**, and
the CLI **only ever copies the contents of one skill's own folder** — it has no mechanism to pull
in files that live outside that folder. So a file meant to ship needs to live inside the one
`<skill>/` folder that needs it; nothing at `skills/<category>/` (as a sibling of the skill
folders) ever gets installed.

Categories today: `management` (engineering-leadership toolkit) and `personal` (currently one
travel-planning skill). Each category is **self-contained**: its own `README.md`, and every skill
sits at exactly `skills/<category>/<skill>/`. If a category needs to distribute shared reference
docs or a subagent alongside its skills, those live bundled inside whichever skill sets the
category up (see `skills/management/setup-management-os/{doc/,agents/}`), not as category-level
siblings — see that skill for the pattern.

### Listing has no category headers
`npx skills --list` shows a flat list; it does **not** render category/folder headers. Folder
names are invisible in the CLI output (they only show in GitHub's file browser). Don't spend
effort trying to make categories appear as headers — it isn't a supported feature here.

## Skill conventions

- **Frontmatter** (`SKILL.md`): `name` (must match the folder), `description` (front-loaded —
  lead with the action word), and `disable-model-invocation: true` for user-invoked skills
  (everything here except `refresh-summaries` and `sync-signals`, which other skills chain to).
- **Cross-references** between skills use the **skill name** (e.g. "invoke `refresh-summaries`"),
  never a file path. **A skill's own bundled files** (siblings inside its own folder) are
  referenced relative to it (e.g. `setup-management-os/SKILL.md` reads `./doc/architecture.md`) —
  that resolves correctly no matter where the skill ends up installed. **Docs a skill expects to
  find in the user's own project** (seeded there by a setup skill, not shipped as part of this
  repo) are referenced by their path in that project (e.g. `docs/agents/conventions.md`) — never
  by a path back into this repo, which won't exist once installed.

## The `management` category — the part that needs multiple files to understand

`management` is a "management operating system" for an engineering leader. Its skills do **not**
operate on this repo — they read/write a **separate, private data repo** the user installs them
into, bootstrapped by `/setup-management-os`. Before changing these skills, read
`skills/management/setup-management-os/doc/architecture.md` (data model + roll-up flow) and
`skills/management/setup-management-os/doc/conventions.md` (exact file/frontmatter shapes) — the
canonical source for both; `setup-management-os` seeds copies of them into the data repo at
`docs/agents/architecture.md` / `conventions.md`, which is what the other skills read at runtime.
Key ideas that span skills:

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
- **`org-analyst` subagent (required)**: `weekly-report` and `prep-boss-1-1` delegate cross-org
  synthesis to it directly — `setup-management-os` guarantees it's installed, so these skills
  don't carry an inline fallback.

**Keep the skills table in sync in two places.** `skills/management/README.md`'s table is for
humans browsing this repo; `setup-management-os/SKILL.md`'s Step 6 carries its own copy because
the installed skill can't read the category README (same reason as the docs above — only its own
folder gets installed). When you add, rename, or remove a management skill, update both.

## Subagents

`npx skills` installs skills only — never subagents — so a skill that needs one has to install it
itself when it runs, using ordinary Read/Write/Bash (no separate script or install step). The
`management` category's `org-analyst` is the current example:
`skills/management/setup-management-os/agents/org-analyst.md` is bundled inside the
`setup-management-os` skill folder (so `npx skills` actually installs it), and that skill's own
`SKILL.md` states where to copy it — Claude Code gets the file verbatim into `<dest>/agents/`;
OpenCode gets a translated copy (`mode: subagent` + a `tools:` map derived from the source
`tools:` CSV). It always asks the user which tool(s) to install for rather than assuming. A future
category that needs a subagent should follow the same pattern: bundle it inside that category's
own setup skill, don't add a category-level `.agents/` sibling folder (see the discovery rule
above for why that wouldn't get installed).

## Git

Default branch `main`, remote `origin` = `git@github.com:joliveirinha/skills.git`. Commit/push
only when asked. End commit messages with:
`Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>`
