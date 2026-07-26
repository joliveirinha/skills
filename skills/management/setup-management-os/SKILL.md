---
name: setup-management-os
description: Bootstrap or reconcile the private management data repo. Interviews the leader, pulls each team's ICs and EM from the service catalog, scaffolds the people/teams/projects tree with index files and settings, seeds this repo's own reference docs and AGENTS.md/CLAUDE.md section, installs the org-analyst subagent, and writes the data repo's own README. Re-runnable to detect and fix drift.
disable-model-invocation: true
---

# setup-management-os

Set up (or repair) the data repo that all the other management skills read and write. Safe to
run repeatedly, any time — the first run and a run a year later behave the same way: explore what's
there, present findings, ask before writing, then write. Never clobber anything without asking.

Read `./doc/architecture.md` and `./doc/conventions.md` (bundled with this skill) before writing
files, so every file matches the expected shape.

## Step 1 — Detect current state

Check for `org.md`, `people/_index.md`, `teams/_index.md`, `projects/_index.md`, `settings.md`,
`docs/agents/architecture.md`, `docs/agents/conventions.md`, an `## Management OS` section in
whichever of `AGENTS.md`/`CLAUDE.md` exists, and whether the `org-analyst` subagent is installed
(check for `agents/org-analyst.md` under `.claude/`, `~/.claude/`, `.opencode/`, and
`~/.config/opencode/`).

- **Nothing present** → first-time bootstrap (Step 2 onward).
- **Present** → reconcile mode: report what conforms, what's missing, and what's drifted
  (e.g. a team folder with no `_index.md` row, a summary missing `last_rolled_up`, `docs/agents/*.md`
  older than the version bundled with this skill, the `## Management OS` section missing or stale,
  `org-analyst` not installed anywhere). **Present this as a list and ask before changing anything**
  — never apply fixes silently. Apply only the changes the leader confirms. **Never delete or
  overwrite existing `log/` entries or summaries** — the reference docs, the AGENTS.md/CLAUDE.md
  section, and the subagent file are safe to refresh freely since they're generated, not user data.
  End with an "already conformant" note if nothing needed changing.

## Step 2 — Write settings.md (tools)

Ask which capabilities are available and which MCP tool backs each: `service-catalog`,
`issue-tracker`, `wiki`, `chat`, `code`. Write `settings.md` per `./doc/conventions.md`, setting
`known-to-exist` for each capability. This file is how every other skill stays vendor-agnostic,
and the one place per-repo operational preferences live.

## Step 3 — Interview for structure

**Establish roles and span first** — they shape everything else. Ask for the leader's own role and
level; who the leader's manager (boss) is, their role and level; and the leader's **span** — do they
manage `ICs`, `EMs`, or `managers-of-managers`? Write these to the `## Roles` block of `org.md` per
`./doc/conventions.md`. The `manages` value selects the structure (see **Management
span** in `./doc/architecture.md`):

- **manages ICs** → a single directly-managed team; **don't** ask about EM-led vs directly-managed
  modes, skip-levels, or a multi-team org. That one team is the top-level view.
- **manages EMs / managers-of-managers** → the multi-team path: the list of teams, and for each its
  EM and whether it is `directly-managed` or `em-led`.

Then gather: the mission of what the leader runs and how it fits the wider org; the boss's goals;
and any known peers / cross-org stakeholders worth tracking.

Also capture **identifiers** for signal lookup (written to `org.md` per
`./doc/conventions.md`): the leader's own handles (chat, wiki/author id, catalog
id) and the boss's handles. These let `prep-boss-1-1` and `sync-signals` pull the leader's and
the boss's recent activity even though neither has a person folder.

## Step 4 — Populate the roster (service catalog is required here)

For each team, get its members — **ICs + EM** for an EM-led team, or just the **ICs** for a
manager-of-ICs' single team (there's no separate EM — the leader runs it). This is
required-for-correctness data:

- If a `service-catalog` MCP is available, pull the roster from it.
- If it is **not** available, say so explicitly and either ask the leader to provide the team
  members directly, or record the team as `roster-pending` and move on — **never invent names
  or leave a silently empty roster.**

## Step 5 — Scaffold the tree

Create, per `./doc/conventions.md`:
- `org.md` (mission, wider-org fit, the `## Roles` block for self/boss role/level + span, boss
  profile + goals, and the `## Identifiers` block for self + boss handles).
- `people/_index.md`, and for each person a `people/<slug>/` folder with a `profile.md` stub,
  an empty `log/`, and a `summary.md` seeded with `last_rolled_up: <today - conservatively old>`
  so the first roll-up reads everything.
- `teams/_index.md`, and for each team a `teams/<slug>/` with `profile.md`, `log/`, `health.md`
  stub, and `summary.md`.
- `stakeholders/_index.md`, and for any known peers a `stakeholders/<slug>/` with `profile.md`,
  `log/`, and a `summary.md` (relationship sections per conventions).
- `projects/_index.md` (rows optional at first), `reports/upward/`, `prep/`.
- A `.gitignore` posture appropriate to a private repo, and confirm to the leader this repo must
  stay private.

## Step 6 — Write the data repo's README

Write `README.md` **in the data repo** describing the operating rhythm and a readable table of
the available skills. This is the leader's at-a-glance guide. Include:
- The capture → synthesis → prep flow.
- When to run each skill (after 1:1s, after meetings, weekly, on reorg).
- The meeting-scope model, if the leader manages EMs (directly-managed vs em-led — see
  `./doc/architecture.md`); for a manager of ICs, note the single-team shape instead.
- A skills table, adapted to what's actually installed (check the installed skills directory —
  don't assume every row below is present):

  | Skill | Invoke with | Use it… |
  |---|---|---|
  | **setup-management-os** | `/setup-management-os` | Once to bootstrap the repo; re-run anytime to reconcile drift. Writes your data repo's own README. |
  | **update-org** | `/update-org` | For reorg events: hires, departures, moving a person between teams, a team joining or leaving your org, adding/retiring a peer stakeholder. |
  | **log-1-1** | `/log-1-1` | After any 1:1, skip-level (if you manage managers), ad-hoc, or **peer meeting** — paste notes or a transcript. |
  | **log-meeting** | `/log-meeting` | After a team/project meeting you attended — paste notes or a transcript. |
  | **refresh-summaries** | `/refresh-summaries` | To roll up person → team → org summaries (usually chained automatically). |
  | **sync-signals** | (automatic) | Helper that pulls live activity from your connected tools. |
  | **weekly-report** | `/weekly-report` | Weekly, to draft your upward report. |
  | **prep-ic-1-1** | `/prep-ic-1-1 <name>` | Before a 1:1 with an IC. |
  | **prep-em-1-1** | `/prep-em-1-1 <em-or-team>` | Before a 1:1 with an engineering manager (if you manage EMs). |
  | **prep-peer-1-1** | `/prep-peer-1-1 <name>` | Before a meeting with a peer / cross-org stakeholder. |
  | **prep-boss-1-1** | `/prep-boss-1-1` | Before a 1:1 with your manager. |

## Step 7 — Seed the reference docs

Copy `./doc/architecture.md` and `./doc/conventions.md` (bundled with this skill) into the data
repo at `docs/agents/architecture.md` and `docs/agents/conventions.md`. Every other management
skill reads these two files at runtime — they don't exist anywhere else once installed. These are
generated reference copies, not user data, so it's always safe to overwrite them to bring them
current; do this whenever they're missing or stale, without needing to ask (unlike everything
under `people/`/`teams/`/`stakeholders/`, which is never overwritten).

## Step 8 — Point AGENTS.md/CLAUDE.md at them

Edit whichever of `AGENTS.md` / `CLAUDE.md` already exists in this repo, adding or updating an
`## Management OS` section that names `docs/agents/architecture.md` and `conventions.md`. If an
`## Management OS` section already exists, update it in place — don't duplicate it. If **neither**
file exists, ask the leader which one to create; never create the other one if one already exists.

## Step 9 — Install the `org-analyst` subagent

`weekly-report` and `prep-boss-1-1` delegate org-wide synthesis to `org-analyst` — it's required,
not optional, so this step isn't skippable.

1. Check for candidate install locations: a project-level `.claude/` or `.opencode/` here, and
   user-level `~/.claude/` or `~/.config/opencode/`. Present whatever you find as a suggested
   default and **ask the leader which tool(s) to install it for** — don't install for every
   candidate silently, and ask directly if you find no candidates at all.
2. For **Claude Code**: copy `./agents/org-analyst.md` (bundled with this skill) verbatim to
   `<chosen-dir>/agents/org-analyst.md`.
3. For **OpenCode**: rewrite the frontmatter — keep `description`, add `mode: subagent`, and
   convert the source `tools:` CSV into an explicit `tools:` map (each tool named in the CSV set to
   `true`, every other tool — `write`, `edit`, `bash`, `read`, `grep`, `glob`, `webfetch` — set to
   `false`) — then write the unchanged body to `<chosen-dir>/agent/org-analyst.md` (or `agents/`,
   matching whichever the target OpenCode config already uses).

## Finish

Summarize what was created or reconciled, list any `roster-pending` teams still needing data, and
tell the leader the next step is `/log-1-1` after their next conversation.
