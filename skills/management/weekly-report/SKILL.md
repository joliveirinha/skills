---
name: weekly-report
description: Draft the leader's weekly upward report to their manager. Refreshes org roll-ups, pulls live signals, runs cross-org analysis, and produces a dated draft of successes, top risks, concerns, decisions needed, asks, and bidirectional feedback for the leader to edit.
disable-model-invocation: true
---

# weekly-report

Produce a review-ready draft of the leader's upward report to their manager. It gathers,
synthesizes, and drafts — the leader edits and sends. Read `org.md` (including the `## Roles` block
and the **Altitude & span calibration** note) and the team summaries. Pitch the whole report at
the **boss's** altitude from `## Roles`, scaled to the level gap.

Read these files only if they aren't already in your context window:
- `docs/agents/conventions.md`

If it's missing, stop, tell the user, and suggest running `/setup-management-os` — don't run it
yourself.

## Steps

1. **Freshen the picture.** Run `refresh-summaries all` so team and org summaries reflect the
   week's captured entries.

2. **Pull signals.** Run `sync-signals org` (and per-team as useful) to catch activity not yet
   in any summary — shipped work, incidents, slipping items.

3. **Analyze across the org.** Delegate the cross-org synthesis to the `org-analyst` subagent,
   pointing it at `org.md`, `teams/*/summary.md`, `teams/*/health.md`, `projects/*.md`,
   `stakeholders/*/summary.md`, and the signals cache. It should produce ranked achievements,
   risks, concerns, cross-cutting patterns, **cross-org dependencies/friction from stakeholders**,
   and the questions the leader should be ready for.

4. **Draft the report** to `reports/upward/YYYY-MM-DD.md` with these sections:
   - **Successes** — 3–5 concrete wins, each tied to a team/person/project and its impact.
   - **Top risks** — ranked; each with impact, what's being done, and any decision or help needed.
   - **Concerns** — softer signals trending wrong (staffing, morale, delivery, key-person risk).
   - **Cross-org dependencies** — where progress hinges on another org (from stakeholders), and
     any relationship friction the boss can help unblock.
   - **Decisions needed / asks of the boss** — specific, answerable requests.
   - **Feedback — up** — what the leader wants to tell their manager (candid, constructive).
   - **Feedback — down/across** — themes the leader is carrying from the org that the boss should
     be aware of.
   - **How I can help my boss / how my boss can help me** — the two-way support framing.

## Rules
- Every claim traces to a summary, signal, or project file — cite the source; don't invent wins
  or risks.
- Keep individual performance/comp details **out** of the upward report unless the leader
  explicitly wants to raise a specific personnel matter.
- Bullet points, pitched at the boss's altitude (from `org.md` `## Roles`) and scaled to the level
  gap — a large gap favors outcomes and risks over task-level detail; a small gap allows more
  concrete delivery detail. See the calibration note in conventions.md.
- Flag stale inputs (a team not refreshed recently) so the leader knows where the picture is thin.

## Finish
Save the draft, show it, and note open questions the leader should resolve before sending.
