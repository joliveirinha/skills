# Design: scheduled / automated mode (NOT built yet)

Status: **design only** — the current package runs on-demand. This is the plan for the next
iteration, captured so it isn't lost. Nothing here is implemented.

## Goal

Reduce the manual steps around the weekly cycle so the leader reviews drafts instead of
generating them, while keeping capture (which needs human notes) manual.

## Candidate jobs

1. **Nightly signal warm-up** — run `sync-signals` for all active people/teams so caches are
   fresh before morning prep. Low value if signals are cheap to pull on demand; revisit.
2. **Weekly roll-up + report draft** — on a chosen morning:
   `refresh-summaries all` → `weekly-report` → leave a draft in `reports/vp/<date>.md` and
   notify the leader to review/edit. This is the highest-value automation.
3. **Staleness nudge** — flag any `summary.md` whose `last_rolled_up` is older than N days, or
   any team with no signal/entry in N days, and surface it as a to-do.

## Mechanism options (to decide next iteration)

- **Cron** (e.g. Claude Code scheduled runs / a system cron invoking the CLI headless). Simple,
  but needs the environment + MCP auth available unattended.
- **Pre-meeting hook** — a git hook or calendar-triggered run that fires the matching `prep-*`
  skill shortly before a meeting. Keeps everything on-demand-ish but removes the "remember to
  prep" step.

## Open questions

- Where do MCP credentials live for an unattended run, and is that acceptable given the data
  sensitivity?
- Idempotency is already handled by `last_rolled_up`, so re-runs are safe — good for cron.
- How to notify (chat message to self? a file? a desktop notification?).
- Do we want auto-capture from meeting transcripts (calendar/recording integration), or keep
  capture human-in-the-loop? Capture quality depends on the leader's private read of the room,
  so lean human-in-the-loop for now.

## Non-goals for the first automated iteration
- No auto-send of the upward report — always a human-reviewed draft.
- No automated performance/comp inference.
