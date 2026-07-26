---
name: scaffold-management-os
description: Bootstrap or reconcile the private management data repo. Interviews the leader, pulls each team's ICs and EM from the service catalog, scaffolds the people/teams/projects tree with index files and mcp-map, and writes the data repo's own README. Re-runnable to detect and fix drift.
disable-model-invocation: true
---

# scaffold-management-os

Set up (or repair) the data repo that all the other management skills read and write. Safe to
run repeatedly: it reconciles rather than clobbers.

Read `skills/management/doc/architecture.md` and `skills/management/doc/conventions.md` (in this package) before writing files, so
every file matches the expected shape.

## Step 1 — Detect current state

Check for `org.md`, `people/_index.md`, `teams/_index.md`, `projects/_index.md`, `mcp-map.md`.

- **Nothing present** → first-time bootstrap (Step 2 onward).
- **Present** → reconcile mode: report what conforms, what's missing, and what's drifted
  (e.g. a team folder with no `_index.md` row, a summary missing `last_rolled_up`). Propose the
  fixes and apply only additive/repairing changes. **Never delete or overwrite existing `log/`
  entries or summaries.** End with an "already conformant" note if nothing needed changing.

## Step 2 — Map the tools (mcp-map.md)

Ask which capabilities are available and which MCP tool backs each: `service-catalog`,
`issue-tracker`, `wiki`, `chat`, `code`. Write `mcp-map.md` per `skills/management/doc/conventions.md`, setting
`known-to-exist` for each. This file is how every other skill stays vendor-agnostic.

## Step 3 — Interview for structure

**Establish roles and span first** — they shape everything else. Ask for the leader's own role and
level; who the leader's manager (boss) is, their role and level; and the leader's **span** — do they
manage `ICs`, `EMs`, or `managers-of-managers`? Write these to the `## Roles` block of `org.md` per
`skills/management/doc/conventions.md`. The `manages` value selects the structure (see **Management
span** in `skills/management/doc/architecture.md`):

- **manages ICs** → a single directly-managed team; **don't** ask about EM-led vs directly-managed
  modes, skip-levels, or a multi-team org. That one team is the top-level view.
- **manages EMs / managers-of-managers** → the multi-team path: the list of teams, and for each its
  EM and whether it is `directly-managed` or `em-led`.

Then gather: the mission of what the leader runs and how it fits the wider org; the boss's goals;
and any known peers / cross-org stakeholders worth tracking.

Also capture **identifiers** for signal lookup (written to `org.md` per
`skills/management/doc/conventions.md`): the leader's own handles (chat, wiki/author id, catalog
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

Create, per `skills/management/doc/conventions.md`:
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
the available skills (mirror the table in this package's README, adapted to what's installed).
This is the leader's at-a-glance guide. Include:
- The capture → synthesis → prep flow.
- When to run each skill (after 1:1s, after meetings, weekly, on reorg).
- The meeting-scope model, if the leader manages EMs (directly-managed vs em-led — see
  `skills/management/doc/architecture.md`); for a manager of ICs, note the single-team shape instead.

## Finish

Summarize what was created or reconciled, list any `roster-pending` teams still needing data,
and tell the leader the next step is `/log-1-1` after their next conversation.
