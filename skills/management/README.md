# Management OS

A set of [Claude Code](https://claude.com/claude-code) skills that give an engineering
leader a durable, git-backed "management operating system": a raw log of every interaction
plus **rolling summaries at person → team → org levels**, so that before any meeting you can
generate a focused, current briefing, and every week you can draft an upward report of
successes / risks / concerns / asks.

The skills are **tool-agnostic**. They talk about *capabilities* — a service catalog, an
issue tracker, a wiki, a chat system, a code host — never a specific product. Which real
tool (MCP server) backs each capability is recorded once in your data repo's `mcp-map.md`.

## Two repos: keep your data separate

This package contains **no personal data**. You install it into a **separate, private repo**
that holds your logs and summaries.

```
this package  (shareable, npx-installable)   ──installed into──▶   your-management-repo (PRIVATE)
```

> [!WARNING]
> Your management repo contains sensitive personnel data — performance notes, concerns,
> promotion/comp context. Keep it a **private** repository, never commit it into this
> package, and treat it accordingly. The `scaffold-management-os` skill sets up a strong
> `.gitignore` posture for you.

## Install

From the repo root, `npx skills@latest add joliveirinha/skills`. Then, inside your **private
management repo**, bootstrap the structure:

```
/scaffold-management-os
```

## The skills

| Skill | Invoke with | Use it… |
|---|---|---|
| **scaffold-management-os** | `/scaffold-management-os` | Once to bootstrap the repo; re-run anytime to reconcile drift. Writes your data repo's own README. |
| **update-org** | `/update-org` | For reorg events: hires, departures, moving a person between teams, a team joining or leaving your org, adding/retiring a peer stakeholder. |
| **log-1-1** | `/log-1-1` | After any 1:1, skip-level, ad-hoc, or **peer meeting** — paste notes or a transcript. |
| **log-meeting** | `/log-meeting` | After a team/project meeting you attended — paste notes or a transcript. |
| **refresh-summaries** | `/refresh-summaries` | To roll up person → team → org summaries (usually chained automatically). |
| **sync-signals** | (automatic) | Helper that pulls live activity from your connected tools. |
| **weekly-report** | `/weekly-report` | Weekly, to draft your upward report. |
| **prep-ic-1-1** | `/prep-ic-1-1 <name>` | Before a 1:1 with an IC. |
| **prep-em-1-1** | `/prep-em-1-1 <em-or-team>` | Before a 1:1 with an engineering manager. |
| **prep-peer-1-1** | `/prep-peer-1-1 <name>` | Before a meeting with a peer / cross-org stakeholder. |
| **prep-boss-1-1** | `/prep-boss-1-1` | Before a 1:1 with your manager. |

## How it fits together

- **Capture** (`log-1-1`, `log-meeting`) appends immutable, dated raw entries. `log-1-1` also
  handles peer/cross-org meetings, routing them to a separate `stakeholders/` area.
- **Synthesis** (`refresh-summaries`, `sync-signals`, `weekly-report`) rolls raw entries
  into rolling summaries and drafts reports, reading only what's new since the last roll-up.
- **Prep** (`prep-*`) reads the summaries (plus live signals) to produce a briefing tailored
  to the audience — IC, EM, peer, or your own manager.

See [`doc/architecture.md`](doc/architecture.md) for the data model and roll-up flow,
[`doc/conventions.md`](doc/conventions.md) for file/entry formats, and
[`design/scheduling.md`](design/scheduling.md) for the (not-yet-built) automation design.
