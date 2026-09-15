# PRD: Execution history and history-based duration prediction

**Type:** feature (runtime logging first, prediction second)
**Repos affected:** rhylthyme-spec (a small `runs` record schema), rhylthyme-cli-runner (runner + new `rhylthyme history`/`calibrate` commands), rhylthyme-server (web player, run store, private library), rhylthyme-mcp (`analyze_schedule` output, new resource), rhylthyme-timeline (planned-vs-actual rendering)
**Origin:** Badosa F, Espinosa A, Acevedo C, Vera G, Ripoll A. *A history-based resource manager for genome analysis workflows applications on clusters with heterogeneous nodes.* Int J Parallel Programming 47(2):317–342 (2019), doi:10.1007/s10766-018-0600-z.

---

## 1. Problem

Every duration in a Rhylthyme program is an author's guess. `fixed` durations come from the recipe or protocol text; `variable` durations carry a `minSeconds`/`maxSeconds`/`defaultSeconds` triple that the author invents; `indefinite` steps get a `defaultSeconds` "so previews look right". Nothing in the system ever learns whether the guess was right, because **neither runtime records what actually happened**. The CLI runner advances a clock and fires triggers on actual completion; the web player does the same on a simulated clock; when the program ends, the actual start and end of each step are gone.

That has three costs:

1. **Plans drift from reality and nobody notices.** A roast that always runs 20 minutes over its `defaultSeconds` makes every negative-offset step ("peel potatoes 45 min before the roast is done") fire early, every time, for every cook who uses the program.
2. **The planners optimise fiction.** `analyze_schedule`'s makespan, slack and critical chain are computed from planned durations. If the planned numbers are systematically wrong, the critical chain it reports is the wrong chain.
3. **The corpus can't improve.** 38 programs in the catalog, each run by many people, would be a duration dataset; today it is a duration *guess* set.

Badosa et al. face the same problem for bioinformatics jobs, whose run time "might vary substantially from one execution to the next" depending on parameters and input size. Their answer has three parts that transfer: (a) record every execution's parameters, inputs and resources together with its measured makespan in a historical database; (b) when a new job arrives, look for identical executions, then similar ones; (c) fit a regression from history to predict duration, selecting predictor variables by correlation with the outcome. Their evaluation shows the approach only works because the history is *inferential* — the same job under the same conditions gives similar times — which is something Rhylthyme can only find out by logging first.

## 2. Goals

- **Phase 1 (logging):** both runtimes record, for every run, the planned and actual start/end of every step, who ended non-fixed steps and when, and the program metadata that plausibly explains variance. Runs are saved with the program in the user's library and, with consent, contributed to the public catalog.
- **Phase 2 (calibration):** a `calibrate` operation proposes updated `defaultSeconds`/`minSeconds`/`maxSeconds` for a program from its run history, with the evidence shown, and the author accepts or rejects per step.
- **Phase 3 (prediction):** for a step with enough history, `analyze_schedule` reports a *predicted* duration and interval alongside the planned one, conditioned on the program's metadata (serves, sample count, oven type, …), and can plan against predicted values on request.
- Keep the program JSON the *plan*; history lives beside it, never silently rewrites it.

## 3. Non-goals

- Live rescheduling during a run based on predictions (the reactive-rescheduling gap in the paper's §9 stays open; this PRD feeds it data).
- Modelling durations outside the executor's control (an incubation that ends when the cells say so). Those are still represented as executor-ended steps; prediction just makes the forecast better.
- Cross-program transfer learning ("all roasts of this weight take this long") in the first release. Prediction is per program per step; pooling across programs that share a `sourceUrl` or step name is an open question (§9).
- Activity recognition as the source of actuals. Actuals come from taps and timers; a recognizer would be another producer of the same record later.

## 4. Data model

### 4.1 Run record (`runs` schema, 0.1.0-alpha)

One JSON document per run, stored with the program (`<programId>/runs/<runId>.json`) and referenced from the program's private-library entry.

```json
{
  "runId": "2026-09-11T16:02:11Z-8f3a",
  "programId": "thanksgiving-one-oven",
  "programVersion": "sha256:…",            // hash of the program JSON that was run
  "runtime": { "kind": "cli" | "web", "version": "…", "clockMode": "wall" | "simulated", "speed": 1 },
  "environmentId": "home-kitchen-2-cooks",
  "startedAt": "2026-09-11T16:02:11Z",
  "endedAt":   "2026-09-11T20:14:40Z",
  "outcome": "completed" | "aborted" | "abandoned",
  "context": {                               // copied from program.metadata + environment at run time
    "serves": "8", "actors": 2, "ingredients": [...], "sourceUrl": "…",
    "userTags": { "oven": "gas", "turkeyKg": 6.4 }   // free-form, author-declared (see 4.2)
  },
  "steps": [
    { "stepId": "turkey-roast", "instance": 1,
      "planned":  { "start": 1500, "end": 11400, "durationType": "indefinite", "defaultSeconds": 9900 },
      "actual":   { "start": 1503, "end": 12610 },
      "endedBy":  "executor" | "timer" | "trigger" | "abort",
      "triggerFiredAt": 1503,
      "waitedOn": ["turkey-prep"],           // predecessors whose actual end gated this start
      "notes": "ran cold, oven door opened twice"   // optional, executor-entered
    }
  ]
}
```

Times are seconds from `startedAt`. `planned` is frozen at run start so a later edit to the program doesn't rewrite history. `endedBy` distinguishes the executor tapping "done" (the only informative case for variable/indefinite steps) from a timer expiring.

### 4.2 Declared variance factors

Badosa's predictor works from job parameters (seed length, thread count) and data characteristics (reads file size). Rhylthyme's equivalent is whatever the author thinks explains variance. Add an optional `metadata.varianceFactors` array to the program schema:

```json
"metadata": {
  "varianceFactors": [
    { "key": "turkeyKg",  "label": "Turkey weight (kg)", "type": "number" },
    { "key": "oven",      "label": "Oven type", "type": "enum", "values": ["gas", "electric", "convection"] },
    { "key": "sampleCount", "label": "Samples", "type": "integer" }
  ]
}
```

Runtimes prompt for these once at run start (skippable) and store them in `context.userTags`. Without them, prediction can still condition on `serves`, `actors` and `environmentId`, which every run has.

## 5. Phase 1: logging (both runtimes)

- **CLI runner:** write the run record on exit (including Ctrl-C → `abandoned`). New commands: `rhylthyme runs <program>` (list), `rhylthyme runs show <runId>` (planned-vs-actual table per step, Gantt via the timeline renderer with actual bars overlaid on planned).
- **Web player:** same record, saved to the user's library when logged in; for anonymous viewers, kept in `localStorage` with a "save this run" prompt. Record `clockMode: "simulated"` and `speed`; runs at speed ≠ 1 are excluded from calibration by default (they measure the timer, not the cook). The known limitation that the player pauses when the phone sleeps must be visible in the record: log `pausedSeconds` per step so calibration can discard steps with pauses.
- **Renderer:** `renderTimelineSvg(program, run)` draws actual bars as a second, thinner bar under each planned bar, coloured by sign of the deviation; the MCP server's PNG preview of a *run* uses this.
- **Privacy:** run records contain no free text unless the executor types a note; `userTags` are author-declared keys. Contributing runs to the public catalog is opt-in per run, and contributed runs are stripped of `notes` and stored keyed by `programVersion` only.

Exit criterion: 30 days of runs on the catalog's five most-loaded programs, and a one-off report answering Badosa's precondition — *is the history inferential?* — i.e. for each step, is the actual-duration variance within a program small enough relative to the planned value that prediction beats the guess? If it isn't for a step type, that step type is flagged as "executor-controlled, don't predict" (§9.1).

## 6. Phase 2: calibration

`rhylthyme calibrate <program> [--runs N] [--since DATE]`, also a button in the web editor and an MCP tool `calibrate_program` (read-only: returns a proposal, never writes).

For each non-fixed step with ≥ *k* usable runs (default *k* = 5; usable = `endedBy: "executor"`, no pauses, speed 1, outcome completed):

- proposed `defaultSeconds` = median actual duration;
- proposed `minSeconds`/`maxSeconds` = 10th/90th percentile, widened to include the current values if the author set them narrower than observed (never silently narrow the author's range);
- for `fixed` steps whose actual end is consistently later than planned (executor could not end early, but the *next* step's trigger fired late), report the lag rather than propose a change: a fixed step that always overruns is usually a step that should be `variable`.

Output is a diff against the program with, per step, the evidence: *n* runs, median, IQR, current value, proposed value, and the effect on makespan and critical chain if accepted. The author accepts per step; accepted values are written to the program with `"calibratedFrom": {"runs": n, "asOf": "…"}` beside the duration so the provenance is visible in the JSON and in the editor.

## 7. Phase 3: prediction in `analyze_schedule`

Following Badosa's lookup order:

1. **Identical context.** Runs of the same `programVersion` with the same `userTags` and `environmentId` → use their median and IQR directly.
2. **Similar context.** Otherwise, runs of the same program (any version whose step ids match) → fit a per-step model. Start with the simplest thing that can work: a linear model on the numeric factors (`serves`, `sampleCount`, `turkeyKg`) plus one-hot enums, with factors kept only if their correlation with actual duration clears a threshold (Badosa's Pearson-selection step); fall back to the median when *n* is small or no factor correlates.
3. **No history.** Planned values, as today.

`analyze_schedule` gains, per step, `predicted: { seconds, low, high, basis: "identical" | "model" | "none", n }`, and two new top-level fields: `predictedMakespan` and `predictedCriticalChain`. A new option `useDurations: "planned" | "predicted"` selects which set the wall-clock itinerary and the planners use. The default stays `planned` so agent-authored programs are analysed on what they say.

For **negative offsets anchored on indefinite steps** (the "potatoes 45 min before the roast is done" case, which the paper flags as resolved against the forecast), the runtime should fire from the *predicted* end when one exists and its interval is narrower than the planned default. This is the first place prediction changes run-time behaviour, and it should be behind a per-program flag (`"offsetsUse": "predicted"`) until Phase 1 data shows it helps.

## 8. Acceptance criteria

- [ ] `runs` schema published; both runtimes write conforming records; the parity corpus gains a "replay" test that feeds a recorded run back into the resolver and reproduces the recorded trigger firings.
- [ ] `rhylthyme runs show` and the web run view render planned-vs-actual for the Thanksgiving example from a recorded run.
- [ ] Inferentiality report produced on real catalog runs, with a per-step-type verdict.
- [ ] `calibrate` proposes values for a program with ≥5 runs, shows evidence, never narrows an author's range, and writes `calibratedFrom` on acceptance.
- [ ] `analyze_schedule` returns `predicted` fields and `useDurations: "predicted"` changes the itinerary; MCP output schema updated.
- [ ] A held-out evaluation on catalog runs: predicted duration beats planned `defaultSeconds` in mean absolute error for at least the step types the inferentiality report marked predictable.

## 9. Open questions

1. **Executor-controlled steps.** Badosa predicts durations the machine determines. Many Rhylthyme durations are chosen by the person ("I'll stop sautéing when it looks right"). The inferentiality report decides empirically which steps behave like measurements and which like choices; the design should expect a large second group and not over-promise.
2. **Pooling across programs.** Steps named "Preheat oven to 200 °C" recur across many programs. Pooling by normalised step name + task + environment would give history to new programs, at the cost of mixing contexts. Defer until per-program prediction is shown to work.
3. **Whose history.** A public program run by 200 households has a duration distribution that reflects 200 kitchens. Per-user history (this cook, this oven) is more relevant when it exists; propose: per-user identical-context runs first, then everyone's.
4. **Clock honesty in the web player.** Until the player re-anchors to wall-clock time after sleep, its actuals are unreliable for long steps. Either fix that first (it is on the paper's limitations list anyway) or restrict Phase 1 to the CLI runner and short web runs.
5. **Schema home for `runs`.** Separate document type in rhylthyme-spec (recommended, parallel to environments) vs. an array inside the program (simpler, but bloats the shareable program and leaks history when a program is shared).

## 10. References

- Badosa et al. 2019, §3 (historical database keyed by application, parameters, data and resources; identical-then-similar lookup; Pearson-selected multivariate regression; variance analysis to establish that history is inferential) and §5 (makespan improvement over SLURM FCFS).
- Rhylthyme technical report §5 (runtimes fire `afterStep` on actual completion; web player not re-anchored after sleep), §9 (negative offsets resolved against forecast; no reactive rescheduling).
