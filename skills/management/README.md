# Management OS

A set of [Claude Code](https://claude.com/claude-code) skills that give an engineering
leader a durable, git-backed "management operating system": a raw log of every interaction
plus **rolling summaries** — at **person → team → org** levels for a leader who manages
managers, collapsing to **person → team** for a first-line manager of ICs — so that before any
meeting you can generate a focused, current briefing, and every week you can draft an upward
report of successes / risks / concerns / asks.

The skills adapt to **your** role and span: they read your and your boss's role/level and what you
manage (ICs, EMs, or managers) from your data repo's `org.md`, and calibrate report altitude and
structure accordingly — a manager of ICs writing to a senior manager gets a different depth than a
director writing to a VP.

The skills are **tool-agnostic**. They talk about *capabilities* — a service catalog, an
issue tracker, a wiki, a chat system, a code host — never a specific product. Which real
tool (MCP server) backs each capability is recorded once in your data repo's `settings.md`.

## Two repos: keep your data separate

This package contains **no personal data**. You install it into a **separate, private repo**
that holds your logs and summaries.

```
this package  (shareable, npx-installable)   ──installed into──▶   your-management-repo (PRIVATE)
```

> [!WARNING]
> Your management repo contains sensitive personnel data — performance notes, concerns,
> promotion/comp context. Keep it a **private** repository, never commit it into this
> package, and treat it accordingly. The `setup-management-os` skill sets up a strong
> `.gitignore` posture for you.

## Install

From the repo root, `npx skills@latest add joliveirinha/skills`. Then, inside your **private
management repo**, bootstrap the structure:

```
/setup-management-os
```

This one skill does everything: scaffolds the `people`/`teams`/`projects` tree, seeds this
category's reference docs into your repo at `docs/agents/architecture.md` and `conventions.md`,
adds a `## Management OS` section to whichever of your `AGENTS.md`/`CLAUDE.md` already exists, and
installs the `org-analyst` subagent (asking which of Claude Code / OpenCode to install it for) —
`weekly-report` and `prep-boss-1-1` depend on it, so it isn't optional. It's safe to re-run any
time; it detects drift and asks before fixing anything.

## The skills

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

## How it fits together

- **Capture** (`log-1-1`, `log-meeting`) appends immutable, dated raw entries. `log-1-1` also
  handles peer/cross-org meetings, routing them to a separate `stakeholders/` area.
- **Synthesis** (`refresh-summaries`, `sync-signals`, `weekly-report`) rolls raw entries
  into rolling summaries and drafts reports, reading only what's new since the last roll-up.
- **Prep** (`prep-*`) reads the summaries (plus live signals) to produce a briefing tailored
  to the audience — IC, EM, peer, or your own manager.

See [`setup-management-os/doc/architecture.md`](setup-management-os/doc/architecture.md) for the
data model and roll-up flow, [`setup-management-os/doc/conventions.md`](setup-management-os/doc/conventions.md)
for file/entry formats, and [`/docs/specs/management/scheduling.md`](/docs/specs/management/scheduling.md)
for the (not-yet-built) automation design.
