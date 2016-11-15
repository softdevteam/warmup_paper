PREBIB=./prebib
PDFLATEX=pdflatex -synctex=1

.SUFFIXES: .tex .ps .dia .pdf .svg

LATEX_SIGPLAN = warmup

LATEX_COMMON =

DIAGRAMS = img/picturebook_warmup.pdf

TABLES= dacapo.table octane.table startup.table \
	bencher3.table bencher5.table bencher6.table

CODE =

BIBDB = bib.bib

BASE_CLEANFILES =	aux bbl blg dvi log ps pdf toc out snm nav vrb \
			vtc synctex.gz
OTHER_CLEANFILES =	${BIBDB} texput.log

all: ${LATEX_SIGPLAN}.pdf

.svg.pdf:
	inkscape --export-pdf=$@ $<

.PHONY: clean
clean: clean-sigplan

.PHONY: clean-sigplan
clean-sigplan:
	rm -rf ${DIAGRAMS:S/.pdf/.eps/}
	for i in ${BASE_CLEANFILES}; do rm -f ${LATEX_SIGPLAN}.$${i}; done
	rm -f ${OTHER_CLEANFILES}

${BIBDB}: ${PREBIB} softdev.bib
	${PREBIB} softdev.bib > ${BIBDB}

TEXMFHOME="../../share/texmf"
${LATEX_SIGPLAN}.pdf: ${LATEX_COMMON} ${LATEX_SIGPLAN}.tex \
		${DIAGRAMS} ${CODE} ${BIBDB} ${TABLES} summary_macros.tex
	TEXMFHOME=${TEXMFHOME} ${PDFLATEX} ${LATEX_SIGPLAN}.tex
	bibtex ${LATEX_SIGPLAN}
	TEXMFHOME=${TEXMFHOME} ${PDFLATEX} ${LATEX_SIGPLAN}.tex
	TEXMFHOME=${TEXMFHOME} ${PDFLATEX} ${LATEX_SIGPLAN}.tex
	pdfsplit -o warmup_paper.pdf 0:13 warmup.pdf
	pdfsplit -o warmup_appendix.pdf 13: warmup.pdf
