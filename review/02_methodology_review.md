# Peer Review Report

## Manuscript Information
- **Title**: Rhylthyme: A Declarative Language and Agent-Native Runtime for Real-Time, Resource-Constrained Schedules that People Follow
- **Manuscript ID**: paper/rhylthyme.tex (pre-submission technical report; 9 pp, 37 refs)
- **Review Date**: 2026-09-08
- **Review Round**: Round 1

---

## Reviewer Information

### Reviewer Role
Peer Reviewer 1 (Methodology)

### Reviewer Identity
Systems-research methodologist specialising in the evaluation of software artifacts and domain-specific languages (Configuration Card #2). I expect every descriptive claim about a system to be checkable against the artifact, and I checked them.

### Review Focus
The manuscript is a descriptive systems report with no empirical evaluation by design, so the methodology question is artifact fidelity: does the code in the monorepo do what Sections 3, 4 and 5 (and Figure 1, Table 1, Listing 1) say it does, and are the descriptive claims hedged appropriately? I read the schema, both validators, both planners, the CLI runner, the MCP server and its tests, the renderer and the importer registry; ran the Python and JavaScript validators over the entire example corpus; ran both planners on a contended example; probed both validators with small adversarial programs; and ran the `mcp-api` and root test suites. Literature coverage and OR-theoretic correctness are outside my remit.

Reviewed snapshot: the tree at `/Volumes/My12tb/dev/rhylthyme-split` (the `~/Documents/dev/rhylthyme-split` path is a symlink to it, so the venv-installed packages and the reviewed files are the same code). The manuscript gives no commit hash, so this is the only snapshot I can speak to.

---

## Overall Assessment

### Recommendation
- [ ] Accept
- [ ] Minor Revision
- [x] **Major Revision**
- [ ] Reject

### Confidence Score
5 — core expertise: verification of software artifacts against their description; every finding below was produced by reading or executing the code.

Confidence is an uncertainty/scope disclosure only; it never changes consensus counts, severity, decision bearing, or arbitration.

### Calibration Status
`NOT_CALIBRATED`

### Summary Assessment
The paper describes a JSON scheduling language, a validator/planner/runtime stack and an MCP server, and positions them against several scheduling traditions. Its evidentiary basis is entirely descriptive, so its value rests on the description being accurate. Most of it is: the schema, trigger vocabulary and OWL-Time annotations (Table 1), duration kinds, replicate modes, environment/actor fields, the `analyze_schedule` algorithm, the curses runner's manual/indefinite/abort/actor handling, the MCP tool surface with its annotations, output schemas, resources, prompt and server instructions, and the refusal path of `visualize_schedule` all check out line-by-line, and Figure 1 and Listing 1 are reproducible from the corpus via the paper's own Makefile. The MCP test suite passes (23/23).

Three claims, however, are not supported by the artifact. The planner paragraph (§4, and contribution 2) describes a `ProgramPlanner` that simulates three duration scenarios and staggers starts around bottlenecks; both shipped planners read a legacy data model (`id`, `resources`, `after`) that no schema-conformant program has, and they return every corpus program unchanged, including the deliberately over-subscribed one. The statement that the Python and JavaScript validators "agree" on the 49-program corpus is false on one file and, more importantly, is backed by a test that never runs the Python validator; probes show the two implementations diverge on cycles (Python crashes), unit-string durations (Python crashes), unparseable durations, missing durations, `onAbort` references and replicate expansion. The "four programs fail because of genuine within-track overlaps" count is a hard-coded list in a JS test; one of the four fails for a different reason and one is valid under the Python pipeline. All three are repairable by rewriting to match the code (or fixing the code), hence Major Revision rather than rejection.

---

## Strengths

### S1: Figure 1 and Listing 1 are reproducible from the artifact
The breakfast program has three tracks and six steps; with default durations the toast track ends at 480 + 210 = 690 s = 11.5 min, matching the caption, and the two listed steps are verbatim from the file. `paper/Makefile` regenerates the SVG from the corpus file and the renderer, which is exactly the provenance a descriptive report should have.
**Evidence Anchor**: `code: paper/Makefile:5-9; rhylthyme-examples/programs/breakfast_schedule.json:15-45`

### S2: The MCP server description is accurate and test-covered
Tool names, the four annotation hints, output schemas, `structuredContent`, `isError` on failure, the login-token guidance, the schema/guide/five-example resources, the `plan_schedule` prompt arguments (goal, deadline, resource limits) and the server-level `instructions` that Figure 2 depicts are all present in `index.js`, and `npm test` passes 23/23 including "visualize_schedule refuses invalid programs before touching the network".
**Evidence Anchor**: `code: rhylthyme-web/mcp-api/index.js:243-266,385-397,1145-1254,1933-2032; rhylthyme-web/mcp-api/index.test.js:125`

### S3: Table 1 and the §3 language description match the schema
Every trigger type, its required fields, the `$comment` OWL-Time annotations (`time:intervalMetBy`/`intervalAfter`/`intervalStarts`/`intervalOverlaps` on `afterStep`), the three duration kinds, the `logic: all|any` compound with `minItems: 2`, `choiceId`, the negative-offset rule text, and the `parallel|stagger|serial` replicate modes are in the 0.2.0-alpha schema as described.
**Evidence Anchor**: `code: rhylthyme-spec/src/rhylthyme_spec/schemas/program_schema_0.2.0-alpha.json:338-355,362-442,648-670,671-796`

### S4: The `analyze_schedule` paragraph is a faithful description of the code
Makespan, the critical-path heuristic (walk back from the last-ending step choosing the predecessor whose end is closest to the start), the per-task sweep line, peak concurrency versus `program.actors`, per-track `slackBeforeFinishSeconds`, and `finishAt`/`startAt` anchoring are implemented exactly as stated.
**Evidence Anchor**: `code: rhylthyme-web/mcp-api/schedule.js:347-489`

### S5: The CLI runner claims are supported
`curses` UI, manual start triggers, `onAbort` firing from the aborted-step set, indefinite/variable steps ended by the executor, actor-type accounting from environment `actorTypes`, and a time-scale control are all present.
**Evidence Anchor**: `code: rhylthyme-cli-runner/src/rhylthyme_cli_runner/program_runner.py:11,448-452,472,642-722,1060,1119,1176,2440-2442`

### S6: The paper hedges the planner and controllability appropriately in §6–§7
"This is a heuristic, not a solver", "no optimality or controllability guarantees" and "no formal semantics beyond the schema and the reference validators" are the right register for this artifact; the problem (W1) is that §4's concrete description of what the heuristic does is not what it does.
**Evidence Anchor**: `text: §7 "The planner is heuristic and offers no optimality or controllability guarantees"`

---

## Weaknesses

### W1: The planner described in §4 (and contribution 2) does not operate on Rhylthyme programs
**Problem**: Both shipped `ProgramPlanner` implementations read `step['id']`, `step['resources']`, `step['after']` and `track['id']`. Schema programs use `stepId`, `task`, `startTrigger`, `trackId`. On every corpus program both planners collapse all steps to a single id `''`, record no resource usage for `task`, find no bottlenecks and return the program unchanged; I confirmed this on `test_overutilization.json` (three tasks with `maxConcurrent` 1–2, clearly over-subscribed) and `breakfast_schedule.json` (`optimized == input: True` for both planners). Beyond the data model: `simulate_execution` runs once and records min/max occupancy from that single pass (not "three times"); `find_bottlenecks` uses a fixed `threshold=2`, not the declared `maxConcurrent` (the root version never reads `maxConcurrent` at all); the min-duration profile is computed but unused by `optimize_schedule`; "adjusts variable durations toward their defaults" is actually `defaultSeconds := optimalSeconds`; and the stagger step emits non-schema fields (`track.startTime`, padding steps with `id`/`resources`), so its output is not a valid program.
**Evidence Anchor**: `code: src/rhylthyme/program_planner.py:145-148,191,248,118-136,257-321,323-383,385-405,531,573-581; rhylthyme-cli-runner/src/rhylthyme_cli_runner/program_planner.py:155,160,801-814,868-883`
**Why it matters**: The planner is one of the four components of contribution 2 and the whole of the §4 "Planning" paragraph; a reader cannot obtain the behaviour described. In a paper whose only evidence is description, this is a material fidelity failure.
**Suggestion**: Either port the planner to the schema data model (map `stepId`/`task`/`startTrigger`, use `maxConcurrent`, actually run three simulations) and describe what it then does, or delete the planner from the contribution list and reduce §4 "Planning" to the honest statement that resource-conflict detection lives in `analyze_schedule` and no staggering heuristic currently operates.
**Severity**: Major
**Confidence**: 5 — executed both planners on corpus files

### W2: "The Python and JavaScript validators agree on the ... corpus of 49 programs" is not supported
**Problem**: (a) On verdicts, they agree on 48 of the 49 JSON files; `corporate_conference.json` is invalid in JS (`track_overlap`, 750 s) and valid in Python because `validate_program_file` runs `expand_replicates` first, which moves the `replicates: {count: 2, mode: parallel}` step into two new sub-tracks and thereby removes the within-track overlap; the JS path never expands replicates. (b) The JS test titled "validator agrees with the Python validator across the example corpus" never invokes Python: it compares against a hard-coded `knownBroken` set over the 38 top-level files only (non-recursive `readdirSync`), so the 11 files in `unplanned/` that make up the "49" are outside it. (c) Semantically the two validators diverge on probes: a two-step cycle gives `RecursionError` in Python and `dependency_cycle` in JS; `"seconds": "banana"` is valid in Python and `unparseable_duration` in JS; a missing `duration` is valid in Python (schema does not require it) and an error in JS; a dangling `onAbort` reference is missed by Python (only `afterStep`/`afterStepWithBuffer` references are collected) and caught by JS; `previousStepComplete` is rejected by the JSON Schema and silently accepted by JS; a negative offset onto a fixed step is an error in Python and a warning in JS; JSON-Schema validation is Python-only.
**Evidence Anchor**: `code: rhylthyme-web/mcp-api/schedule.test.js:157-176; src/rhylthyme/validate_program.py:91,444-491,531-536; src/rhylthyme/expand_replicates.py:185-187,258; rhylthyme-web/mcp-api/schedule.js:30-33,147-176,209-215,256-266`
**Why it matters**: The paper treats "the validator" as one thing whose semantics the MCP contract enforces. If the reference implementations disagree on what a valid program is, the language has no single validity notion, which undercuts §7's remark that the reference validators stand in for a formal semantics.
**Suggestion**: Replace the sentence with a precise statement (e.g. "agree on the validity verdict for 48 of 49 JSON examples; the exception is replicate expansion, which only the Python path performs"), add a real cross-implementation test that runs both, and list the known semantic differences in §7.
**Severity**: Major
**Confidence**: 5 — ran both validators over the corpus and on constructed probes

### W3: The §7 "four example programs fail ... because of genuine within-track overlaps" count is wrong on number, cause and corpus
**Problem**: The "four" is the hard-coded `knownBroken` set in `schedule.test.js`. Of those four, `comprehensive_manual_demo.json` fails for `task_not_constrained` (six tasks with no resource constraint), not overlap; `corporate_conference.json` is valid under the Python pipeline (W2). Over the 38 top-level files the Python validator rejects 3 (two for overlaps, one for missing constraints) and JS rejects 4 (three for overlaps). Over the 49 JSON files the paper counts, Python rejects 13 and JS 14, ten of them for overlaps, and the Python validator additionally crashes on one of the seven YAML examples it also accepts (`flexible_time_format_example.yaml`, `ValueError` on `"30s"`).
**Evidence Anchor**: `text: §7 "Four example programs in the public corpus fail the validator because of genuine within-track overlaps"`
**Why it matters**: This sentence is offered as "evidence that the checks are useful". A stated count that the artifact contradicts three ways (number, cause, corpus definition) cannot stand in a descriptive report.
**Suggestion**: State which validator, which directory (top-level vs. `unplanned/`), and the per-cause breakdown; or drop the number and say "several".
**Severity**: Major
**Confidence**: 5 — corpus runs reported above; results saved from both validators

### W4: "Offsets and durations accept either a number of seconds or a unit string" is not true of the Python validator
**Problem**: The schema and the JS engine accept `"30s"`/`"5m"`, but `parse_duration_to_seconds` does `int(duration["seconds"])` (ValueError on `"30s"`) and the `afterStep` branch compares `offsetSeconds < 0` without parsing (TypeError on `"5m"`). Both crash rather than report. The corpus YAML `flexible_time_format_example.yaml` triggers the first crash.
**Evidence Anchor**: `code: src/rhylthyme/validate_program.py:363,446,483`
**Why it matters**: A language feature claimed in §3 is unusable through one of the two reference validators, and the failure mode is an uncaught exception, not a finding with a fix hint.
**Suggestion**: Route every `seconds`/`offsetSeconds` read through the string parser (as the negative-offset check already does), or scope the §3 sentence to the schema and JS engine.
**Severity**: Minor
**Confidence**: 5 — reproduced with three-line probe programs

### W5: The §4 validation checklist is a union of two implementations, attributed to one validator
**Problem**: "schema validation followed by logic checks: ... dependency cycles ... unparseable durations" — schema validation exists only in Python; cycle detection and unparseable-duration detection exist only in JS (Python recurses without a guard and hits `RecursionError`; it returns 0 for unparseable strings). The fix-hint example is JS-only, which the paper does say.
**Evidence Anchor**: `text: §4 "Validation is schema validation followed by logic checks: duplicate or missing identifiers, references to non-existent steps, dependency cycles"`
**Why it matters**: A reader implementing or reusing "the validator" will pick one and get a different subset.
**Suggestion**: Present the checks as a table with a column per implementation, or fix the Python validator to match and say so.
**Severity**: Minor
**Confidence**: 5 — probes above

### W6: The "refuses to publish" claim omits the documented bypass
**Problem**: `visualize_schedule` refuses invalid programs by default but accepts `allowInvalid: true` and then publishes with the errors attached; the abstract, §5 and the conclusion present refusal as unconditional ("a tool contract that refuses to publish what will not work"). `save_program` has no such bypass.
**Evidence Anchor**: `code: rhylthyme-web/mcp-api/index.js:1206,1212-1218`
**Why it matters**: The strength of the "move correctness into the tool contract" argument depends on whether the model can opt out; it can, on the publish path.
**Suggestion**: One clause: "refuses by default; an explicit `allowInvalid` flag publishes a draft with its findings attached".
**Severity**: Minor
**Confidence**: 5 — read the handler

### W7: "instantiated four times" lists five endpoints
**Problem**: §5 says four instantiations and then names `/mcp`, `/kitchen/mcp`, `/lab/mcp`, `/events/mcp` and `/gym/mcp`. The code and `vercel.json` wire five (generic plus four verticals); contribution 3 says "four vertical endpoints", which is the consistent reading.
**Evidence Anchor**: `text: §5 "instantiated four times, at \code{/mcp}, \code{/kitchen/mcp}, \code{/lab/mcp}, \code{/events/mcp} and \code{/gym/mcp}"`
**Why it matters**: Internal inconsistency in a factual sentence.
**Suggestion**: "instantiated five times (a generic endpoint and four verticals)".
**Severity**: Minor
**Confidence**: 5 — `index.js:1-19`, `vercel.json` rewrites

### W8: Figure 1's renderer does not serve the web runtime
**Problem**: The caption says the open-source renderer "also serves the web runtime and the MCP server's image previews". It serves the MCP PNG previews (`renderSvgGantt` → resvg) and the paper's figure, but the Flask web runtime never references `timeline-render.js` (zero matches under `rhylthyme-web/src`); it uses its own D3 visualiser with a separate timing routine (`web_visualizer.calculate_timeline_data`). That makes three timing engines (Python validator, `timeline-render.js`, `web_visualizer.py`) whose mutual agreement the paper does not address.
**Evidence Anchor**: `absence: rhylthyme-web/src — expected a reference to static/js/timeline-render.js from the web runtime; checked rhylthyme-web/src/rhylthyme_web/app.py, rhylthyme-web/src/rhylthyme_web/web/web_visualizer.py, rhylthyme-web/api`
**Why it matters**: "Both consume the same JSON" (§4) is true, but the implication that they share one timing engine is not, and the live page a cook actually follows is rendered by the engine the paper does not describe.
**Suggestion**: Correct the caption; state which engine renders the live page, and add a test that the three engines agree on resolved start times over the corpus.
**Severity**: Minor
**Confidence**: 4 — grep-based absence; I did not execute the Flask viewer

### W9: Benchling is not in the importer registry
**Problem**: §4 says "A registry of importers converts external sources ... Benchling protocols". `ImporterRegistry.register` is called for TheMealDB, protocols.io, Spoonacular, Cooklang, Opentrons and recipe-scrapers; the Benchling package has an importer but no registration, and is wired through dedicated Flask routes and a special case in the MCP server.
**Evidence Anchor**: `code: rhylthyme-importers/src/rhylthyme_importers/themealdb.py:443; rhylthyme-importers/src/rhylthyme_importers/opentrons/__init__.py:26; rhylthyme-web/src/rhylthyme_web/app.py:25118,25294; rhylthyme-web/mcp-api/index.js:1289`
**Why it matters**: Minor architectural inaccuracy; the "auto-detects which importer" mechanism (`ImporterRegistry`) does not cover Benchling.
**Suggestion**: "A registry of importers, plus a separately authenticated Benchling connector, ..."
**Severity**: Minor
**Confidence**: 5

### W10: The resource-constraint rule omits the `actors` exemption
**Problem**: §3 says every task needs a constraint "unless the program instead references a named environment". Both validators also exempt programs that declare `actors` (Python skips the check entirely; JS downgrades to a warning).
**Evidence Anchor**: `code: src/rhylthyme/validate_program.py:180; rhylthyme-web/mcp-api/schedule.js:242-251`
**Why it matters**: The rule as written is stricter than the rule enforced; the MCP authoring guide states it correctly.
**Suggestion**: "... unless the program references an environment or declares `actors`".
**Severity**: Minor
**Confidence**: 5

### W11: Reproducibility of the Python toolchain and artifact versioning
**Problem**: (a) The manuscript pins no commit, release or DOI; only the schema carries a version. (b) The installed root CLI cannot validate anything out of the box: `rhylthyme validate <file>` exits with "Invalid value for '--schema': Path '.../src/rhylthyme/program_schema.json' does not exist" (the schema lives in `rhylthyme-spec`), which is why the root suite fails: `tests/test_validator.py` + `tests/test_examples_integration.py` give 15 failed / 19 passed / 3 skipped on the reviewed snapshot, versus 23/23 for the JS suite. (c) The "49 programs" figure counts JSON files recursively including the `unplanned/` directory (11 files, 10 of which fail) and excludes seven YAML programs the Python validator also loads.
**Evidence Anchor**: `absence: §8 Availability — expected a commit hash or release tag for the reviewed artifacts and a corpus definition; checked §3, §4, §7, §8`
**Why it matters**: A descriptive report is only checkable against a fixed snapshot; and a reader following §8 will be unable to run the Python validator without discovering the `--schema` flag.
**Suggestion**: Cite a tagged release; fix the CLI's default schema path (or package the schema with the root library); define the corpus precisely.
**Severity**: Minor
**Confidence**: 5

---

## Claim-by-claim verification

Status: VERIFIED = code does what the text says; PARTLY = true with a material qualification; NOT SUPPORTED = code contradicts the text. Anchors are `path:line` in the monorepo.

| # | Section | Claim | Status | Anchor / note |
|---|---|---|---|---|
| 1 | §1, Tab. 1 | Trigger vocabulary: programStart, programStartOffset, afterStep (end/start, signed offset), afterStepWithBuffer, manual, onAbort, compound all/any | VERIFIED | `program_schema_0.2.0-alpha.json:338-355,671-796`. Note: both validators also accept an undocumented `previousStepComplete` that the schema rejects (JS) / schema rejects (Python) |
| 2 | §1, Tab. 1 | Schema annotates each trigger with OWL-Time/Allen relation via `$comment` | VERIFIED | `:683,714,741,753,770,786` |
| 3 | §1, §3 | Durations fixed / variable(min,max,default) / indefinite(default) | VERIFIED | `:362-442` |
| 4 | §1, §4 | Planner simulates min/default/max, records occupancy, reports bottlenecks vs capacity, staggers starts | NOT SUPPORTED | W1; `program_planner.py:145-148,118-136,257-321`; both planners return corpus programs unchanged |
| 5 | §1, §4 | Curses runner with manual, indefinite, abort handling, actor accounting | VERIFIED | `program_runner.py:11,448-452,472,642-722,1176` |
| 6 | §1, §4 | Web timeline with live clock, itinerary, dependency views, play/pause/speed, kitchen ingredient checklist, public catalog, per-user libraries | VERIFIED (not executed) | `app.py:4397` (DAG/Timeline/Resources/Itinerary/Radial/Editor toggles), `:24860` `/api/public/search`, `:24671` `/api/mcp/programs`; static description only |
| 7 | §2 | Track = unary resource; validator rejects within-track overlap | VERIFIED | `validate_program.py:259-340`; `schedule.js:267-293` |
| 8 | §2 | `analyze_schedule` computes critical path over resolved start times | VERIFIED | `schedule.js:384-401` |
| 9 | §2 | `actors`, `actorTypes`, `actorsRequired`, `qualifiedActorTypes` expressed declaratively, accounted not solved | VERIFIED | `environment_schema_0.1.0-alpha.json:69-97,116-125`; `program_runner.py:663-673` |
| 10 | §2, §4 | Imports protocols.io, Benchling, Opentrons | PARTLY | Benchling not in `ImporterRegistry` (W9) |
| 11 | §3 | Schema version 0.2.0-alpha; MCP resource is that schema | VERIFIED | bundled `static/schema/...json` byte-identical to spec; `index.js:63` |
| 12 | Fig. 1 | breakfast_schedule: 3 tracks, 6 steps, 11.5 min; rendered by the open-source renderer | VERIFIED | 480+210 = 690 s; `paper/Makefile:5-9` |
| 13 | Fig. 1 caption | Renderer also serves the web runtime | PARTLY | W8; serves MCP PNG previews (`index.js:748-777`) but not the Flask viewer |
| 14 | Listing 1 | Two steps quoted verbatim | VERIFIED | `breakfast_schedule.json:15-45` |
| 15 | §3 | Program fields: programId, name, environmentType, actors, tracks, resourceConstraints, metadata | VERIFIED | `program_schema:26-60,582-603,635-645`; `environmentType` is a free string, not an enum |
| 16 | §3 | Step ids unique across the program | VERIFIED (validators, not schema) | `validate_program.py:94-97`; `schedule.js:122-124` |
| 17 | §3 | Offsets/durations accept number or unit string | PARTLY | Schema + JS yes; Python validator crashes (W4) |
| 18 | §3 | Compound `{logic, triggers}` waits for all/first | VERIFIED | `validate_program.py:420-430`; `timeline-render.js:126-155` |
| 19 | §3 | `choiceId` gating and `choice` block; validator checks option references | VERIFIED | `validate_program.py:104-129`; `schedule.js:216-220` |
| 20 | Tab. 1 | Negative offset requires referenced step indefinite | PARTLY | Python: error (`:215-232`); JS: warning only (`schedule.js:209-215`) |
| 21 | §3 | Every task needs a constraint unless environment referenced | PARTLY | `actors` also exempts (W10) |
| 22 | §3 | Environment schema packages constraints + actorTypes(counts) + actorsRequired + qualifiedActorTypes | VERIFIED | `environment_schema:69-131` |
| 23 | §3 | `replicates` on track or step; parallel/stagger/serial; expanded before validation | PARTLY | Python only (`validate_program.py:531-536`, `expand_replicates.py:185-187`); MCP/JS path never expands, which is the W2 disagreement |
| 24 | §4 | Validation = schema + logic checks (dup/missing ids, dangling refs, cycles, choice refs, unconstrained tasks, unparseable durations, overlaps) | PARTLY | Union of two implementations (W5); Python crashes on cycles |
| 25 | §4 | Web/MCP validator returns code + message + fix hint; quoted hint | VERIFIED | `schedule.js:69,286-290` |
| 26 | §4 | Python and JS validators agree on 49-program corpus | NOT SUPPORTED | W2; 48/49 verdicts; test is a hard-coded list over 38 files |
| 27 | §4 | `optimize_schedule` staggers track and step starts, adjusts variable durations toward defaults | NOT SUPPORTED | W1; sets `defaultSeconds := optimalSeconds`; emits non-schema fields |
| 28 | §4 | `analyze_schedule`: makespan, critical path, sweep-line conflicts, peak concurrency vs actors, per-track slack, finishAt/startAt wall clock | VERIFIED | `schedule.js:347-489` |
| 29 | §4 | CLI runner lets executor end variable/indefinite steps; onAbort | VERIFIED | `program_runner.py:1060,1119,1176,450-452` |
| 30 | §4 | Importer registry: Spoonacular, TheMealDB, Cooklang, protocols.io, Benchling, Opentrons; output validated | PARTLY | Registrations at `themealdb.py:443, protocolsio.py:555, spoonacular.py:541, cooklang.py:551, opentrons/__init__.py:26`; Benchling separate (W9) |
| 31 | §5 | Stateless Streamable HTTP; five paths from one implementation; verticals differ in catalog filter, host, copy, one-shot + random tool | VERIFIED (count wording PARTLY) | `index.js:1-38,80-235,2055-2100`; `vercel.json` rewrites; `README.md:17` "stateless"; W7 on "four" |
| 32 | Fig. 2 | Server `instructions` describe search → build → validate → analyze → visualize; catalog hits return live URL directly | VERIFIED | `index.js:243-266` |
| 33 | §5 | Tools carry title, four annotation hints, outputSchema; validate/analyze read-only | VERIFIED | `index.js:385-397,1153,1175` |
| 34 | §5 | `visualize_schedule` validates first, refuses invalid, creates share record, returns markdown (cover, equipment, ingredients, ASCII Gantt, itinerary, schedule check), inline PNG, live URL | PARTLY | All present (`index.js:1212-1254,688,748-777,852,896-997`); refusal has `allowInvalid` bypass (W6) |
| 35 | §5 | `save_program` also validates first | VERIFIED | `index.js:1653-1666` (no bypass) |
| 36 | §5 | Failures set `isError`, including login-token guidance | VERIFIED | `index.js:549-551`; `index.test.js:148` |
| 37 | §5 | Resources: schema, authoring guide, five example programs; `plan_schedule` prompt with goal/deadline/limits; server-level instructions | VERIFIED | `index.js:54-60,1933-2032,2055-2065` |
| 38 | §7 | Four corpus programs fail because of within-track overlaps | NOT SUPPORTED | W3 |
| 39 | §7 | Login is a pasted short-lived token | VERIFIED | `index.js:312` ("expire after about an hour") |
| 40 | §8 | Open source at github.com/rhylthyme; remote server at mcp.rhylthyme.com/mcp | VERIFIED locally / UNVERIFIED remotely | Apache-2.0 LICENSE in each subproject; `package.json` repository URL; I did not access the network |

---

## Detailed Comments

### Title & Abstract
- The abstract's "(ii) a validator, a heuristic planner and two runtimes" should be read against W1: the planner component is not functional on the language the paper defines. The abstract's description of the MCP server is accurate.

### Introduction
- The three contributions are stated precisely enough to be checked, which I appreciate. Contribution 2's planner clause is the one that fails the check (W1); contribution 3 is fully supported.

### Methodology / Research Design
- **Design type**: descriptive systems report, explicitly declared (§1: "This is a descriptive systems report. We make no optimality claims"). Appropriate; the design's validity rests on artifact fidelity, which is what I assessed.
- **Artifact fidelity (§3)**: high. Every schema-level claim verified except the two qualifications in W4 and W10 and the `environmentType` list (free string in the schema; the vertical filters use `kitchen`, `laboratory`, `event`, `gym`; the corpus also uses `fitness`, `events`, `general`, `test`).
- **Artifact fidelity (§4)**: mixed. Validation and analysis paragraphs are accurate for the JS implementation; the planner paragraph is not accurate for either implementation; the "agree" sentence is unsupported.
- **Artifact fidelity (§5)**: high; the only qualifications are W6 and W7.
- **Hedging**: §6–§7 hedge the right things (no optimality, no controllability, actors accounted not solved). What is under-hedged is the state of the Python toolchain relative to the JS one: the paper presents them as equivalent reference implementations when the Python validator crashes on inputs the schema allows.

### Sampling Strategy
- Not applicable as an empirical notion. The only "sample" is the example corpus; its definition is unstated (W11c) and the numbers quoted from it are wrong (W3).

### Data Collection
- Not applicable. No user study, no performance measurement, no agent-run transcripts. The §5 "Why this matters" paragraph asserts a failure mode of LLM planners without evidence; since it is framed as motivation rather than result, I do not count it as a finding, but the authors should not let it drift into a claim.

### Analysis Methods
- The only analyses are algorithmic descriptions. `analyze_schedule` is described faithfully (S4). The critical-path rule ("predecessor whose end is closest to each start") is a heuristic that can pick a non-binding predecessor when a step waits on a compound `all` trigger with slack on every branch; the paper does not claim otherwise, but it should not be called "the critical path" without a qualifier (Reviewer 2 may say more).

### Results Presentation
- Figure 1: reproducible (S1). Figure 2: matches `serverInstructions` and the prompt. Table 1: matches the schema; `afterStepWithBuffer` also accepts `event`, which the table omits. Table 2 (positioning) is outside my remit except the Rhylthyme column, whose cells are supported by the code with the caveats above.
- Selective reporting: the paper reports the Python and JS validators as agreeing and reports four corpus failures; both numbers are more favourable than the artifact supports (W2, W3).

### Reproducibility
- JS: `cd rhylthyme-web && npm test` passes 23/23 on the reviewed snapshot. Figure regeneration works from the Makefile recipe.
- Python: the installed `rhylthyme validate` CLI cannot find its default schema; the root test files I ran give 15 failures. Validation is possible only through the library API with an explicit schema path. The corpus verdicts I report were obtained that way.
- No commit hash, release or DOI (W11a).
- The three timing engines (Python validator, `timeline-render.js`, `web_visualizer.py`) are not cross-tested (W8).

### Methodological Fallacies Detected
- **Over-inference from a hard-coded test**: the "agree" and "four fail" claims are read off a test that encodes expectations rather than measuring them (W2b, W3).
- **Composition fallacy**: attributing the union of two implementations' checks to "the validator" (W5).
- No statistical fallacies apply; the paper reports no inferential statistics. Arithmetic recompute: `no_recomputable_statistics` — the only numeric claims (11.5 min, 49 programs, four failures) are counts I recomputed from the artifact and report in the claim table.

### Discussion / Conclusion
- The conclusion's "a tool contract that refuses to publish what will not work" should carry the `allowInvalid` qualification (W6). Otherwise the conclusions do not extend beyond what the (corrected) description supports.

---

## Questions for Authors

1. Which planner do you intend the paper to describe? Both `src/rhylthyme/program_planner.py` and `rhylthyme-cli-runner/.../program_planner.py` read `id`/`resources`/`after`; on `test_overutilization.json` both return the input unchanged. Is there a third implementation (e.g. an `auto_planner` referenced in the coverage report) that actually consumes `stepId`/`task`/`startTrigger`? If so, where, and does it simulate three scenarios?
2. What is the intended validity semantics for a program with `replicates` on the MCP path? `validate_program`/`visualize_schedule` never expand replicates, so `corporate_conference.json` is refused there but accepted by the Python pipeline. Which behaviour is the specification?
3. Do the three timing engines (Python `calculate_step_start_time`, `timeline-render.js computeStepTimings`, `web_visualizer.calculate_timeline_data`) agree on resolved start times over the corpus? The live page a cook follows is rendered by the third, which the paper does not describe.
4. Is `previousStepComplete` part of the language? The schema rejects it, the JS validator accepts it silently, and the Python timing code handles it.

---

## Minor Issues

### Language / Grammar
- §5 first sentence: "four times" vs five listed paths (W7).
- §4 "Planning": "adjusts variable durations toward their defaults" — the code sets `defaultSeconds` from `optimalSeconds`, a field the paper never mentions.

### Citation Format
- Not assessed (Reviewer 2).

### Figures and Tables
- Table 1: add `event` to the `afterStepWithBuffer` row; note that `programStartOffset.offsetSeconds` has `minimum: 0` (negative offsets are `afterStep`-only).
- Figure 1 caption: correct the "web runtime" clause (W8).

### Layout
- §3 "environmentType (kitchen, laboratory, event, gym, and others)": the schema imposes no enumeration; say "a free-form string; the verticals use kitchen, laboratory, event, gym".
- §4 "example corpus of 49 programs": define the corpus (38 top-level JSON + 11 in `unplanned/`; 7 YAML excluded).
- §8: add a release tag or commit hash.

---

## Criterion-Bound Judgements

Calibration status: `NOT_CALIBRATED`

| Dimension | Criterion source | Judgement | Evidence anchor(s) | Rationale | Uncertainty / scope limit | Decision bearing? |
|---|---|---|---|---|---|---|
| Originality | Reviewer Configuration Card #2 (not in remit) | NOT_ASSESSED | — | Reviewer 2/3 remit | — | no |
| Methodological Rigor | review_criteria_framework §1; Card #2 "every descriptive claim checkable against the artifact" | PARTLY_MEETS | `code: src/rhylthyme/program_planner.py:145-148`; `code: rhylthyme-web/mcp-api/schedule.test.js:157-176` | Most of §3–§5 is verifiable and verified; the planner description and the validator-agreement claim are contradicted by the artifact | None beyond the reviewed snapshot lacking a commit hash | yes — W1, W2 must be corrected before acceptance |
| Evidence Sufficiency | review_criteria_framework §1 | PARTLY_MEETS | `text: §7 "Four example programs in the public corpus fail the validator because of genuine within-track overlaps"` | The only quantitative evidence offered (corpus counts, agreement) is wrong or unmeasured; qualitative description otherwise adequate for a descriptive report | none identified | yes — W3 |
| Argument Coherence | review_criteria_framework §1 | MEETS | `text: §1 "This is a descriptive systems report. We make no optimality claims"` | Problem, system, positioning and limitations form a traceable argument; the hedging in §6–§7 is consistent with the artifact except where W1 over-describes | none identified | no |
| Writing Quality | review_criteria_framework §1 (precision sufficient to verify) | MEETS | `code: rhylthyme-web/mcp-api/index.js:243-266` | Descriptions are concrete enough that I could locate every claim in code; the few imprecisions are listed under Minor Issues | none identified | no |
| Literature Integration | Card #2 (not in remit) | NOT_ASSESSED | — | Reviewer 2 remit | — | no |
| Significance & Impact | Card #2 (not in remit) | NOT_ASSESSED | — | EIC / Reviewer 3 remit | — | no |

Recommendation rationale: the two decision-bearing criteria fail on three findings (W1, W2, W3) that are each repairable by rewriting the text to match the artifact or by fixing the artifact and re-describing it; none is fatal to the language, runtime or MCP contributions, which are otherwise well supported. Hence Major Revision, with re-review of §4 and §7 against the code.
