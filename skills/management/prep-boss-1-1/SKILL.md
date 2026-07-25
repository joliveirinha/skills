---
name: prep-boss-1-1
description: Management — Prepare a briefing before a 1:1 with the leader's own manager. Produces org status, the leader's main concerns, feedback in both directions, how the leader can help their boss succeed, and how the boss can help the leader.
disable-model-invocation: true
---

# prep-boss-1-1

Prep the upward 1:1 — a two-way conversation, not just a status readout. Read `org.md` (which
holds the boss's profile and goals) and `skills/management/doc/conventions.md`.

## Steps

1. **Freshen the org view.** If team/org summaries are stale, run `refresh-summaries all` first.

2. **Load context.** Read `org.md` (org state, parent-org fit, boss's goals, and the
   `## Identifiers` block), the latest `reports/vp/` report, the team summaries, and the
   `stakeholders/*/summary.md` (cross-org relationships are often the most VP-relevant). Run
   `sync-signals org` for anything material that landed since the last roll-up.

3. **Pull self + boss activity.** Run `sync-signals self` and `sync-signals boss` (handles from
   `org.md`) to see what the leader has been working on recently (wiki pages, notable chat) and
   what the boss is currently focused on. This is the raw material for finding overlap.

4. **Analyze.** Use the `org-analyst` agent for a ranked cross-org read — achievements, risks,
   concerns, cross-cutting patterns, cross-org dependencies (from stakeholders), and questions
   the boss may ask.

5. **Produce the briefing** (save to `prep/boss-YYYY-MM-DD.md` and show it):
   - **How my org is doing** — the honest current state at VP altitude: outcomes, trajectory,
     top risks.
   - **My main concerns** — what's keeping the leader up, and what (if anything) they need from
     the boss on each.
   - **Scope intersections** — where the leader's recent work and the boss's recent focus overlap
     or collide (from steps 2–3): shared initiatives, cross-org dependencies via stakeholders,
     places to align or where the leader can advance the boss's agenda. This is the section that
     turns a status readout into a two-way conversation.
   - **Feedback — up** — candid, constructive things to tell the boss (what's working, what
     isn't, where alignment is thin).
   - **Feedback — down/across** — what the leader is hearing from the org that the boss should
     know.
   - **How I can help my boss succeed** — tie the org's work and the intersections above to the
     boss's stated goals in `org.md`; where can the leader take something off the boss's plate.
   - **How my boss can help me** — specific, actionable asks: decisions, air cover, headcount,
     cross-org unblocking.

## Rules
- **Manager-to-manager altitude.** Keep everything high-level; this is a director→VP
  conversation. **Exclude low-level technical detail** unless it maps to a high-level topic — a
  **critical project** or a **critical person**. When a technical item does surface, frame it in
  terms of outcome, risk, or decision, not implementation.
- Anchor "how I can help my boss" in the boss's actual goals from `org.md` — not generic
  platitudes. If those goals aren't recorded, note the gap and suggest capturing them.
- Base scope intersections on real signals (steps 2–3); flag anything inferred as inference, and
  say so if `self`/`boss` handles aren't set in `org.md` (then intersections are best-effort).
- Keep personnel specifics out unless the leader intends to raise a particular matter.
- Ground claims in sources; flag inference; note where the org picture is thin.

## Finish
Show the briefing and highlight the single most important thing to raise, and the single most
important ask to make.
