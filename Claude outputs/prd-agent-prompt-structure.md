# PRD: Structured prompting for agent-authored programs (`plan_schedule`, importers, evaluation harness)

**Type:** feature (MCP server prompts and instructions; new LLM-backed importer path; evaluation harness)
**Repos affected:** rhylthyme-mcp (server `instructions`, `plan_schedule` prompt, resources, new `import_text` tool), rhylthyme-server (importer registry: new `llm-text` importer), rhylthyme-examples (gold set for evaluation), rhylthyme-cli-runner (eval script)
**Origin:** Almuntashiri AH, Ibáñez L-D, Chapman A. *Using LLMs to infer provenance information.* Proc. ProvenanceWeek (PW '25), ACM, 2025, doi:10.1145/3736229.3736261.

---

## 1. Problem

An agent authors a Rhylthyme program in two situations: from a goal ("plan Thanksgiving with one oven, dinner at six") through the `plan_schedule` prompt, or from a source text (a recipe, a protocol, a run sheet) that the structure-based importers can't handle well — the paper notes that importers "typically yield one or two tracks" because they read structure, not meaning, and that all the multi-track programs in the corpus were authored by hand or by an agent.

Today the agent path is: server `instructions` describe the workflow once, `plan_schedule` walks the model through search → build → validate → analyze → publish, and the validator's fix hints catch *structural* mistakes. What is unspecified is the **extraction step itself** — how the model should read the source and decide what the tracks, steps, dependencies, durations and resources are — and there is no way to measure how well it does. The paper's own §7 says so: "an evaluation of agent-authored programs against the validator is future work."

Almuntashiri et al. study exactly this problem in a neighbouring domain: getting an LLM to extract a structured record (activities, entities, agents and their relationships, in PROV-DM) from unstructured scientific text. Three of their findings apply:

1. **Prompt pattern matters and can be measured.** They compared eight prompt patterns (persona, recipe, question refinement, alternative approaches, cognitive verifier, context/examples, scenario, goal-first). The *scenario* pattern ("imagine you need to reproduce this experiment from only the paper…") and *question refinement* ("within this scope, propose a better version of the extraction question, then answer it") scored highest, about 0.90 precision, averaged over entity types.
2. **Confirm the target model before extracting.** Their four-step protocol first has the model confirm it has read the whole source, then confirm it understands the target data model, and only then asks for extraction, and finally asks separately for the *relationships* between extracted items. Relationships were the weakest component.
3. **A small expert gold set plus per-component precision/recall is enough to drive iteration.** Six papers with expert-built provenance records, scored per component (entities, activities, agents, relationships), were enough to rank the patterns; 73% average accuracy in the extraction experiment, >90% precision and recall in the user study.

Rhylthyme's mapping: *activities* → steps, *entities* → resources/ingredients/samples, *agents* → actors, *relationships* → triggers (dependencies) and track membership. The paper's observation that relationships are the hard part matches Rhylthyme's experience that agents get step lists right and cross-track dependencies wrong.

## 2. Goals

- Give `plan_schedule` and a new text-import path a **fixed, tested prompt structure** instead of a one-page workflow description.
- Separate **extraction** (what steps, durations, resources) from **relationship inference** (which track, which trigger) as distinct model turns, since the second is the error-prone one.
- Ship an **evaluation harness** with an expert gold set so prompt changes are measured, not eyeballed, and so the paper's future-work claim can be closed.

## 3. Non-goals

- Replacing the structure-based importers. Spoonacular/TheMealDB/Cooklang/protocols.io/Benchling/Opentrons stay; the LLM path is a new importer for free text and a post-processor that can *enrich* structural imports (split into tracks, add cross-track triggers).
- Fine-tuning a model. Prompt structure only; the server remains host-agnostic.
- Guaranteeing that durations or orderings are *sensible*. The validator checks structure; the harness measures fidelity to a gold program; neither can check that a recipe is good.

## 4. Prompt structure

### 4.1 Four turns, mirroring Almuntashiri's protocol

Encoded in `plan_schedule` (for goals) and `import_text` (for sources) as a sequence the host runs, with each turn's expected output shape stated so hosts that support structured output can enforce it.

| turn | purpose | Rhylthyme content |
|---|---|---|
| **T1 Read-back** | Model confirms it has read the whole source and states, in one paragraph, what is being made, for how many, with what constraints, by when. | Catches truncated sources and misread goals before any JSON is produced. Output: `{summary, servesOrScale, deadline?, constraints[]}`. |
| **T2 Model check** | Model restates the target schema in its own words: tracks are sequential lines of work; steps have one duration kind; triggers link steps; every task needs a resource constraint; step ids are global. | The paper found this step improved fidelity to PROV-DM. Here it is cheap (the authoring guide resource is already served) and it primes the validator rules the model most often breaks. Output: acknowledgement + list of the resource constraints it expects to declare. |
| **T3 Extraction** | Scenario-pattern prompt (below) asking for **steps only**: id, name, task, duration kind and values, and the *source span* each came from. No triggers yet. | Output: flat step list with `sourceSpan` (quoted text or line range). Source spans make the gold-set scoring possible and give the human editor a hover-to-see-why. |
| **T4 Relationships** | Given T3's list, assign each step to a track and give it a trigger, using only the trigger vocabulary; then apply the question-refinement pattern: "propose a better version of this dependency question for *this* recipe, answer it, and revise". | Output: full program JSON → `validate_program` → fix loop → `analyze_schedule` → `visualize_schedule`, as today. |

### 4.2 The scenario prompt (T3)

Adapted from the paper's pattern G, which scored highest:

> Imagine you have to carry out this {recipe | protocol | run-of-show} yourself, in a {kitchen with one oven and two burners | lab with two thermocyclers | …}, and everything must be ready at {deadline}. You have only the text below. Read all of it. List every timed activity you would have to perform, in the order the text gives it, with: how long it takes (exact, a range, or "until I decide"), which resource it occupies, and the exact words in the text you took it from. Do not decide yet which activities can overlap.

The environment and deadline slots are filled from the `plan_schedule` arguments (goal, deadline, resource limits) or from `import_text`'s `environmentType`.

### 4.3 The refinement prompt (T4, second half)

Adapted from pattern C:

> Within the scope of scheduling these activities for one person to follow, suggest a better version of the question "which activities depend on which, and which can run at the same time?" that would expose dependencies this text implies but does not state (things that must cool, rest, preheat, or be held). Then answer your improved question and revise the triggers.

### 4.4 Where it lives

- `plan_schedule` prompt: rewritten as the four turns; arguments unchanged (goal, deadline, resource limits) plus optional `sourceText`.
- Server `instructions`: shortened to point at the prompt; the workflow diagram stays.
- New MCP resource `rhylthyme://guide/extraction` carrying the turn templates so a host without prompt support can still follow them.
- New tool `import_text` (`{text, environmentType, deadline?, hints?}`): server-side, runs the four turns against a configured model, returns the validated program plus the T3 step list with source spans (so the editor can show provenance). Registered as an importer (`llm-text`) beside the structural ones. Requires login like other importers.
- Structural importers gain an optional `enrich: true` flag that sends their one-track output through T4 only, to split tracks and add cross-track triggers. This is where the paper says the multi-track programs currently come from by hand.

## 5. Evaluation harness

### 5.1 Gold set

Following the paper's six-paper design, but larger because sources are short: **24 gold programs**, expert-authored and validated, each paired with its source text and a `context` (environment, deadline):

- 10 kitchen (recipes of 1–5 dishes; include Thanksgiving-with-one-oven),
- 6 laboratory (protocols.io-style, with incubations and shared instruments),
- 4 event (run-of-show with manual gates),
- 4 fitness/other (supersets, rest intervals).

Each gold program's steps carry `sourceSpan`, so extraction can be scored by span match, not just by name.

### 5.2 Metrics, per component (the paper's split)

| component | Rhylthyme unit | match rule | metric |
|---|---|---|---|
| activities | steps | source-span overlap ≥ 0.5 or normalised-name match | precision / recall / F1 |
| durations | per matched step | kind equal; value within 20 % (fixed) or interval overlap (variable) | accuracy |
| entities | resource constraints (`task`) | name match after normalisation | P / R |
| agents | actors / `actorsRequired` | count equal | accuracy |
| **relationships** | triggers | same anchor step, same `type`, offset within 10 % | P / R / F1 — reported separately, since this is the weak component |
| structure | tracks | Rand index between gold and predicted step-to-track partitions | RI |
| end-to-end | whole program | passes both validators; makespan within 10 % of gold; critical chain shares ≥ 50 % of steps | pass rate |

Plus the paper's intermediate scoring for T1/T2: 2 if correct first time, 1 if after a retry, 0 if not, so a failing run can be attributed to reading, modelling, extraction or relationships.

### 5.3 Runner

`rhylthyme eval-prompts --gold rhylthyme-examples/gold --model <host-or-api> --patterns scenario,refine,baseline` runs each gold source through the four-turn structure (and, for comparison, through the current single `plan_schedule` prompt as *baseline*), writes a per-program, per-component table, and a summary. CI runs it on a fixed model pinned by version on every change to the prompt templates, and fails on a drop of more than 5 points F1 in relationships or a drop in end-to-end pass rate.

## 6. Acceptance criteria

- [ ] Gold set of 24 programs with source spans merged into rhylthyme-examples; all pass both validators.
- [ ] `plan_schedule` rewritten as four turns; `rhylthyme://guide/extraction` resource served; server `instructions` shortened.
- [ ] `import_text` tool and `llm-text` importer registered; returns program + step list with `sourceSpan`.
- [ ] `enrich` flag on structural importers, demonstrated on one protocols.io protocol that today yields one track and afterwards yields ≥2 with validated cross-track triggers.
- [ ] Harness runs in CI against a pinned model; baseline vs. four-turn numbers published in the repo README.
- [ ] Four-turn structure beats the baseline on relationship F1 and end-to-end pass rate on the gold set (this is the hypothesis; if it doesn't, the PRD's §4 is revised, but the harness stays).
- [ ] The technical report's "evaluation of agent-authored programs … is future work" sentence is replaced by the numbers.

## 7. Open questions

1. **Server-side model calls.** `import_text` runs an LLM inside rhylthyme-server, which today makes no model calls. It needs a configured provider and a cost cap; the alternative is to keep everything host-side (prompt + resource only) and drop `import_text`. Recommendation: ship the host-side pieces first; add `import_text` once the harness shows the structure works.
2. **Token limits on long sources.** The paper chunked papers by sentence when they exceeded the model's limit and found extraction degraded. Recipes fit; long protocols may not. T1's read-back is the check; if the summary misses sections, chunk by section and merge step lists before T4.
3. **Source-span format.** Character offsets are exact but fragile across whitespace changes; quoted substrings are robust but ambiguous when text repeats ("bake 10 min" twice). Propose: quoted substring plus occurrence index.
4. **Hallucinated steps.** The paper's precision numbers are for text that describes real experiments; recipes are terse and the model will infer unstated steps (preheat, rest). Some are right. Score them as *unsupported* rather than wrong, report the rate, and let the T4 refinement prompt be the place inferred steps are allowed in, tagged `inferred: true` in `metadata` so the editor shows them differently.
5. **Which model pins CI.** Any pin goes stale; a drift in the pinned model's behaviour looks like a prompt regression. Pin and re-baseline quarterly, with the baseline numbers stored beside the pin.

## 8. References

- Almuntashiri, Ibáñez & Chapman 2025: §3 (eight prompt patterns, statements for each), §5.2 (four-step protocol: read whole content → confirm PROV-DM → extraction → relationships; 2/1/0 scoring of intermediate steps), Table 2 (scenario and question-refinement patterns highest precision, ≈0.90), §6 (73 % average accuracy/precision/recall in the extraction experiment; >90 % in the user study; scaled to all exome-sequencing papers in PubMed).
- White et al., *A prompt pattern catalog to enhance prompt engineering with ChatGPT* (the pattern vocabulary the paper adapts).
- Rhylthyme technical report §5 (importers yield one or two tracks; multi-track programs authored by hand or agent), §7 (MCP server: `plan_schedule`, instructions, validator fix hints; "we report this as a design, not a measurement").
