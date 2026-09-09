# Peer Review Report — Journal-Fit Review Card

## Manuscript Information
- **Title**: Rhylthyme: A Declarative Language and Agent-Native Runtime for Real-Time, Resource-Constrained Schedules that People Follow
- **Manuscript ID**: n/a (pre-submission; `paper/rhylthyme.tex`, 37 references, one figure, one listing, one diagram, two tables)
- **Review Date**: 2026-09-08
- **Review Round**: Round 1

---

## Reviewer Information

### Reviewer Role
Journal-Fit Reviewer (internal role: EIC), seat #1 of a five-seat blind panel. I have not seen any other seat's report.

### Reviewer Identity
Senior editor for software-systems and research-tools venues (arXiv cs.SE moderation, SoftwareX/JOSS-style editorial boards); reads many descriptive systems reports and knows how they fail. (Configuration Card #1, `00_field_analysis.md`.)

### Review Focus
(1) Is the contribution claim precise and defensible for a descriptive report with no evaluation? (2) Does the paper earn its related-work breadth, or does it read as a survey with a system appended? (3) Would a general cs.SE / scheduling reader find it interesting? I care particularly about whether "new" in Section 6 is actually new and whether the absence of evaluation is honestly framed. I do not assess code-level accuracy or deep OR correctness (other seats' remits).

### Venue Binding
criteria_binding_unavailable

No target venue is confirmed. I review field-generally as an arXiv-style descriptive systems technical report and make no venue-alignment claim. Length, formatting and article-type limits of any specific venue are therefore not assessed.

---

## Overall Assessment

### Recommendation
- [ ] Accept
- [ ] Minor Revision
- [x] **Major Revision** — one round; the required changes are bounded (one new related-work paragraph, one worked agent example, per-vertical corpus evidence, and wording), but they touch the paper's "what is new" argument, so a re-read is warranted.
- [ ] Reject

### Confidence Score
**4** — Mostly within my area of expertise (systems/DSL reports, research-tool editorial standards); I am not the right seat for OR-theoretic or code-level verification and have not attempted either.

Confidence is an uncertainty/scope disclosure only; it never changes consensus counts, severity, decision bearing, or arbitration.

### Calibration Status
`NOT_CALIBRATED`

### Summary Assessment
The paper describes Rhylthyme, a JSON language plus validator, heuristic planner, two runtimes and an MCP server for multi-track, resource-constrained schedules whose executor is a person, and positions it against six scheduling and workflow traditions. It is explicitly a descriptive systems report with no evaluation, and it says so plainly in the Introduction and structures its Discussion as borrows / omits / new. As a piece of technical writing it is unusually disciplined: short, concrete, every related-work lens ends by mapping onto a named Rhylthyme construct, and the Limitations section admits things most authors hide (four corpus programs fail the validator; login is a pasted token; no formal semantics). The core weakness is that the novelty argument rests on a comparison set chosen from the *optimization* and *machine-execution* traditions, while the tools nearest to the "person-as-executor live runtime" leg — step-through protocol runners, guided-cooking timers, show-control and cue-calling software, interval timers — are absent, so the reader cannot tell whether that leg is new or merely re-implemented. Second, the title's "agent-native" claim is described but never once shown: no agent-authored program, no transcript, no illustrative tool-call exchange. Third, the "one schema, four verticals" leg is asserted with a single kitchen example. All three are repairable within one revision, and the underlying report is worth publishing; hence Major Revision rather than Minor.

---

## Criterion-Bound Judgements

Calibration status: `NOT_CALIBRATED`. Judgements are local to each criterion; do not total, weight, or map mechanically to the recommendation.

| Dimension | Criterion source | Judgement | Evidence anchor(s) | Rationale | Uncertainty / scope limit | Decision bearing? |
|---|---|---|---|---|---|---|
| Originality | `review_criteria_framework.md` §1; Card #1 focus (1) | PARTLY_MEETS | text: §6 "What is \emph{new} is the combination of three things none of the compared systems has together"; absence: §2/§6 — expected comparison to human step-through runtimes; checked §2.1–2.6, Table 2, §6, §7 | The combination claim is precise and honestly scoped, but its truth depends on the comparison set, which omits the systems closest to the runtime leg. | I have not audited every consumer product; the gap is in what the paper confronts, not a claim that a specific competitor is identical. | yes — this is the paper's contribution claim |
| Methodological Rigor | framework §1 | NOT_ASSESSED | — | Descriptive report with no evaluation by design; verification of §3–5 against the artifact is Reviewer 1's remit. | Outside this seat. | no |
| Evidence Sufficiency | framework §1; §2.2 (conceptual paper: argument logic) | PARTLY_MEETS | absence: §5 — expected one worked agent-authoring example; checked §1, §5, Fig. 2, §6, §8; absence: §3/§6 — expected a non-kitchen program or per-vertical corpus counts; checked §3, Fig. 1, Listing 1, §4, §6, §7 | For a descriptive report, the evidence standard is "show me the thing you describe." The language and runtime legs are shown (Fig. 1, Listing 1, §4); the agent leg and cross-vertical leg are asserted only. | The artifacts may well exist in the repository; the deficit is in the manuscript. | yes |
| Argument Coherence | framework §1 | MEETS | text: §1 "This is a descriptive systems report. We make no optimality claims" ; section: §6 | Title → abstract → contributions list → §6 borrows/omits/new → §7 form one traceable line; no over-promising in the framing itself. One conclusion sentence over-reaches (W5). | none identified beyond W5 | no (W5 is Minor) |
| Writing Quality | framework §1 | EXCEEDS | section: §2–§5; text: §8 "a person, a clock, several things happening at once, and not enough ovens" | Dense, concrete, free of padding; each related-work paragraph closes on a Rhylthyme construct; technical vocabulary used with care. | none identified | no |
| Literature Integration | framework §1; Card #1 focus (2) | PARTLY_MEETS | section: §2.3; table: Table 2 — "Agent interface" row, cell "emerging" (uncited); absence as in Originality row | Breadth is mostly earned: §2.2, §2.4, §2.5, §2.6 each pay for themselves with a mapping. §2.3 (ATC) contributes little beyond what §2.2 already gives. The human-runtime tool family is missing. All 37 bib entries are cited; entries look like genuine primary sources. | Detailed accuracy of the OR and lab-automation citations is Reviewers 2/3's remit. | yes (via Originality) |
| Significance & Impact | framework §1; Card #1 focus (3) | MEETS | text: §5 "moves the burden of correctness from the model's text to the tool contract" ; section: §6 | A general cs.SE reader would find the "person as executor" framing, the STNU reading of indefinite steps, and the validate-before-publish tool contract interesting; the MCP design section is the part most likely to be cited. Impact is capped by the absence of any usage or example evidence, which the paper acknowledges. | Interest is a judgement, not a measurement. | no |

---

## Strengths

### S1: The absence of evaluation is honestly framed and the contribution is scoped to match
The paper says up front what it is and is not, and the Discussion is organised as borrows / omits / new rather than as a list of features. This is exactly how a descriptive report should protect itself from over-claiming, and it is rarer than it should be.
**Evidence Anchor**: text: §1 "This is a descriptive systems report. We make no optimality claims"

### S2: Related-work breadth is (mostly) earned by construct-level mappings
Each lens ends by naming the Rhylthyme construct it explains: tracks as unary and `resourceConstraints` as cumulative resources (§2.2); triggers as Allen relations and indefinite steps plus negative offsets as contingent links (§2.4); `afterStep` with zero offset as the human analogue of zero-gap synchronisation (§2.5); classification on the author's own pipeline-framework axes (§2.6). This is what distinguishes positioning from survey.
**Evidence Anchor**: text: §2.2 "a \rt{} track is a unary resource (one pair of hands at one station"

### S3: The MCP section describes a real design, not a wrapper
Tool annotations, structured output, validate-before-publish, coded findings with fix hints, resources and a prompt are described concretely enough that a reader could reproduce the design decisions, and the rationale ("act on the message verbatim") is the right one for an LLM caller.
**Evidence Anchor**: text: §4 "which turns out to matter when the author is a language model that will act on the message verbatim"

### S4: Candid Limitations section
The section reports negative facts about the authors' own artifact (validator failures in the public corpus, pasted-token login, no formal semantics) and converts them into well-posed future work (dynamic controllability, Tercio-style assignment).
**Evidence Anchor**: text: §7 "Four example programs in the public corpus fail the validator because of genuine within-track overlaps"

### S5: Writing quality and length discipline
Nine pages, one figure, one listing, one diagram, two tables, no filler. The Introduction's opening paragraph states the problem in one sentence a non-specialist can follow, and the Conclusion is four sentences.
**Evidence Anchor**: section: §1, §8

### S6: Bibliography is complete and appears to be primary-source
All 37 entries in `references.bib` are cited in the text; the entries carry DOIs or publisher identifiers and mix foundational (Kelley & Walker 1959, Allen 1983) with current (Tom et al. 2024, Zhou et al. 2026) sources. (Accuracy of individual citations is the domain seats' remit.)
**Evidence Anchor**: dataset: references.bib — 37 entries, 37 distinct keys cited in rhylthyme.tex

---

## Weaknesses

### W1: The novelty claim is only as strong as a comparison set that omits the nearest human-runtime tools
**Problem**: Section 6 claims that no compared system combines a person-as-executor runtime, a cross-domain schema and an agent interface. But every column of Table 2 is drawn from the optimisation or machine-execution traditions. The family of tools closest to the *runtime* leg is not confronted anywhere: step-through protocol runners (to my knowledge protocols.io itself offers a "run" mode with per-step timers, and it is cited only as an import source), guided-cooking applications with multi-recipe timers, show-control and cue-calling software used by the stage managers §1 invokes, and interval-timer applications for the gym vertical. The event and gym verticals have no related work at all.
**Evidence Anchor**: absence: §2 and §6 — expected a comparison to human step-through runtimes (protocol run modes, guided-cooking timers, show-control/cue-calling, interval timers); checked §2.1–2.6, Table 2, §6, §7
**Why it matters**: The Introduction's dichotomy (offline plan vs. machine execution) is the premise of the whole paper. If live, human-followed runtimes already exist in each vertical, the premise is false as stated and the novelty narrows to the schema-plus-agent-interface combination. The core survives, but the argument must be re-cut.
**Suggestion**: Add a short §2.7 (or extend §2.5) on human-followed runtimes, one paragraph, and add a column or row to Table 2. State precisely what those tools lack (typically: a portable schema, resource capacity, cross-track dependencies, an agent interface) rather than ignoring them. Re-word the §1 dichotomy to "either … or … or plays a single procedure with timers."
**Severity**: Major
**Confidence**: 4 — core expertise: systems positioning; I have not audited individual products' feature sets, and the finding is about what the manuscript confronts.

### W2: "Agent-native" is the title's headline claim and is never shown
**Problem**: Section 5 describes the tool surface well, and the "Why this matters" paragraph asserts that the design changes LLM behaviour, but the manuscript contains no agent-authored program, no transcript, no example of a validator finding being acted on, and no example of `analyze_schedule` answering "when do I start." Figure 2 is the *intended* interaction, as its caption says.
**Evidence Anchor**: absence: §5 — expected one worked example of an agent authoring, validating and publishing a program via the tools; checked §1, §5 (all paragraphs), Fig. 2, §6, §8
**Why it matters**: A descriptive report's minimal evidence standard is a demonstration of the thing described. The language leg gets Listing 1 and Fig. 1; the runtime leg gets §4; the agent leg gets prose. The "practical failure mode of an LLM … is a wall of prose" claim is stated as fact without even an anecdote, which sits uneasily with the paper's otherwise careful no-evaluation stance.
**Suggestion**: Add one boxed example (half a page): a `plan_schedule` prompt, the invalid program the agent first produced, the coded findings with fix hints, the corrected program, and the `analyze_schedule` wall-clock answer. Hedge the "practical failure mode" sentence as the authors' experience, or drop it. No evaluation is required; one honest illustration is.
**Severity**: Major
**Confidence**: 4 — core expertise: evaluating systems-report evidence standards.

### W3: "One schema reused unchanged across four verticals" is asserted with a single kitchen example
**Problem**: The cross-domain leg of the novelty claim appears in the abstract, §1, §5, §6, Table 2 and §8, but the only program shown is `breakfast_schedule`; no laboratory, event or gym program is exhibited, and the 49-program corpus is never broken down by vertical. The reader cannot tell whether "reused unchanged" means the event and gym verticals have substantive programs or merely an `environmentType` value.
**Evidence Anchor**: text: §6 "a single schema reused unchanged across cooking, laboratory, event and training verticals"
**Why it matters**: It is one of the three legs on which "new" stands. As written it is an enumeration, not evidence.
**Suggestion**: Add a small table: corpus programs per vertical, with track/step counts and makespan range, and one short listing from a non-kitchen vertical (the PLAN mentions a ~42 h immunoblotting protocol, which would also illustrate long-horizon indefinite steps). This is a modest addition that converts an assertion into a checkable claim.
**Severity**: Major
**Confidence**: 3 — adjacent field for the verticals; the corpus may already support the claim, but the manuscript does not show it.

### W4: The ATC lens contributes little that RCPSP does not already give
**Problem**: Section 2.3's two "transferring" ideas are a capacity cap on concurrent occupancy (already the cumulative-resource notion of §2.2) and the CDM premise of a shared live plan, which the section itself says operates "on a very different scale and with no optimization layer." The lens is enjoyable but does not inform any design decision described in §3–§5, and its Table 2 column mostly repeats the RCPSP column with different nouns.
**Evidence Anchor**: text: §2.3 "on a very different scale and with no optimization layer"
**Why it matters**: This is the one place where the paper reads as a survey with a system appended (Card #1 focus 2). It costs space that W1's missing lens needs.
**Suggestion**: Compress §2.3 to two sentences inside §2.2, or keep it only if a concrete design borrowing (e.g. time-windowed capacity) is added to the model.
**Severity**: Minor
**Confidence**: 4 — core expertise: related-work editing.

### W5: The Conclusion over-states what the tool contract refuses
**Problem**: §8 says the MCP tool contract "refuses to publish what will not work." By §4, validation rejects structural errors and within-track overlaps; resource over-capacity is reported by the planner and analyzer as bottlenecks and conflict windows, not rejected. A program that exceeds `maxConcurrent` therefore appears to be publishable.
**Evidence Anchor**: text: §8 "a tool contract that refuses to publish what will not work"
**Why it matters**: It is the final sentence of the paper and the one a skimming reader will remember; it promises more than §4 delivers.
**Suggestion**: "refuses to publish what is structurally invalid, and says where the resource pressure is" — or make `visualize_schedule` refuse on resource conflicts and say so in §5.
**Severity**: Minor
**Confidence**: 4 — inference from the manuscript's own §4/§5 description; the domain seats can confirm against code.

### W6: Availability statement is not version-pinned
**Problem**: The only quasi-empirical statements in the paper (49-program corpus; two validators agree; four programs fail) and the availability paragraph point at a GitHub organisation and a live endpoint with no tag, commit, release, or archival DOI, and no date. The schema version "0.2.0-alpha at the time of writing" is the only pin.
**Evidence Anchor**: text: §8 "open source at \url{https://github.com/rhylthyme}; the remote server is at \url{https://mcp.rhylthyme.com/mcp}"
**Why it matters**: For a report whose value is the artifact, a reader in 2028 must be able to find the version described. Also, "agree on the corpus of 49" and "four fail" should be reconciled in one sentence (presumably both validators flag the same four).
**Suggestion**: Cite a tagged release or Zenodo DOI; state the corpus size, date and the four failing programs' identifiers in one place.
**Severity**: Minor
**Confidence**: 4 — core expertise: research-software editorial standards.

### W7: Uncited "emerging" cell and an internal count mismatch
**Problem**: Table 2's "Agent interface" row marks lab-automation orchestrators as "emerging" with no citation, while every other cell in §2 is backed by a reference. Separately, §1 says the MCP server is instantiated "at four vertical endpoints" while §5 lists five paths (`/mcp` plus four verticals), described as "instantiated four times."
**Evidence Anchor**: table: Table 2 — "Agent interface" row, "Lab automation orchestrators" column, cell "emerging"
**Why it matters**: Small, but both are in the positioning surface a skeptical reader inspects first.
**Suggestion**: Cite whatever "emerging" refers to (the PLAN mentions a lab agent-protocol preprint; verify it before citing) or change the cell to "none cited." Fix the four/five count.
**Severity**: Minor
**Confidence**: 4 — direct reading.

---

## Detailed Comments

### Journal Fit
- No venue is bound (`criteria_binding_unavailable`), so this is a field-general fit assessment. As an arXiv cs.SE technical report the manuscript is well within genre norms: a system description with positioning, honest scope, open-source artifact. If the authors later target a peer-reviewed research-software venue (JOSS/SoftwareX-style), W6 (version pinning) becomes mandatory and the absence of any usage evidence will be raised; if they target a DSL or HCI venue, W1 and W2 will be the first objections. If they target a scheduling/OR venue, the paper would be out of scope: it makes no algorithmic contribution and says so.
- A general cs.SE reader would find the piece readable end-to-end; the temporal-reasoning reader gets the STNU framing; the LLM-tooling reader gets §5. The audience most likely to cite it is builders of MCP tool surfaces for domain DSLs.

### Originality
- The source of originality is a *new combination* (runtime for a human executor + cross-domain schema + agent interface), stated exactly that way in §6, which is the correct and defensible framing. Two of the three legs are not evidenced in the manuscript (W2, W3), and the combination claim is made against a comparison set that omits the nearest neighbours to the first leg (W1). The language itself is a modest DSL over well-known concepts; the paper does not pretend otherwise.

### Significance
- If the claims hold, the impact is local to sub-fields (human-followed process tooling; LLM tool design) rather than discipline-wide. The timely part is §5: a concrete, reasoned design for validate-before-publish tool contracts. The lasting part may be the observation that indefinite steps plus negative offsets make ordinary cooking schedules STNUs; that is the sentence a scheduling reader will quote.

### Structural Coherence
- Title → abstract → contribution list → §6 borrows/omits/new → §7 are consistent. The research question ("what fills the gap between offline plan and machine execution?") is answered by the system description. The one over-promise is the Conclusion's final clause (W5). Section ordering is sensible; §5 could precede §4's Importers paragraph without loss, but this is taste.

### Title & Abstract
- The title is long but accurate; "that People Follow" is the paper's thesis in three words and should stay. "Agent-Native" is earned by §5's design but not by any shown example (W2).
- The abstract is structured (problem, three contributions, positioning, contribution-claim) and honest. It could name the STNU observation, which is the most quotable technical point.

### Conclusion
- Four sentences, no new claims except the over-reach in W5. The Availability paragraph belongs here but needs pinning (W6).

### References
- All 37 entries cited; mix of foundational and current; no citation of any human-runtime tool family (W1) and no citation for "emerging" (W7).

---

## Questions for Authors
1. Does protocols.io's own step-through run mode (or any guided-cooking, show-control or interval-timer application) already provide a live, human-followed runtime for a single procedure? If so, what specifically does Rhylthyme add over it, and can that be stated in §2/§6?
2. Has any program in the public catalog been authored end-to-end by an LLM agent through the MCP server? If yes, can one such exchange (prompt, first invalid attempt, coded findings, corrected program, wall-clock answer) be included as a boxed example?
3. How do the 49 corpus programs distribute across the kitchen, laboratory, event and gym verticals, and what do the event and gym programs look like structurally (tracks, indefinite steps, choices)?
4. Does `visualize_schedule` refuse a program whose planner run shows demand exceeding `maxConcurrent`, or only structurally invalid programs? The answer determines how §8 should be worded.
5. Which venue is intended? The revision priorities differ materially between an arXiv report, a research-software journal, and a DSL/HCI venue.

---

## Minor Issues

### Language / Grammar
- §5, first paragraph: "instantiated four times, at `/mcp`, `/kitchen/mcp`, `/lab/mcp`, `/events/mcp` and `/gym/mcp`" lists five paths; reconcile with §1 "four vertical endpoints."
- §4, Validation: "which turns out to matter" — the claim is fine but "turns out" implies observation; consider "matters" unless an observation is added (see W2).
- §2.5: "a bench scientist runs by hand" — "runs" vs. "follows"; the paper elsewhere uses "follow" for the human executor.

### Citation Format
- Table 2 cell "emerging" is uncited (W7).
- `sila2`, `autoprotocol`, `opentronsapi`, `w3c2020owltime`, `anthropic2024mcp`: add access dates consistently (some have them, some do not).

### Figures and Tables
- Figure 1 caption gives "11.5 min"; consider stating the same figure in seconds or the same unit as Listing 1 for consistency.
- Figure 2 caption says the workflow is what the server's `instructions` "describe"; label the figure "intended interaction" in the body text as well, or replace it with an observed trace (W2).
- Table 2 would benefit from a "Human-followed runtimes" column if W1 is addressed.

### Layout
- None affecting reading; the two-table, one-figure, one-listing budget is appropriate for the length.
