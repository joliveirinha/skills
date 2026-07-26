---
name: log-meeting
description: Record a team or project meeting the leader attended. Accepts raw notes or a full transcript, appends a dated entry to the team or project log, updates project status and risks, and flags new risks into team health. For meetings the leader actually attends.
disable-model-invocation: true
---

# log-meeting

Capture a meeting into the right team or project log. Read `skills/management/doc/conventions.md` for shapes and
`skills/management/doc/architecture.md` for the meeting-scope model.

## Scope — which meetings belong here
- Meetings of **directly-managed teams** the leader attends: eng syncs, retros, standups,
  reviews → log to the team.
- **Critical / cross-cutting project** meetings the leader attends → log to the project.
- **Do not** use this for EM-led teams' internal meetings — the leader doesn't attend those;
  that visibility comes through `log-1-1` with the EM. If asked to log an EM-led team's meeting,
  point that out and confirm before proceeding. (EM-led teams exist only when the leader manages
  EMs — see **Management span** in `architecture.md`; a manager of ICs logs their one team's
  meetings here as directly-managed.)

## Inputs
- **Which team or project** (resolve via `teams/_index.md` or `projects/_index.md`).
- **What** — raw notes or a full transcript (pasted, file, or dictated).
- **Type** (optional) — `sync`, `retro`, `standup`, `review`, `incident`, or `project`.

## Steps

1. **Resolve the target** team or project — confirm which one rather than assuming when it's
   ambiguous (per **Never assume — ask** in `conventions.md`). If it's a project not yet in
   `projects/_index.md`, offer to add it.

2. **Distill** a transcript to substance (decisions, risks, blockers, owners, dates); clean up
   notes lightly without inventing content.

3. **Append the raw entry** to `teams/<slug>/log/` or write it against the project, using the
   entry shape. Record **who attended and their roles** in the entry's `## Participants` block —
   resolve names/roles from the roster and stakeholder index, then tools, then ask (per **Never
   assume — ask**); cross-link tracked people by slug, and offer to add an untracked-but-relevant
   attendee. Append-only; disambiguate same-day entries with `-2`.

4. **Update project state** (if project-scoped): status/RAG, milestones, dependencies, and the
   decision log in `projects/<slug>.md`. Add new risks to that project's risk list.

5. **Flag team-level risks** into `teams/<slug>/health.md` where relevant (delivery slip,
   staffing, on-call, morale from a retro), each as a dated trend line.

6. **Do not roll up here.** Team/org roll-up happens on the weekly cadence via
   `refresh-summaries`. Just note that the team's summary is now due for refresh.

## Finish
Confirm the entry path, list decisions and new risks captured, and name any owners/dates that
need follow-up.
