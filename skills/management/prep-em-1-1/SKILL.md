---
name: prep-em-1-1
description: Management — Prepare a briefing before a 1:1 with an engineering manager. Given the EM or their team, produces how the team is doing, how the EM is doing, team concerns, top achievements, top risks, and coaching or advice to offer. The primary visibility path for EM-led teams.
disable-model-invocation: true
---

# prep-em-1-1

Prep an EM 1:1 that covers both the team and the manager. For EM-led teams this 1:1 is the
leader's main window into the team, so treat it as both a status and a coaching conversation.
Read `skills/management/doc/architecture.md` (meeting-scope model) and `skills/management/doc/conventions.md`.

## Input
The **EM's name or their team** (resolve via `people/_index.md` / `teams/_index.md`; each maps
to the other).

## Steps

1. **Load the team and the EM.** Read `teams/<team>/summary.md`, `health.md`, and recent team
   `log/`; the EM's own `people/<em>/summary.md` and `profile.md`; and skim member summaries for
   anything the EM should know about (or that you should probe).

2. **Pull live signals.** Run `sync-signals <team>` (delivery, incidents, on-call, aging work)
   and `sync-signals <em>` — actively fetch when a topic from last time needs a current read.

3. **Produce the briefing** (save to `prep/em-<em-slug>-YYYY-MM-DD.md` and show it):
   - **How the team is doing** — delivery, health trends, staffing, morale from `health.md` + signals.
   - **How the EM is doing** — their own load, growth, effectiveness; distinct from the team's health.
   - **Team concerns** — what's trending wrong or needs your attention; key-person and attrition risk.
   - **Top achievements** — wins to acknowledge and reinforce.
   - **Top risks** — ranked, with what you'd want the EM to be doing about each.
   - **Coaching / advice** — specific, situational guidance to offer this EM (delegation, hiring,
     handling a struggling report, prioritization) — the highest-value part.
   - **Questions to ask** — to draw out what the summaries can't tell you.

## Rules
- Separate *team health* from *EM performance* — don't conflate a struggling team with a
  struggling manager, or vice versa.
- Ground every point in a source; flag inference. Note stale summaries and refresh if needed.
- For em-led teams, lean on this 1:1's captured entries as the main input — probe for the
  visibility you don't otherwise get.

## Finish
Show the briefing and highlight the most important coaching moment and the top risk to land.
