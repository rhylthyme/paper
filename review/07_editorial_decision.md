# Editorial Decision (Round 1)

**Manuscript**: Rhylthyme: A Declarative Language and Agent-Native Runtime for Human-Executed, Resource-Constrained Schedules
**Decision date**: 2026-09-08
**Mode**: `full` (no sprint contract; no-contract synthesis path per `editorial_decision_standards.md` §0)

## Panel provenance

| Seat | Report | Status |
|---|---|---|
| Journal-Fit Reviewer (EIC) | `01_journal_fit_review.md` | complete |
| Reviewer 1 — Methodology (artifact verification) | `02_methodology_review.md` | complete (agent's closing summary lost to a rate limit; report on disk is whole) |
| Reviewer 2 — Domain (scheduling / temporal reasoning) | `03_domain_review.md` | complete |
| Reviewer 3 — Perspective (lab automation / MCP practice) | `04_perspective_review.md` | complete |
| Devil's Advocate | `05_devils_advocate.md` | complete (same; no CRITICAL, nine MAJOR) |
| Citation compliance (separate mode) | `06_citation_check.md` | complete |

All five seats reviewed blind (each saw only `00_field_analysis.md`); same model family, same provider, no human reviewer. Role separation only; no independence claim. `criteria_binding_unavailable`: no venue target confirmed, field-general review.

## Decision: **Major Revision** (4 of 4 scoring seats; DA raised no CRITICAL)

DA CRITICAL adjudication: none raised. DA MAJOR M5, M6, M8, M9 (description not matching the artifact) are adjudicated together below as validated, since R1 independently reproduced M5 and M6 by executing the code.

## Reviewer summary

| Reviewer | Recommendation | Confidence |
|---|---|---|
| Journal-Fit | Major Revision (light end) | 4 |
| R1 Methodology | Major Revision | 5 |
| R2 Domain | Major Revision | 4 |
| R3 Perspective | Major Revision | 4 |
| Devil's Advocate | findings only: 0 CRITICAL, 9 MAJOR, 12 MINOR | per finding |

## Consensus

**[CONSENSUS-3]** The abstract/§1 dichotomy ("static plan" vs. "machine executor") overstates the gap: human step-through runtimes already exist (protocols.io run mode; guided-cooking timers; show control; Tercio's human–robot teams; Artificial's guided manual steps). The §6 *combination* claim survives; the premise as first stated does not. (EIC W1; R2 W4; R3 W1/W3.)

**[CONSENSUS-2, third silent]** Table 2 cells are unfair to compared traditions: robots-only executor, "agent interface: none" for workflow engines (Seqera hosts an MCP server), BPMN mischaracterized as lacking timing. (EIC W7 partially; R3 W1/W2/W4.)

**[CONSENSUS-2]** "Four" endpoints in §1 vs. five listed in §5. (EIC W7; R3 minor; also citation check aside.)

**[CONSENSUS-2, R1 + DA, corroborated by execution]** The core-library `ProgramPlanner` reads a legacy data model and returns every schema-conformant program unchanged; the §4 planner paragraph described intent, not behaviour. (R1 W1; DA M5.)

**[CONSENSUS-2, R1 + DA]** "Python and JavaScript validators agree on the 49-program corpus" is unsupported: no cross-implementation test exists, verdicts differ on one file (replicate expansion), and rule sets differ (cycles, unparseable durations, unit strings, negative-offset severity). (R1 W2/W4/W5; DA M6.)

**[CONSENSUS-2, R1 + DA]** The "four fail for overlaps" count is wrong on number, cause and corpus definition. (R1 W3; DA m6.)

## Disagreements / single-seat findings adjudicated

- **R2 W1 (Major) — STNU framing.** Variable/indefinite steps are executor-ended (controllable), not contingent links; "unbounded contingent link" is not an STNU object; the DC future-work item was mis-posed. *Validated on the manuscript's own definitions.* Accepted.
- **R2 W2 (Major) — Allen labels for `event: start` triggers wrong/incomplete.** Validated (a start-anchored trigger induces a disjunction). Accepted; the schema `$comment` carries the same error and is flagged to the author as a code issue outside the manuscript.
- **R2 W3 (Major) — "critical path" is not CPM's.** Validated against §4's own description of the algorithm. Accepted.
- **R3 W5 (Major) — MCP citation predates the features used.** Validated (Streamable HTTP/annotations 2025-03-26; structured output 2025-06-18). Accepted.
- **R3 W8 (Major) — importer executes fetched code with no threat model.** Validated against `rhylthyme-importers/.../opentrons/simulator.py` (`exec`). Accepted as a limitation to disclose; a sandbox is out of scope for this report.
- **EIC W2 (Major) — "agent-native" never demonstrated.** Partly accepted: the report is descriptive by design, but the "wall of prose" failure-mode claim must be marked as design rationale, not measurement. A worked agent transcript is recommended, not required.
- **EIC W3 (Major) — one-schema-four-verticals asserted from one example.** Accepted as a Minor: a per-vertical corpus breakdown resolves it.
- **R2 W5 — missing execution-side lineage (dispatchable STN execution, mixed-initiative scheduling).** Accepted as Suggested (should-fix): the references R2 lists are verified by R2 but not yet independently re-verified by the editor; add after verification.

- **DA M7 (Major) — negative offsets fire from a forecast, not the actual end; validator placement is a placeholder.** Validated against `program_runner.py` and `validate_program.py` line references. Accepted.
- **DA M8 (Major) — the web "live clock" is a simulated interval-timer clock, not re-anchored to wall time.** Code-read, not device-tested; accepted as a disclosure requirement.
- **DA M9 (Major) — availability sentence names repositories not visible publicly.** Accepted; the sentence is narrowed and the author must either publish or keep it narrowed.
- **DA M3/M4 (Major) — "one schema across verticals" is achieved by keeping domain content out of the schema; the validator checks structure, not correctness, so "refuses what will not work" overclaims.** Accepted; §5 and §6 reworded to the narrower, defensible claim.
- **DA "Unexamined premise" — the person is modelled as a capacity-one resource with a button as duration oracle.** Accepted as framing; §6 now states the claim on that footing.
- **R1 W8 (Minor) — the renderer does not serve the Flask web runtime; three timing engines coexist.** Validated by grep; accepted (caption and §7).
- **R1 W11 (Minor) — no commit/release pin; root CLI default schema path broken; corpus definition ambiguous.** Accepted as author to-dos outside the manuscript, plus the corpus definition fixed in §4.

## Required revisions and status

| Ref | Item | Source | Status in revision 2 (2026-09-08) |
|---|---|---|---|
| R1 | Re-cut §1/abstract premise as three families; confront human step-through runtimes | EIC W1, R2 W4, R3 W3 | **Done** — new three-way framing; protocols.io run mode, guided timers, show control named; §6 "nearest neighbours" adds the runtime-without-model family |
| R2 | Remove incorrect Allen labels for start-anchored triggers | R2 W2 | **Done** — trigger table removed at author's request; triggers described in prose without relation labels; ontology section maps only the relations the schema annotates correctly |
| R3 | Fix STNU framing; distinguish executor-ended from process-ended durations; re-pose DC future work | R2 W1 | **Done** — §2.4, §3 Durations, §7 rewritten |
| R4 | Rename "critical path" to a critical-chain heuristic; drop "borrows CPM's critical path" | R2 W3 | **Done** — §2.1, §4 Analysis, §6, §7 |
| R5 | Correct Table 2: executor cells, workflow-engine agent interface, add caveat; fix BPMN characterization | R3 W1/W2/W4 | **Done** — cells revised, caption caveat added, BPMN paragraph rewritten (user tasks, timer events) |
| R6 | Cite the MCP spec revisions actually used; disclose bearer-token login vs. OAuth | R3 W5 | **Done** — `mcpspec2025` entry added; §5 and §7 |
| R7 | Disclose importer code execution | R3 W8 | **Done** — §4 Importers and §7 |
| R8 | "Refuses to publish" → "refuses by default (`allowInvalid`)"; annotations are hints | R3 W6/W7, EIC W5 | **Done** — §5 Tools, §5 Why this matters, §8 |
| R9 | Five endpoints, not four | EIC W7, R3 | **Done** |
| R10 | Per-vertical corpus breakdown | EIC W3 | **Done** — §4 Validation (38 JSON programs by vertical) |
| R11 | Mark the "wall of prose" claim as design rationale, not measurement | EIC W2 | **Done** — §5 closing sentence |
| R12 | Falling-behind semantics and multi-participant state | R3 W9/W10 | **Done** — §4 Execution (afterStep propagation, no replanning) and §7 (per-participant clocks) |
| R14 | Replace the planner paragraph with what the auto-planner does; drop `ProgramPlanner` claims | R1 W1, DA M5 | **Done** — §1 contribution 2, §4 "Common optimizations" |
| R15 | Replace the validator-agreement and "four overlaps" sentences with the measured, per-validator statement; list validator differences | R1 W2/W3/W4/W5, DA M6 | **Done** — §4 Validation, §7 |
| R16 | Disclose forecast-based firing of negative offsets | DA M7 | **Done** — §3 Triggers, §7 |
| R17 | Describe the web runtime as a simulated-clock player | DA M8 | **Done** — §4 Execution, §7 |
| R18 | Narrow the availability statement to public repositories | DA M9 | **Done** — §8 |
| R19 | Narrow "refuses what will not work" to structural correctness; state the person-as-resource premise; note Table 2 compares traditions | DA M3/M4, premise | **Done** — §5 Why this matters, §6, Table 2 caption |
| R20 | Renderer caption; Benchling not in registry; `actors` exemption; actor accounting scoped to CLI runner; tool/output-schema counts | R1 W8/W9/W10, DA m7/m12 | **Done** |
| R13 | Citation metadata corrections (16 FIX items) | citation check | **Done** — `references.bib` patched: pages (Wambsganss), DOIs (7 entries), Zhou author names + advance-article note, Nextflow issue, Pinedo edition, URL/access-date normalization, brace protection |

## Suggested revisions (not yet applied)

| Ref | Item | Source |
|---|---|---|
| S1 | Add execution-side lineage: dispatchable STN execution (Muscettola/Morris/Tsamardinos 1998; Morris & Muscettola 2005), mixed-initiative and personal scheduling (MAPGEN; SelfPlanner; PTIME), Cooking Navi (Hamada 2005) — after independent verification. **Partly done (author-supplied list, 2026-09-08):** 13 references verified via Crossref/arXiv and cited — mixed-initiative scheduling (Hsu 1993; Norbis & Smith 1996), rescheduling (Kelleher 1997; Melissargos & Pu 1997), timing and agency (Yu et al. 2017), programs for people (Abbott et al. 2015), wet/digital workflows (Lacroix 2009), HELAO (Rahmanian 2022), protocol translation (Shi 2024), lab-agent authoring (Angelopoulos 2026), MCP planning copilot (Benyamin 2025), ontology-to-tools (Zhou 2026), MCP workflow engine (Parmar 2026). Dispatchable-STN and personal-scheduling references still open. | R2 W5, W4 |
| S2 | One boxed agent-authoring exchange (prompt → validator findings → fix → publish) | EIC W2 |
| S8 | **Done (author request)** — Figure 1 replaced by a purpose-built five-track *Thanksgiving with One Oven* program that exercises cross-track dependencies, an indefinite step, a negative offset, a manual gate and a compound trigger; the bundled renderer now draws dependency arrows and marks indefinite/variable/manual steps (renderer v1.2.0, tests pass) | editor |
| S3 | Trim §2.3 (ATC) if length matters; it adds least beyond RCPSP | EIC W4 |
| S4 | Cite show-control software (e.g. QLab) for the events vertical | R3 W13 |
| S5 | Fix the schema's `$comment` for `event: start` (code change, not manuscript) | R2 W2 |
| S6 | Version-pin the availability statement | EIC W6 |
| S7 | Length: revision 2 is 12 pages (≈9.5 body) against the author's 6–8 target; §2.3 and the "Others" views paragraph are the natural cuts | editor |

## Revision roadmap

Round 2 should (a) re-review the revised manuscript against this roadmap (re-review mode); (b) verify and add S1's references; (c) decide on S2 and S7; (d) outside the manuscript: publish or rename the missing repositories, fix the root CLI's default schema path, add a cross-validator corpus test, and correct the schema `$comment` for start-anchored triggers. On completion of (a) without new findings, the editor expects Minor Revision.

## Author-facing items outside the manuscript

- `program_schema_0.2.0-alpha.json`: the `$comment` on `afterStep` with `event: start` labels the relation as `time:intervalStarts`/`time:intervalOverlaps`; per R2 the correct reading is a disjunction that depends on offset and relative duration.
- `rhylthyme-importers/.../opentrons/simulator.py` executes fetched protocol source in-process; sandbox before accepting arbitrary URLs from the MCP `import_from_source` tool.
