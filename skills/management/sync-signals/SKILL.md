---
name: sync-signals
description: Pull live activity signals for a person, stakeholder, team, project, the org, or the special self and boss targets, from connected tools (issue tracker, code host, chat, wiki, incidents, on-call) into a short-lived cache for prep and reporting skills. Applies the required-vs-enrichment policy and degrades gracefully when a tool is absent.
---

# sync-signals

A helper for prep and reporting skills. Given an entity, gather current external signals so a
briefing reflects reality, not just what was said in the last 1:1. Read `mcp-map.md` in the data
repo to learn which capability maps to which MCP tool and which are `known-to-exist`.

## Input
An entity: a person (slug), a **stakeholder** (slug), a team (slug), a project (slug), `org`, or
the special targets `self` and `boss`.

- For `self` and `boss`, resolve the handles from the `## Identifiers` block in `org.md` (chat,
  wiki/author id, catalog id). These entities have no folder — you're pulling their *recent
  activity* to spot priorities and scope overlap, not maintaining a summary.
- For a stakeholder, pull what's visible cross-org (often limited): shared docs, joint project
  activity, chat threads you're both in.

## What to pull (by capability, when mapped)
- `issue-tracker` — open/assigned tickets, blockers, aging items, recently closed.
- `code` — recent PRs/merges, review load, stale branches.
- `chat` — notable recent threads the entity was central to (topics, not verbatim).
- `wiki` — recently changed or newly created docs relevant to the entity.
- incidents / on-call (via whichever capability provides them) — recent incidents, current
  on-call load.

Write results to a short-lived signals cache keyed by entity and date (a scratch file the
caller reads, not a permanent record). Summarize; don't dump raw payloads.

## Required-vs-enrichment policy
Signals here are **enrichment** — a prep or report should still work without them. But:

- If a capability is **mapped and `known-to-exist`** in `mcp-map.md`, do **not** silently skip
  it — pull it. In particular, if the caller flags that a **recently discussed topic needs more
  context**, actively fetch from the relevant tool rather than relying on memory.
- If a capability is genuinely **absent/unmapped**, skip it cleanly and record in the cache that
  it was unavailable, so the caller can note the gap rather than assume "all quiet".
- Never fabricate a signal. Absence of data is a real, reportable state.

(Contrast: roster data in `scaffold-management-os` / `update-org` is *required-for-correctness*
— there, a missing service-catalog tool blocks and asks the user. Here, missing tools degrade.)

## Finish
Return a compact, sourced signal summary per capability (with "unavailable" noted where it
applies) for the caller to fold into its output.
