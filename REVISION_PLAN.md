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

### Phase 1a. Model comparison runs (added 2026-09-18 at the author's request)

The evaluation becomes a two-factor comparison: model tier by prompt
structure, over the same 24 gold programs. The interesting question is the
interaction, not the ranking: does the four-turn structure matter less as
the model gets stronger, and which errors (dependencies, resources) survive
at the top tier? A flat "bigger model scores higher" table is the expected
and least useful outcome; the per-component breakdown is what earns the
space.

Design:

- Models: `claude-haiku-4-5` (done, one run), `claude-sonnet-5`,
  `claude-opus-5`, `claude-fable-5-1`. The harness is Anthropic-only
  (`eval/llm.py`). Other vendors need a provider adapter first and are out of
  this phase; the paper must say the comparison is within one model family.
- Conditions: `baseline` and `four-turn`, unchanged prompts, default
  sampling, `--max-fix-iterations 2`, the same matcher threshold (0.5).
- Replicates: three per cell, to report a mean and a range instead of a
  single draw. The response cache is keyed by model, pattern and prompt, so
  each replicate needs its own `--cache-dir` or it replays the first.
- Recorded per cell: the eight metrics already reported, fix iterations
  (validator rejections repaired), tokens, cost and wall time, so the paper
  can show cost against end-to-end pass rate.
- No harness code changes are needed; a driver script under
  `rhylthyme-cli-runner/eval/` loops models, patterns and replicates and
  writes `eval/models/<model>/<pattern>/run<N>/results.json`.

Cost, from the measured Haiku token counts (1.33 M input, 0.39 M output for
one full run of both prompts) and the harness price table dated 2026-06-24.
Stronger models may use fewer fix iterations or longer outputs, so treat
these as estimates within about 30%:

| Model | One run | Three runs |
|---|---|---|
| Haiku 4.5 | $3.30 | $9.90 |
| Sonnet 5 | $6.59 | $19.77 |
| Opus 5 | $16.48 | $49.44 |
| Fable 5.1 | $32.97 | $98.91 |
| All four | $59.34 | $178.02 |
| Without Fable | $26.37 | $79.12 |

An earlier version of this plan said "about $10 for two more models at three
runs each". That was wrong: it priced every model at Haiku rates.

Cheaper designs that keep the point: (a) one run per cell for all four
models, about $59, no variance; (b) three runs for Haiku and Sonnet, one for
Opus and Fable, about $79; (c) three runs without Fable, about $79. Option
(b) gives variance where it is cheap and a single reading at the top, and is
the recommended default.

Acceptance: a results directory per cell, a summary CSV, and `--from-cache`
re-scoring reproduces every number without spending.

#### Result of Phase 1a under the author's $10 ceiling (run 2026-09-18)

The author capped total spending at $10. A one-program canary showed the cost
table above was far too low for Sonnet: on the same program it wrote about 3.5
times Haiku's output tokens, so a program costs about five times Haiku's, not
twice, and a full 24-program Sonnet run would be about $16. The design was cut
to a paired, domain-balanced subset with a hard stop in the driver
(`rhylthyme-cli-runner/eval/run_model_comparison.py`, ledger in
`eval/models/spend-ledger.json`). It stopped itself at **$5.34** after seven
programs (event 2, fitness 2, kitchen 2, lab 1), each run through both
prompts. With the $3.30 already spent on Haiku the total is $8.64.

Like-for-like on those seven programs, one run per cell
(`eval/models/comparison.md`, regenerate with `eval/compare_models.py`):

| Metric | Haiku baseline | Haiku four-turn | Sonnet baseline | Sonnet four-turn |
|---|---|---|---|---|
| Steps F1 | 0.56 | 0.91 | 0.58 | 0.90 |
| Relationships F1 | 0.30 | 0.64 | 0.27 | 0.55 |
| Unsupported steps | 60% | 2% | 52% | 4% |
| End-to-end pass | 2 of 7 | 3 of 7 | 3 of 7 | 4 of 7 |
| Produced a program | 7 of 7 | 7 of 7 | 7 of 7 | 6 of 7 |
| Cost per program | $0.05 | $0.09 | $0.26 | $0.51 |
| Output tokens per program | 6,500 | 10,700 | 22,600 | 39,600 |

What this supports, and what it does not:

- The prompt structure matters more than the model tier. Going from baseline
  to four-turn moves steps F1 by about 0.33 and relationships F1 by about 0.3
  on both models; going from Haiku to Sonnet moves them by about nothing.
- The larger model is not better at this task on these programs, and costs
  five to six times as much per program. Haiku with the four-turn prompt
  matches Sonnet with the baseline prompt on end-to-end pass at a third of
  the cost.
- One Sonnet four-turn run (the bread bake) spent 66,000 output tokens over
  two repair rounds and never returned a complete program, most likely
  because its longer answers hit the 16,000-token per-call limit before the
  JSON closed. It is counted as a failure. Verbosity is a cost and a
  reliability problem here, not a quality gain.
- The two models fail on different programs (each passes one the other
  fails), so with seven programs and one run per cell the end-to-end
  difference (3 vs 4) is within noise. The paper must present this as a pilot:
  n = 7, no variance estimate, one vendor, two tiers. It cannot claim Sonnet
  is better or worse end to end.

For the paper: keep the full 24-program Haiku table as the main result and
add this as a short "model tier" paragraph with the table above, framed as a
pilot. Figure A (pass rate against cost) still works with four points. Opus
and Fable are out of reach at this budget; say so rather than extrapolate.

#### Extension: DeepSeek and Gemini (run 2026-09-19)

The author supplied DeepSeek and Gemini keys. The harness gained an
OpenAI-compatible client, so both run through the same prompts, fix loop and
scorer. Coverage is set by money, not design: `gemini-3.1-flash-lite` 20
programs ($0.52), `deepseek-flash` 16 programs (ledger estimate $2.02 at peak
list prices, **actually charged $0.85** off-peak with cached input), Sonnet 7,
Haiku 24. Spending in total: Haiku $3.30 + Sonnet $5.34 + DeepSeek $0.85 +
Gemini $0.52 = **$10.01**, one cent over the ceiling (a DeepSeek program that
had just started when the run was stopped was still billed).

Like for like on the 16 programs Haiku, DeepSeek and Gemini all ran (4 per
domain), one run per cell (`eval/models/comparison.md`):

| Metric | Haiku base | Haiku 4-turn | DeepSeek base | DeepSeek 4-turn | Gemini base | Gemini 4-turn |
|---|---|---|---|---|---|---|
| Steps F1 | 0.50 | 0.92 | 0.39 | 0.88 | 0.52 | 0.75 |
| Relationships F1 | 0.25 | 0.63 | 0.14 | 0.57 | 0.27 | 0.48 |
| Unsupported steps | 61% | 1% | 72% | 5% | 47% | 8% |
| End-to-end pass | 2/16 | 9/16 | 3/16 | 7/16 | 2/16 | 5/16 |
| Produced a program | 16/16 | 16/16 | 10/16 | 10/16 | 16/16 | 15/16 |
| Cost per program (list) | $0.044 | $0.088 | $0.047 | $0.079 | $0.006 | $0.019 |
| Output tokens per program | 6,000 | 10,100 | 36,600 | 53,300 | 2,400 | 6,600 |
| Seconds per program (approx.) | 60 | 60 | 270 | 270 | 17 | 17 |

What it supports:

- The main claim holds on all four models from three vendors: the four-turn
  structure roughly doubles steps F1 and relationships F1 and cuts
  unsupported steps from about half to a few percent, whatever the model.
  This is the result worth a figure.
- Cost and quality do not line up. Gemini Flash-Lite is 5x cheaper and 15x
  faster than Haiku and clearly weaker (steps F1 0.75 vs 0.92, 5 vs 9
  end-to-end). DeepSeek matches Haiku's component scores when it answers, at
  similar list cost, but is 4-5x slower.
- **A confound that must be reported.** The harness caps each call at 16,000
  output tokens. 63 of DeepSeek's 131 calls and 13 of Sonnet's 48 stopped at
  that ceiling, because both spend tokens on long reasoning that counts as
  output; Haiku and Gemini never reached it. Every "no program" failure for
  DeepSeek (6 of 16) and Sonnet (1 of 7) is of this kind. Their end-to-end
  numbers are therefore a lower bound under this harness setting, not a
  measure of what the models can do. The fair rerun is `--max-tokens 64000`
  for those two models; it was not done because the budget is spent.
- Still a pilot: one run per cell, 7 to 24 programs per model, no variance.

For the paper: lead with "structure helps every model" (a small-multiples
figure, one panel per metric, baseline vs four-turn per model), report cost
and latency per program as a table, and state the token-ceiling confound in
the threats paragraph rather than ranking the reasoning models.

### Phase 1b. Evaluation section (new Section 8, before Discussion)

The highest-value change, and the others lean on it.

- Title: "Evaluation: can an agent author a valid schedule?" About 450 words.
- Setup paragraph: gold set (who wrote it, 24 programs, four domains, what a
  gold program fixes: steps, durations, resources, actors, relationships),
  the two conditions, the model, the matcher (how predicted steps are aligned
  to gold), the end-to-end criterion.
- One table: models as columns, the two prompts as paired sub-columns, the
  eight metrics as rows (mean of the replicates, range in parentheses).
- Figure A: end-to-end pass rate against cost per program, one point per
  model and prompt, the two prompts joined by a line per model. This is the
  figure that shows whether structure substitutes for model size.
- Figure B: per-domain steps F1, relationships F1 and end-to-end pass for the
  four-turn condition (the transferability evidence for suggestion #4).
  Both figures as vector PDF.
- Findings paragraph, stated plainly, including what did not improve:
  resource extraction is flat at 0.56 in both conditions, 9 of 24 still fail
  end to end, fitness is the weakest domain.
- Threats to validity paragraph: gold set written by the author, one model
  family from one vendor, three replicates at most, sources are clean text rather than
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

## Nearest prior work (added 2026-09-19)

Cited in a new Related Work paragraph, "Language models as authors of
procedures"; PDFs are in `refs/` (not committed). Metadata verified against
the ACL Anthology, Crossref and the arXiv API; claims checked in the full
text.

- `kourani2026bpm` (Software and Systems Modeling 25(4)): closest by design.
  Text to a process model in an intermediate language, validator errors fed
  back, 20 processes, 16 models, efficient error handling goes with quality.
  They report latency per model and deliberately not cost.
- `du2024paged` (ACL 2024): closest by finding. 3,394 documents; ChatGPT,
  Flan-T5 and Llama 2; good at actors and actions, "can hardly get > 0.5 F1"
  on gateways and flows; proposes a self-refine strategy.
- `odonoghue2023bioplanner` (EMNLP 2023): biology protocols as pseudocode.
- `zheng2024naturalplan` (arXiv): scheduling from prose, about a third of
  trip plans solved, under 5% at ten cities.

The evaluation section should position against the first two: the same
step-versus-structure gap as PAGED, and a validator loop like Kourani et
al.'s, but with timed steps, shared-resource capacities and an end-to-end
check on makespan and critical path.

## What I recommend not doing

- A user study. The reviewer offers "benchmark or user-task results"; the
  benchmark exists and a study does not. Naming the absence in Limitations is
  honest and sufficient for a technical report.
- Citing production usage. It is two days of data dominated by crawlers.

## Decisions needed from you

1. Add the cross-domain table (Phase 4), or rely on the per-domain evaluation
   figure alone?
2. Decided and done 2026-09-18: compare models within a $10 total ceiling
   (spent $8.64 including the earlier Haiku runs). See the Phase 1a result.
3. Is the 19 to 20 page length acceptable, or should the evaluation displace
   something (the candidate is the second environment listing)?

## Order and effort

Phase 1a then 1b first (they produce the numbers the abstract, contributions and MCP
section quote), then 3, 2, 5, 6, with 4 slotted in if approved. Roughly half
a day of writing plus figure work; every phase can be reviewed on its own
commit.
