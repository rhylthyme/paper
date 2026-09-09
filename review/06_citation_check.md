# Citation Error Report — `paper/rhylthyme.tex` / `paper/references.bib`

Mode: academic-paper `citation-check` (citation_compliance_agent persona). Date: 2026-09-08.
Scope: 37 BibTeX entries, 37 distinct keys cited (56 `\cite` occurrences), natbib `plainnat` numeric.
Manuscript and bib were read only; nothing was modified. All corrections below are proposals.

Verification sources: Crossref REST API (`api.crossref.org/works/<DOI>`), Semantic Scholar Graph API, PubMed/PMC E-utilities, arXiv API, figshare API, dblp, and direct HTTP checks of every URL-only source. Publisher landing pages (INFORMS, ScienceDirect, IEEE, RSC) return 403 to automated fetches, so metadata was confirmed through the indexer records for the same DOI, which are populated from the publisher deposit.

## Summary

| Metric | Count |
|---|---|
| Bib entries | 37 |
| Distinct keys cited in text | 37 |
| Orphan in-text keys (cited, not in bib) | 0 |
| Orphan bib entries (never cited) | 0 |
| OK | 20 |
| FIX | 16 |
| UNVERIFIED | 1 |
| Missing DOIs where one exists | 9 (brucker, vidal, ball, gombolay, wierenga, hobbs, colledanchise, fehlis, +issue for ditommaso) |
| Wrong page range | 1 (wambsganss) |
| In-text mischaracterizations | 0 major; 2 minor wording cautions |
| Self-citation ratio | 1/37 = 2.7% |

## Summary table

| key | status | issue | evidence URL |
|---|---|---|---|
| wilson2003gantt | OK | all fields match (EJOR 149(2):430–437, 2003) | https://api.crossref.org/works/10.1016/S0377-2217(02)00769-5 |
| kelley1959cpm | OK | pages 160–173 and DOI confirmed; booktitle is an acceptable short form | https://api.crossref.org/works/10.1145/1460299.1460318 |
| malcolm1959pert | OK | Oper. Res. 7(5):646–669, 1959 confirmed | https://api.crossref.org/works/10.1287/opre.7.5.646 |
| brucker1999rcpsp | FIX | DOI missing; exists: 10.1016/S0377-2217(98)00204-5 | https://api.crossref.org/works/10.1016/S0377-2217(98)00204-5 |
| kolisch2001survey | OK | Omega 29(3):249–272 confirmed | https://api.crossref.org/works/10.1016/S0305-0483(00)00046-3 |
| pinedo2022scheduling | FIX (format) | DOI/edition/year confirmed; `edition={6}` renders as "6 edition" in plainnat; use `edition={Sixth}`; add `address={Cham}` | https://api.crossref.org/works/10.1007/978-3-031-05921-6 |
| bertsimas1998atfm | OK | Oper. Res. 46(3):406–422; author "Stock Patterson, Sarah" correct | https://api.crossref.org/works/10.1287/opre.46.3.406 |
| ball2003groundholding | FIX | DOI missing; exists: 10.1287/opre.51.1.167.12795; vol/issue/pages (51(1):167–171) confirmed | https://api.crossref.org/works/10.1287/opre.51.1.167.12795 |
| wambsganss1996cdm | FIX | **pages wrong**: bib says 107–123; Crossref and Semantic Scholar give 109–125 (the DOI suffix `.4.2.109` itself encodes first page 109) | https://api.crossref.org/works/10.2514/atcq.4.2.109 |
| allen1983intervals | OK | CACM 26(11):832–843 confirmed | https://api.crossref.org/works/10.1145/182.358434 |
| dechter1991tcn | OK | AIJ 49(1–3):61–95 confirmed | https://api.crossref.org/works/10.1016/0004-3702(91)90006-6 |
| vidal1999stnu | FIX | DOI missing; exists: 10.1080/095281399146607. JETAI 11(1):23–45 confirmed. Crossref deposit lists only Vidal; Semantic Scholar/dblp (journals/jetai/VidalF99) confirm Vidal and Fargier — keep both authors | https://api.semanticscholar.org/graph/v1/paper/DOI:10.1080/095281399146607?fields=title,authors,year |
| morris2001dc | FIX (minor) | pages 494–502 confirmed; `booktitle={Proc. IJCAI}` should be expanded (IJCAI-01, Seattle, Aug 2001) for consistency with other entries | https://www.researchgate.net/publication/2866300_Dynamic_Control_Of_Plans_With_Temporal_Uncertainty ; dblp conf/ijcai/MorrisMV01 |
| gerkey2004mrta | OK | **pages 939–954 confirmed** (IJRR 23(9), Sept 2004); DOI confirmed | https://api.crossref.org/works/10.1177/0278364904045564 |
| korsah2013mrta | OK | **issue 12 confirmed** (IJRR 32(12):1495–1512, Oct 2013) | https://api.crossref.org/works/10.1177/0278364913496484 |
| gombolay2018tercio | FIX | DOI missing; exists: 10.1109/TRO.2018.2795034; T-RO 34(1):220–239, Feb 2018 confirmed | https://api.crossref.org/works/10.1109/TRO.2018.2795034 |
| colledanchise2018bt | FIX | DOI missing; exists: 10.1201/9780429489105 (CRC Press, 2018) | https://api.crossref.org/works/10.1201/9780429489105 |
| guley1984foodservice | OK | JOM 4(2):129–144, 1984; given names are Helen M. Guley and Joel P. Stinson (initials acceptable) | https://api.crossref.org/works/10.1016/0272-6963(84)90028-7 |
| matsushima2015cooking | OK | IEICE Trans. Inf. Syst. E98-D(8):1439–1448 confirmed (J-STAGE writes vol. "E98.D"; IEICE house style is "E98-D") | https://www.jstage.jst.go.jp/article/transinf/E98.D/8/E98.D_2015EDP7048/_article |
| nakabe2021cooking | OK | Algorithms 14(2):67, 2021 confirmed | https://api.crossref.org/works/10.3390/a14020067 |
| tom2024sdl | OK | Chem. Rev. 124(16):9633–9732; all 16 authors match Crossref exactly | https://api.crossref.org/works/10.1021/acs.chemrev.4c00055 |
| zhou2026sdlscheduling | FIX | exists (Chem. Sci., DOI 10.1039/d6sc03892a, published online 4 Aug 2026, PMID 42583255, PMC13459762). **Authors given as initials only**; full names: Junyi Zhou, Luyao Ge, Xiaobo Li, Lulu Guo, Linjiang Chen, Jun Jiang, Weiwei Shang. No volume/issue/pages assigned yet (advance article) — add `note={Advance article, published 4 August 2026}` | https://api.crossref.org/works/10.1039/d6sc03892a ; https://pubmed.ncbi.nlm.nih.gov/42583255/ ; https://pmc.ncbi.nlm.nih.gov/articles/PMC13459762/ |
| fehlis2025artificial | FIX (minor) | exists; authors/title confirmed (arXiv 2504.00986, 2025). Add DOI 10.48550/arXiv.2504.00986 and `eprint`/`archivePrefix` for consistency with amstutz2016cwl, which carries a DOI | https://api.semanticscholar.org/graph/v1/paper/ARXIV:2504.00986?fields=title,authors,year,externalIds |
| wierenga2023pylabrobot | FIX | DOI missing; exists: 10.1016/j.device.2023.100111. Device 1(4):100111, Oct 2023; **author list (Wierenga, Golas, Ho, Coley, Esvelt) confirmed complete and in order** | https://api.crossref.org/works/10.1016/j.device.2023.100111 |
| teytelman2016protocolsio | OK | PLOS Biology 14(8):e1002538 confirmed | https://api.crossref.org/works/10.1371/journal.pbio.1002538 |
| sila2 | FIX (descriptor) | URL live (HTTP 200). Year 2019 is right for SiLA 2 v1.0 (Part C v1.0 released 30 Sept 2019). But "Technical note" misdescribes a multi-part standard specification, and the URL is the consortium home page rather than the standard | https://sila-standard.com/standards/ ; https://sila-standard.com/wp-content/uploads/2022/03/SiLA-2-Part-C-Standard-Features-Index-v1.0.pdf |
| autoprotocol | UNVERIFIED | `https://autoprotocol.org/` fails TLS (certificate expired; curl error 60); plain HTTP returns 200 from S3. Descriptor "Strateos (formerly Transcriptic)" is accurate. Year `2023` could not be tied to any dated version of the spec (the spec page is undated) | https://developers.strateos.com/docs/autoprotocol ; http://autoprotocol.org/specification/ |
| opentronsapi | FIX (URL) | `https://docs.opentrons.com/v2/` now 301-redirects to `https://docs.opentrons.com/python-api/`; cite the canonical URL. Descriptor accurate | https://docs.opentrons.com/python-api/ |
| leipzig2017pipelines | OK | Brief. Bioinform. 18(3):530–536, 2017 confirmed via PubMed (PMID 27013646); Crossref carries the March 2016 online-first record (pages "bbw020"), so the print citation used here is the right one. Author confirmed = manuscript author | https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=pubmed&id=27013646&retmode=json |
| koster2012snakemake | OK | Bioinformatics 28(19):2520–2522 confirmed | https://api.crossref.org/works/10.1093/bioinformatics/bts480 |
| ditommaso2017nextflow | FIX (minor) | issue number missing: Nat. Biotechnol. 35(**4**):316–319 | https://api.crossref.org/works/10.1038/nbt.3820 |
| amstutz2016cwl | OK | figshare record 3115156 v2, DOI and all 13 authors match | https://api.figshare.com/v2/articles/3115156 |
| crusoe2022cwl | OK | CACM 65(6):54–63; author list incl. "The CWL Community" matches | https://api.crossref.org/works/10.1145/3486897 |
| omg2011bpmn | FIX (minor) | document exists; OMG site lists it as `formal/11-01-03` (the PDF cover prints `formal/2011-01-03`, so either form is defensible). No URL given — add the canonical spec URL | https://www.omg.org/spec/BPMN/2.0/ |
| hobbs2004owltime | FIX | DOI missing; exists: 10.1145/1017068.1017073; TALIP 3(1):66–85, 2004 confirmed | https://api.crossref.org/works/10.1145/1017068.1017073 |
| w3c2020owltime | OK | URL live, page title "Time Ontology in OWL", status "W3C Candidate Recommendation" 26 March 2020 confirmed. Note: superseded by a Candidate Recommendation Draft of 15 Nov 2022 at https://www.w3.org/TR/owl-time/ — citing the dated 2020 CR is still correct as long as that is the version whose terms the schema uses | https://www.w3.org/TR/2020/CR-owl-time-20200326/ |
| anthropic2024mcp | OK | URL live; announcement dated Nov 25, 2024 confirmed; spec revision `2024-11-05` exists at modelcontextprotocol.io | https://www.anthropic.com/news/model-context-protocol ; https://modelcontextprotocol.io/specification/2024-11-05 |

## Corrected BibTeX for FIX / UNVERIFIED items

```bibtex
@article{brucker1999rcpsp,
  author={Brucker, Peter and Drexl, Andreas and M{\"o}hring, Rolf and Neumann, Klaus and Pesch, Erwin},
  title={Resource-constrained project scheduling: Notation, classification, models, and methods},
  journal={European Journal of Operational Research}, volume={112}, number={1}, pages={3--41}, year={1999},
  doi={10.1016/S0377-2217(98)00204-5}}

@book{pinedo2022scheduling,
  author={Pinedo, Michael L.}, title={Scheduling: Theory, Algorithms, and Systems}, edition={Sixth},
  publisher={Springer}, address={Cham}, year={2022}, doi={10.1007/978-3-031-05921-6}}

@article{ball2003groundholding,
  author={Ball, Michael O. and Hoffman, Robert and Odoni, Amedeo R. and Rifkin, Ryan},
  title={A stochastic integer program with dual network structure and its application to the ground-holding problem},
  journal={Operations Research}, volume={51}, number={1}, pages={167--171}, year={2003},
  doi={10.1287/opre.51.1.167.12795}}

@article{wambsganss1996cdm,
  author={Wambsganss, Michael}, title={Collaborative decision making through dynamic information transfer},
  journal={Air Traffic Control Quarterly}, volume={4}, number={2}, pages={109--125}, year={1996},
  doi={10.2514/atcq.4.2.109}}

@article{vidal1999stnu,
  author={Vidal, Thierry and Fargier, H{\'e}l{\`e}ne},
  title={Handling contingency in temporal constraint networks: from consistency to controllabilities},
  journal={Journal of Experimental \& Theoretical Artificial Intelligence}, volume={11}, number={1}, pages={23--45}, year={1999},
  doi={10.1080/095281399146607}}

@inproceedings{morris2001dc,
  author={Morris, Paul and Muscettola, Nicola and Vidal, Thierry},
  title={Dynamic control of plans with temporal uncertainty},
  booktitle={Proceedings of the 17th International Joint Conference on Artificial Intelligence ({IJCAI}-01)},
  address={Seattle, WA}, pages={494--502}, year={2001}}

@article{gombolay2018tercio,
  author={Gombolay, Matthew C. and Wilcox, Ronald J. and Shah, Julie A.},
  title={Fast scheduling of robot teams performing tasks with temporospatial constraints},
  journal={IEEE Transactions on Robotics}, volume={34}, number={1}, pages={220--239}, year={2018},
  doi={10.1109/TRO.2018.2795034}}

@book{colledanchise2018bt,
  author={Colledanchise, Michele and {\"O}gren, Petter},
  title={Behavior Trees in Robotics and {AI}: An Introduction},
  publisher={CRC Press}, address={Boca Raton, FL}, year={2018}, doi={10.1201/9780429489105}}

@article{zhou2026sdlscheduling,
  author={Zhou, Junyi and Ge, Luyao and Li, Xiaobo and Guo, Lulu and Chen, Linjiang and Jiang, Jun and Shang, Weiwei},
  title={Multi-task scheduling of self-driving laboratories under scientific constraints},
  journal={Chemical Science}, year={2026}, doi={10.1039/d6sc03892a},
  note={Advance article, published online 4 August 2026}}

@misc{fehlis2025artificial,
  author={Fehlis, Yao and Mandel, Paul and Crain, Charles and Liu, Betty and Fuller, David},
  title={Accelerating drug discovery with {Artificial}: a whole-lab orchestration and scheduling system for self-driving labs},
  howpublished={arXiv:2504.00986}, eprint={2504.00986}, archivePrefix={arXiv}, year={2025},
  doi={10.48550/arXiv.2504.00986}}

@article{wierenga2023pylabrobot,
  author={Wierenga, Rick P. and Golas, Stefan M. and Ho, Wilson and Coley, Connor W. and Esvelt, Kevin M.},
  title={{PyLabRobot}: An open-source, hardware-agnostic interface for liquid-handling robots and accessories},
  journal={Device}, volume={1}, number={4}, pages={100111}, year={2023},
  doi={10.1016/j.device.2023.100111}}

@misc{sila2,
  author={{SiLA Consortium}}, year={2019},
  title={{SiLA} 2 standard, version 1.0 (Parts A--C)},
  howpublished={Specification, released September 2019},
  url={https://sila-standard.com/standards/}, note={Accessed 2026-09-08}}

@misc{autoprotocol,
  author={{Strateos}}, title={{Autoprotocol} specification},
  howpublished={Strateos (formerly Transcriptic); undated web specification},
  url={http://autoprotocol.org/specification/}, note={Accessed 2026-09-08; see also \url{https://developers.strateos.com/docs/autoprotocol}}}
% UNVERIFIED: no dated release supports year={2023}. Either drop the year (as above) or cite the
% autoprotocol-python package release you actually used, which does carry a date.
% The HTTPS certificate for autoprotocol.org has expired; the HTTP URL serves the page.

@misc{opentronsapi,
  author={{Opentrons Labworks}}, year={2026},
  title={{Opentrons Python Protocol API}, version 2},
  howpublished={Documentation}, url={https://docs.opentrons.com/python-api/}, note={Accessed 2026-09-08}}

@article{ditommaso2017nextflow,
  author={Di Tommaso, Paolo and Chatzou, Maria and Floden, Evan W. and Prieto Barja, Pablo and Palumbo, Emilio and Notredame, C{\'e}dric},
  title={{Nextflow} enables reproducible computational workflows},
  journal={Nature Biotechnology}, volume={35}, number={4}, pages={316--319}, year={2017}, doi={10.1038/nbt.3820}}

@misc{omg2011bpmn,
  author={{Object Management Group}},
  title={{Business Process Model and Notation} ({BPMN}), Version 2.0},
  howpublished={OMG Document formal/2011-01-03}, year={2011},
  url={https://www.omg.org/spec/BPMN/2.0/}, note={Accessed 2026-09-08}}

@article{hobbs2004owltime,
  author={Hobbs, Jerry R. and Pan, Feng}, title={An ontology of time for the semantic web},
  journal={ACM Transactions on Asian Language Information Processing}, volume={3}, number={1}, pages={66--85}, year={2004},
  doi={10.1145/1017068.1017073}}
```

## In-text usage check

Every `\cite` was checked against the cited work's abstract or full text. No attribution errors (wrong paper for a claim) were found. Verified-correct characterizations, briefly:

- L61 Wilson: "its origins are murkier than its ubiquity suggests" — abstract: "Although Henry L. Gantt is recognized as their developer their origins and provenance are less well known." Correct.
- L61 PERT "three-point duration estimates" — Malcolm et al. 1959. Correct.
- L64 Brucker et al. (notation/classification), Kolisch and Padman (survey), Pinedo (machine scheduling). Correct.
- L67 Bertsimas and Stock Patterson "integer program over airport and sector capacities and show it is NP-hard" — the paper proves NP-hardness and gives the IP. Correct. Ball et al. "designed to integrate with CDM" — abstract: "allowing for easy integration into ground delay program procedures based on the Collaborative Decision Making paradigm." Correct. Wambsganss 1996 for CDM's 1990s origin. Correct.
- L70 Allen (13 relations), Dechter/Meiri/Pearl (metric bounds, STN), Vidal and Fargier (contingent links / STNU), Morris et al. (dynamic controllability). Correct.
- L72 Gerkey and Matarić taxonomy; Korsah et al. "extension to interrelated utilities and constraints" — iTax abstract uses that exact phrase. Correct. Gombolay et al. "satisficing sequencer inspired by real-time processor scheduling" — abstract: "a fast, satisficing multi-agent task sequencer inspired by real-time processor scheduling techniques." Correct. Behavior trees. Correct.
- L75 Guley and Stinson "branch and bound in 1984" — abstract presents a branch-and-bound algorithm. Correct. Matsushima and Funabiki "six cooking-step types ... cook and utensil constraints, with a guidance interface" — abstract confirms all three. Correct. Nakabe et al. "task graph per recipe ... optimal parallel procedure". Correct.
- L77 Tom et al. survey; Zhou et al. "operation precedence, station allocation and zero-gap synchronization constraints, where one operation must begin the instant its predecessor ends" — full text (PMC13459762) defines the "time synchronization constraint, requiring zero gap between an operation and its successor". Correct. Fehlis et al. "whole-lab orchestration and scheduling" is the paper's own title wording. SiLA 2 gRPC/feature definitions, Opentrons API, PyLabRobot hardware-agnostic, Autoprotocol JSON, protocols.io. Correct.
- L80 "We previously surveyed these frameworks along three axes: implicit versus explicit syntax, configuration/convention/class design paradigm, and command-line versus workbench interface" — matches the abstract of leipzig2017pipelines verbatim in substance. Snakemake, Nextflow, CWL, BPMN 2.0 execution semantics. Correct.
- L125 (Table caption) OWL-Time via Hobbs and Pan 2004 and the 2020 W3C CR. Correct.
- L149 MCP definition (tools, resources, prompts). Correct.
- L213 Morris et al. for dynamic-controllability check; Tercio as assignment layer. Correct.

### Minor wording cautions (no rewrite strictly required)

1. L46/L75, cited works matsushima2015cooking, nakabe2021cooking, zhou2026sdlscheduling.
   Quoted: "Domain-specific schedulers for kitchens and laboratories formulate the problem well but stop at an optimized procedure" and "each computes and presents a procedure, whereas \rt{} additionally plays it, with a clock, cues, manual steps".
   Caution: Matsushima and Funabiki's system explicitly includes a *guidance system* that presents steps to the cook during execution, so "stop at an optimized procedure" slightly understates it. Proposed rewording for L46: "...formulate the problem well but stop at an optimized (and, at most, step-by-step displayed) procedure". The L75 sentence already concedes the guidance interface and is fine as is.

2. L77, cited work zhou2026sdlscheduling.
   Quoted: "\emph{zero-gap} synchronization constraints".
   Caution: the paper's own term is "time synchronization constraint"; "zero gap" is its defining property, not its name. Proposed: "time-synchronization (zero-gap) constraints, where one operation must begin the instant its predecessor ends". Optional.

Non-citation aside noticed in a cited sentence (L149): "instantiated four times, at /mcp, /kitchen/mcp, /lab/mcp, /events/mcp and /gym/mcp" lists five endpoints. Flagged for the author; outside this report's scope.

## Unused / missing keys

- Bib entries never cited: none (0 of 37).
- Keys cited but absent from the bib: none.
- Every key resolves under `\bibliography{references}` with `plainnat`.

## Format consistency issues in `references.bib`

1. **plainnat lowercases `title` for `@article`, `@inproceedings` and `@misc`** (change.case$ "t"). Proper nouns not wrapped in braces will be downcased in the rendered bibliography. Affected: `Gantt` (wilson2003gantt), `PyLabRobot` (wierenga2023pylabrobot), `Snakemake` (koster2012snakemake), `Nextflow` (ditommaso2017nextflow), `Common Workflow Language` (amstutz2016cwl), `Artificial` (fehlis2025artificial), `Opentrons Python Protocol API` (opentronsapi), `Autoprotocol` (autoprotocol), `Model Context Protocol` (anthropic2024mcp), `Time Ontology` (w3c2020owltime), `Business Process Model and Notation` (omg2011bpmn), `Protocols.io` is first-word so safe. Wrap each in `{...}` as done already for `{SiLA}`, `{BPMN}`, `{OWL}`.
2. **DOI coverage inconsistent**: 9 entries lack a resolvable DOI that exists (listed above). After the fixes only the true web-only sources (sila2, autoprotocol, opentronsapi, omg2011bpmn, w3c2020owltime, anthropic2024mcp) will be without one, which is appropriate.
3. **Access dates inconsistent**: autoprotocol and opentronsapi embed "accessed 2026-09-08" inside `howpublished`; sila2, w3c2020owltime, anthropic2024mcp, omg2011bpmn have none. Use a uniform `note={Accessed 2026-09-08}` field for all six URL-only entries (plainnat has no `urldate`), and keep `howpublished` for the document descriptor only.
4. **`edition={6}`** (pinedo2022scheduling) renders as "6 edition" in plainnat; use `edition={Sixth}`.
5. **Venue abbreviation inconsistency**: `booktitle={Proc. IJCAI}` (morris2001dc) and `booktitle={Proc. Eastern Joint IRE-AIEE-ACM Computer Conference}` (kelley1959cpm) are abbreviated while all journal names are spelled out. Expand at least morris2001dc as shown above.
6. Diacritics, `and` separators, and `--` en-dashes in page ranges are consistent throughout; no issues. Author-name diacritics (`Matari{\'c}`, `M{\"o}hring`, `K{\"o}ster`, `{\"O}gren`, `Pablo-Garc{\'i}a`, `Tijani{\'c}`, `M{\'e}nager`, `Gavrilovi{\'c}`, `Al{\'a}n`) all verified against publisher records.
7. `journal={PLoS Biology}`: the journal has styled itself "PLOS Biology" since 2012; cosmetic.
8. `volume={E98-D}` (matsushima2015cooking) follows IEICE house style; J-STAGE metadata uses "E98.D". Either is accepted; no change needed.
9. Corporate authors are consistently double-braced (`{{SiLA Consortium}}`, `{{Strateos}}`, `{{Opentrons Labworks}}`, `{{Object Management Group}}`, `{{W3C}}`, `{{Anthropic}}`). Good.

## Self-citation

`leipzig2017pipelines` is the sole self-citation (1/37 = 2.7%, well under the 15% flag threshold). The manuscript's sole author (Jeremy Leipzig) is the sole author of the 2017 review, so "We previously surveyed" is correctly attributed. For an arXiv preprint there is no double-blind requirement, so the first-person self-reference needs no anonymisation; if the paper is later submitted to a double-blind venue, change "We previously surveyed ... \cite{leipzig2017pipelines}" to "A prior survey \cite{leipzig2017pipelines} classified these frameworks along three axes".

## Retraction screen

None of the 22 DOI-bearing journal articles carries a retraction, correction, or expression-of-concern notice in the Crossref or PubMed records retrieved.
