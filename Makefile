# Build the Rhylthyme technical report. Requires pdflatex, bibtex, node, rsvg-convert.
all: rhylthyme.pdf

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

clean:
	rm -f *.aux *.bbl *.blg *.log *.out rhylthyme.pdf
