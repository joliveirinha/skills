---
name: refresh-summaries
description: Roll raw log entries up into rolling summaries at person, team, forum, and org levels. Reads only entries newer than each summary's last_rolled_up marker, so it is cheap and idempotent. Called by log-1-1 for one person, and run weekly for teams, forums, and the org.
---

# refresh-summaries

Rebuild the *current picture* from the raw log, bottom-up. Idempotent: each `summary.md` carries
`last_rolled_up`, and this skill reads only entries dated after it.

Read these files only if they aren't already in your context window:
- `docs/agents/conventions.md`
- `docs/agents/architecture.md`

If either is missing, stop, tell the user, and suggest running `/setup-management-os` — don't run
it yourself.

## Target
Accept a target: a **person**, a **stakeholder**, a **team**, a **forum**, `org`, or `all`.
Default to `all` if unspecified for a weekly run; `log-1-1` calls this with a single person or
stakeholder.

## Order (always bottom-up)
1. **Person summaries** — for each in-scope person: read `people/<p>/log/` entries newer than
   `last_rolled_up`; fold them into `summary.md` under `## Current work`, `## Concerns`,
   `## Feedback to give`, `## Open follow-ups`. Prefer updating/retiring existing points over
   appending duplicates. **Also append** any growth/development signals in those entries to
   `## Growth / trajectory` as dated lines — this section accumulates and older lines are never
   dropped (see conventions). Stamp the new `last_rolled_up`.
2. **Stakeholder summaries** — for each in-scope stakeholder: read `stakeholders/<s>/log/` newer
   than `last_rolled_up` (+ signals) and update `summary.md` (`## Relationship state`, `## Shared
   projects & dependencies`, `## Open threads / asks`, `## Friction & risks`). Stamp the date.
   Stakeholders do **not** roll into any team or person summary.
3. **Team summaries** — for each in-scope team: read its members' summaries + the team `log/`
   (directly-managed) or the EM-1:1 entries + signals (em-led, per the meeting-scope model) +
   `sync-signals` output. Update `summary.md` (`## Health`, `## Top achievements`, `## Top
   risks`, `## EM notes`) and `health.md` trend lines. Stamp the date. (The em-led input path
   applies only when the leader manages EMs — see **Management span** in `architecture.md`; a
   manager of ICs has one directly-managed team.)
4. **Forum summaries** — for each in-scope forum: read `forums/<f>/log/` entries newer than
   `last_rolled_up` (+ signals) and update `summary.md` (`## Key points & direction`,
   `## Decisions`, `## Cross-cutting risks`, `## Follow-ups & asks`); keep the `scope` frontmatter.
   Stamp the date. Flag any cross-team risk surfaced here into the affected teams' `health.md`.
   Forums do **not** roll into person or team summaries — they feed the org / boss-facing views
   directly (next step, and read by `prep-boss-1-1`/`weekly-report`).
5. **Org section** — **only when the leader manages EMs/managers** (span from `org.md` `## Roles`):
   update the org-state portion of `org.md` from the team summaries, the **forum** summaries
   (`own-staff` for internal cross-team state; `boss-staff`/`cross-org` for direction and cross-org
   dependencies), **and** stakeholder summaries: the handful of things true across the org right
   now, the top cross-cutting risks, and cross-org dependencies/friction. For a manager of ICs
   there is no separate org layer — stop at the single team summary, which serves as the top-level
   view (a manager of ICs may still keep an `own-staff` forum; refresh it, but it has no org layer
   above it).

## Rules
- Only read what's new. Do not re-summarize history already reflected in a summary.
- Summaries are a *current* view, not a changelog — merge, promote, and drop stale points; the
  raw log is the historical record. **Exception:** a person's `## Growth / trajectory` accumulates
  (dated lines, never dropped) — the drop-stale rule applies only to the current-view sections.
- Pull enrichment via `sync-signals` for team/org levels when tools are mapped (see that skill's
  required-vs-enrichment policy). Skip cleanly if unavailable.
- Respect scope: refreshing one person must not touch team/forum/org files.
- Note any summary whose source data is stale or a team with no recent entries/signals.

## Finish
Report which summaries were updated and the new `last_rolled_up` dates, and call out anything
newly surfaced (a fresh risk, a concern crossing teams).
