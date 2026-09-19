# arXiv submission sheet

Everything to paste into arxiv.org/submit, and why. Build the package with
`make arxiv`; it writes `arxiv/rhylthyme-arxiv.tar.gz` (upload this) and
`arxiv/rhylthyme-arxiv-preview.pdf` (what arXiv's compile should look like).

## Upload

`arxiv/rhylthyme-arxiv.tar.gz`, 316 KB: `rhylthyme.tex`, `rhylthyme.bbl`,
`eval-table.tex` and six figures. arXiv compiles the TeX itself and does not
run BibTeX, so the package carries the compiled `.bbl` and no `.bib`. The
first line of the TeX is `\pdfoutput=1` so arXiv picks pdfLaTeX. The build
target compiles the staged copy without BibTeX, exactly as arXiv will, and
fails on any undefined citation, undefined reference or missing file. Last
verified 2026-09-19: 21 pages, 82 references, text identical to
`rhylthyme.pdf`.

## Metadata

**Title**

Rhylthyme: A Declarative Language and Agent-Native Runtime for Human-Executed, Resource-Constrained Schedules

**Authors**

Jeremy Leipzig

**Abstract** (1898 characters; arXiv's limit is 1,920. Identical to the PDF's.)

Scheduling software falls into three kinds: tools that compute a plan and hand it to a person as a static artifact; engines that execute a dependency graph on machines with no person in the loop; and checklists with timers that walk a person through steps without any model of shared resources or parallel work. Rhylthyme ("real time") is built for what falls between them: capacity-constrained, multi-track schedules whose executor is a human working against a clock, with steps the executor starts and ends. We describe (i) a compact JSON language of parallel tracks, timed steps, dependency triggers, environments and resource constraints, annotated with workflow and time ontology terms; (ii) a validator, an auto-planner with several strategies, and two runtimes (a terminal runner and a web player with timeline, itinerary and dependency-graph views); and (iii) a Model Context Protocol server that exposes validation, timing analysis, catalog search, import and publication as annotated tools, so that a language-model agent authors and delivers a schedule as tool calls, not prose. On 24 expert-authored programs, a four-turn authoring prompt improves step and dependency extraction on all seven models tested, from six vendors, and raises the number that validate and match the expert's makespan and critical chain from at most 4 to between 9 and 16 on the four models that ran the full set; the prompt matters more than the model. We position the system against project scheduling, air-traffic flow management, temporal constraint networks, robot task scheduling, kitchen and laboratory schedulers, and workflow engines, arguing that its contribution is a narrow one: capacity constraints and cross-track dependencies inside a followable, human-executed timeline, one schema used across domains, and an agent interface whose validator refuses malformed programs before they are published.

**Comments**

21 pages, 6 figures, 2 tables, 3 listings. Code, gold set, evaluation harness and results: https://github.com/rhylthyme

**Primary category: cs.AI (Artificial Intelligence)**

arXiv defines cs.AI to include planning, and scheduling under resource
constraints is the paper's subject: the related work is CPM/PERT, RCPSP,
temporal constraint networks and robot task allocation, and the evaluation
is of language-model agents authoring plans against a validator (the
LLM-Modulo arrangement the paper cites). That is where readers of this work
look.

**Cross-lists: cs.HC and cs.SE**

- cs.HC (Human-Computer Interaction): the executor is a person. The timeline,
  itinerary and dependency-graph views, manual gates and the mixed-initiative
  framing are HCI content, and the kitchen and lab prior work the paper builds
  on is HCI work.
- cs.SE (Software Engineering): a declarative language with a schema, two
  validators, a runtime and an MCP server is a software-systems contribution,
  and the workflow-engine comparison is cs.SE territory.

Considered and left out, because arXiv moderators remove marginal
cross-lists and more than two invites it: cs.CL (the evaluation extracts
structure from text, but no language-modelling contribution is claimed),
cs.PL (the language is a JSON schema, not a programming-language result),
cs.RO (compared against, not contributed to).

**ACM classification** (optional field)

I.2.8; H.5.2; D.2.11; I.2.7

- I.2.8 Problem Solving, Control Methods, and Search: plan execution,
  formation and generation; scheduling
- H.5.2 User Interfaces
- D.2.11 Software Architectures: domain-specific architectures, languages
- I.2.7 Natural Language Processing: text analysis

**MSC class**: leave blank. **Report number**: leave blank.
**Journal reference / DOI**: leave blank (unpublished).

**License: CC BY 4.0**

The paper's availability paragraph already says it is released under CC BY
4.0, so the arXiv license must match. It is also the license most journals
accept for a later version of record.

## Before you press submit

1. **Endorsement.** cs.AI requires an endorsement for a first submission to
   the archive from an account without one. If arXiv asks, it gives you a
   code to send to an endorser: anyone who has submitted a few cs.AI (or
   cs.LG, cs.CL) papers in the last five years can endorse. cs.SE and cs.HC
   have the same rule, so switching primary does not avoid it. This is the
   one step that can take days; start it first.
2. **Check arXiv's own compile.** After upload, open the PDF arXiv produces
   and compare it with `arxiv/rhylthyme-arxiv-preview.pdf`: page count 21,
   Table 1 on page 5, Table 2 and Figure 6 in Section 8, no "??".
3. **Type 3 fonts.** Two vector figures (the Gantt chart and the lab
   dependency graph) embed Type 3 fonts from the SVG conversion. arXiv
   accepts these. A journal later may not; regenerate those two figures with
   text converted to paths, or through Inkscape, if one objects.
4. **Author identity.** Add your ORCID in your arXiv profile so the paper
   links to it. The PDF shows a gmail address, which becomes public and is
   scraped; change it in `rhylthyme.tex` and run `make arxiv` again if you
   would rather show another.
5. **Announcement timing.** Submissions before 14:00 US Eastern on a weekday
   are announced that evening; after that, the next day. New submissions to
   cs.AI are sometimes held a day or two for moderation.
6. **After it is announced**, add the arXiv identifier to the repositories'
   READMEs and the docs site, and to the paper's own availability paragraph
   in a v2 if you revise.

## What is deliberately not in the package

`references.bib` (the `.bbl` replaces it), `eval/` (results live in the
public repositories and are linked from the comments field), `refs/`
(downloaded papers, never redistributed), the SVG sources of the figures, the
revision plans, and `rhylthyme.pdf` itself (arXiv builds its own).
