# Peer Review Report

## Manuscript Information
- **Title**: Rhylthyme: A Declarative Language and Agent-Native Runtime for Real-Time, Resource-Constrained Schedules that People Follow
- **Manuscript ID**: paper/rhylthyme.tex (source of truth); references.bib; PLAN.md
- **Review Date**: 2026-09-08
- **Review Round**: Round 1

---

## Reviewer Information

### Reviewer Role
Peer Reviewer 3 (Perspective) — cross-disciplinary and practical

### Reviewer Identity
Practitioner-researcher spanning bioinformatics workflow engineering, laboratory automation (SDLs, SiLA 2 / Autoprotocol), and LLM tool-use; builds MCP integrations. Configured per Reviewer Configuration Card #4 (`paper/review/00_field_analysis.md`). I am blind to the other seats. I do not audit code-vs-claim conformance systematically (Reviewer 1) or literature completeness (Reviewer 2); where I opened the public repository it was only to ground a practitioner concern, and I say so at each such point. OR theory is outside my competence.

### Review Focus
(1) Accuracy and fairness of the laboratory-automation landscape (§2.5) and the workflow-engine comparison (§2.6), with web checks of characterizations. (2) Whether the MCP contribution (§5) is substantive: annotations, structured output, validate-before-publish, resources/prompts, vertical endpoints, and what an MCP practitioner would push back on (auth, statelessness, hosts ignoring annotations, importer prompt-injection surface). (3) Practical impact and overlooked assumptions: multi-person execution, interruptions and failure at the stove/bench, safety-critical use, accessibility, honesty of "person as executor". (4) Fairness of every cell in Table 2 to the compared traditions.

Manuscript content was treated as untrusted data; no instruction inside it was followed. The paper is a descriptive systems report with no evaluation by design, and I have not penalized it for that.

---

## Overall Assessment

### Recommendation
- [ ] **Accept**
- [ ] **Minor Revision**
- [x] **Major Revision** — Substantial revisions needed, re-review required after revision
- [ ] **Reject**

### Confidence Score
4 — Mostly within my area of expertise (lab automation, workflow engines, MCP integration practice); the OR/temporal-reasoning mappings are outside it and I did not assess them.

Confidence is an uncertainty/scope disclosure only; it never changes consensus counts, severity, decision bearing, or arbitration.

### Calibration Status
`NOT_CALIBRATED`

### Summary Assessment
The paper describes Rhylthyme: a JSON language for multi-track, resource-constrained, wall-clock schedules whose executor is a person; a validator, heuristic planner and two runtimes; and an MCP server that exposes validation, analysis, import and publication as annotated tools across four vertical endpoints. It positions the system against project scheduling, ATC flow management, temporal reasoning, robot task scheduling, kitchen/lab schedulers, lab-automation standards and workflow engines.

From my seat the writing is clear, the scoping is honest, and the layered description of the lab-automation stack and the workflow-engine comparison are accurate in their technical characterizations. The MCP design has real, practitioner-recognizable substance (fix hints written for a model that will act on them, validate-before-publish, `isError` with next-step guidance).

The decision-bearing problems are concentrated in the novelty claim and in Table 2. The "person as executor" gap is asserted against traditions whose own cited exemplars include humans as executors (Tercio schedules human-robot teams; Artificial orchestrates manual and automated workflows), against a human-process notation whose engines run timer events and user tasks (BPMN), and without mention that protocols.io already ships a timed, timestamped Run mode. The "Agent interface: none" cell for workflow engines is out of date (Seqera hosts an MCP server). On the MCP side the paper cites the 2024-11-05 revision while relying on 2025 features, and its token-as-tool-argument login sits outside the protocol's own authorization model. Practically, the paper never says what happens when the person falls behind, whether the "shareable live timeline" is actually shared state across participants, or what the threat model is for importers that execute fetched Python. These are repairable; the core system survives. Major revision.

---

## Strengths

### S1: Honest framing of a descriptive report
The paper states up front what it is and what it does not claim, and the Discussion is organized as borrows / omits / new, which is exactly the structure a reader needs to evaluate a systems report without evaluation.
**Evidence Anchor**: `text: §1 "This is a descriptive systems report. We make no optimality claims"`

### S2: The lab-automation stack is layered correctly and characterized accurately
Device layer (SiLA 2 feature definitions over gRPC; Opentrons Python Protocol API v2; PyLabRobot's hardware-agnostic interface), machine-protocol layer (Autoprotocol's JSON), human-protocol layer (protocols.io, Benchling), orchestration (SDL schedulers, Artificial). Each characterization checks out against the primary sources I consulted, and the layering is how practitioners actually think about the stack. The framing of Rhylthyme as importing from both the human and the machine ends is a genuinely useful positioning.
**Evidence Anchor**: `text: §2.5 "device-level standards and drivers (SiLA~2's typed feature definitions over gRPC"`

### S3: The workflow-engine comparison is fair and technically accurate
Snakemake (Python rule language, wildcard inference), Nextflow (dataflow, containers), CWL (vendor-neutral portability and provenance) are described correctly, the executor/objective distinction is the right one, and self-classifying Rhylthyme on the 2017 taxonomy axes keeps the section short and non-tutorial.
**Evidence Anchor**: `text: §2.6 "What separates it from the frameworks is not architecture but executor and objective"`

### S4: Fix hints designed for a model that will act on them verbatim
This is a concrete, transferable MCP design insight that most tool authors miss: an error message is an instruction to the next tool call, not a log line.
**Evidence Anchor**: `text: §4 "which turns out to matter when the author is a language model that will act on the message verbatim"`

### S5: Validate-before-publish as a tool contract, with actionable failures
Refusing to publish invalid programs and returning the same coded findings, plus `isError` results that say what to do next (including when a login is needed), is the right shape for an agent-facing surface and is more than incidental MCP wrapping.
**Evidence Anchor**: `text: §5 "Failures set \code{isError} and say what to do next, including when a call needs a login token"`

### S6: Candid limitations, including evidence against itself
Reporting that four corpus programs fail the validator, and that login is a pasted token, is the kind of candor that makes the rest of the report credible.
**Evidence Anchor**: `text: §7 "Four example programs in the public corpus fail the validator because of genuine within-track overlaps"`

---

## Weaknesses

### W1: Table 2 misstates the executor of the very systems it cites for robotics and lab orchestration
**Problem**: The Executor row gives "robots" for robot task scheduling and "instruments, robots" for lab automation orchestrators. The paper's own exemplar for the former, Tercio (Gombolay, Wilcox, Shah 2018), schedules human-robot teams in manual manufacturing; its exemplar for the latter, Artificial (arXiv:2504.00986), states that it orchestrates "both manual and automated R&D workflows" and provides "interactive guides and instructions for scientists and lab operators to follow manual or semi-automated processes." Both traditions therefore already treat a person as an executor.
**Evidence Anchor**: `table: Table 2 — Executor row, cells "robots" and "instruments, robots"`
**Why it matters**: "A runtime whose executor is a person" is the first of the three legs of the novelty claim in §6. Two of the five comparison columns are set up to make that leg look unoccupied by describing the compared systems less generously than their own papers do.
**Suggestion**: Correct the cells ("human-robot teams" for Tercio; "instruments, robots, and guided manual steps" for Artificial). Then sharpen the claim to what is actually distinctive: Rhylthyme is person-as-executor with no machine executor at all, with manual/indefinite steps and a shareable clock, rather than "person as executor" per se.
**Severity**: Major
**Confidence**: 5 — core expertise: lab orchestration platforms; Tercio abstract and Artificial preprint checked directly.

### W2: "Agent interface: none" for workflow engines is out of date
**Problem**: Seqera publishes an MCP server (`https://mcp.seqera.io/mcp`) that lets agents launch, schedule and monitor Nextflow pipelines on Seqera Platform, and community Nextflow MCP servers exist. The cell should read "emerging," as the lab-automation cell does.
**Evidence Anchor**: `table: Table 2 — Agent interface row, Workflow engines column, cell "none"`
**Why it matters**: The third leg of the novelty claim is "a native agent interface … none of the compared systems has together." A factually wrong "none" in the most architecturally similar column is the kind of error a bioinformatics reader will spot immediately, and it damages trust in the rest of the table.
**Suggestion**: Change to "emerging (platform MCP servers)" and, in §2.6, one sentence distinguishing Rhylthyme's agent interface (authoring and publishing a human-executed schedule) from Seqera's (operating machine execution). The distinction survives; the "none" does not.
**Severity**: Major
**Confidence**: 5 — core expertise: bioinformatics workflow engineering; Seqera documentation and blog checked.

### W3: protocols.io already ships a person-as-executor runtime for lab protocols, and the paper treats it as a static layer
**Problem**: §2.5 places protocols.io in a "human-readable protocol layer" that Rhylthyme merely imports from, and §2.5/§6 contrast Rhylthyme's ability to "play" a procedure with prior systems that "stop" at a procedure. protocols.io's Run mode executes a protocol as a checklist with an integrated timer, timestamps each step, records deviations and notes, and saves a shareable run record. For the lab vertical this is a live, person-executed runtime with exactly the run-logging that Rhylthyme lacks (see W9).
**Evidence Anchor**: `text: §2.5 "a human-readable protocol layer (protocols.io~\cite{teytelman2016protocolsio}, electronic notebooks such as Benchling)"`
**Why it matters**: The paper's differentiator for the lab vertical is that the schedule is played live. A bench scientist reviewing this will ask why they should leave protocols.io Run, and the paper does not answer because it does not acknowledge the feature. What Rhylthyme adds over Run mode is real (parallel tracks, resource capacity, cross-track triggers, an agent interface) but must be stated against the actual competitor.
**Suggestion**: Add two sentences to §2.5 describing Run mode and stating the delta (single linear checklist with timers vs. multi-track resource-aware schedule; run record vs. no run record). Consider a protocols.io/Benchling column or row note in Table 2.
**Severity**: Major
**Confidence**: 5 — core expertise: wet-lab protocol tooling; protocols.io help pages checked.

### W4: BPMN is mischaracterized on the two axes that matter, and omitted from Table 2 despite being named the nearest human-process analogue
**Problem**: §2.6 says BPMN "models control flow and roles rather than wall-clock timing and resource capacity." BPMN 2.0 has timer start, intermediate and boundary events with `timeDate`, `timeDuration` and `timeCycle`, and engines such as Camunda and Flowable execute user tasks assigned to people, with task lists, due dates and timer-driven escalation. That is a person-as-executor runtime with wall-clock timing. BPMN genuinely lacks resource capacity (`maxConcurrent`) and the multi-track "finish together" objective; the paper should say that instead.
**Evidence Anchor**: `text: §2.6 "though BPMN models control flow and roles rather than wall-clock timing and resource capacity"`
**Why it matters**: BPMN engines are the most widely deployed person-as-executor workflow runtimes in existence. Describing them as lacking timing undermines the claim that the person-as-executor runtime is new, and a workflow-engineering reader will know it.
**Suggestion**: Correct the sentence; add a BPMN/human-workflow column to Table 2 (Executor: people via task lists, live; Temporal: timer events, due dates; Resources: none beyond role/pool; Objective: process completion; Agent interface: none/emerging). The contrast that survives is a good one: Rhylthyme is what you get when the process is one person's next four hours, not an organization's next four weeks.
**Severity**: Major
**Confidence**: 4 — adjacent field: process engines; BPMN 2.0 timer semantics checked against Camunda/Flowable documentation.

### W5: MCP spec revision cited does not contain the features the server relies on, and the login design sits outside the protocol's own authorization model
**Problem**: The only MCP citation is the 2024-11-05 specification revision (bib entry `anthropic2024mcp`). Streamable HTTP transport and tool annotations (`readOnlyHint` etc.) were introduced in the 2025-03-26 revision; `outputSchema`/`structuredContent` and tool `title` in the 2025-06-18 revision; an OAuth 2.1-based authorization framework has been part of the spec since 2025-03-26 and was tightened in 2025-06-18. The paper's login is a bearer token pasted by the user and passed as a tool argument (`token`) on every authenticated call, which places a credential in the model context and in host transcripts and logs, and §7 frames OAuth as a future convenience rather than the protocol's specified auth path.
**Evidence Anchor**: `text: §7 "The MCP server's login is a pasted, short-lived token; OAuth would remove that step for consumer hosts."`
**Why it matters**: The paper claims the MCP server as a distinctive contribution and describes it in the spec's vocabulary. An MCP practitioner will notice that the citation cannot support the vocabulary and that the auth design is the one thing the spec explicitly moved away from. It weakens the "native" in "native agent interface."
**Suggestion**: Cite the specific spec revisions for each feature used (2025-03-26 for transport and annotations; 2025-06-18 for structured output); state plainly that the server does not implement the MCP authorization framework and why (stateless Vercel deployment, consumer hosts without OAuth support at the time), and that tokens transit the model context. The one-hour expiry is a mitigation worth stating in the same breath.
**Severity**: Major
**Confidence**: 5 — core expertise: builds MCP integrations; spec revision history checked.

### W6: Annotations are presented as something hosts act on; the spec says clients must treat them as untrusted hints
**Problem**: §5 says annotations are registered "so that hosts can auto-approve read-only calls," and §6 calls them "honest annotations." Per the specification, annotations are hints that clients must not rely on for security decisions unless the server is trusted, and major consumer hosts still prompt on first use regardless. The benefit is real (a well-behaved host can reduce friction) but is conditional on host behavior the paper does not control.
**Evidence Anchor**: `text: §5 "so that hosts can auto-approve read-only calls and agent frameworks can consume \code{structuredContent} without parsing markdown"`
**Why it matters**: Minor for the core claim, but the sentence promises a behavior the reader cannot count on and a practitioner will discount.
**Suggestion**: "so that hosts that honor annotations can auto-approve read-only calls" plus one clause on the spec's untrusted-hint stance.
**Severity**: Minor
**Confidence**: 5 — core expertise: MCP client behavior.

### W7: "Refuses to publish what will not work" is stronger than the implemented contract
**Problem**: The conclusion and §5 state that the publisher refuses invalid input. In the public repository (`rhylthyme-web/mcp-api/index.js`, `visualize_schedule`), the tool accepts an `allowInvalid` flag that publishes anyway, with the description noting "the live page may show wrong timings." That is a reasonable product choice, but it is a different contract from the one the paper describes, and an agent can set the flag.
**Evidence Anchor**: `text: §8 "against a tool contract that refuses to publish what will not work"`
**Why it matters**: Validate-before-publish is one of the paper's crispest MCP claims; readers will build on the stated contract. Code-vs-claim conformance is Reviewer 1's remit; I raise it only because it changes what the MCP contribution is.
**Suggestion**: Describe the escape hatch and its guard ("only when the user explicitly wants an imperfect draft shared"), or remove it from the deployed surface if the paper's claim is the intended contract.
**Severity**: Minor
**Confidence**: 4 — adjacent evidence: read the mirrored source; did not run it.

### W8: No threat model for importers, including an importer that executes fetched Python
**Problem**: §4 and §5 describe importers that pull from protocols.io, Benchling, Spoonacular, TheMealDB, Cooklang URLs and Opentrons scripts and return the result into the agent's context, with no discussion of untrusted content. Two practitioner concerns follow. First, prompt injection: recipe and protocol text is third-party content that flows straight into the model context of a tool-using agent that also holds the user's token. Second, code execution: in the public repository the Opentrons importer's primary parser is a "simulator" that `compile`s and `exec`s the fetched `.py` in-process against a stubbed `ProtocolContext`, with the AST walker only as fallback (`rhylthyme-importers/src/rhylthyme_importers/opentrons/simulator.py`, `importer.py`). If that path runs server-side on the hosted endpoint, a URL supplied by a user (or by an injected instruction) is remote code execution, gated only by the login token.
**Evidence Anchor**: `absence: §4 Importers / §5 Tools — expected a threat model for untrusted imported content and script execution; checked §4, §5, §7`
**Why it matters**: The MCP server is deployed publicly and is claimed as a contribution. A security-minded reader of an agent-tooling paper expects at least one paragraph on what the tool trusts. The Opentrons path in particular converts a data-import feature into an execution feature.
**Suggestion**: Add a short "Trust boundaries" paragraph to §5: what is user-supplied, what is third-party, what is executed, where. For Opentrons, run the simulator in a sandbox or subprocess with no network and a timeout, or make the AST parser primary. Note that imported text is untrusted for the consuming agent.
**Severity**: Major
**Confidence**: 4 — core expertise: agent tool security; code path read in the mirrored repository, not executed on the hosted endpoint.

### W9: The runtime is described without saying what happens when the person falls behind
**Problem**: §4 describes a runner that "advances a clock, starts steps as their triggers fire." Every real kitchen and bench run drifts: the roast takes fifteen minutes longer, the centrifuge is occupied, the phone rings. Steps anchored by `afterStep` will shift with the delayed predecessor, but steps anchored by `programStart`/`programStartOffset` are absolute, so a "finish together" plan built by staggering absolute offsets silently decouples the moment one track overruns. The paper invokes ATC flow management, whose defining property is continuous replanning, without stating that Rhylthyme has no live replan, pause-all, or "shift everything downstream" semantics, and without mentioning what a variable step does when the executor exceeds `maxSeconds`.
**Evidence Anchor**: `text: §4 "advances a clock, starts steps as their triggers fire, waits on manual triggers, lets the executor end variable and indefinite steps"`
**Why it matters**: The stated objective is "a timeline that can be followed." Drift is the primary reason timelines stop being followable. A descriptive paper need not solve this, but it must say what the runtime does, because it determines whether the ATC analogy in §2.3 and the "a person, live" cell in Table 2 are earned.
**Suggestion**: One paragraph in §4 on overrun semantics (what happens at `maxSeconds`; whether pause is global; whether absolute-offset steps are re-anchored when an upstream step ends late) and a line in §7 listing live re-planning as future work. Design-wise, an "anchor to latest predecessor end" mode or a "re-plan from now" button would close most of the gap and is cheap.
**Severity**: Major
**Confidence**: 4 — practitioner basis: has run multi-track bench protocols and kitchen schedules; runtime behavior inferred from the trigger semantics in §3, not from executing the code.

### W10: "Shareable live timeline" and the CDM analogy imply shared state across participants that the paper does not describe
**Problem**: §2.3 says CDM's premise that "the plan is a shared, live artifact updated as participants act is the premise of Rhylthyme's shareable live timeline," and §5 promises "a live page on the cook's phone." The paper never says whether two people opening the same link share one clock and one set of manual-trigger and abort states, or each run an independent local playback of a shared program. Actor accounting ("accounts for actor capacity") is meaningless at run time if the second actor's device does not know the first has pressed "pan-ready."
**Evidence Anchor**: `text: §2.3 "CDM's premise that the plan is a shared, live artifact updated as participants act is the premise of \rt{}'s shareable live timeline"`
**Why it matters**: Multi-person execution (two cooks, a lab with a technician and a PI, a stage manager and an A/V operator) is the normal case in three of the four verticals. If state is per-device, the CDM analogy overclaims and the actors model is planning-only; if state is synchronized, that is a significant runtime feature the paper undersells.
**Suggestion**: State the model explicitly in §4 (shared program, per-device run vs. shared run state), and in §7 add multi-participant synchronization to future work if it is absent. If absent, soften §2.3 to "shared plan" rather than "shared, live artifact."
**Severity**: Major
**Confidence**: 3 — practitioner inference from the text; I could not confirm runtime synchronization behavior from the mirror and have put the question to the authors.

### W11: No run record, no hard bounds, no escalation for indefinite steps in a system pitched at bench protocols
**Problem**: For laboratory use the paper promises programs "a bench scientist runs by hand" including 42-hour protocols with indefinite steps. It does not mention recording actual start/end times of a run (the basis of any lab notebook entry and of GLP traceability), maximum safe durations for indefinite steps (a lysis or a proofing that must not exceed a bound), or alarm/escalation semantics when a cue is missed. protocols.io Run mode (W3) has the first; the second and third are absent from the language.
**Evidence Anchor**: `absence: §4 Execution / §7 — expected a statement on run logging, hard upper bounds and missed-cue behavior; checked §3, §4, §6, §7`
**Why it matters**: Does not affect the core claims, but bounds the lab vertical's practical adoption and safety story. An indefinite step with no upper bound is a safety gap in a lab and a food-safety gap in a kitchen.
**Suggestion**: Add optional `maxSeconds` semantics for indefinite steps (warning, then alarm) and a per-run record of actual times as future work; state in §7 that the system is not intended for safety-critical timing without those.
**Severity**: Minor
**Confidence**: 4 — practitioner basis: wet-lab protocol execution.

### W12: Cue modality and accessibility at the stove/bench are unstated
**Problem**: The executor's hands are wet, gloved, or holding a pan; the phone is across the room. The paper says the runtime issues "cues" and that the deliverable is "a live page on the cook's phone" but never states the modality (visual only, audio, speech), nor whether the timeline is usable with a screen reader or by voice. The deployed tool descriptions mention "audio step cues," which suggests the feature exists and the paper simply omits it.
**Evidence Anchor**: `text: §5 "the deliverable from a chat message to a live page on the cook's phone"`
**Why it matters**: Person-as-executor is an HCI claim as much as a scheduling one. Followability at the stove is determined by modality; a paper whose whole objective is followability should say one sentence about it.
**Suggestion**: One sentence in §4 on cue modalities (audio, visual, optional speech) and one in §7 on accessibility and hands-free control as future work.
**Severity**: Minor
**Confidence**: 4 — practitioner basis; adjacent field: HCI.

### W13: Cue-based show control (QLab and its kin) is the closest existing person-as-executor runtime for the events vertical and is absent
**Problem**: Theatre and live-event show control software executes cue lists with pre-wait, post-wait, auto-follow ("start the next cue when this one ends"), auto-continue ("start the next cue when this one starts, after a post-wait") and a manual GO, operated live by a stage manager. That is, respectively, `programStartOffset`, `afterStep` with offset, `afterStep` (met-by), `afterStep` with `event: start`, and `manual`. The events vertical is positioned against nothing.
**Evidence Anchor**: `absence: §2 / Table 2 — expected a comparison to cue-based show control for the events vertical; checked §2.1–2.6, §6, Table 2`
**Why it matters**: The paper's "stage manager calling cues" motivating example already has mature software with the same trigger vocabulary and a live human operator. This is a literature point (Reviewer 2's remit) that I raise as Minor only because it also supplies a useful validation of the trigger vocabulary: an independent tradition converged on the same primitives.
**Suggestion**: One paragraph, or a Table 2 column, on show control: executor a person live; triggers pre/post-wait and follow/continue; no resource capacity; no agent interface.
**Severity**: Minor
**Confidence**: 4 — adjacent field: live-event production; QLab documentation checked.

### W14: Opentrons-script import into a human-run schedule needs a stated caveat
**Problem**: Opentrons Protocol API scripts encode robot pipetting whose durations are robot durations; the paper says they are converted into "timed, resource-aware programs a bench scientist runs by hand." The interesting import is the protocol's structure and its incubations, not its timing, and the relation "human-executed analogue of the SDL zero-gap constraint" is an aspiration rather than a constraint the runtime can enforce (a person cannot guarantee zero gap; the SDL formulation treats it as a hard constraint).
**Evidence Anchor**: `text: §2.5 "its \code{afterStep} with zero offset is the human-executed analogue of the SDL zero-gap constraint"`
**Why it matters**: Minor; it is a fairness point toward the SDL scheduling literature and a practical accuracy point about what the Opentrons importer can honestly produce.
**Suggestion**: Qualify both sentences: Opentrons import recovers step structure and instrument occupancy, with durations re-estimated for a human; zero offset expresses the intent of zero-gap without guaranteeing it.
**Severity**: Minor
**Confidence**: 4 — core expertise: lab automation.

---

## Detailed Comments

### Title & Abstract
The title's "that People Follow" is the right hook and honest about scope. The abstract's "argue that its contribution lies in the combination of a person-as-executor runtime, a single schema reused across domains, and a native agent interface" is defensible once W1–W4 are addressed; today the first leg is under-defended against BPMN engines, protocols.io Run, Tercio and Artificial.

### Introduction
The motivating examples (cook, technician, stage manager, trainer) are well chosen. The two-way split ("plan offline and leave execution to people" vs. "execute on machines") is a clean rhetorical frame but it elides the third category that already exists: human-task workflow engines (BPMN), protocol run modes (protocols.io), and show control (QLab). The gap the paper fills is narrower and more interesting than the introduction claims: multi-track, resource-capacity-aware, wall-clock schedules for a single person or small group over hours, with an agent authoring surface.

### Literature Review / Related Work
- §2.5 lab automation: technically accurate at the device and protocol layers (S2). The characterization of Artificial and of protocols.io understates their human-in-the-loop scope (W1, W3). Autoprotocol remains an open standard; fine. No mention of LLM-agent-driven lab automation (Coscientist and successors), which is the nearest "agent interface" prior in the lab column and would justify the "emerging" cell with a citation.
- §2.6 workflow engines: accurate and fair (S3), except the BPMN sentence (W4) and the Table 2 agent-interface cell (W2).
- The mapping to Allen relations and STN/STNU is outside my remit and not assessed.

### Methodology / System Description (§3–§4)
Clear and concise. What is missing is behavioral, not structural: overrun and drift semantics (W9), shared vs. per-device run state (W10), run logging and hard bounds (W11), cue modality (W12). Each is a paragraph, not a redesign.

### The MCP Server (§5)
Substantive, not incidental, in three respects: fix hints written for a model consumer (S4), validate-before-publish with `isError` guidance (S5), and server-level `instructions` plus a `plan_schedule` prompt that carry the workflow once per session rather than per tool. The vertical-endpoint pattern (one implementation, four catalogs and hosts) is a sensible way to ship domain-specific defaults without forking a schema.

What an MCP practitioner would push back on, in order: (a) the spec citation cannot support the features described, and the login design bypasses the spec's authorization framework, with bearer tokens transiting the model context (W5); (b) annotations are hints and the paper presents them as host behavior (W6); (c) `allowInvalid` weakens the stated contract (W7); (d) no trust boundary for imported third-party content, and an importer that executes fetched code (W8); (e) statelessness: a stateless Streamable HTTP deployment cannot push progress or notifications, so a long import or a multi-hour run cannot report back to the agent; the paper should state that the agent's involvement ends at the URL. None of these is fatal; all should be stated.

### Discussion / Table 2
Cell-by-cell fairness, from my seat (OR columns not assessed):
- Executor: CPM/PERT/RCPSP "human, offline" fair. ATC "controllers, airlines, live" fair. Robot "robots" unfair to Tercio (W1). Lab orchestrators "instruments, robots" unfair to Artificial (W1). Workflow engines "compute nodes" fair.
- Author: all fair; "bioinformatician" for workflow engines is slightly narrow (Nextflow/CWL are used well beyond bioinformatics) but acceptable given the section's framing.
- Temporal semantics: lab "zero-gap sync, stations" fair to Zhou et al. but narrow for the column (Artificial and most SDL schedulers model general precedence and time windows). Workflow "data-dependency DAG" fair.
- Objective: lab "throughput under scientific constraints" fair. Workflow "reproducible, portable output" fair.
- Resources: lab "stations" fair but thin; workflow "CPU, memory, containers" fair.
- Uncertainty: lab "process variance" vague; workflow "retries" fair and slightly ungenerous (Nextflow has dynamic resource re-allocation on retry, Snakemake has checkpoints) but not wrong.
- Portability: lab "SiLA, Autoprotocol" fair; workflow "containers, CWL" fair.
- Agent interface: lab "emerging" fair; workflow "none" wrong (W2).
- Missing columns that the text itself invites: BPMN/human workflow engines (W4), protocol run modes (W3), show control (W13).

### Limitations
Candid (S6). Should additionally list: live re-planning under drift, multi-participant run state, run logging/hard bounds, importer trust boundaries, and the MCP authorization gap as a spec-conformance matter rather than a convenience.

### Conclusion
"Refuses to publish what will not work" overstates the implemented contract (W7); otherwise proportionate.

### References
The MCP citation is the 2024-11-05 revision; the features used need 2025-03-26 and 2025-06-18 (W5). Benchling has no citation at all; a product URL with access date would be consistent with the Autoprotocol and Opentrons entries.

#### Assumption Audit
- **Explicit assumptions**: "The executor is a human working against a wall clock and a small set of shared resources." Holds, but the single-executor reading is implicit and drives W10.
- **Implicit assumptions**: (i) that the person keeps up with the clock, or that the runtime's behavior when they do not is obvious (W9); (ii) that "shareable" means "shared" (W10); (iii) that imported content is benign (W8); (iv) that an agent host will honor annotations (W6); (v) that a timeline on a phone is followable regardless of modality (W12); (vi) that prior human-executed runtimes do not exist because they are not framed as schedulers (W3, W4, W13).
- **Paradigmatic assumptions**: The paper reasons from the scheduling literature, where the artifact is a plan. From an HCI or process-execution standpoint the artifact is a run: something with a start time, actual times, deviations and an outcome. The language has no run object, which is why W9–W11 cluster together. Naming this in §7 would make the future-work list coherent rather than a list.

#### Cross-Disciplinary Connections
- **Parallel research**: Human-task workflow engines (BPMN user tasks with timers) and protocol run modes (protocols.io) solve the "person executes, system keeps time" problem in their own vocabularies. Show control (QLab) independently converged on the same trigger primitives (pre-wait/post-wait/follow/continue/GO). LLM-agent-driven lab automation (Coscientist) is the nearest "agent authors, lab executes" prior.
- **Borrowing opportunities**: The run record (protocols.io), timer boundary events with escalation (BPMN), "GO" semantics with a standby cue (show control), and the checklist literature's insight that the executor's cognitive load, not the plan's optimality, determines whether a procedure is followed.
- **Methodological borrowing**: Once evaluation is on the table, the natural design is the one Nakabe et al. already used for cooking: a within-subjects comparison of following the same multi-dish meal from prose vs. a static Gantt vs. the live runtime, measuring finish-time spread and missed cues. The paper does not need this now; it should name it.

#### Practical Impact
- **Real-world application**: For a home cook using a consumer LLM host, the pipeline (ask, get a validated live URL) is a real improvement over prose. For a lab, adoption hinges on run logging and on how the import compares to protocols.io Run; for events, on multi-operator state; for gyms, on hands-free cues.
- **Implementation feasibility**: The pieces exist and are deployed. Barriers are the ones listed in W5, W8–W10: auth model for consumer hosts, trust boundaries, drift, shared state. None requires new theory.
- **Stakeholders**: The second person in the kitchen or lab is the overlooked stakeholder (W10). Third-party content owners (recipe sites, protocol authors) are another: the tool descriptions in the deployed server already carry a "structural orchestration, not protected content" rationale for republishing assembly recipes; the paper should state its stance on source attribution and republication in §4 Importers rather than leaving it to the tool text.

#### Broader Implications
- **Ethical dimensions**: Publicly hosted, anonymously creatable share pages that carry user-supplied cover images and attribution are an abuse and moderation surface the paper does not mention; per-user libraries hold what people cook and what protocols they run, which is more sensitive than it looks.
- **Social impact**: Modest and positive; the main risk is a confidently wrong timeline in a lab context, which W9 and W11 address.
- **Future directions**: A run object with actual times; re-anchoring under drift; shared run state; sandboxed importers; MCP authorization; and a small evaluation of followability.

---

## Cross-Disciplinary Reading Recommendations
- Boiko, MacKnight, Kline, Gomes, "Autonomous chemical research with large language models," Nature 624, 570–578 (2023). LLM agent driving Opentrons and a cloud lab; the nearest prior for "agent authors, lab executes" and a citation to justify the "emerging" cell.
- Seqera, "Introducing the Seqera MCP Server" (seqera.io/blog/seqera-mcp) and the Seqera MCP documentation (docs.seqera.io/platform-cloud/seqera-mcp/overview). Corrects Table 2 and gives the paper a concrete machine-executor MCP to contrast with.
- protocols.io, "Run protocols as checklists" (protocols.io/help/ongoing-research-work/run) and the run/pause/save tutorial. The lab vertical's real competitor.
- Camunda / Flowable BPMN 2.0 reference on timer events and user tasks (docs.camunda.io; flowable.com open-source docs). Grounds the corrected BPMN sentence.
- QLab documentation, "Cue Sequences" (qlab.app/docs/v5/fundamentals/cue-sequences). Independent convergence on the trigger vocabulary; the events vertical's nearest neighbor.
- Model Context Protocol specification changelogs for 2025-03-26 and 2025-06-18 (modelcontextprotocol.io). Needed to cite the features the server uses and the authorization framework it does not implement.
- `[UNVERIFIED]` search lead: the checklist and cognitive-load literature on procedure-following in aviation and surgery (e.g., Gawande's *The Checklist Manifesto* and the WHO Surgical Safety Checklist evaluations). Relevant to why followability rather than optimality is the right objective; I have not re-verified specific citations for this review.

---

## Questions for Authors
1. When two people open the same share link, do they share one clock and one set of manual-trigger/abort states, or does each device run its own playback of the shared program? The answer determines whether §2.3's CDM analogy and the runtime's actor accounting hold at execution time (W10).
2. What does the runtime do when a variable step exceeds `maxSeconds`, and when an upstream step ends late relative to a downstream step anchored by `programStartOffset`? Is there any re-anchoring, global pause, or "re-plan from now" (W9)?
3. Does the hosted `import_from_source` endpoint run the Opentrons simulator (in-process `exec` of the fetched script) server-side, and if so in what isolation? What is the intended trust model for third-party recipe and protocol text returned into the agent's context (W8)?
4. Given that the MCP specification has carried an OAuth 2.1 authorization framework since 2025-03-26, what prevented implementing it, and is the token-as-tool-argument design intended to persist? Which hosts were the server tested with, and which of them honor `readOnlyHint` (W5, W6)?
5. What, precisely, does Rhylthyme add for a bench scientist over protocols.io Run mode, and for an organization over a BPMN engine with user tasks and timers (W3, W4)?

---

## Minor Issues

### Language / Grammar
- §5, first paragraph: "instantiated four times, at `/mcp`, `/kitchen/mcp`, `/lab/mcp`, `/events/mcp` and `/gym/mcp`" lists five paths for four instantiations; presumably `/mcp` is the generic endpoint and the count should be five, or the generic path should be described separately.
- §2.5: "converts protocols.io and Benchling protocols *and* Opentrons protocol scripts" — the emphasized "and" reads as a typographical accident.

### Citation Format
- `anthropic2024mcp` cites an announcement page plus "Specification revision 2024-11-05"; cite the specification revisions actually relied on (see W5).
- Benchling is named in §2.5 and §4 without any reference; add a product URL with access date, consistent with `autoprotocol` and `opentronsapi`.

### Figures and Tables
- Table 2 caption "Positioning Rhylthyme against the traditions in Section 2" — the table omits two traditions the text names as nearest neighbours (BPMN in §2.6; cooking-step schedulers in §2.5), so the caption over-promises.
- Figure 2 shows validation as strictly gating publication; if `allowInvalid` remains, the figure should show the bypass or the caption should note it.

### Layout
- None beyond the above.

---

## Criterion-Bound Judgements

Calibration status: `NOT_CALIBRATED`

| Dimension | Criterion source | Judgement | Evidence anchor(s) | Rationale | Uncertainty / scope limit | Decision bearing? |
|---|---|---|---|---|---|---|
| Originality | review_criteria_framework.md §1; Card #4 remit (3) | PARTLY_MEETS | `table: Table 2 — Executor row, cells "robots" and "instruments, robots"`; `text: §2.6 "though BPMN models control flow and roles rather than wall-clock timing and resource capacity"` | The three-way combination is plausibly novel, but the person-as-executor leg is defended against under-described competitors (Tercio, Artificial, BPMN engines, protocols.io Run, show control). | OR-side novelty not assessed by this seat. | yes — the novelty claim needs re-statement against the real neighbours (W1, W3, W4, W13). |
| Methodological Rigor | review_criteria_framework.md §1 | NOT_ASSESSED | — | Reviewer 1's remit. | — | no |
| Evidence Sufficiency | review_criteria_framework.md §1; Card #4 remit (4) | PARTLY_MEETS | `table: Table 2 — Agent interface row, Workflow engines column, cell "none"`; `text: §7 "The MCP server's login is a pasted, short-lived token; OAuth would remove that step for consumer hosts."` | Landscape characterizations at the device/protocol layer are accurate; two Table 2 cells are factually wrong or out of date and the MCP citation cannot support the features described. | Web checks performed 2026-09-08; vendor status may change. | yes — repairable by correcting cells and citations (W2, W5). |
| Argument Coherence | review_criteria_framework.md §1 | MEETS | `text: §1 "This is a descriptive systems report. We make no optimality claims"` | Problem, system, positioning and limitations form a traceable argument; the borrows/omits/new structure is clear. | none identified | no |
| Writing Quality | review_criteria_framework.md §1 | MEETS | `text: §4 "which turns out to matter when the author is a language model that will act on the message verbatim"` | Precise, compact, and readable across the disciplines it spans. | none identified | no |
| Literature Integration | review_criteria_framework.md §1; Card #4 remit (1) | PARTLY_MEETS | `text: §2.5 "a human-readable protocol layer (protocols.io~\cite{teytelman2016protocolsio}, electronic notebooks such as Benchling)"` | Lab-automation and workflow-engine literature is integrated accurately at the technical level, but the human-executed runtimes inside those traditions (Run mode, BPMN user tasks, Artificial's Assistants, Tercio's human agents) are not engaged. | Completeness audit is Reviewer 2's remit; this judgement covers only the seat's landscape. | yes — same repair as Originality. |
| Significance & Impact | review_criteria_framework.md §1; Card #4 remit (2)–(3) | PARTLY_MEETS | `absence: §4 Importers / §5 Tools — expected a threat model for untrusted imported content and script execution; checked §4, §5, §7`; `text: §2.3 "CDM's premise that the plan is a shared, live artifact updated as participants act is the premise of \rt{}'s shareable live timeline"` | The MCP surface is substantive and the deployed pipeline is a real practical improvement for single-person use; impact for labs, events and multi-person kitchens is bounded by unstated drift, shared-state, safety and trust behavior. | Runtime synchronization behavior could not be confirmed from the mirror; routed to Questions 1–3. | yes — the practical claims need the behavioral paragraphs requested in W8–W10; core survives. |

**Recommendation rationale.** The unresolved decision-bearing criteria are Originality and Literature Integration (the person-as-executor gap is asserted against compared traditions described less generously than their own sources: W1, W3, W4), Evidence Sufficiency (two wrong Table 2 cells and an MCP citation that cannot support the features used: W2, W5), and Significance & Impact (no statement of drift, shared-state, or trust behavior: W8–W10). All are repairable with corrected cells, a few added paragraphs and citations, and honest re-statement of the contribution; none requires new experiments. Strengths S1–S6 do not offset these failures, but they are why I expect the revision to succeed. Major Revision.
