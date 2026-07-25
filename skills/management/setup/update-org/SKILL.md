---
name: update-org
description: Apply an org change to the management data repo. Handles hires, departures, moving a person between teams (carrying their history), a whole team joining or leaving the org, and adding or retiring a peer / cross-org stakeholder. Keeps the roster, team, project, and stakeholder index files and profiles in sync.
disable-model-invocation: true
---

# update-org

Incremental, reorg-aware maintenance of the data repo. For first-time setup or a full
reconcile, use `scaffold-management-os` instead. Read `skills/management/doc/conventions.md` for file shapes.

Ask which change is happening (or infer it from what the leader says), then apply the matching
flow. Always update **both** `people/_index.md` and `teams/_index.md` where relevant, and never
destroy existing `log/` entries or summaries.

## Hire (new person)
1. Add a row to `people/_index.md` (`status: active`).
2. Create `people/<slug>/` with `profile.md` stub, empty `log/`, and `summary.md` seeded with an
   old `last_rolled_up`.
3. Add them to the team's member list in `teams/_index.md` and adjust headcount.

## Offboard (departure)
1. Set the person's `status` to `leaver` in `people/_index.md` (do **not** delete the folder —
   archive it; their history stays).
2. Remove them from the team's active member list and adjust headcount.
3. Note the departure and its date; flag any single-points-of-failure this creates into the
   team's `health.md` (attrition/staffing).

## Move a person between teams
This must preserve history — the log follows the person.
1. Update the person's `team` and `manager` in `people/_index.md`.
2. Remove them from the old team's members and add them to the new team's members in
   `teams/_index.md`; adjust both headcounts.
3. Move `people/<slug>/` under the new team's ownership per your layout, **keeping `log/` and
   `summary.md` intact**, and append a short transfer note to `profile.md` with the date and
   from/to teams.
4. Note the move in both teams' `health.md` (staffing change).

## A team joins the org
1. Interview for the team's charter, EM, and management mode (`directly-managed`/`em-led`).
2. Pull its ICs + EM from the `service-catalog` MCP (required data — if unavailable, ask the
   leader for members or mark `roster-pending`; never invent names).
3. Create `teams/<slug>/` (profile, log, health, summary) and person folders for new members;
   add all index rows.
4. Add a note to `org.md` reflecting the changed org shape.

## A team leaves the org
1. Archive the team: mark it inactive in `teams/_index.md` (do not delete), and set its people's
   `status` appropriately (moved-out/leaver) in `people/_index.md`.
2. Drop it from active roll-ups (so `refresh-summaries` and `weekly-report` skip it) while
   keeping its history for the record.
3. Update `org.md`.

## Add or retire a peer / cross-org stakeholder
Lighter than a team reorg — no roster pull needed.
1. Add or update a row in `stakeholders/_index.md` (name, role, their org, relationship, shared
   projects).
2. For a new stakeholder, create `stakeholders/<slug>/` with `profile.md`, empty `log/`, and a
   `summary.md` (relationship sections per conventions).
3. When a relationship ends or moves, mark the stakeholder inactive (keep history); do not delete.

## Finish
Summarize the change, confirm both index files agree, and if the skill set or team list changed,
update the data repo's `README.md` table. Suggest running `/refresh-summaries` if a move or
departure materially changed a team.
