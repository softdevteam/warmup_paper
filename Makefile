PREBIB=./prebib
PDFLATEX=pdflatex -synctex=1

.SUFFIXES: .tex .ps .dia .pdf .svg

LATEX_SIGPLAN = warmup
EXTENDED_ABSTRACT = warmup_extended_abstract

LATEX_COMMON =

DIAGRAMS = img/picturebook_warmup.pdf

TABLES= dacapo.table octane.table results1.table results2.table startup.table

CODE =

BIBDB = bib.bib

BASE_CLEANFILES =	aux bbl blg dvi log ps pdf toc out snm nav vrb \
			vtc synctex.gz
OTHER_CLEANFILES =	${BIBDB} texput.log

all: ${LATEX_SIGPLAN}.pdf ${EXTENDED_ABSTRACT}.pdf

.svg.pdf:
	inkscape --export-pdf=$@ $<

.PHONY: clean
clean: clean-sigplan clean-extended-abstract

.PHONY: clean-sigplan
clean-sigplan:
	rm -rf ${DIAGRAMS:S/.pdf/.eps/}
	for i in ${BASE_CLEANFILES}; do rm -f ${LATEX_SIGPLAN}.$${i}; done
	rm -f ${OTHER_CLEANFILES}

.PHONY: clean-extended-abstract
clean-extended-abstract:
	for i in ${BASE_CLEANFILES}; do rm -f ${EXTENDED_ABSTRACT}.$${i}; done
	rm -f ${OTHER_CLEANFILES}

${BIBDB}: ${PREBIB} softdev.bib
	${PREBIB} softdev.bib > ${BIBDB}

TEXMFHOME="../../share/texmf"
${LATEX_SIGPLAN}.pdf: ${LATEX_COMMON} ${LATEX_SIGPLAN}.tex \
		${DIAGRAMS} ${CODE} ${BIBDB} ${TABLES}
	TEXMFHOME=${TEXMFHOME} ${PDFLATEX} ${LATEX_SIGPLAN}.tex
	bibtex ${LATEX_SIGPLAN}
	TEXMFHOME=${TEXMFHOME} ${PDFLATEX} ${LATEX_SIGPLAN}.tex
	TEXMFHOME=${TEXMFHOME} ${PDFLATEX} ${LATEX_SIGPLAN}.tex

# Extended abstract for ICOOOLPS
${EXTENDED_ABSTRACT}.pdf: ${EXTENDED_ABSTRACT}.tex \
		${DIAGRAMS} ${CODE} ${BIBDB} ${TABLES}
	TEXMFHOME=${TEXMFHOME} ${PDFLATEX} ${EXTENDED_ABSTRACT}
	bibtex ${EXTENDED_ABSTRACT}
	TEXMFHOME=${TEXMFHOME} ${PDFLATEX} ${EXTENDED_ABSTRACT}
	TEXMFHOME=${TEXMFHOME} ${PDFLATEX} ${EXTENDED_ABSTRACT}
