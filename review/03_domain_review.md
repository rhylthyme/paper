# Peer Review Report — Peer Reviewer 2 (Domain: scheduling and temporal reasoning)

## Manuscript Information
- **Title**: Rhylthyme: A Declarative Language and Agent-Native Runtime for Real-Time, Resource-Constrained Schedules that People Follow
- **Manuscript ID**: paper/rhylthyme.tex (9 pp., 37 refs)
- **Review Date**: 2026-09-08
- **Review Round**: Round 1

---

## Reviewer Information

### Reviewer Role
Peer Reviewer 2 (Domain)

### Reviewer Identity
Scheduling and temporal-reasoning scholar (RCPSP, machine scheduling, STN/STNU, Allen algebra) with an operations-research background (Configuration Card #3).

### Review Focus
(1) Technical correctness of the formal mappings the paper makes: Table 1's Allen-relation labels, the STN claim for fixed-duration programs, the STNU/contingent-link framing of variable and indefinite durations, the "track = unary resource, resourceConstraints = cumulative resource" mapping, and the critical-path description. (2) Literature coverage and accuracy across §2.1–2.6. (3) Whether the claimed gap ("scheduling whose executor is a person, played live") is genuinely unoccupied. I do not assess code-level reproducibility (Reviewer 1) or the lab-automation/MCP landscape (Reviewer 3).

---

## Overall Assessment

### Recommendation
- [ ] Accept
- [ ] Minor Revision
- [x] **Major Revision**
- [ ] Reject

### Confidence Score
4 — Mostly within my area of expertise (scheduling theory, temporal constraint networks, project-scheduling literature). Lower confidence on LLM/agent tooling and laboratory practice, which I do not judge here. Confidence is a scope disclosure only; it does not change severity or decision bearing.

### Calibration Status
`NOT_CALIBRATED`

### Summary Assessment
The paper describes Rhylthyme, a JSON language plus validator, heuristic planner, two live runtimes and an MCP server for multi-track, resource-constrained schedules executed by a person, and positions it against six scheduling traditions. It is explicitly a descriptive systems report with no evaluation, and I review it as such. Within my remit the paper is well organized and, with one exception, characterizes the works it cites accurately; the nearest-neighbour comparison in §6 is the right one. Its weakness is that the formal vocabulary it borrows is used loosely at exactly the points that matter to a scheduling reader: variable and indefinite steps are called contingent links although the schema makes them executor-ended (controllable), so the STNU framing and the "dynamic-controllability check" future-work item are mis-posed; the Allen labels for start-anchored triggers in Table 1 are wrong in direction and incomplete; and what §4 calls "the critical path" is a nearest-predecessor walk, not the CPM longest path, in a setting (resource-constrained, staggered) where classical criticality is known not to apply. On literature, the paper omits the execution-side lineage its runtime belongs to (dispatchable STN execution; mixed-initiative and personal scheduling) and understates occupied neighbours of its gap claim (Cooking Navi, protocols.io Run mode, guideline execution languages). All of this is repairable by rewriting, not new experiments, which is why I recommend Major Revision rather than rejection.

---

## Strengths

### S1: Cited works are characterized accurately
I checked the substantive claims made about Guley & Stinson (branch and bound), Matsushima & Funabiki (six cooking-step types under cook and utensil constraints), Zhou et al. (precedence, station allocation and a zero-gap synchronization constraint "e_{k,q} = s_{k,q+1}"), Bertsimas & Stock Patterson (0–1 IP, NP-hardness), Tercio (satisficing sequencer inspired by real-time processor scheduling), Kelley & Walker, Malcolm et al., Allen, Dechter–Meiri–Pearl, Vidal & Fargier and Morris et al. All are correct as stated.
**Evidence Anchor**: `section: §2.1–§2.5`

### S2: Honest scoping of controllability
The paper does not claim to check controllability and says so in the related-work section rather than burying it in limitations.
**Evidence Anchor**: `text: §2.4 "whether such a program is dynamically controllable is a question Rhylthyme does not currently answer"`

### S3: End-anchored Allen labels are correct
For `afterStep` anchored on the referenced step's end, *met-by* (offset 0) and *after* (offset > 0) are the determinate Allen relations regardless of durations; the schema's OWL-Time `$comment` annotations (`time:intervalMetBy`, `time:intervalAfter`) are a sound basis for this part of the table.
**Evidence Anchor**: `table: Table 1 — afterStep row, "met-by the referenced step's end (offset 0), after it (offset > 0)"`

### S4: The nearest-neighbour contrast is well chosen and fairly stated
Identifying the cooking-step schedulers and the SDL scheduler as systems that model the same objects and stop at an optimized procedure is the sharpest available contrast, and the "target for their output" framing is fair to those works.
**Evidence Anchor**: `text: §6 "Rhylthyme would be a natural target for their output, since none of them produces a live, shareable runtime or an agent interface"`

### S5: Related work is synthesized, not enumerated
Each subsection ends by stating what transfers to Rhylthyme and what does not, and Table 2 collapses the six lenses onto eight comparable axes.
**Evidence Anchor**: `section: §2, Table 2`

---

## Weaknesses

### W1: Variable and indefinite steps are called contingent links, but the schema makes them executor-ended (controllable); the STNU framing is misapplied and the DC future-work item is mis-posed
**Problem**: In the STNU vocabulary the paper invokes (Vidal & Fargier 1999; Morris, Muscettola & Vidal 2001), a *contingent* link is one whose duration is chosen by nature and merely observed by the executing agent; the agent chooses only *requirement*/controllable time points. The manuscript defines a variable step as one that "may be ended early by the executor" and an indefinite step as one that "runs until the executor ends it" (§3). A step whose end the executor chooses is a *controllable* link with a flexible duration, not a contingent one. Three consequences follow. (a) The mapping "controllable / bounded contingent / unbounded contingent" is inverted for the executor-ended case. (b) STNU contingent links are defined with finite bounds (0 < l < u < ∞); an "unbounded contingent link" is not an STNU object, so "programs with indefinite steps and negative offsets are STNUs" (§7) does not hold as written. (c) For a genuinely contingent end with any positive duration range, an *exact* negative offset (X must start at end(Y) − 20 min) is never dynamically controllable: no execution strategy can commit to X's start 20 minutes before an end it has not yet observed unless the range is a single point. So the future-work question "would a DC check tell authors whether 'start twenty minutes before the roast is done' can always be honoured" already has an answer: no, if the roast end is contingent; trivially yes, if the cook controls it. The validator's own rule that a negative offset "requires the referenced step to be indefinite" (Table 1) points the same way: a countdown into a fixed-duration step is the one case where the target instant *is* known in advance, so the rule is a runtime-implementation constraint, not a temporal-reasoning one, and should be presented as such.
**Evidence Anchor**: `text: §3 "The three kinds correspond to a controllable link, a bounded contingent link, and an unbounded contingent link"`
**Why it matters**: The paper's temporal-reasoning positioning (§2.4, §3, §7, Table 2 "contingent durations" column) rests on this identification. A temporal-reasoning reader will conclude the authors have the direction of uncertainty backwards, and the stated future-work item would be wasted effort as posed.
**Suggestion**: Distinguish two kinds of non-fixed step explicitly: *executor-ended* (the person decides when it ends; controllable, flexible duration — the object of dispatchable-STN execution, Muscettola, Morris & Tsamardinos 1998) and *process-ended* (the oven reaching temperature, a culture reaching density; the person only observes — genuinely contingent). Add a schema flag or document the convention. Recast §7: for process-ended steps with negative offsets the right tool is not a DC check but either (i) a bounded window ("start X between 15 and 25 min before Y ends", i.e. a requirement link with slack, for which DC is non-trivial and the Morris 2005/2014 algorithms apply) or (ii) treating the cue as advisory. Keep the three-scenario (min/default/max) simulation but describe it as sampling the duration space, not as a controllability guarantee.
**Severity**: Major
**Confidence**: 5 — core expertise: temporal constraint networks with uncertainty

### W2: Table 1's Allen labels for start-anchored and negative-offset triggers are incorrect in direction and incomplete
**Problem**: An Allen relation constrains both endpoints of two intervals; a start trigger constrains only the new step's start instant. For `afterStep` with `event: start` and offset 0, the induced relation between the new step X and the referenced step Y is the disjunction {X *starts* Y, X *started-by* Y, X *equals* Y}, decided by the two durations; with offset > 0 it is {X *during* Y, X *finishes* Y, X *overlapped-by* Y}. "*overlaps*" (X o Y) requires X to start *before* Y, which no `event: start` trigger with non-negative offset can produce. The table is also inconsistent about which interval is the subject: *met-by* takes X as subject, whereas *overlaps* would only be right with Y as subject. The negative-offset case has no Allen label at all, and for an indefinite Y (W1) the relation is undetermined. The schema's own `$comment` ("time:intervalStarts or time:intervalOverlaps") carries the same error, so the manuscript has reproduced rather than checked it.
**Evidence Anchor**: `table: Table 1 — afterStep row, "with event: start, starts/overlaps"`
**Why it matters**: The abstract and contribution (i) present "start triggers map onto Allen's interval relations" as a feature of the language, and §7 proposes a formal semantics "in the vocabulary of Table 1". A formal semantics built on this table would be wrong for every start-anchored trigger.
**Suggestion**: Either (a) present the mapping as what it is — point constraints on `time:hasBeginning` relative to the referenced step's `hasBeginning`/`hasEnd` with a signed metric offset, which is the OWL-Time vocabulary the schema already uses — and give the *set* of Allen relations each row admits; or (b) keep Allen labels only on rows where they are determinate (end-anchored, offset ≥ 0; `afterStepWithBuffer`). If the authors want the qualitative-plus-metric combination as a single formalism, the literature on combining Allen relations with metric constraints is the right citation (search lead: work by Meiri, *Artificial Intelligence* 1996 — `[UNVERIFIED]` metadata, verify before citing).
**Severity**: Major
**Confidence**: 5 — core expertise: interval algebra

### W3: What §4 calls "the critical path" is a nearest-predecessor walk, not CPM's critical path, and the paper says it borrows CPM's
**Problem**: CPM's critical path (Kelley & Walker 1959) is the longest path through the precedence network, equivalently the chain of zero-total-float activities found by a forward and backward pass. The manuscript describes a different procedure: from the last-ending step, repeatedly choose "the predecessor whose end is closest to each start". This (a) selects by temporal proximity rather than by the binding constraint — with offsets or buffers the binding predecessor is the one maximizing end + offset, which is not in general the one minimizing |end − start|; (b) yields *a* backward chain, not necessarily the longest one, and gives no float for the remaining steps; (c) terminates at any step without trigger predecessors, including one placed by `programStartOffset`, whose delay is then reported as if it were on the critical path; and (d) ignores implicit within-track ordering except for manual triggers, although the validator enforces that ordering as non-overlap. More fundamentally, once the planner staggers starts around resource bottlenecks (§4 "Planning"), the schedule is resource-constrained, and it has been known since Wiest (1964) that the CPM critical path is not well defined there; Bowers (1995) gives the standard resource-constrained float. §6 nevertheless lists "CPM's critical path" among the things Rhylthyme borrows.
**Evidence Anchor**: `text: §4 "walking back from the last-ending step through the predecessor whose end is closest to each start"`
**Why it matters**: `analyze_schedule` is a headline MCP tool whose output ("find why a schedule is longer than expected") an LLM will relay to a cook or technician as *the* critical path. A scheduling reader will see the definition and discount the tool; the §6 borrowing claim is inaccurate as stated.
**Suggestion**: Either implement the standard forward/backward pass over the trigger graph (earliest start from triggers; latest start from successors and makespan; critical = zero float) and report float per step — the per-track slack already computed is one step short of this — or rename the current output ("driving chain" / "binding predecessor chain") and state in §4 and §6 that it is a heuristic distinct from CPM criticality. In either case cite Wiest 1964 and Bowers 1995 for why criticality under resource constraints needs care.
**Severity**: Major
**Confidence**: 5 — core expertise: project scheduling

### W4: The gap claim "person as executor, played live" is partly occupied, and the manuscript does not acknowledge the occupants
**Problem**: The thesis sentence divides prior software into static-plan producers and machine executors. At least four bodies of work sit in between and are absent or mischaracterized. (i) *Cooking Navi* (Hamada et al., ACM Multimedia 2005) rescheduled steps across several recipes and guided a novice cook live in the kitchen; it is the direct ancestor of the paper's kitchen vertical and of the cited Matsushima/Nakabe line, and is not cited. (ii) *protocols.io* has a Run mode — a step-by-step checklist with an integrated timer and timestamped record of each completed step — which is a person-as-executor live runtime for bench protocols; the manuscript cites protocols.io only as a "human-readable protocol layer" and an import source. (iii) Computer-interpretable clinical guideline languages, notably Asbru (Miksch, Shahar & Johnson 1997), are time-oriented plan languages with earliest/latest/duration annotations executed by and for clinicians; this is the most developed "schedule a person follows" formalism in the literature. (iv) Gombolay et al. (Autonomous Robots 2015) studied humans executing robot-generated schedules live and found they prefer ceding scheduling authority — directly relevant evidence for the paper's premise, and from a group the paper already cites.
**Evidence Anchor**: `absence: §1, §2.5, §6 and Table 2 — expected acknowledgement of Cooking Navi, protocols.io Run mode, guideline-execution languages (Asbru) and Gombolay et al. 2015 as prior person-as-executor runtimes; checked §1, §2.1–2.6, §6, Table 2, §7, references.bib`
**Why it matters**: Originality is claimed on the *combination* (§6), which survives; but the framing in the abstract and §1 ("Most scheduling software either … or …") is broader than the evidence, and the protocols.io omission in particular is unfair to a system the paper depends on.
**Suggestion**: Add these to §2.5 (kitchen and laboratory) and §2.4 (human-robot), add a "human-followed runtimes" column or rows to Table 2 (Cooking Navi, protocols.io Run, Asbru-style guideline engines), and narrow the §1 dichotomy to "with rare exceptions, discussed in §2.5". The combination claim in §6 should then carry the weight, which it can.
**Severity**: Major
**Confidence**: 4 — core expertise in scheduling; product-feature claim for protocols.io verified from its documentation, not from use

### W5: The execution-side literature the runtime belongs to — dispatchable temporal plans, mixed-initiative and personal scheduling — is absent
**Problem**: The runtime "plays a program live": it resolves start times, fires steps when triggers are satisfied, and lets the person end flexible steps. In temporal reasoning this is *dispatching* a flexible temporal plan, and there is a specific literature on when local propagation suffices (dispatchability: Muscettola, Morris & Tsamardinos 1998; incremental maintenance under partial controllability: Shah, Stedl, Williams & Robertson 2007; the DC–dispatchability relationship: Morris 2014). The paper cites Dechter et al. and Morris et al. 2001 for representation but nothing for execution, so the one thing the runtime actually does has no lineage. Separately, a person who authors a schedule with a tool and then executes it is the subject of the mixed-initiative scheduling literature (MAPGEN, Ai-Chang et al. 2004) and of personal/calendar scheduling (SelfPlanner, Refanidis & Yorke-Smith 2010; PTIME, Berry et al. 2011), where the "domain expert or LLM agent" authoring axis of Table 2 was the human–assistant pair. None is cited.
**Evidence Anchor**: `absence: §2.4 and §4 "Execution" — expected citations for dispatchable STN execution and for mixed-initiative / personal scheduling; checked §2.4, §4, §6, §7, references.bib`
**Why it matters**: Section 2 is the paper's main body and its stated basis for positioning; a temporal-reasoning reader will regard a "live runtime for temporal plans" that does not mention dispatchability as unaware of the field, and the §7 "formal semantics" item would be well-posed only against that literature.
**Suggestion**: One paragraph in §2.4 on dispatchable execution (what the runner does is dispatch an STN whose triggers are lower bounds; whether late human starts propagate is the dispatchability question — see Q3). One paragraph in a new or extended subsection on mixed-initiative and personal scheduling, which also strengthens the "authoring audience" row of Table 2.
**Severity**: Major
**Confidence**: 5 — core expertise: temporal plan execution

### W6: The STN claim for fixed-duration programs is imprecise about which constraints are and are not in an STN
**Problem**: With triggers read as equalities ("begins at t = offset", "met-by") the fixed-duration/non-negative-offset program is not a constraint network with flexibility but a fully determined schedule; read as lower bounds it is an STN with only forward difference constraints and no upper bounds, which is consistent iff acyclic, so "consistency" reduces to the cycle check the validator already does. Two constructs the paper includes are *not* STN-expressible: the `any` compound trigger (start = earliest of several triggers is a disjunction), and within-track non-overlap (a disjunctive resource constraint, which is what the overlap check enforces). `manual` triggers are exogenous time points. The sentence is therefore true only for a narrower fragment than stated and the validator checks both less (no upper bounds, no deadlines) and more (resource disjunctions) than STN consistency.
**Evidence Anchor**: `text: §2.4 "a program with only fixed durations and non-negative offsets is a simple temporal network whose consistency the validator checks by resolving all start times"`
**Why it matters**: Framing accuracy in the section that positions the language against temporal constraint networks; no core claim depends on it.
**Suggestion**: State the fragment precisely (fixed durations, `programStart`/`programStartOffset`/`afterStep`/`afterStepWithBuffer` with offset ≥ 0, `all` compounds) and say that `any` compounds are disjunctive (search lead: disjunctive temporal problems, e.g. Tsamardinos & Pollack, *Artificial Intelligence* 2003 — `[UNVERIFIED]` metadata) and that track non-overlap is a resource constraint outside the STN.
**Severity**: Minor
**Confidence**: 5 — core expertise: temporal constraint networks

### W7: "Unary/cumulative resource" is constraint-programming vocabulary, and a track is more than a unary resource
**Problem**: Brucker et al. (1999) classify resources as renewable/non-renewable/doubly constrained with capacities R_k; "unary" and "cumulative" are the constraint-based scheduling terms (Baptiste, Le Pape & Nuijten 2001). The mapping is correct in substance (a track is a renewable resource with R_k = 1) but attributed to the wrong notation. Additionally, a unary resource permits any order of its activities, whereas a track is described as "a named sequence"; the paper should say whether the array order is enforced or only non-overlap is (the validator text suggests the latter). Finally, in RCPSP terms the scarce renewable resource in a kitchen is the *person*, and whether two tracks can be active simultaneously depends on whether their current steps need attention (whisking) or not (roasting). The manuscript handles this only through environment-level `actorsRequired`; it deserves a sentence in §2.2 because it is the resource that distinguishes human-executed from machine-executed scheduling.
**Evidence Anchor**: `text: §2.2 "In RCPSP terms a track is a unary resource"`
**Why it matters**: Terminology precision for OR readers; the attended/unattended distinction is a genuine modeling point that the paper's own premise depends on.
**Suggestion**: Cite Baptiste et al. 2001 for unary/cumulative; say "renewable resource of capacity one" when attributing to Brucker; clarify order vs. non-overlap; add the attended/unattended point and how `actorsRequired` expresses it.
**Severity**: Minor
**Confidence**: 5 — core expertise: RCPSP notation

### W8: The ATC capacity analogy is overstated
**Problem**: In Bertsimas & Stock Patterson (1998) airport capacities are per-period arrival and departure *rates* (throughput), and sector capacities are occupancy caps; only the latter is "exactly" `maxConcurrent`. Also, the ATC problem's defining feature — ground-holding and rerouting decisions under capacity *reductions* that arrive during execution — has no analogue in Rhylthyme, which fixes capacities at authoring time.
**Evidence Anchor**: `text: §2.3 "capacity is expressed as a cap on concurrent occupancy of a shared resource over a time window, exactly Rhylthyme's maxConcurrent"`
**Why it matters**: Precision of an analogy; no core claim depends on it.
**Suggestion**: "sector capacity is a cap on concurrent occupancy, which is Rhylthyme's `maxConcurrent`; airport capacities are throughput rates, which Rhylthyme does not model."
**Severity**: Minor
**Confidence**: 4 — adjacent expertise: air-traffic flow management models

### W9: Gantt-chart HCI and temporal-uncertainty visualization literature is absent from §2.1
**Problem**: §2.1 cites Wilson's history only. The critical project-management reading of the Gantt chart (Geraldi & Lechter 2012 — it was designed for repetitive shop operations, not one-off projects, which is closer to Rhylthyme's use than to project management) and the visualization of temporal uncertainty on timelines (PlanningLines, Aigner et al. 2005, designed precisely for earliest/latest start and duration ranges) are directly relevant to a system whose primary view is a Gantt chart with variable-duration bars.
**Evidence Anchor**: `absence: §2.1 — expected Gantt-chart HCI and temporal-uncertainty visualization references; checked §2.1, §4 "Execution", Figure 1 caption, references.bib`
**Why it matters**: The rendered timeline is the paper's main artifact; how variable and indefinite bars are drawn is a design decision with prior art.
**Suggestion**: Add both references and say how the renderer depicts min/default/max (Figure 1 does not show it).
**Severity**: Minor
**Confidence**: 4 — adjacent expertise: temporal visualization

---

## Detailed Comments

### Literature Review / Theoretical Framework
- **Coverage**: Strong on the OR and robotics side (§2.1–2.4 cite the right seminal works), thin on execution and human-facing scheduling. Missing: dispatchable execution (W5), mixed-initiative and personal scheduling (W5), human-followed runtimes and guideline languages (W4), Gantt HCI (W9), resource-constrained criticality (W3), CP-scheduling vocabulary (W7). The chosen cooking and lab references are correct and well characterized (S1), with Cooking Navi the notable omission in the cooking line.
- **Integration quality**: Genuine synthesis: each lens ends with a "what transfers" statement and Table 2 makes the comparison explicit. §6's nearest-neighbour paragraph is the best part of the positioning.
- **Research gap argument**: The dichotomy in the abstract/§1 is too clean (W4); the combination claim in §6 is defensible and should carry the argument.

### Theoretical Framework
- **Appropriateness**: Allen algebra, STN/STNU and RCPSP are the right frameworks for this system. The choice is sound.
- **Application depth**: Superficial at the three decisive points — contingent vs. controllable (W1), interval vs. point constraints (W2), critical path vs. driving chain (W3). Each is fixable by a paragraph of careful definition, and fixing them would make the §7 "formal semantics" item well-posed.
- **Alternative frameworks**: Dispatchable STN execution (Muscettola et al. 1998) is a better fit for what the runtime does than STNU controllability, because in the executor-ended reading there is no exogenous uncertainty to control against. Disjunctive temporal problems cover `any` compounds. Asbru-style time annotations (earliest/latest start, min/max duration) are a mature alternative representation of the same information as `minSeconds`/`maxSeconds`/`defaultSeconds`.

### Academic Argument Quality
- **Factual accuracy**: Cited works accurate (S1). Inaccuracies are in the paper's own mappings: W1 (direction of contingency; STNU bounds), W2 (Allen labels), W3 (critical path), W8 (ATC capacity types).
- **Argument logic**: The §7 claim that a DC check "would tell authors in advance whether … can always be honoured" is a logical leap once W1 is accepted: the answer is determined by the modeling decision, not by an algorithm. `[FIELD-NORM UNVERIFIED]` does not apply here — the severities of W1–W3 rest on definitions in the cited primary sources (Morris et al. 2001; Allen 1983; Kelley & Walker 1959), not on a field norm.
- **Terminology precision**: "contingent", "controllability", "critical path", "unary/cumulative" — all used more loosely than the field does (W1, W3, W7). "Simple temporal network" used for a fragment larger than the one it fits (W6).

### Contribution to the Field
- **Incremental contribution**: Practical/systems: a schema plus runtime plus agent interface reused across four verticals. From a scheduling-theory standpoint there is no new model or algorithm, and the paper does not claim one. The genuinely new element for this field is the *executor-ended* flexible step in a live dispatcher — which the paper has, but mislabels as contingency (W1). Naming it correctly would sharpen the contribution.
- **Positioning**: Correct relative to the compared systems; incomplete relative to human-followed runtimes and execution theory (W4, W5).
- **Overclaiming**: Moderate. The abstract's dichotomy and the "borrows CPM's critical path" sentence overstate; the §6 combination claim and the "no optimality claims" disclaimer are appropriately modest.

### Missing Key References
All entries below were verified to exist on 2026-09-08 via publisher, ACM/IEEE DL, Springer, or repository pages; items marked `[UNVERIFIED]` are search leads only.

1. Hamada, R., Okabe, J., Ide, I., Satoh, S., Sakai, S., Tanaka, H. (2005). Cooking Navi: Assistant for daily cooking in kitchen. *Proc. 13th ACM International Conference on Multimedia*, 371–374. doi:10.1145/1101149.1101228. — Live, multi-recipe, rescheduled kitchen guidance; direct ancestor of the kitchen vertical (W4).
2. Muscettola, N., Morris, P., Tsamardinos, I. (1998). Reformulating temporal plans for efficient execution. *Proc. 6th Int. Conf. on Principles of Knowledge Representation and Reasoning (KR'98)*. — Dispatchability; what "playing a program live" is in temporal-reasoning terms (W5).
3. Morris, P., Muscettola, N. (2005). Temporal dynamic controllability revisited. *Proc. AAAI-05*, 1193–1198. — Polynomial DC checking; the algorithm §7 would need if process-ended steps are kept contingent (W1).
4. Morris, P. (2014). Dynamic controllability and dispatchability relationships. *CPAIOR 2014*, LNCS 8451, 464–479. doi:10.1007/978-3-319-07046-9_33. — Connects the two notions the paper needs (W1, W5).
5. Shah, J.A., Stedl, J., Williams, B.C., Robertson, P. (2007). A fast incremental algorithm for maintaining dispatchability of partially controllable plans. *Proc. ICAPS 2007*. — Dispatching with partial controllability; the model closest to a person ending some steps and observing others (W5).
6. Ai-Chang, M., Bresina, J., Charest, L., Chase, A., Hsu, J., Jonsson, A., Kanefsky, B., Morris, P., Rajan, K., Yglesias, J., Chafin, G., Dias, W., Maldague, P. (2004). MAPGEN: Mixed-initiative planning and scheduling for the Mars Exploration Rover mission. *IEEE Intelligent Systems* 19(1), 8–12. — Canonical mixed-initiative scheduling with a human author and STN core (W5).
7. Refanidis, I., Yorke-Smith, N. (2010). A constraint-based approach to scheduling an individual's activities. *ACM Transactions on Intelligent Systems and Technology* 1(2), 12:1–12:32. doi:10.1145/1869397.1869401. — Personal task scheduling with duration ranges and interruptibility (W5).
8. Berry, P.M., Gervasio, M., Peintner, B., Yorke-Smith, N. (2011). PTIME: Personalized assistance for calendaring. *ACM Transactions on Intelligent Systems and Technology* 2(4), 40:1–40:22. doi:10.1145/1989734.1989744. — Assistant-authored personal schedules (W5, Table 2 "Author" row).
9. Miksch, S., Shahar, Y., Johnson, P. (1997). Asbru: A task-specific, intention-based, and time-oriented language for representing skeletal plans. *Proc. 7th Workshop on Knowledge Engineering: Methods & Languages (KEML-97)*. — Time-oriented plan language executed by people, with earliest/latest/duration annotations (W4).
10. Gombolay, M.C., Gutierrez, R.A., Clarke, S.G., Sturla, G.F., Shah, J.A. (2015). Decision-making authority, team efficiency and human worker satisfaction in mixed human–robot teams. *Autonomous Robots* 39(3), 293–312. doi:10.1007/s10514-015-9457-9. — Humans executing machine-generated schedules live (W4).
11. Wiest, J.D. (1964). Some properties of schedules for large projects with limited resources. *Operations Research* 12(3), 395–418. — "Critical sequence": why the CPM critical path does not survive resource constraints (W3).
12. Bowers, J.A. (1995). Criticality in resource constrained networks. *Journal of the Operational Research Society* 46(1), 80–91. doi:10.1057/jors.1995.9. — Resource-constrained float (W3).
13. Baptiste, P., Le Pape, C., Nuijten, W. (2001). *Constraint-Based Scheduling: Applying Constraint Programming to Scheduling Problems*. Kluwer, Int. Series in OR & MS 39. doi:10.1007/978-1-4615-1479-4. — Source of "unary" and "cumulative" resource vocabulary (W7).
14. Geraldi, J., Lechter, T. (2012). Gantt charts revisited: A critical analysis of its roots and implications to the management of projects today. *International Journal of Managing Projects in Business* 5(4), 578–594. doi:10.1108/17538371211268889. (W9)
15. Aigner, W., Miksch, S., Thurnher, B., Biffl, S. (2005). PlanningLines: Novel glyphs for representing temporal uncertainties and their evaluation. *Proc. 9th Int. Conf. on Information Visualisation (IV'05)*, 457–463. (W9)
16. protocols.io, "Run protocols as checklists" (product documentation, https://www.protocols.io/help/ongoing-research-work/run, accessed 2026-09-08). — Cite alongside Teytelman et al. 2016 when acknowledging the Run mode (W4).

Search leads, `[UNVERIFIED]` metadata: combining qualitative and metric temporal constraints (Meiri, *Artificial Intelligence*, 1996); disjunctive temporal problems (Tsamardinos & Pollack, *Artificial Intelligence*, 2003); the original introduction of contingent links (Vidal & Ghallab, ECAI 1996); the Aigner–Miksch–Schumann–Tominski book *Visualization of Time-Oriented Data* (Springer, 2011); recent STNU DC-checking algorithms by the Hunsberger/Posenato group.

---

## Questions for Authors

1. For a variable or indefinite step, who decides when it ends — the executor by choice (the cook decides the onions are done enough), or a physical process the executor merely observes (the oven reaches 200 °C)? The schema seems to assume the former; the roast example in §2.4 assumes the latter. Which is intended, and if both occur, how are they distinguished? (Determines W1.)
2. At run time, is `afterStep` an equality (the runner fires the step the instant the trigger is satisfied) or a lower bound (the person may start later)? If a person starts a step late, do downstream planned times propagate, and if so how far — i.e., is the runner a dispatcher in the sense of Muscettola et al. 1998? (Determines the §2.4 STN claim and W5.)
3. Is `afterStepWithBuffer` semantically different from `afterStep` with a positive `offsetSeconds`? Table 1 gives both the label *after*.
4. Is the array order of steps within a track enforced, or only non-overlap? The text says "a named sequence of steps that must not overlap"; the analyzer's predecessor logic appears to add the previous step only for manual triggers.
5. The analyzer's predecessor logic recognizes a `previousStepComplete` trigger type that Table 1 does not list. Is it part of the vocabulary?
6. How does `optimize_schedule`'s staggering interact with the reported critical path — is the path computed before or after resource-driven delays are inserted?

---

## Minor Issues

### Language / Grammar
- §5 first sentence: "instantiated four times, at /mcp, /kitchen/mcp, /lab/mcp, /events/mcp and /gym/mcp" lists five endpoints.
- §2.1: PERT's three-point estimate is a beta-distribution assumption; "without PERT's distributional assumptions" is fine, but Table 2's "PERT beta, stochastic" for the whole CPM/PERT/RCPSP column conflates deterministic RCPSP with stochastic PERT.

### Citation Format
- `vidal1999stnu`, `morris2001dc`, `brucker1999rcpsp`, `ball2003groundholding`, `gombolay2018tercio` lack DOIs while neighbouring entries carry them; harmless but inconsistent.
- W3C OWL-Time: the bib says "Candidate Recommendation, 26 March 2020"; consider also citing the 2017 version if the schema's namespace (`http://www.w3.org/2006/time#`) predates it.

### Figures and Tables
- Table 1 lacks the negative-offset case as its own row; if kept (W1), give it a row with its own semantics and no Allen label.
- Table 2, "Uncertainty" row: after W1, the Rhylthyme cell should read "executor-ended flexible durations" rather than sit under the same heading as "contingent durations".
- Figure 1 does not show how variable or indefinite durations are drawn; a min/max whisker or the PlanningLines convention would make the "three-point estimate" claim visible.

---

## Criterion-Bound Judgements

Calibration status: `NOT_CALIBRATED`

| Dimension | Criterion source | Judgement | Evidence anchor(s) | Rationale | Uncertainty / scope limit | Decision bearing? |
|---|---|---|---|---|---|---|
| Originality | review_criteria_framework.md §1 | PARTLY_MEETS | `absence: §1, §2.5, §6 and Table 2 — expected acknowledgement of prior person-as-executor runtimes; checked §1, §2, §6, Table 2, references.bib` | The combination claim (§6) is defensible; the dichotomy framing overstates because Cooking Navi, protocols.io Run, Asbru-style engines occupy part of the gap (W4). | I have not used protocols.io Run mode; feature claim from documentation. | yes — the gap argument is the thesis; repairable by rewriting |
| Methodological Rigor | review_criteria_framework.md §1 | NOT_ASSESSED | — | Reviewer 1's remit (code verification). | — | no |
| Evidence Sufficiency | review_criteria_framework.md §1 | NOT_ASSESSED | — | Descriptive report by design; artifact checking is Reviewer 1's remit. | — | no |
| Argument Coherence | review_criteria_framework.md §1, §2.2 (conceptual definition precision) | PARTLY_MEETS | `text: §3 "The three kinds correspond to a controllable link, a bounded contingent link, and an unbounded contingent link"` | The executor-ended definition in §3 contradicts the contingent-link label and the §7 DC future-work item (W1); the §6 "borrows CPM's critical path" claim contradicts the §4 procedure (W3). | none identified | yes — repairable by redefinition, no new data |
| Writing Quality | review_criteria_framework.md §1 | MEETS | `section: §2, §6` | Clear, compact, well-structured; terminology looseness is a domain-accuracy issue (above), not a prose issue. | none identified | no |
| Literature Integration | review_criteria_framework.md §1 | PARTLY_MEETS | `absence: §2.4 and §4 "Execution" — expected dispatchable-execution and mixed-initiative citations; checked §2.4, §4, §6, §7, references.bib` | Cited works accurate and synthesized (S1, S5); execution-side and human-followed-runtime literatures missing (W4, W5, W9). | none identified | yes — repairable by adding ~1 page of related work |
| Significance & Impact | review_criteria_framework.md §1 | PARTLY_MEETS | `text: §6 "Rhylthyme would be a natural target for their output, since none of them produces a live, shareable runtime or an agent interface"` | For scheduling theory the contribution is a correctly identified but mislabeled object (executor-ended flexible steps in a live dispatcher); naming it correctly would raise significance for this audience. Practical impact is Reviewer 3's remit. | Assessed for the scheduling audience only. | no on its own |

Recommendation rationale: the decision-bearing, unresolved criteria are Argument Coherence (W1–W3: formal mappings incorrect as stated) and Literature Integration / Originality (W4, W5: gap partly occupied, execution lineage absent). All are repairable by rewriting and redefinition without new experiments, so Major Revision rather than Reject. Strengths in synthesis and accuracy of cited works do not offset them.
