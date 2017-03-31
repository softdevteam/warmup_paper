PDFLATEX=pdflatex -synctex=1

.SUFFIXES: .tex .ps .dia .pdf .svg

LATEX_SIGPLAN = warmup

LATEX_COMMON =

DIAGRAMS = 	img/picturebook_warmup.pdf \
		examples/new_warmup_no_migrate.pdf \
		examples/changepoint_example.pdf \
		examples/new_no_steady.pdf \
		examples/new_inconsistent.pdf \
		examples/new_cyclic.pdf

TABLES= dacapo.table startup.table \
	bencher5_octane.table bencher6_octane.table bencher7_octane.table \
	bencher5.table bencher6.table bencher7.table

CODE =

BASE_CLEANFILES =	aux bbl blg dvi log ps pdf toc out snm nav vrb \
			vtc synctex.gz
OTHER_CLEANFILES =	bib.bib texput.log warmup_paper.pdf warmup_appendix.pdf

all: ${LATEX_SIGPLAN}.pdf bib.bib

.svg.pdf:
	inkscape --export-pdf=$@ $<

.PHONY: clean
clean: clean-sigplan

.PHONY: clean-sigplan
clean-sigplan:
	rm -rf ${DIAGRAMS:S/.pdf/.eps/}
	for i in ${BASE_CLEANFILES}; do rm -f ${LATEX_SIGPLAN}.$${i}; done
	rm -f ${OTHER_CLEANFILES}

bib.bib: softdevbib/softdev.bib
	softdevbib/bin/prebib softdevbib/softdev.bib > bib.bib

softdevbib-update: softdevbib
	cd softdevbib && git pull

softdevbib/softdev.bib: softdevbib

softdevbib:
	git clone https://github.com/softdevteam/softdevbib.git

TEXMFHOME="../../share/texmf"
${LATEX_SIGPLAN}.pdf: ${LATEX_COMMON} ${LATEX_SIGPLAN}.tex \
		${DIAGRAMS} ${CODE} bib.bib ${TABLES} summary_macros.tex
	TEXMFHOME=${TEXMFHOME} ${PDFLATEX} ${LATEX_SIGPLAN}.tex
	bibtex ${LATEX_SIGPLAN}
	TEXMFHOME=${TEXMFHOME} ${PDFLATEX} ${LATEX_SIGPLAN}.tex
	TEXMFHOME=${TEXMFHOME} ${PDFLATEX} ${LATEX_SIGPLAN}.tex
	pdfsplit -o warmup_paper.pdf 0:20 warmup.pdf
	pdfsplit -o warmup_appendix.pdf 20: warmup.pdf

#
# Plots in main body of paper (in order of appearance in tex src).
# Outputs imported into git for convenience.
#

# Not included, too large for repo.
# clone this manually
EXPERIMENT_REPO=../warmup_experiment

BENCHER5_DATA=annotated_results/warmup_results_0_8_linux2_i7_4790_outliers_w200_changepoints.json.bz2
BENCHER6_DATA=annotated_results/warmup_results_0_8_openbsd1_i7_4790_outliers_w200_changepoints.json.bz2
BENCHER7_DATA=annotated_results/warmup_results_0_8_linux3_e3_1240_outliers_w200_changepoints.json.bz2
ANN_RESULTS=${BENCHER5_DATA} ${BENCHER6_DATA} ${BENCHER7_DATA}

# Use this for side-by-side plots, then adjust the height manually until it
# looks ok. Make sure the cell width in tex is .49\textwidth.
WIDTH_2COL=5

examples/new_warmup_no_migrate.pdf: ${ANN_RESULTS}
	${EXPERIMENT_REPO}/bin/plot_krun_results --core-cycles 3 --export-size ${WIDTH_2COL},5 -o examples/new_warmup_no_migrate.pdf -b bencher5:nbody:HHVM:default-php:3 --no-zoom --no-inset --with-changepoint-means ${BENCHER5_DATA} --with-outliers

examples/changepoint_example.pdf: ${ANN_RESULTS}
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 --with-changepoint-means --with-outliers -o examples/changepoint_example.pdf -b bencher7:richards:Hotspot:default-java:14 ${BENCHER7_DATA} --core-cycles 0,1,2 --inset-xlimits 0,9

examples/new_no_steady.pdf: ${ANN_RESULTS}
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 -o examples/new_no_steady.pdf -b bencher5:binarytrees:V8:default-javascript:23 ${BENCHER5_DATA} --no-zoom --with-outliers


examples/new_inconsistent.pdf: ${ANN_RESULTS}
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size 6,4 --no-zoom -o examples/new_inconsistent.pdf -b bencher6:fannkuch_redux:LuaJIT:default-lua:24 -b bencher6:fannkuch_redux:LuaJIT:default-lua:9 --wallclock-only --with-changepoint-means --with-outliers ${BENCHER6_DATA}

examples/new_cyclic.pdf: ${ANN_RESULTS}
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},10 -o examples/new_cyclic.pdf -b bencher5:fannkuch_redux:Hotspot:default-java:0 --no-zoom --inset-xlimits 600,999 --core-cycles 1 --with-changepoint-means --with-outliers ${BENCHER5_DATA}


