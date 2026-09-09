# Build the Rhylthyme technical report. Requires pdflatex, bibtex, node, rsvg-convert.
all: rhylthyme.pdf

figures/thanksgiving-gantt.svg: figures/thanksgiving_one_oven.json ../rhylthyme-server/static/js/timeline-render.js
	node -e "const R=require('../rhylthyme-server/static/js/timeline-render.js');const fs=require('fs');fs.writeFileSync('$@',R.renderTimelineSvg(JSON.parse(fs.readFileSync('$<'))))"

figures/thanksgiving-gantt.pdf: figures/thanksgiving-gantt.svg
	rsvg-convert -f pdf -o $@ $<

rhylthyme.pdf: rhylthyme.tex references.bib figures/thanksgiving-gantt.pdf
	pdflatex -interaction=nonstopmode rhylthyme.tex >/dev/null
	bibtex rhylthyme >/dev/null
	pdflatex -interaction=nonstopmode rhylthyme.tex >/dev/null
	pdflatex -interaction=nonstopmode rhylthyme.tex >/dev/null
	rm -f *.aux *.bbl *.blg *.log *.out

clean:
	rm -f *.aux *.bbl *.blg *.log *.out rhylthyme.pdf
