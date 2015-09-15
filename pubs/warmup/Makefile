PREBIB=../../bin/prebib
PDFLATEX=pdflatex -synctex=1

.SUFFIXES: .tex .ps .dia .pdf .svg

LATEX_SIGPLAN = warmup

LATEX_COMMON = 

DIAGRAMS = 

TABLES=

CODE =

BIBDB = bib.bib

BASE_CLEANFILES =	aux bbl blg dvi log ps pdf toc out snm nav vrb
OTHER_CLEANFILES =	${BIBDB} texput.log

all: ${LATEX_SIGPLAN}.pdf

.PHONY: clean
clean: clean-sigplan

.PHONY: clean-sigplan
clean-sigplan:
	rm -rf ${DIAGRAMS} ${DIAGRAMS:S/.pdf/.eps/}
	for i in ${BASE_CLEANFILES}; do rm -f ${LATEX_SIGPLAN}.$${i}; done
	rm -f ${OTHER_CLEANFILES}

${BIBDB}: ${PREBIB} ../softdev.bib
	${PREBIB} ../softdev.bib > ${BIBDB}

TEXMFHOME="../../share/texmf"
${LATEX_SIGPLAN}.pdf: ${LATEX_COMMON} ${LATEX_SIGPLAN}.tex \
		${DIAGRAMS} ${CODE} ${BIBDB} ${TABLES}
	TEXMFHOME=${TEXMFHOME} ${PDFLATEX} ${LATEX_SIGPLAN}.tex
	bibtex ${LATEX_SIGPLAN}
	TEXMFHOME=${TEXMFHOME} ${PDFLATEX} ${LATEX_SIGPLAN}.tex
	TEXMFHOME=${TEXMFHOME} ${PDFLATEX} ${LATEX_SIGPLAN}.tex
