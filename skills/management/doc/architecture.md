# Architecture

## The idea

Two things that are usually kept in a leader's head are made durable and composable:

1. **Raw log** — an append-only, dated record of every interaction (1:1s, skip-levels,
   meetings, ad-hoc). Never rewritten; the source of truth.
2. **Rolling summaries** — a *current* view at three levels, rebuilt from the raw log plus
   live signals. These are what you actually read before a meeting.

```
                          ┌──────────────────────────────────────────────┐
   capture                │                 synthesis                     │        prep
─────────────             │           (bottom-up roll-up)                 │  ───────────────
 log-1-1  ──▶ people/<p>/log/ ──▶ people/<p>/summary.md ──┐               │  prep-ic-1-1
                                                          ├─▶ teams/<t>/summary.md ─┐  prep-em-1-1
 log-meeting ─▶ teams/<t>/log/ ───────────────────────────┘   + health.md          ├─▶ prep-boss-1-1
              projects/<x>.md                                                       │  weekly-report
                                                                 org.md  ◀──────────┘
 sync-signals ─▶ live signals (tickets, PRs, incidents, chat, on-call) feed every level
```

## The roll-up, and why it's cheap

Every `summary.md` (person and team) carries a frontmatter marker:

```yaml
last_rolled_up: 2026-07-18
```

`refresh-summaries` reads **only the raw entries newer than that date**, folds them into the
existing summary, and stamps a new date. So:

- Re-running a roll-up is **idempotent** and cheap — it never re-reads history.
- The raw log and the summary never fight: history lives in `log/`, the current picture lives
  in `summary.md`.

Order is strictly bottom-up: person summaries first, then team summaries (which read their
members' summaries + the team log + signals), then the org section of `org.md` (which reads
team summaries). `log-1-1` refreshes just the one person it touched — a cheap, immediate update.

## Meeting-scope model (whose meetings feed what)

The leader manages two kinds of teams, and visibility flows differently:

- **Directly-managed teams** — the leader attends their eng syncs, retros, standups. These go
  through `log-meeting` into `teams/<t>/log/`, and feed the team summary directly.
- **EM-led teams** — the leader does **not** attend the team's internal meetings. Visibility
  comes from the **EM 1:1** (`log-1-1` with the EM) plus live signals. For these teams,
  `refresh-summaries` and `prep-em-1-1` treat the EM-1:1 entries + signals as the primary input,
  not `log-meeting`.
- **Critical / cross-cutting projects** — the leader attends these regardless of who runs the
  owning team; they go through `log-meeting` into `projects/<x>.md`.

Each team's `_index.md` row records its management mode (`directly-managed` | `em-led`) so the
skills know where to look.

## Peers & cross-org stakeholders

Not everyone the leader meets reports to them. Fellow directors, partner EMs, and PMs in other
orgs are tracked as **stakeholders** (`stakeholders/<slug>/`), with the same log/summary shape
as people but a *relationship-centric* summary (shared projects, dependencies, asks both ways,
friction). `log-1-1` routes a peer meeting here instead of `people/`. Stakeholders do **not**
roll into team or person summaries, but their cross-org dependencies and risks surface at the
**org** level — the `org-analyst` agent reads `stakeholders/*/summary.md` for `weekly-report`
and `prep-boss-1-1`, where cross-org relationships are often the most VP-relevant.

## Capabilities, not products

Skills reference capability names only: `service-catalog`, `issue-tracker`, `wiki`, `chat`,
`code`. `mcp-map.md` maps each capability to the actual MCP tool available in your environment,
and remembers which capabilities are known to exist across sessions. See `sync-signals` and
`skills/management/doc/conventions.md` for the required-vs-enrichment policy.
