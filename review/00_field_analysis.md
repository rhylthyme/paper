# Field Analysis Report (Phase 0)

**Manuscript**: Rhylthyme: A Declarative Language and Agent-Native Runtime for Real-Time, Resource-Constrained Schedules that People Follow (paper/rhylthyme.tex, 9 pp, 37 refs)

| Dimension | Finding |
|---|---|
| Primary discipline | Software systems / domain-specific languages (cs.SE) |
| Secondary disciplines | Operations research (scheduling), temporal reasoning (AI), human-computer interaction, laboratory automation |
| Research paradigm | Theoretical/conceptual + descriptive systems report |
| Methodology type | System description with comparative positioning; no empirical evaluation by design |
| Target venue | `criteria_binding_unavailable` — author states arXiv-style technical report; field-general review only, no venue-fit claim |
| Paper maturity | Pre-submission: complete structure, verified bibliography, compiled PDF with figures and tables |

### Reviewer Configuration Card #1
**Role**: EIC — **Display role**: Journal-Fit Reviewer
**Identity**: Senior editor for software-systems and research-tools venues (arXiv cs.SE moderation, SoftwareX/JOSS-style editorial boards); reads many descriptive systems reports and knows how they fail.
**Review Focus**: (1) Is the contribution claim precise and defensible for a descriptive report with no evaluation? (2) Does the paper earn its related-work breadth or does it read as a survey with a system appended? (3) Would a general cs.SE / scheduling reader find it interesting?
**Will particularly care about**: whether "new" in Section 6 is actually new, and whether the absence of evaluation is honestly framed.
**Possible blind spots**: deep OR correctness; code-level accuracy.

### Reviewer Configuration Card #2
**Role**: Peer Reviewer 1 — Methodology
**Identity**: Systems-research methodologist specializing in evaluation of software artifacts and DSLs; expects every descriptive claim about a system to be checkable against the artifact.
**Review Focus**: (1) Verify Sections 3–5 against the code in the monorepo (schema, validator, planner, runners, MCP server). (2) Reproducibility and availability claims. (3) Whether descriptive claims are hedged appropriately given no evaluation.
**Will particularly care about**: any statement the code does not support.
**Possible blind spots**: literature completeness.

### Reviewer Configuration Card #3
**Role**: Peer Reviewer 2 — Domain
**Identity**: Scheduling and temporal-reasoning scholar (RCPSP, machine scheduling, STN/STNU, Allen algebra) with an operations-research background.
**Review Focus**: (1) Correctness of the mappings to Allen relations, STN/STNU and RCPSP notation. (2) Literature coverage and accuracy across Section 2. (3) Whether the claimed gap ("person as executor") is genuinely unoccupied.
**Will particularly care about**: sloppy use of "critical path", "controllability", "unary/cumulative resource".
**Possible blind spots**: LLM/agent tooling; lab automation practice.

### Reviewer Configuration Card #4
**Role**: Peer Reviewer 3 — Perspective
**Identity**: Practitioner-researcher spanning bioinformatics workflow engineering, laboratory automation (SDLs, SiLA/Autoprotocol) and LLM tool-use; builds MCP integrations.
**Review Focus**: (1) Accuracy of the lab-automation landscape and workflow-engine comparison. (2) Whether the MCP contribution is substantive or incidental. (3) Practical impact and overlooked assumptions (multi-person execution, failure modes, safety).
**Will particularly care about**: whether the positioning table's cells are fair to the compared systems.
**Possible blind spots**: OR theory.

Fifth seat: fixed Devil's Advocate (no card).
