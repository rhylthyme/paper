# Build the Rhylthyme technical report. Requires pdflatex, bibtex, node, rsvg-convert.
all: rhylthyme.pdf
.PHONY: all arxiv clean

figures/thanksgiving-gantt.svg: figures/thanksgiving_one_oven.json ../rhylthyme-server/static/js/timeline-render.js
	node -e "const R=require('../rhylthyme-server/static/js/timeline-render.js');const fs=require('fs');fs.writeFileSync('$@',R.renderTimelineSvg(JSON.parse(fs.readFileSync('$<')),{style:'publication',fontScale:1.1}))"

figures/thanksgiving-gantt.pdf: figures/thanksgiving-gantt.svg
	rsvg-convert -f pdf -o $@ $<

# Evaluation table and figure, generated from eval/ so the paper cannot drift
# from the results. Needs matplotlib (the monorepo .venv has it).
PYTHON ?= ../.venv/bin/python
eval-table.tex: eval/make_paper_assets.py eval/baseline.json eval/four-turn.json $(wildcard eval/models/*/*/results.json)
	$(PYTHON) eval/make_paper_assets.py >/dev/null

# The same script writes the figure.
figures/eval-models.pdf: eval-table.tex

rhylthyme.pdf: rhylthyme.tex references.bib figures/thanksgiving-gantt.pdf eval-table.tex figures/eval-models.pdf
	pdflatex -interaction=nonstopmode rhylthyme.tex >/dev/null
	bibtex rhylthyme >/dev/null
	pdflatex -interaction=nonstopmode rhylthyme.tex >/dev/null
	pdflatex -interaction=nonstopmode rhylthyme.tex >/dev/null
	rm -f *.aux *.bbl *.blg *.log *.out

# arXiv source package. arXiv compiles the TeX itself and does not run BibTeX,
# so the package carries the .bbl and only the files the paper uses. The
# staged copy is test-compiled without bibtex, exactly as arXiv will.
ARXIV_FILES = figures/thanksgiving-gantt.pdf figures/view-timeline.png figures/view-itinerary.png \
              figures/view-dag.png figures/view-dag-lab.pdf figures/eval-models.pdf
arxiv: rhylthyme.tex references.bib eval-table.tex $(ARXIV_FILES)
	rm -rf arxiv/stage arxiv/rhylthyme-arxiv.tar.gz && mkdir -p arxiv/stage/figures
	cp rhylthyme.tex references.bib eval-table.tex arxiv/stage/
	cp $(ARXIV_FILES) arxiv/stage/figures/
	cd arxiv/stage && pdflatex -interaction=nonstopmode rhylthyme.tex >/dev/null && bibtex rhylthyme >/dev/null
	cd arxiv/stage && rm -f references.bib *.aux *.blg *.log *.out rhylthyme.pdf
	# From here on the stage holds exactly what arXiv receives: compile it the way arXiv does.
	cd arxiv/stage && pdflatex -interaction=nonstopmode rhylthyme.tex >/dev/null && pdflatex -interaction=nonstopmode rhylthyme.tex >/dev/null && pdflatex -interaction=nonstopmode rhylthyme.tex > build.log
	@cd arxiv/stage && ! grep -E "Citation .* undefined|Reference .* undefined|LaTeX Error|Emergency stop|File .* not found" build.log
	@echo "staged build: $$(pdfinfo arxiv/stage/rhylthyme.pdf | grep Pages)"
	cp arxiv/stage/rhylthyme.pdf arxiv/rhylthyme-arxiv-preview.pdf
	cd arxiv/stage && rm -f *.aux *.log *.out rhylthyme.pdf && tar czf ../rhylthyme-arxiv.tar.gz *
	@echo "wrote arxiv/rhylthyme-arxiv.tar.gz ($$(du -h arxiv/rhylthyme-arxiv.tar.gz | cut -f1)):" && tar tzf arxiv/rhylthyme-arxiv.tar.gz | grep -v '/$$'

clean:
	rm -f *.aux *.bbl *.blg *.log *.out rhylthyme.pdf
