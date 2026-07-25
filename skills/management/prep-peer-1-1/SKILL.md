---
name: prep-peer-1-1
description: Management — Prepare a briefing before a meeting with a peer or cross-org stakeholder (fellow director, partner manager, PM in another org). Given their name, produces relationship state, shared projects and dependencies, open asks both directions, friction to resolve, cross-org opportunities, and questions to ask.
disable-model-invocation: true
---

# prep-peer-1-1

Prep a cross-org working meeting. This is a **collaborative, peer-level** conversation — about
the relationship and shared work, not performance or coaching. Read
`skills/management/doc/conventions.md` for file shapes.

## Input
The **peer's name** (resolve to a slug via `stakeholders/_index.md`; if unknown, offer to add
them via `/update-org`, or capture the meeting first with `/log-1-1` which can create the entry).

## Steps

1. **Load the relationship.** Read `stakeholders/<slug>/summary.md`, their `profile.md` (their
   org, remit, why they matter, dependencies), and the most recent few `log/` entries.

2. **Pull shared context.** Run `sync-signals <slug>` for cross-org signals (shared docs, joint
   project activity, chat threads you're both in) — visibility is often limited, so degrade
   cleanly. Cross-reference any `projects/*.md` you share.

3. **Produce the briefing** (save to `prep/peer-<slug>-YYYY-MM-DD.md` and show it):
   - **Relationship state** — where things stand: healthy, strained, transactional, new.
   - **Shared projects & dependencies** — what connects your orgs right now, and who depends on
     whom for what.
   - **Open asks (both directions)** — what you need from them, and what they've asked of you;
     flag anything overdue.
   - **Friction & risks** — misalignments, contended priorities, or dependencies at risk, and
     what would resolve them.
   - **Opportunities** — where closer collaboration would help both orgs.
   - **Questions to ask** — to surface their priorities and unblock shared work.

## Rules
- Keep it peer-level and collaborative — no performance/coaching framing (that's for reports).
- Ground every point in a source (summary, entry, signal, shared project); flag inference.
- If the summary is stale, note it and refresh first if there are unread entries.
- Note where cross-org visibility is thin — you often can't see their internal state.

## Finish
Show the briefing and highlight the single most important thing to align on and the top ask to
make (or expect).
