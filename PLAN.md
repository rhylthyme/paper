# Rhylthyme paper — chapter plan

Status: PLAN (ars-plan mode). Nothing below is prose for the paper yet; it is the
agreed skeleton, page budget, comparison axes, and a bibliography where every
entry has been verified against a primary index (publisher page, DOI, dblp, or
ACM/IEEE DL) on 2026-09-08.

## Scope decisions (from the planning dialogue)

| Decision | Choice |
|---|---|
| Document type | Technical report / arXiv-style writeup |
| Citation rigor | Real, verified citations only |
| Evaluation | Descriptive systems paper — no new experiments |
| Length | Short, 6–8 pages |
| Related-work breadth | Broad: Gantt/CPM/PERT, RCPSP, ATC flow management, robotics task allocation and temporal planning, cooking-step scheduling, lab automation, bioinformatics pipeline frameworks (one lens among several, not the focus) |
| Lab automation | Explicit subsection placing Rhylthyme in the landscape (SiLA 2, Autoprotocol, Opentrons API, PyLabRobot, protocols.io/Benchling, self-driving-lab schedulers) |

Working title: *Rhylthyme: a declarative language and agent-native runtime for
real-time, resource-constrained schedules that people follow*

## Thesis (one paragraph the whole paper defends)

Most scheduling software either (a) computes an optimal plan and hands it to a
human as a static artifact (CPM/PERT, RCPSP solvers, ATC flow programs), or (b)
executes a dependency graph on machines with no human in the loop
(bioinformatics workflow engines, lab-automation orchestrators, robot task
schedulers). Rhylthyme occupies the gap between them: a small declarative JSON
language for multi-track, resource-constrained, wall-clock schedules whose
*executor is a person*, a runtime that plays the schedule live (timers, cues,
manual and indefinite steps, choice branches), and an MCP server that lets an
LLM agent author, validate, analyze and publish such schedules as first-class
tool calls. The same schema is reused unchanged across cooking, bench
protocols, event run-of-show and training.

## Structure and budget (target ≈ 7 pages incl. one table and two figures)

| # | Section | Words | Notes |
|---|---|---|---|
| — | Abstract | 150 | |
| 1 | Introduction | 450 | The "person as executor" gap; contributions list (language, runtime, MCP server, cross-domain verticals) |
| 2 | Related work | 1400 | Six short lenses, ≈230w each, ordered from oldest tradition to closest relative |
| 2.1 | Gantt charts, CPM and PERT | | Wilson 2003; Kelley & Walker 1959; Malcolm et al. 1959 |
| 2.2 | Resource-constrained project scheduling | | Brucker et al. 1999; Kolisch & Padman 2001; Pinedo (6th ed.) |
| 2.3 | Real-time flow management in air traffic control | | Bertsimas & Stock Patterson 1998; Ball et al. 2003; Wambsganss 1996 (CDM) |
| 2.4 | Temporal reasoning and robot task scheduling | | Allen 1983 (the schema's `$comment`s cite Allen relations explicitly); Dechter/Meiri/Pearl 1991 (STN); Vidal & Fargier 1999 and Morris/Muscettola/Vidal 2001 (STNU, dynamic controllability = Rhylthyme's *indefinite* + *afterStep with negative offset*); Gerkey & Matarić 2004 and Korsah et al. 2013 (MRTA taxonomy); Gombolay/Wilcox/Shah 2018 (Tercio, temporospatial constraints); Colledanchise & Ögren 2018 (behavior trees as the reactive-execution counterpart) |
| 2.5 | Domain schedulers: kitchens and laboratories | | Guley & Stinson 1984; Matsushima & Funabiki 2015; Nakabe et al. 2021; Tom et al. 2024 (SDL review); Zhou et al. 2026 (multi-task SDL scheduling with zero-gap sync constraints); Fehlis et al. 2025 (Artificial orchestration); SiLA 2; Autoprotocol; Opentrons Protocol API; PyLabRobot (Wierenga et al. 2023); protocols.io (Teytelman et al. 2016) |
| 2.6 | Computational workflow engines | | Leipzig 2017 (framework taxonomy: implicit/explicit syntax, configuration/convention/class paradigms, CLI/workbench); Köster & Rahmann 2012; Di Tommaso et al. 2017; Amstutz et al. 2016 / Crusoe et al. 2022 (CWL); BPMN 2.0 as the human-process analogue |
| 3 | The Rhylthyme program model | 650 | Program → tracks → steps; `startTrigger` (programStart, programStartOffset, afterStep [event, offsetSeconds incl. negative, choiceId], afterStepWithBuffer, manual, onAbort, compound all/any); `duration` (fixed / variable / indefinite); `resourceConstraints` (maxConcurrent per task); `actors`; `choice`; `replicates` (parallel/stagger/serial); metadata. Map trigger types to Allen relations / OWL-Time terms that the schema already annotates. **Figure 1:** a 3-track example (breakfast) as JSON + rendered Gantt |
| 4 | Runtime and tooling | 500 | Validator (schema + logic: duplicate ids, dangling refs, within-track overlap, task↔constraint consistency, choice refs); `ProgramPlanner` (simulate_execution over min/default/max durations, bottleneck detection via ResourceUsage, optimize_schedule: stagger track/step starts, adjust variable durations); CLI/TUI runner (`ProgramRunner`: start/pause/stop, manual triggers, abort → onAbort); web runtime (D3 timeline, itinerary, DAG, live clock, per-vertical hosts) |
| 5 | The MCP server: agent-native authoring | 550 | Why MCP (Anthropic 2024 spec); tool surface with annotations: `validate_program` (coded findings + fix hints), `analyze_schedule` (makespan, critical path, resource-conflict windows, wall-clock anchoring via finishAt/startAt), `visualize_schedule` (validate → publish → live URL + PNG), `import_from_source` (Spoonacular/TheMealDB/protocols.io/Cooklang/Opentrons/Benchling), `create_environment`, catalog search/load, account tools; resources (`rhylthyme://schema/program`, authoring guide, examples) and the `plan_schedule` prompt; verticals as endpoint-level instantiation of one schema. **Figure 2:** sequence diagram of search → build → validate → analyze → visualize |
| 6 | Discussion: positioning | 500 | **Table 1** (below). Then three paragraphs: what Rhylthyme borrows (Gantt semantics, STN-style triggers, RCPSP resource model), what it deliberately omits (optimality guarantees, machine execution), what is new (person-as-executor runtime + LLM-authored programs + one schema across domains) |
| 7 | Limitations and future work | 200 | Planner is heuristic, no controllability check for STNU-shaped programs; no multi-actor assignment solver; import quality bounded by source structure; OAuth for MCP; formal semantics |
| 8 | Conclusion | 100 | |

### Table 1 — positioning axes

| Axis | CPM/PERT/RCPSP | ATC flow mgmt | Robot task scheduling | Lab automation orchestrators | Bioinformatics workflow engines | **Rhylthyme** |
|---|---|---|---|---|---|---|
| Executor | human, offline | controllers + airlines, live | robots | instruments/robots | compute nodes | **a person, live** |
| Authoring audience | analyst/PM | traffic manager | roboticist | automation engineer | bioinformatician | **domain expert or LLM agent** |
| Temporal semantics | precedence + durations | slot/time windows, replanned | STN/STNU, temporospatial | zero-gap sync, station allocation | data-dependency DAG | **wall-clock triggers incl. manual/indefinite, live clock** |
| Objective | optimal makespan/NPV | min delay cost under capacity | feasible/near-optimal | throughput under scientific constraints | reproducible output, portability | **followable timeline; feasibility + conflict surfacing** |
| Resource model | renewable resources | sector/airport capacity | robot capabilities | stations | CPU/RAM/containers | **maxConcurrent per task + actors** |
| Uncertainty | PERT beta / stochastic | stochastic demand | contingent durations | process variance | retries | **variable/indefinite steps, user-ended** |
| Portability | tool-specific | domain-specific | domain-specific | vendor/standard (SiLA, Autoprotocol) | container/CWL | **one JSON schema across kitchen/lab/events/gym** |
| Agent interface | none | none | none | emerging (LAP, MCP wrappers) | none | **native MCP tools/resources/prompts** |

## INSIGHT collection

1. **Allen and OWL-Time are already in the schema.** `program_schema_0.2.0-alpha.json` annotates every trigger with `$comment`s in OWL-Time / Allen vocabulary (`time:intervalMetBy`, `time:intervalAfter`, `time:hasBeginning`). Section 3 should present the trigger table *as* a mapping to Allen relations rather than inventing a new formalism. Cite Allen 1983 and Hobbs & Pan 2004 / W3C OWL-Time.
2. **Indefinite steps + negative offsets are an STNU in disguise.** "Start the potatoes 20 min before the roast finishes, roast is indefinite" is a contingent link. Vidal & Fargier / Morris et al. give the vocabulary (weak/strong/dynamic controllability); the honest claim is that Rhylthyme *represents* such constraints and lets the runtime resolve them at execution time, but does not check dynamic controllability — list as future work, not a contribution.
3. **The validator's `track_overlap` rule is the RCPSP "one machine per track" assumption made explicit.** A track is a unary resource (the person's hands at one station). Frame tracks as unary resources and `resourceConstraints` as cumulative resources; this maps cleanly onto Brucker et al.'s notation.
4. **Closest existing systems are the cooking-step schedulers (Matsushima & Funabiki; Nakabe et al.) and SDL schedulers (Zhou et al.).** Both formulate cooking/lab as RCPSP-like optimization; neither produces a live, human-followed runtime or an agent interface. This is the sharpest "nearest neighbour" contrast and belongs in 6, not buried in 2.
5. **Bioinformatics engines are the right *architectural* comparison but the wrong *problem* comparison.** Same shape (declarative DAG, validation, execution engine, importers), different executor (machines) and objective (reproducibility). Use Leipzig 2017's taxonomy axes (implicit/explicit, configuration/convention/class, CLI/workbench) to classify Rhylthyme itself: explicit syntax, configuration paradigm, both CLI and workbench. This keeps the section short and non-tutorial, as requested.
6. **Lab automation is a *layered* landscape and Rhylthyme sits in the protocol/human layer.** Device layer: SiLA 2, Opentrons API, PyLabRobot. Machine-protocol layer: Autoprotocol. Human-protocol layer: protocols.io, Benchling, ELNs. Orchestration/scheduling layer: Artificial, SDL schedulers. Rhylthyme imports from the human-protocol layer (protocols.io, Benchling) *and* the machine layer (Opentrons .py) and turns both into a timed, resource-aware schedule a bench scientist runs — a bridge that none of the cited systems provide. Cite Tom et al. 2024 as the survey anchor.
7. **MCP is the distinctive engineering contribution, so describe it concretely.** Tool annotations (read-only/idempotent), structured output, validation-before-publish, resources and prompts. Cite the Anthropic spec (2024-11-05 revision) and note LAP (arXiv 2606.03755) as a parallel agent-to-instrument protocol in the lab world.
8. **Use the verified example corpus for figures.** `rhylthyme-examples/programs` has 49 programs; breakfast_schedule (3 tracks, 12 min) for Figure 1, and a lab example (protein_lysate_immunoblotting, ~42 h) for the "long-horizon indefinite steps" point.
9. **Self-citation.** If the author is the Leipzig of Leipzig 2017, section 2.6 naturally reads as "we previously surveyed…" — confirm with the user before wording it that way.

## Verified bibliography

Each entry was confirmed on 2026-09-08 via the linked index. BibTeX keys are
proposed.

```bibtex
@article{wilson2003gantt,
  author={Wilson, James M.}, title={Gantt charts: A centenary appreciation},
  journal={European Journal of Operational Research}, volume={149}, number={2}, pages={430--437}, year={2003},
  doi={10.1016/S0377-2217(02)00769-5}}
@inproceedings{kelley1959cpm,
  author={Kelley, James E. and Walker, Morgan R.}, title={Critical-path planning and scheduling},
  booktitle={Proc. Eastern Joint IRE-AIEE-ACM Computer Conference}, pages={160--173}, year={1959}, doi={10.1145/1460299.1460318}}
@article{malcolm1959pert,
  author={Malcolm, D. G. and Roseboom, J. H. and Clark, C. E. and Fazar, W.},
  title={Application of a technique for research and development program evaluation},
  journal={Operations Research}, volume={7}, number={5}, pages={646--669}, year={1959}, doi={10.1287/opre.7.5.646}}
@article{brucker1999rcpsp,
  author={Brucker, Peter and Drexl, Andreas and M{\"o}hring, Rolf and Neumann, Klaus and Pesch, Erwin},
  title={Resource-constrained project scheduling: Notation, classification, models, and methods},
  journal={European Journal of Operational Research}, volume={112}, number={1}, pages={3--41}, year={1999}}
@article{kolisch2001survey,
  author={Kolisch, Rainer and Padman, Rema}, title={An integrated survey of deterministic project scheduling},
  journal={Omega}, volume={29}, number={3}, pages={249--272}, year={2001}, doi={10.1016/S0305-0483(00)00046-3}}
@book{pinedo2022scheduling,
  author={Pinedo, Michael L.}, title={Scheduling: Theory, Algorithms, and Systems}, edition={6}, publisher={Springer}, year={2022},
  doi={10.1007/978-3-031-05921-6}}
@article{bertsimas1998atfm,
  author={Bertsimas, Dimitris and Stock Patterson, Sarah}, title={The air traffic flow management problem with enroute capacities},
  journal={Operations Research}, volume={46}, number={3}, pages={406--422}, year={1998}, doi={10.1287/opre.46.3.406}}
@article{ball2003groundholding,
  author={Ball, Michael O. and Hoffman, Robert and Odoni, Amedeo R. and Rifkin, Ryan},
  title={A stochastic integer program with dual network structure and its application to the ground-holding problem},
  journal={Operations Research}, volume={51}, number={1}, pages={167--171}, year={2003}}
@article{wambsganss1996cdm,
  author={Wambsganss, Michael}, title={Collaborative decision making through dynamic information transfer},
  journal={Air Traffic Control Quarterly}, volume={4}, number={2}, pages={107--123}, year={1996}, doi={10.2514/atcq.4.2.109}}
@article{allen1983intervals,
  author={Allen, James F.}, title={Maintaining knowledge about temporal intervals},
  journal={Communications of the ACM}, volume={26}, number={11}, pages={832--843}, year={1983}, doi={10.1145/182.358434}}
@article{dechter1991tcn,
  author={Dechter, Rina and Meiri, Itay and Pearl, Judea}, title={Temporal constraint networks},
  journal={Artificial Intelligence}, volume={49}, number={1--3}, pages={61--95}, year={1991}, doi={10.1016/0004-3702(91)90006-6}}
@article{vidal1999stnu,
  author={Vidal, Thierry and Fargier, H{\'e}l{\`e}ne},
  title={Handling contingency in temporal constraint networks: from consistency to controllabilities},
  journal={Journal of Experimental \& Theoretical Artificial Intelligence}, volume={11}, number={1}, pages={23--45}, year={1999}}
@inproceedings{morris2001dc,
  author={Morris, Paul and Muscettola, Nicola and Vidal, Thierry}, title={Dynamic control of plans with temporal uncertainty},
  booktitle={Proc. IJCAI}, pages={494--502}, year={2001}}
@article{gerkey2004mrta,
  author={Gerkey, Brian P. and Matari{\'c}, Maja J.}, title={A formal analysis and taxonomy of task allocation in multi-robot systems},
  journal={International Journal of Robotics Research}, volume={23}, number={9}, pages={939--954}, year={2004}, doi={10.1177/0278364904045564}}
@article{korsah2013mrta,
  author={Korsah, G. Ayorkor and Stentz, Anthony and Dias, M. Bernardine}, title={A comprehensive taxonomy for multi-robot task allocation},
  journal={International Journal of Robotics Research}, volume={32}, number={12}, pages={1495--1512}, year={2013}, doi={10.1177/0278364913496484}}
@article{gombolay2018tercio,
  author={Gombolay, Matthew C. and Wilcox, Ronald J. and Shah, Julie A.},
  title={Fast scheduling of robot teams performing tasks with temporospatial constraints},
  journal={IEEE Transactions on Robotics}, volume={34}, number={1}, pages={220--239}, year={2018}}
@book{colledanchise2018bt,
  author={Colledanchise, Michele and {\"O}gren, Petter}, title={Behavior Trees in Robotics and AI: An Introduction}, publisher={CRC Press}, year={2018}}
@article{guley1984foodservice,
  author={Guley, H. M. and Stinson, J. P.}, title={Scheduling and resource allocation in a food service system},
  journal={Journal of Operations Management}, volume={4}, number={2}, pages={129--144}, year={1984}, doi={10.1016/0272-6963(84)90028-7}}
@article{matsushima2015cooking,
  author={Matsushima, Yukiko and Funabiki, Nobuo}, title={A cooking-step scheduling algorithm with guidance system for homemade cooking},
  journal={IEICE Transactions on Information and Systems}, volume={E98-D}, number={8}, pages={1439--1448}, year={2015}, doi={10.1587/transinf.2015EDP7048}}
@article{nakabe2021cooking,
  author={Nakabe, Jin and Mizumoto, Teruhiro and Suwa, Hirohiko and Yasumoto, Keiichi},
  title={Optimal cooking procedure presentation system for multiple recipes and investigating its effect},
  journal={Algorithms}, volume={14}, number={2}, pages={67}, year={2021}, doi={10.3390/a14020067}}
@article{tom2024sdl,
  author={Tom, Gary and Schmid, Stefan P. and Baird, Sterling G. and Cao, Yang and Darvish, Kourosh and Hao, Han and Lo, Stanley and Pablo-Garc{\'i}a, Sergio and Rajaonson, Ella M. and Skreta, Marta and Yoshikawa, Naruki and Corapi, Samantha and Akkoc, Gun Deniz and Strieth-Kalthoff, Felix and Seifrid, Martin and Aspuru-Guzik, Al{\'a}n},
  title={Self-driving laboratories for chemistry and materials science},
  journal={Chemical Reviews}, volume={124}, number={16}, pages={9633--9732}, year={2024}, doi={10.1021/acs.chemrev.4c00055}}
@article{zhou2026sdlscheduling,
  author={Zhou, J. and Ge, L. and Li, X. and Guo, L. and Chen, L. and Jiang, J. and Shang, W.},
  title={Multi-task scheduling of self-driving laboratories under scientific constraints},
  journal={Chemical Science}, year={2026}, doi={10.1039/d6sc03892a}}
@misc{fehlis2025artificial,
  author={Fehlis, Yao and Mandel, Paul and Crain, Charles and Liu, Betty and Fuller, David},
  title={Accelerating drug discovery with Artificial: a whole-lab orchestration and scheduling system for self-driving labs},
  howpublished={arXiv:2504.00986}, year={2025}}
@article{wierenga2023pylabrobot,
  author={Wierenga, Rick P. and Golas, Stefan M. and Ho, Wilson and Coley, Connor W. and Esvelt, Kevin M.},
  title={PyLabRobot: An open-source, hardware-agnostic interface for liquid-handling robots and accessories},
  journal={Device}, volume={1}, number={4}, pages={100111}, year={2023}}
@article{teytelman2016protocolsio,
  author={Teytelman, Leonid and Stoliartchouk, Alexei and Kindler, Lori and Hurwitz, Bonnie L.},
  title={Protocols.io: Virtual communities for protocol development and discussion},
  journal={PLoS Biology}, volume={14}, number={8}, pages={e1002538}, year={2016}, doi={10.1371/journal.pbio.1002538}}
@misc{sila2,
  title={{SiLA} 2: The next generation lab automation standard}, howpublished={SiLA Consortium, technical note; v1.0 released 2019},
  url={https://sila-standard.com/}}
@misc{autoprotocol, title={Autoprotocol specification}, howpublished={Strateos (formerly Transcriptic)}, url={https://autoprotocol.org/}}
@misc{opentronsapi, title={Opentrons Python Protocol API, version 2}, howpublished={Opentrons Labworks}, url={https://docs.opentrons.com/v2/}}
@article{leipzig2017pipelines,
  author={Leipzig, Jeremy}, title={A review of bioinformatic pipeline frameworks},
  journal={Briefings in Bioinformatics}, volume={18}, number={3}, pages={530--536}, year={2017}, doi={10.1093/bib/bbw020}}
@article{koster2012snakemake,
  author={K{\"o}ster, Johannes and Rahmann, Sven}, title={Snakemake---a scalable bioinformatics workflow engine},
  journal={Bioinformatics}, volume={28}, number={19}, pages={2520--2522}, year={2012}, doi={10.1093/bioinformatics/bts480}}
@article{ditommaso2017nextflow,
  author={Di Tommaso, Paolo and Chatzou, Maria and Floden, Evan W. and Prieto Barja, Pablo and Palumbo, Emilio and Notredame, C{\'e}dric},
  title={Nextflow enables reproducible computational workflows},
  journal={Nature Biotechnology}, volume={35}, pages={316--319}, year={2017}, doi={10.1038/nbt.3820}}
@misc{amstutz2016cwl,
  author={Amstutz, Peter and Crusoe, Michael R. and Tijani{\'c}, Neboj{\v{s}}a and Chapman, Brad and Chilton, John and Heuer, Michael and Kartashov, Andrey and Leehr, Dan and M{\'e}nager, Herv{\'e} and Nedeljkovich, Maya and Scales, Matt and Soiland-Reyes, Stian and Stojanovic, Luka},
  title={Common Workflow Language, v1.0}, howpublished={figshare}, year={2016}, doi={10.6084/m9.figshare.3115156.v2}}
@article{crusoe2022cwl,
  author={Crusoe, Michael R. and Abeln, Sanne and Iosup, Alexandru and Amstutz, Peter and Chilton, John and Tijani{\'c}, Neboj{\v{s}}a and M{\'e}nager, Herv{\'e} and Soiland-Reyes, Stian and Gavrilovi{\'c}, Bogdan and Goble, Carole and {The CWL Community}},
  title={Methods included: Standardizing computational reuse and portability with the Common Workflow Language},
  journal={Communications of the ACM}, volume={65}, number={6}, pages={54--63}, year={2022}, doi={10.1145/3486897}}
@misc{omg2011bpmn, title={Business Process Model and Notation ({BPMN}), Version 2.0}, howpublished={Object Management Group, formal/2011-01-03}, year={2011}}
@article{hobbs2004owltime,
  author={Hobbs, Jerry R. and Pan, Feng}, title={An ontology of time for the semantic web},
  journal={ACM Transactions on Asian Language Information Processing}, volume={3}, number={1}, pages={66--85}, year={2004}}
@misc{w3c2020owltime, title={Time Ontology in {OWL}}, howpublished={W3C Candidate Recommendation, 26 March 2020}, url={https://www.w3.org/TR/2020/CR-owl-time-20200326}}
@misc{anthropic2024mcp, title={Introducing the Model Context Protocol}, author={{Anthropic}}, year={2024}, howpublished={Specification revision 2024-11-05; announcement 2024-11-25}, url={https://www.anthropic.com/news/model-context-protocol}}
```

Not yet verified and therefore **not** in the list: any Pinedo page numbers; the
LAP agent-to-instrument protocol preprint (arXiv 2606.03755) — verify before
citing; Benchling has no citable paper, cite the product URL only.

## Open questions for the author

1. Self-citation wording for 2.6 (see INSIGHT 9).
2. Author list / affiliation / license line for the title block.
3. Figures: render Figure 1 from `breakfast_schedule.json` via the existing SVG
   renderer (`static/js/timeline-render.js`)? It is deterministic and needs no
   browser.
4. Output format for the draft: Markdown here, or LaTeX (arXiv-ready) from the start?

## Next step

On approval: write `paper/rhylthyme.md` (or `.tex`) section by section against
the budget above, citing only keys in this file, then run a citation check.
