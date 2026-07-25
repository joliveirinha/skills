# Conventions

All files in the **data repo** (the private repo you install these skills into) follow the
formats below. Skills read and write to these shapes; keep them stable.

## Slugs & naming
- People and teams use kebab-case slugs derived from the display name: `Jane Doe → jane-doe`.
- Raw log entries: `log/YYYY-MM-DD-<type>.md`. If two entries share a date+type, append `-2`, `-3`.
- Entry types: `1-1`, `skip` (skip-level), `adhoc`, `feedback` (person logs); `sync`, `retro`,
  `standup`, `review`, `incident`, `project` (team/project logs).

## Index files (the "database")

`people/_index.md` — one Markdown table, the roster:

```markdown
| name | slug | role | level | team | manager | kind | start | status |
|------|------|------|-------|------|---------|------|-------|--------|
| Jane Doe | jane-doe | Senior SWE | L5 | platform | john-em | ic | 2023-02-01 | active |
```

`teams/_index.md` — team → EM → members + management mode:

```markdown
| team | slug | em | mode | headcount | members |
|------|------|----|------|-----------|---------|
| Platform | platform | John EM (john-em) | em-led | 6 | jane-doe, ... |
```

(`mode` is `directly-managed` or `em-led`.)

`projects/_index.md` — the project registry:

```markdown
| project | slug | team | owner | status | next milestone |
|---------|------|------|-------|--------|----------------|
```

`stakeholders/_index.md` — peers and cross-org partners (not reports, not the boss):

```markdown
| name | slug | role | their org | relationship | shared projects |
|------|------|------|-----------|--------------|-----------------|
| Dana Ray | dana-ray | Director | Data Platform | peer-director | streaming-migration |
```

(`relationship` examples: `peer-director`, `partner-em`, `partner-pm`, `exec-stakeholder`.)

## org.md — identifiers for signal lookup

`org.md` holds the org overview, how it fits the parent org, and the boss's profile + goals.
It also records **handles** so signals can be pulled for people who have no folder — the
leader themselves and the boss:

```markdown
## Identifiers
- self: <chat handle> · <wiki/author id> · <catalog id>
- boss: <name> · <chat handle> · <wiki/author id>

## Boss goals
- ...
```

`prep-boss-1-1` and `sync-signals` read these to fetch the leader's and the boss's recent
activity.

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
