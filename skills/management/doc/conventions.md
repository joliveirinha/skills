# Conventions

All files in the **data repo** (the private repo you install these skills into) follow the
formats below. Skills read and write to these shapes; keep them stable.

## Slugs & naming
- People and teams use kebab-case slugs derived from the display name: `Jane Doe → jane-doe`.
- Raw log entries: `log/YYYY-MM-DD-<type>.md`. If two entries share a date+type, append `-2`, `-3`.
- Entry types: `1-1`, `skip` (skip-level), `adhoc`, `feedback` (person logs); `sync`, `retro`,
  `standup`, `review`, `incident`, `project` (team/project logs). `skip` only applies when the
  leader manages EMs/managers (i.e. their reports have their own reports); a manager of ICs
  won't use it. See **Management span** in `architecture.md`.

## Index files (the "database")

`people/_index.md` — one Markdown table, the roster:

```markdown
| name | slug | role | level | team | manager | kind | start | status |
|------|------|------|-------|------|---------|------|-------|--------|
| Jane Doe | jane-doe | Senior SWE | (your scheme) | platform | john-em | ic | 2023-02-01 | active |
```

(`level` uses whatever leveling scheme your company does — e.g. `L5`, `IC3`, `E4`, `Senior`. It's
free text; the skills don't parse it.)

`teams/_index.md` — team → EM → members + management mode:

```markdown
| team | slug | em | mode | headcount | members |
|------|------|----|------|-----------|---------|
| Platform | platform | John EM (john-em) | em-led | 6 | jane-doe, ... |
```

(`mode` is `directly-managed` or `em-led`. The `em-led` mode only applies when the leader manages
EMs; a manager of ICs has a single directly-managed team — see **Management span** in
`architecture.md`.)

`projects/_index.md` — the project registry:

```markdown
| project | slug | team | owner | status | next milestone |
|---------|------|------|-------|--------|----------------|
```

`stakeholders/_index.md` — peers and cross-org partners (not reports, not the boss):

```markdown
| name | slug | role | their org | relationship | shared projects |
|------|------|------|-----------|--------------|-----------------|
| Dana Ray | dana-ray | (their role) | Data Platform | peer | streaming-migration |
```

(`relationship` describes how they relate to the leader — e.g. `peer` (same level, another org),
`partner-em`, `partner-pm`, `exec-stakeholder`. Use whatever labels fit your org.)

## org.md — roles, identifiers, and calibration

`org.md` holds the overview of what the leader runs, how it fits the wider org, the leader's and
boss's roles, and the boss's profile + goals. It also records **handles** so signals can be pulled
for people who have no folder — the leader themselves and the boss.

### Roles block

The single place that pins down **who the leader is** and **who they report to**. Every
upward-facing and structural skill reads it — nothing else hardcodes a level or span:

```markdown
## Roles
- self: <role> · <level> · manages <ICs | EMs | managers-of-managers>
- boss: <role> · <level>
```

- `role`/`level` — free text in whatever titles/scheme the company uses (e.g. `Engineering Manager`
  · `M4`, `Director` · `L7`, `VP` · `E9`). The skills don't parse them; they compare them to gauge
  the level gap for altitude (below).
- `manages` — the leader's **span**, and the switch that selects which structural layers are active
  (see **Management span** in `architecture.md`): `ICs` (first-line manager of a single team),
  `EMs`, or `managers-of-managers`.

### Identifiers & boss goals

```markdown
## Identifiers
- self: <chat handle> · <wiki/author id> · <catalog id>
- boss: <name> · <chat handle> · <wiki/author id>

## Boss goals
- ...
```

`prep-boss-1-1` and `sync-signals` read these to fetch the leader's and the boss's recent activity.

### Altitude & span calibration

The **single source** the upward/structural skills point at (by concept, not by copying rules), so
this guidance can grow — e.g. into explicit per-level tables — without editing any skill:

- **Altitude.** Frame upward artifacts (`weekly-report`, `prep-boss-1-1`) at the **boss's**
  altitude, read from the `## Roles` block. Scale depth **inversely to the level gap**: a large gap
  (e.g. Director → VP) means fewer task-level details and more outcomes / trajectory / risk; a small
  gap (e.g. manager-of-ICs → senior manager) means more concrete delivery detail is appropriate. If
  the `## Roles` block is missing, say so and fall back to a neutral manager-to-manager altitude.
- **Span.** The `manages` value selects which structural layers exist — a manager of ICs has no
  EMs, no skip-levels, and one team that *is* the top-level view (see **Management span**).
- **Cadence.** "Weekly" is the **default** rhythm for the upward report and roll-up, not a rule —
  adjust to whatever cadence the leader actually reports on.

## Rolling summary frontmatter

Every `people/<p>/summary.md` and `teams/<t>/summary.md` starts with:

```yaml
---
last_rolled_up: 2026-07-18
---
```

`refresh-summaries` reads only `log/` entries dated after `last_rolled_up`, then rewrites the
date. Never hand-edit this date to a future value — it would skip entries.

### Person `summary.md` sections
`## Current work` · `## Concerns` · `## Feedback to give` · `## Open follow-ups`

### Team `summary.md` sections
`## Health` · `## Top achievements` · `## Top risks` · `## EM notes`

### Stakeholder `summary.md` sections (`stakeholders/<slug>/summary.md`)
`## Relationship state` · `## Shared projects & dependencies` · `## Open threads / asks (ours ↔ theirs)` · `## Friction & risks`
Same `last_rolled_up` frontmatter as other summaries.

### `health.md` sections (team)
`## Delivery` · `## Morale` · `## Staffing` · `## On-call` · `## Attrition risk`
Each with a short trend line and a date, so change over time is visible.

## Raw log entry shape

```markdown
---
date: 2026-07-18
type: 1-1
with: jane-doe
---

## Notes
<the raw notes or cleaned-up transcript summary>

## Action items
- [ ] ...

## Feedback exchanged
- given: ...
- received: ...
```

Raw entries are **append-only**. Correct mistakes with a new entry, don't rewrite history.

## mcp-map.md

```markdown
# Capability → MCP map

| capability | mcp tool | known-to-exist | notes |
|------------|----------|----------------|-------|
| service-catalog | <tool name> | yes | source of team roster (ICs + EM) |
| issue-tracker | <tool name> | yes | |
| wiki | <tool name> | no | not connected yet |
| chat | <tool name> | yes | |
| code | <tool name> | yes | |

## Cadence
- person roll-up: after each log-1-1
- team/org roll-up: weekly (or before weekly-report)
```

`known-to-exist: yes` means a skill should *not* silently skip that capability when a topic
needs more context — see the required-vs-enrichment policy in the `sync-signals` skill.

## Privacy
The data repo is private. Individual performance, compensation, and promotion notes live only
in `people/<p>/profile.md` and person summaries — never copy them into upward reports unless
explicitly intended.
