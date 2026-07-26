---
name: prep-ic-1-1
description: Prepare a briefing before a 1:1 with an individual contributor. Given the IC's name, produces a current-work overview, likely concerns, feedback to give, unresolved follow-ups from last time, and a short list of questions to ask.
disable-model-invocation: true
---

# prep-ic-1-1

Walk into an IC 1:1 already oriented. Read `skills/management/doc/conventions.md` for file shapes.

## Input
The **IC's name** (resolve to a slug via `people/_index.md`; ask if ambiguous).

## Steps

1. **Load the person.** Read `people/<slug>/summary.md`, their `profile.md` (role, level, goals,
   growth areas, comms style), and the most recent few `log/` entries.

2. **Pull live signals.** Run `sync-signals <slug>` for current tickets/PRs/blockers and any
   recent chat threads — especially if a topic from last time was left open and needs an update.

3. **Produce the briefing** (save to `prep/ic-<slug>-YYYY-MM-DD.md` and show it):
   - **Current work** — what they're focused on, in plain terms, with any blockers visible in
     signals.
   - **Likely concerns** — what they may raise or be quietly worried about (from summary trends,
     recent entries, signals like aging tickets or heavy review load).
   - **Feedback to give** — the `## Feedback to give` items from their summary, phrased ready to
     say, both praise and constructive.
   - **Open follow-ups** — unresolved action items from prior entries; note which are theirs vs
     yours.
   - **Growth / trajectory** — from the summary's accumulating `## Growth / trajectory`: how
     they've been developing over time, so feedback and career conversation build on that arc.
   - **Questions to ask** — a short, pointed list to open conversation and surface risks (career
     growth, blockers, morale, collaboration).

## Rules
- Ground every point in a source (summary, entry, signal); flag inference as inference.
- If the summary is stale (`last_rolled_up` old), say so and refresh first if there are unread
  entries.
- Keep it scannable — this is a pre-meeting glance, not a dossier.

## Finish
Show the briefing and highlight the one or two things most worth not missing this session.
