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

For a leader who manages ICs directly (see **Management span** below) there is a single team and no
separate org layer: the roll-up is just person → team, and that team summary *is* the boss-facing
top-level view.

## Knowledge retention (keep everything, read the summary)

Nothing is ever discarded, but no skill re-reads the whole history:

- **Raw `log/` entries are append-only and kept forever** — the complete, immutable record. Full
  retention lives here.
- **The rolling `summary.md` is the read layer.** Prep and reporting skills read the summary plus
  only the newest/recent entries and live signals — never the entire log. `last_rolled_up` gates
  the incremental roll-up so cost stays flat as history grows.
- So the picture you read is always synthesized and current; the raw detail is always still on disk
  if you need to go back to it.
- **One exception to "summary = current snapshot":** a person summary's `## Growth / trajectory`
  section *accumulates* (dated lines, never dropped) so how someone has grown over time stays
  visible. Every other summary section is a current view that merges and drops stale points.

## Management span (what the leader manages)

The leader's **span** — recorded once as `manages` in the `## Roles` block of `org.md` (see
`conventions.md`) — decides which structural layers exist. Skills read it instead of assuming a
level:

- **Manages ICs** (first-line manager). One team is the whole scope. The model collapses to
  **person → team**; that team summary doubles as the "org" view the boss sees. There are **no
  EM-led teams** (the one team is directly-managed), **no skip-levels**, and `prep-em-1-1` doesn't
  apply — `prep-ic-1-1` is the main downward prep. `org.md` still exists, holding the roles, the
  boss context, and the team-level top view.
- **Manages EMs / managers-of-managers.** The full multi-team model below applies: several teams
  (each directly-managed or EM-led), skip-levels, and a person → team → org roll-up.

Everything that follows describes the fuller (manages-EMs) shape; a manages-ICs leader simply uses
the subset that applies.

## Meeting-scope model (whose meetings feed what)

A leader who manages EMs has two kinds of teams, and visibility flows differently (a manager of ICs
has just one directly-managed team — the EM-led branch below simply doesn't apply):

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

## Standing forums (meetings that aren't a team or a project)

Some recurring meetings the leader attends span multiple teams or reach outside the org, so they
don't belong to any single `team` or `project`. These are **forums** (`forums/<slug>/`), a
first-class entity with the same log + rolling-summary shape as everything else. Each forum's
`_index.md` row records a **scope**:

- **`own-staff`** — the leader's own staff / leadership meeting (the leader + their EMs + any
  directly-run team). Content is cross-team: org-level themes, decisions, and risks that span
  teams. `log-meeting` routes it to `forums/<slug>/log/`; its summary is an input to the **org**
  view and to `org-analyst`. Cross-team risks raised here are still flagged into the affected
  `teams/<t>/health.md`.
- **`boss-staff`** — the leader's manager's staff meeting (the boss + the leader's peers). The
  leader attends, so it is logged here even though it sits *above* them — a deliberate exception
  to "only log what you attend/own." Its summary feeds the **boss** context: `prep-boss-1-1` and
  `weekly-report` read `boss-staff` (and `cross-org`) forum summaries.
- **`cross-org`** — standing councils / syncs with other orgs. Treated like `boss-staff` for
  read purposes (surfaces cross-org dependencies upward).
- **`other`** — any standing forum that doesn't fit the above.

Forums roll up on the same `last_rolled_up` cadence as everything else: only entries newer than
the marker are folded in. A forum does **not** roll into person or team summaries; it feeds the
org / boss-facing views directly.

## Peers & cross-org stakeholders

Not everyone the leader meets reports to them. Fellow directors, partner EMs, and PMs in other
orgs are tracked as **stakeholders** (`stakeholders/<slug>/`), with the same log/summary shape
as people but a *relationship-centric* summary (shared projects, dependencies, asks both ways,
friction). `log-1-1` routes a peer meeting here instead of `people/`. Stakeholders do **not**
roll into team or person summaries, but their cross-org dependencies and risks surface at the
**org** level — the `org-analyst` agent reads `stakeholders/*/summary.md` for `weekly-report`
and `prep-boss-1-1`, where cross-org relationships are often the most relevant to the boss.

## Capabilities, not products

Skills reference capability names only: `service-catalog`, `issue-tracker`, `wiki`, `chat`,
`code`. `settings.md` maps each capability to the actual MCP tool available in your environment,
and remembers which capabilities are known to exist across sessions. See `sync-signals` and
`conventions.md` for the required-vs-enrichment policy.
