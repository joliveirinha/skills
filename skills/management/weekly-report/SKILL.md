---
name: weekly-report
description: Draft the leader's weekly upward report to their manager. Refreshes org roll-ups, pulls live signals, runs cross-org analysis, and produces a dated draft of successes, top risks, concerns, decisions needed, asks, and bidirectional feedback for the leader to edit.
disable-model-invocation: true
---

# weekly-report

Produce a review-ready draft of the report a Director gives a VP. It gathers, synthesizes, and
drafts — the leader edits and sends. Read `org.md`, the team summaries, and `skills/management/doc/conventions.md`.

## Steps

1. **Freshen the picture.** Run `refresh-summaries all` so team and org summaries reflect the
   week's captured entries.

2. **Pull signals.** Run `sync-signals org` (and per-team as useful) to catch activity not yet
   in any summary — shipped work, incidents, slipping items.

3. **Analyze across the org.** If an `org-analyst` subagent is available, delegate the cross-org
   synthesis to it; otherwise do the same analysis inline. Either way, read `org.md`,
   `teams/*/summary.md`, `teams/*/health.md`, `projects/*.md`, `stakeholders/*/summary.md`, and
   the signals cache, and produce ranked achievements, risks, concerns, cross-cutting patterns,
   **cross-org dependencies/friction from stakeholders**, and the questions the leader should be
   ready for. (The subagent isn't installed by plain `npx skills` — see the category README; the
   inline path yields the same result, just using more of the main context.)

4. **Draft the report** to `reports/vp/YYYY-MM-DD.md` with these sections:
   - **Successes** — 3–5 concrete wins, each tied to a team/person/project and its impact.
   - **Top risks** — ranked; each with impact, what's being done, and any decision or help needed.
   - **Concerns** — softer signals trending wrong (staffing, morale, delivery, key-person risk).
   - **Cross-org dependencies** — where progress hinges on another org (from stakeholders), and
     any relationship friction the VP can help unblock.
   - **Decisions needed / asks of the VP** — specific, answerable requests.
   - **Feedback — up** — what the leader wants to tell their manager (candid, constructive).
   - **Feedback — down/across** — themes the leader is carrying from the org that the VP should
     be aware of.
   - **How I can help my boss / how my boss can help me** — the two-way support framing.

## Rules
- Every claim traces to a summary, signal, or project file — cite the source; don't invent wins
  or risks.
- Keep individual performance/comp details **out** of the upward report unless the leader
  explicitly wants to raise a specific personnel matter.
- Bullet points, VP-appropriate altitude — outcomes and risks, not task-level detail.
- Flag stale inputs (a team not refreshed recently) so the leader knows where the picture is thin.

## Finish
Save the draft, show it, and note open questions the leader should resolve before sending.
