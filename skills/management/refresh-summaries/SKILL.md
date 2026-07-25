---
name: refresh-summaries
description: Management — Roll raw log entries up into rolling summaries at person, team, and org levels. Reads only entries newer than each summary's last_rolled_up marker, so it is cheap and idempotent. Called by log-1-1 for one person, and run weekly for teams and the org.
---

# refresh-summaries

Rebuild the *current picture* from the raw log, bottom-up. Idempotent: each `summary.md` carries
`last_rolled_up`, and this skill reads only entries dated after it. Read `skills/management/doc/conventions.md`
and `skills/management/doc/architecture.md` first.

## Target
Accept a target: a **person**, a **stakeholder**, a **team**, `org`, or `all`. Default to `all`
if unspecified for a weekly run; `log-1-1` calls this with a single person or stakeholder.

## Order (always bottom-up)
1. **Person summaries** — for each in-scope person: read `people/<p>/log/` entries newer than
   `last_rolled_up`; fold them into `summary.md` under `## Current work`, `## Concerns`,
   `## Feedback to give`, `## Open follow-ups`. Prefer updating/retiring existing points over
   appending duplicates. Stamp the new `last_rolled_up`.
2. **Stakeholder summaries** — for each in-scope stakeholder: read `stakeholders/<s>/log/` newer
   than `last_rolled_up` (+ signals) and update `summary.md` (`## Relationship state`, `## Shared
   projects & dependencies`, `## Open threads / asks`, `## Friction & risks`). Stamp the date.
   Stakeholders do **not** roll into any team or person summary.
3. **Team summaries** — for each in-scope team: read its members' summaries + the team `log/`
   (directly-managed) or the EM-1:1 entries + signals (em-led, per the meeting-scope model) +
   `sync-signals` output. Update `summary.md` (`## Health`, `## Top achievements`, `## Top
   risks`, `## EM notes`) and `health.md` trend lines. Stamp the date.
4. **Org section** — update the org-state portion of `org.md` from the team summaries **and**
   stakeholder summaries: the handful of things true across the org right now, the top
   cross-cutting risks, and cross-org dependencies/friction drawn from stakeholders.

## Rules
- Only read what's new. Do not re-summarize history already reflected in a summary.
- Summaries are a *current* view, not a changelog — merge, promote, and drop stale points; the
  raw log is the historical record.
- Pull enrichment via `sync-signals` for team/org levels when tools are mapped (see that skill's
  required-vs-enrichment policy). Skip cleanly if unavailable.
- Respect scope: refreshing one person must not touch team/org files.
- Note any summary whose source data is stale or a team with no recent entries/signals.

## Finish
Report which summaries were updated and the new `last_rolled_up` dates, and call out anything
newly surfaced (a fresh risk, a concern crossing teams).
