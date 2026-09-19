# Rhylthyme paper: revision plan from the Consensus review

Source: `edit_and_suggest_improvements.pdf` (Consensus, 2026-09-17, 2 pages).
Status: PLAN. Nothing here has been applied to `rhylthyme.tex`.

## How to read the review

The reviewer worked mainly from the abstract, introduction and conclusion: it
says "evaluation is not visible here" and "if the full paper does not already
foreground one". Five of its eight points were checked against the full
manuscript (19 pages, as of commit 3239798). Three are real gaps, three are
framing problems in text that already exists, and two are already satisfied
and only need to be made easier to find.

| # | Suggestion | Status in the manuscript | Verdict |
|---|---|---|---|
| 1 | Open with one concrete scheduler failure case | The intro opens with a general statement; the concrete failure ("a wall of prose that is wrong about timing") sits in the last paragraph of Section 7 | Framing: move it up |
| 2 | Contributions read as a product inventory; recast as claims with evidence | True. Each item lists features (tool names, strategies, five endpoints) and none says what it enables or where it is shown | Framing: rewrite |
| 3 | State the narrowness claim earlier and more often | In the abstract's last sentence and the conclusion; absent from the intro and contributions | Framing: add two sentences |
| 4 | Cross-domain scope is asserted; add one comparison table across domains | Asserted ("one schema used across domains"); shown only by example figures from two domains | Real gap |
| 5 | Agent section sounds implementation-first; emphasise validator-gated publication | Section 7 opens with transport and tool lists; the gate is described in "Why this matters", the last paragraph | Framing: reorder |
| 6 | Evaluation is not visible; add benchmark or user-task results | There is none. The original plan (`PLAN.md`) scoped this as "descriptive systems paper, no new experiments" | Real gap, and the largest |
| 7 | Add a short worked example early | Present: Figure 1 and Listing 1 (Thanksgiving) on page 5, in Section 3 | Satisfied; point to it from page 1 |
| 8 | Clarify why MCP changes the user workflow | Present but late (same paragraph as #5) | Covered by #5 |

## The evidence already exists

The scope decision "no new experiments" predates work done since. Three
bodies of evidence are in the repositories and none is in the paper.

**A. Agent authoring benchmark** (`rhylthyme-cli-runner/eval/`, run 2026-09-14,
`claude-haiku-4-5`, 24 expert-written gold programs in
`rhylthyme-examples/gold`: 10 kitchen, 6 lab, 4 event, 4 fitness). Two
prompting conditions over the same sources: a single-shot baseline and the
four-turn structure the MCP server ships as its `plan_schedule` prompt and
runs server-side in `import_text`.

| Metric | Baseline | Four-turn |
|---|---|---|
| Steps F1 | 0.48 | 0.92 |
| Durations accuracy | 0.85 | 0.92 |
| Relationships (trigger) F1 | 0.22 | 0.63 |
| Track structure (Rand index) | 0.80 | 0.93 |
| Steps with no support in the source | 60% | 0.6% |
| End-to-end pass (valid in both validators, makespan and critical path match gold) | 2 of 24 | 15 of 24 |
| Resources precision / recall | 0.57 / 0.54 | 0.56 / 0.56 |
| Cost for the 24 programs | $1.10 | $2.20 |

Per domain, four-turn: steps F1 0.96 kitchen, 0.91 lab, 0.95 event, 0.83
fitness; relationships F1 0.67, 0.59, 0.66, 0.55; end-to-end pass 6/10, 4/6,
2/4, 3/4. This one table answers both #6 (does it work) and #4 (does it
transfer).

**B. Validator gate in the fix loop.** The same runs record fix iterations: 25
for the baseline, 15 for four-turn. The harness counts how often the
validator rejected a draft and the agent repaired it, which is the direct
measurement behind the "validator-gated publication" claim in #5.

**C. Conformance and coverage.** Two validators (Python, JavaScript) agree on
the example corpus (42 programs across 11 environment types) and on the gold
set; `rhylthyme mcp-test --publish` runs 12 checks on each of five endpoints
against the deployed server (60 of 60 passed on 2026-09-18). This is supporting material, one sentence, not
a result.

Not usable as evidence yet: production usage (logging started 2026-09-17,
almost all traffic is directory crawlers), and the duration-prediction
evaluation (synthetic runs only). Neither should be cited as a result.

## Plan

Six phases, ordered so that each leaves the paper in a consistent state. Page
budget: the related-work condensation freed about one page; the plan spends
it and stays at 19 to 20 pages.

### Phase 1. Evaluation section (new Section 8, before Discussion)

The highest-value change, and the others lean on it.

- Title: "Evaluation: can an agent author a valid schedule?" About 450 words.
- Setup paragraph: gold set (who wrote it, 24 programs, four domains, what a
  gold program fixes: steps, durations, resources, actors, relationships),
  the two conditions, the model, the matcher (how predicted steps are aligned
  to gold), the end-to-end criterion.
- One table: the eight rows above, baseline against four-turn.
- One small table or grouped bar figure: per-domain steps F1, relationships
  F1 and end-to-end pass. A figure is better; it can be drawn with the
  repository's chart conventions and exported as vector PDF.
- Findings paragraph, stated plainly, including what did not improve:
  resource extraction is flat at 0.56 in both conditions, 9 of 24 still fail
  end to end, fitness is the weakest domain.
- Threats to validity paragraph: gold set written by the author, one model,
  one run per condition (no variance), sources are clean text rather than
  scraped pages, the benchmark measures authoring and not whether a person
  can follow the result.

Acceptance: every number in the section is reproducible from
`eval/baseline.json` and `eval/four-turn.json`; a `make eval-tables` rule (or
a short script under `paper/`) regenerates the table so it cannot drift.

### Phase 2. First page: failure case, narrowness, pointer to the example

- Replace the intro's first paragraph opening with one concrete failure,
  about 90 words: Thanksgiving with one oven. A checklist app times each dish
  alone and cannot know the oven is taken; a project planner produces a
  chart the cook cannot run from; an LLM asked in prose gives timings that
  collide. End with a forward reference to Figure 1. The general statement
  (cook, technician, stage manager, trainer) follows as the second paragraph,
  shortened.
- Add the narrowness claim as the last sentence before the contribution
  list: what the paper does not claim (new scheduling theory, optimality) and
  what it does.
- Trim paragraph 2 (Gantt/CPM/PERT definitions) by about a third; those
  definitions now live in Related Work.

Acceptance: a reader of page 1 alone can state the use case, the claim and
where the example is.

### Phase 3. Contributions as claims with evidence

Rewrite the three items. Same three headings (language, runtime, agent
interface); each becomes: the claim, the alternative it is measured against,
and the section or table that supports it. Draft shape:

1. Language: one schema expresses capacity limits, cross-track dependencies
   and executor-controlled durations for four domains without domain-specific
   constructs (Table 1, new cross-domain table, Section 3).
2. Runtime: the constraints stay enforced while a person runs the schedule,
   rather than being resolved once into a static plan (Section 5 and 6).
3. Agent interface: an agent's schedule is refused until it validates, and a
   structured authoring prompt raises end-to-end correctness from 2 of 24 to
   15 of 24 (Section 7, Section 8).

Feature inventories (tool names, planner strategies, endpoint list) move out
of the list into their sections, where they already appear.

### Phase 4. Cross-domain table

One table, about a third of a page, in Section 3 after Table 1. Rows are
constructs; columns are kitchen, laboratory, event, fitness. Each cell is a
real instance from the gold set or corpus. The sketch below shows the shape
only; apart from the Thanksgiving and cookie entries its cells are
placeholders, not yet checked against the programs:

| Construct | Kitchen | Laboratory | Event | Fitness |
|---|---|---|---|---|
| Capacity-limited resource | oven, max 1 | centrifuge rotor, max 6 tubes | stage, max 1 | bench, max 1 |
| Indefinite step | roast until 74 °C | incubate until confluent | hold for house open | rest until recovered |
| Manual gate | guests seated | sample arrives | MC cue | coach signal |
| Negative offset | start potatoes 45 min before roast ends | pre-warm media before thaw ends | open doors 30 min before curtain | (none in set) |
| Replicates with in-flight limit | three trays, two on the rack | twelve samples, one rotor | (none in set) | rounds of a circuit |

Cells must be filled from actual programs, with "none in set" where the
corpus has no instance; invented examples would undercut the point.

**This needs your decision.** You removed the earlier Table 2 (positioning
against other systems). This table is a different thing, Rhylthyme across its
own domains rather than Rhylthyme against competitors, but it is still a
second table in the same section. If you would rather not add it, the
per-domain evaluation figure from Phase 1 carries the transferability claim
alone and this phase is dropped.

### Phase 5. Reorder the MCP section

No new content, only order. Open Section 7 with the workflow change: the
agent authors through tools, the validator refuses malformed programs, and
only a validated program gets a URL. Then the fix-loop counts from evidence
B. Then the tool inventory, transports, annotations and endpoints, which
currently come first. Move "Why this matters" from last paragraph to first
and fold its failure example into the Phase 2 opening so it is not told
twice.

### Phase 6. Abstract, conclusion, consistency

- Abstract: add one sentence of result (the 2-of-24 to 15-of-24 figure and
  the relationships F1), cut one sentence of enumeration to stay near 230
  words.
- Conclusion: restate the narrow claim with the evidence, and name the two
  honest gaps the evaluation exposed (resource extraction, no human-subject
  result).
- Limitations: replace the sentence that implies there is no evaluation;
  keep "no study of people following a schedule" as future work.
- Update `PLAN.md`'s scope table ("Evaluation: descriptive, no new
  experiments") so the two planning documents agree.
- Rebuild, check page count, check that Table 1 no longer floats past the
  references (a known leftover).

## What I recommend not doing

- A user study. The reviewer offers "benchmark or user-task results"; the
  benchmark exists and a study does not. Naming the absence in Limitations is
  honest and sufficient for a technical report.
- Citing production usage. It is two days of data dominated by crawlers.
- Re-running the benchmark on more models before this revision. It is worth
  doing (a second model and three runs per condition would give variance and
  answer the single-model threat), but it costs money and changes numbers, so
  it should be a deliberate step. Estimated cost at current prices: about $10
  for two more models at three runs each.

## Decisions needed from you

1. Add the cross-domain table (Phase 4), or rely on the per-domain evaluation
   figure alone?
2. Report the existing single-run benchmark as is, or spend about $10 first
   to add a second model and repeated runs?
3. Is the 19 to 20 page length acceptable, or should the evaluation displace
   something (the candidate is the second environment listing)?

## Order and effort

Phase 1 first (it produces the numbers the abstract, contributions and MCP
section quote), then 3, 2, 5, 6, with 4 slotted in if approved. Roughly half
a day of writing plus figure work; every phase can be reviewed on its own
commit.
