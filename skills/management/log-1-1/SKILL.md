---
name: log-1-1
description: Management — Record a 1:1, skip-level, ad-hoc, or peer / cross-org conversation with one person. Accepts raw notes or a full transcript, resolves the person via the roster or the stakeholders index, appends a dated raw entry, extracts action items and feedback, and refreshes that entity's rolling summary.
disable-model-invocation: true
---

# log-1-1

Turn the notes from one conversation into a durable log entry plus an updated summary. Read
`skills/management/doc/conventions.md` for the entry and summary shapes.

## Inputs
- **Who** — the person's name (resolve via `people/_index.md` **or** `stakeholders/_index.md`;
  if ambiguous, ask; if genuinely new, offer to add them — a report via `/update-org`, a peer as
  a stakeholder).
- **What** — either raw notes or a full meeting transcript, pasted, in a file, or dictated.
- **Type** (optional) — `1-1` (default), `skip`, `adhoc`, or `feedback` (person); `1-1`, `sync`,
  `escalation`, `adhoc` (stakeholder).

## Steps

1. **Resolve who, and which area.** Look the name up in `people/_index.md` first, then
   `stakeholders/_index.md`. A **report** logs under `people/<slug>/`; a **peer / cross-org
   stakeholder** logs under `stakeholders/<slug>/`. Confirm the match if there's any doubt; if the
   name is unknown, ask whether they're a report or a peer and offer to create the entry.

2. **Distill the input.** If it's a transcript, condense to the substance — decisions,
   concerns, commitments, mood — don't store the verbatim transcript. If it's notes, clean them
   up lightly without inventing content.

3. **Append the raw entry** to `<area>/<slug>/log/YYYY-MM-DD-<type>.md` (where `<area>` is
   `people` or `stakeholders`) using the entry shape: `## Notes`, `## Action items`,
   `## Feedback exchanged` (given / received). Raw entries are append-only — if today already has
   an entry of this type, add `-2`.

4. **Extract structure** as you write:
   - Action items (yours and theirs) → the entry's `## Action items`.
   - Feedback given/received → `## Feedback exchanged`.
   - New concerns, mood signals, or growth moments worth carrying forward. For a stakeholder,
     capture instead: relationship state, shared-project/dependency updates, and asks both ways.

5. **Refresh this entity's summary.** Invoke `refresh-summaries` for this one person or
   stakeholder (it reads only entries newer than `last_rolled_up`, folds this entry into
   `summary.md`, and re-stamps the date). Keep it scoped — do not roll up the whole team here.

6. **If this is an EM 1:1**, remember (per the meeting-scope model) that this entry is a primary
   source of visibility into that EM's team. Capture team-level signals — delivery, risks,
   morale, staffing — clearly, since they will feed the team summary at the next team roll-up.

## Finish
Confirm the entry path, list the action items you captured, and surface anything that looks like
a risk or a feedback item worth raising — but do not roll up beyond this entity.
