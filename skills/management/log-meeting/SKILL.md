---
name: log-meeting
description: Record a team, project, or standing-forum meeting the leader attended. Accepts raw notes or a full transcript, appends a dated entry to the team, project, or forum log, updates project status and risks, and flags new risks into team health. For meetings the leader actually attends (including their own staff and their boss's staff).
disable-model-invocation: true
---

# log-meeting

Capture a meeting into the right team, project, or forum log.

Read these files only if they aren't already in your context window:
- `docs/agents/conventions.md` — entry shapes
- `docs/agents/architecture.md` — the meeting-scope model

If either is missing, stop, tell the user, and suggest running `/setup-management-os` — don't run
it yourself.

## Scope — which meetings belong here
- Meetings of **directly-managed teams** the leader attends: eng syncs, retros, standups,
  reviews → log to the team.
- **Critical / cross-cutting project** meetings the leader attends → log to the project.
- **Standing forums** the leader attends that span teams or reach outside the org — the leader's
  **own staff** meeting, the **boss's staff** meeting, a **cross-org council** → log to
  `forums/<slug>/log/` (resolve via `forums/_index.md`). See **Standing forums** in
  `architecture.md`. The boss's staff (`boss-staff` scope) is logged here even though it sits
  *above* the leader — a deliberate exception, because the leader attends it.
- **Do not** use this for EM-led teams' internal meetings — the leader doesn't attend those;
  that visibility comes through `log-1-1` with the EM. If asked to log an EM-led team's meeting,
  point that out and confirm before proceeding. (EM-led teams exist only when the leader manages
  EMs — see **Management span** in `architecture.md`; a manager of ICs logs their one team's
  meetings here as directly-managed.)

## Inputs
- **Which team, project, or forum** (resolve via `teams/_index.md`, `projects/_index.md`, or
  `forums/_index.md`).
- **What** — raw notes or a full transcript (pasted, file, or dictated).
- **Type** (optional) — `sync`, `retro`, `standup`, `review`, `incident`, `project`, or `staff`
  (forum default).

## Steps

1. **Resolve the target** team, project, or forum — confirm which one rather than assuming when
   it's ambiguous (per **Never assume — ask** in `conventions.md`). If it's a project not yet in
   `projects/_index.md`, or a forum not yet in `forums/_index.md`, offer to add it.

2. **Distill** a transcript to substance (decisions, risks, blockers, owners, dates); clean up
   notes lightly without inventing content.

3. **Append the raw entry** to `teams/<slug>/log/`, the project, or `forums/<slug>/log/`, using
   the entry shape. Record **who attended and their roles** in the entry's `## Participants`
   block — resolve names/roles from the roster and stakeholder index, then tools, then ask (per
   **Never assume — ask**); cross-link tracked people by slug, and offer to add an
   untracked-but-relevant attendee. Append-only; disambiguate same-day entries with `-2`.

4. **Update project state** (if project-scoped): status/RAG, milestones, dependencies, and the
   decision log in `projects/<slug>.md`. Add new risks to that project's risk list.

5. **Flag team-level risks** into `teams/<slug>/health.md` where relevant (delivery slip,
   staffing, on-call, morale from a retro), each as a dated trend line. This applies to
   cross-team risks surfaced in a forum too — flag them into each affected team's `health.md`.

6. **If forum-scoped**, capture per the forum's scope (see **Standing forums** in
   `architecture.md`): for `own-staff`, cross-team themes, decisions, and risks; for
   `boss-staff`/`cross-org`, direction from the boss and cross-org threads/asks — these feed
   `prep-boss-1-1` and `weekly-report`, so make them explicit.

7. **Do not roll up here.** Team/forum/org roll-up happens on the weekly cadence via
   `refresh-summaries`. Just note that the team's or forum's summary is now due for refresh.

## Finish
Confirm the entry path, list decisions and new risks captured, and name any owners/dates that
need follow-up.
