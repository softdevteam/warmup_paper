PDFLATEX=pdflatex -synctex=1

.SUFFIXES: .tex .ps .dia .pdf .svg

LATEX_SIGPLAN = warmup
DIFF = diff-warmup

LATEX_COMMON =

DIAGRAMS =
PLOTS =		examples/new_warmup_no_migrate.pdf \
		examples/changepoint_example.pdf \
		examples/new_no_steady.pdf \
		examples/new_inconsistent.pdf \
		examples/new_cyclic.pdf \
		category_examples/warmup/warmup0.pdf \
		category_examples/warmup/warmup1.pdf \
		category_examples/warmup/warmup2.pdf \
		category_examples/warmup/warmup3.pdf \
		category_examples/flat/flat0.pdf \
		category_examples/flat/flat1.pdf \
		category_examples/flat/flat2.pdf \
		category_examples/flat/flat3.pdf \
		category_examples/slowdown/slowdown0.pdf \
		category_examples/slowdown/slowdown1.pdf \
		category_examples/slowdown/slowdown2.pdf \
		category_examples/slowdown/slowdown3.pdf \
		category_examples/nosteadystate/nosteadystate0.pdf \
		category_examples/nosteadystate/nosteadystate1.pdf \
		category_examples/nosteadystate/nosteadystate2.pdf \
		category_examples/nosteadystate/nosteadystate3.pdf \
		examples/new_miscomp.pdf \
		examples/new_good_comp.pdf \
		examples/warmup_flat.pdf \
		examples/unexplained_weirdness.pdf \
		examples/truncated_same_plot.pdf \
		examples/truncated1.pdf \
		examples/truncated2.pdf
DIAGRAMS +=	${PLOTS}

TABLES= dacapo.table startup.table \
	bencher5_octane.table bencher6_octane.table bencher7_octane.table \
	bencher5.table bencher6.table bencher7.table

CODE =

BASE_CLEANFILES =	aux bbl blg dvi log ps pdf toc out snm nav vrb \
			vtc synctex.gz
OTHER_CLEANFILES =	bib.bib texput.log warmup_paper.pdf warmup_appendix.pdf submitted.tex ${DIFF}.tex

all: ${LATEX_SIGPLAN}.pdf bib.bib

.svg.pdf:
	inkscape --export-pdf=$@ $<

.PHONY: clean
clean: clean-sigplan clean-arxiv

.PHONY: clean-sigplan
clean-sigplan:
	rm -rf ${DIAGRAMS:S/.pdf/.eps/}
	for i in ${BASE_CLEANFILES}; do rm -f ${LATEX_SIGPLAN}.$${i}; done
	for i in ${BASE_CLEANFILES}; do rm -f ${DIFF}.$${i}; done
	rm -f ${OTHER_CLEANFILES}

bib.bib: softdevbib/softdev.bib
	softdevbib/bin/prebib softdevbib/softdev.bib > bib.bib

softdevbib-update: softdevbib
	cd softdevbib && git pull

softdevbib/softdev.bib: softdevbib

softdevbib:
	git clone https://github.com/softdevteam/softdevbib.git

TEXMFHOME="../../share/texmf"
${LATEX_SIGPLAN}.pdf: ${DIAGRAMS} ${LATEX_COMMON} ${LATEX_SIGPLAN}.tex \
		${CODE} bib.bib ${TABLES} summary_macros.tex
	TEXMFHOME=${TEXMFHOME} ${PDFLATEX} ${LATEX_SIGPLAN}.tex
	bibtex ${LATEX_SIGPLAN}
	TEXMFHOME=${TEXMFHOME} ${PDFLATEX} ${LATEX_SIGPLAN}.tex
	TEXMFHOME=${TEXMFHOME} ${PDFLATEX} ${LATEX_SIGPLAN}.tex

.PHONY: diff
diff: ${DIFF}.pdf

${DIFF}.pdf: ${LATEX_SIGPLAN}.pdf
	git show oopsla17_submission:warmup.tex > submitted.tex
	latexdiff submitted.tex warmup.tex > ${DIFF}.tex
	TEXMFHOME=${TEXMFHOME} ${PDFLATEX} ${DIFF}.tex
	bibtex ${DIFF}
	TEXMFHOME=${TEXMFHOME} ${PDFLATEX} ${DIFF}.tex
	TEXMFHOME=${TEXMFHOME} ${PDFLATEX} ${DIFF}.tex
#
# Plots in main body of paper (in order of appearance in tex src).
# Outputs imported into git for convenience.
#

# Use this to force regeneration of plots on next build.
clean-plots:
	rm -f ${PLOTS}

# Use this to force regeneration of tables on next build.
clean-tables:
	rm -f ${TABLES}

# Not included, too large for repo.
# clone this manually
EXPERIMENT_REPO=../warmup_experiment

BENCHER5_OCTANE_DATA=annotated_results/octane_spidermonkey_results_0_8_linux2_i7_4790_outliers_w200_changepoints.json.bz2 annotated_results/octane_v8_results_0_8_linux2_i7_4790_outliers_w200_changepoints.json.bz2
BENCHER6_OCTANE_DATA=annotated_results/octane_v8_results_0_8_openbsd1_i7_4790_outliers_w200_changepoints.json.bz2
BENCHER7_OCTANE_DATA=annotated_results/octane_spidermonkey_results_0_8_linux3_e3_1240_outliers_w200_changepoints.json.bz2 annotated_results/octane_v8_results_0_8_linux3_e3_1240_outliers_w200_changepoints.json.bz2
DACAPO_DATA=annotated_results/dacapo_graal_results_0_8_linux2_i7_4790_outliers_w200_changepoints.json.bz2 annotated_results/dacapo_hotspot_results_0_8_linux2_i7_4790_outliers_w200_changepoints.json.bz2
STARTUP_DATA=annotated_results/startup_results_0_8_linux2_i7_4790.json.bz2 annotated_results/startup_results_0_8_openbsd1_i7_4790.json.bz2
BENCHER5_DATA=annotated_results/warmup_results_0_8_linux2_i7_4790_outliers_w200_changepoints.json.bz2
BENCHER6_DATA=annotated_results/warmup_results_0_8_openbsd1_i7_4790_outliers_w200_changepoints.json.bz2
BENCHER7_DATA=annotated_results/warmup_results_0_8_linux3_e3_1240_outliers_w200_changepoints.json.bz2
BENCHER7_INSTR_DATA=annotated_results/instr_results_0_8_linux3_e3_1240_outliers_w200_changepoints_results.json.bz2
# And you would have the instr data dir named:
# instr_results_0_8_linux3_e3_1240_outliers_w200_changepoints_instr_data

# Use this for two separate but side-by-side plots.
WIDTH_2COL=5

# Plots in the main paper body
examples/new_warmup_no_migrate.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 -o examples/new_warmup_no_migrate.pdf -b bencher5:binarytrees:Hotspot:default-java:4 --wallclock-only --with-changepoint-means --with-outliers --inset-xlimits 0,10 ${BENCHER5_DATA}

examples/changepoint_example.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 --with-changepoint-means --with-outliers -o examples/changepoint_example.pdf -b bencher7:richards:Hotspot:default-java:14 ${BENCHER7_DATA} --wallclock-only --inset-xlimits 0,10

examples/new_no_steady.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 -o examples/new_no_steady.pdf -b bencher5:binarytrees:V8:default-javascript:23 ${BENCHER5_DATA} --no-zoom --with-outliers --with-changepoint-means

examples/new_inconsistent.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size 6,4 --no-zoom -o examples/new_inconsistent.pdf -b bencher7:binarytrees:V8:default-javascript:6 -b bencher7:binarytrees:V8:default-javascript:7 --wallclock-only --with-changepoint-means --with-outliers ${BENCHER7_DATA}

examples/new_cyclic.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 -o examples/new_cyclic.pdf -b bencher5:fannkuch_redux:Hotspot:default-java:0 --no-zoom --inset-xlimits 600,1000 --core-cycles 1 --with-changepoint-means --with-outliers --cycles-ylimits 1.2270e9,1.2400e9 ${BENCHER5_DATA}


examples/unexplained_weirdness.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 -o examples/unexplained_weirdness.pdf -b bencher7:fannkuch_redux:Hotspot:default-java:3 --no-zoom --no-inset --core-cycles "" --with-changepoint-means --with-outliers ${BENCHER7_INSTR_DATA}


examples/warmup_flat.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size 6,4 --no-zoom -o examples/warmup_flat.pdf -b bencher6:binarytrees:PyPy:default-python:23 -b bencher6:binarytrees:PyPy:default-python:27 --wallclock-only --with-changepoint-means --with-outliers ${BENCHER6_DATA} --inset-xlimits 0,12

# Plots in the appendix

# warmup
category_examples/warmup/warmup0.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 -o category_examples/warmup/warmup0.pdf -b bencher6:fannkuch_redux:LuaJIT:default-lua:11 --no-zoom --wallclock-only --with-changepoint-means --with-outliers ${BENCHER6_DATA}

category_examples/warmup/warmup1.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 -o category_examples/warmup/warmup1.pdf -b bencher6:fannkuch_redux:PyPy:default-python:7 --no-zoom --wallclock-only --with-changepoint-means --with-outliers ${BENCHER6_DATA}

category_examples/warmup/warmup2.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 -o category_examples/warmup/warmup2.pdf -b bencher5:fasta:V8:default-javascript:14 --inset-xlimits 0,12 --no-zoom --wallclock-only --with-changepoint-means --with-outliers ${BENCHER5_DATA}

category_examples/warmup/warmup3.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 -o category_examples/warmup/warmup3.pdf -b bencher7:spectralnorm:PyPy:default-python:12 --no-zoom --wallclock-only --inset-xlimits 0,30 --with-changepoint-means --with-outliers ${BENCHER7_DATA}

# Flat
category_examples/flat/flat0.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 -o category_examples/flat/flat0.pdf -b bencher5:fasta:LuaJIT:default-lua:21 --no-zoom --wallclock-only --with-changepoint-means --with-outliers ${BENCHER5_DATA}

category_examples/flat/flat1.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 -o category_examples/flat/flat1.pdf -b bencher7:fasta:C:default-c:13 --no-zoom --wallclock-only --with-changepoint-means --with-outliers ${BENCHER7_DATA}

category_examples/flat/flat2.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 -o category_examples/flat/flat2.pdf -b bencher7:nbody:PyPy:default-python:5 --no-zoom --wallclock-only --with-changepoint-means --with-outliers ${BENCHER7_DATA}

category_examples/flat/flat3.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 -o category_examples/flat/flat3.pdf -b bencher7:nbody:V8:default-javascript:4 --no-zoom --wallclock-only --with-changepoint-means --with-outliers ${BENCHER7_DATA}

# slowdown
category_examples/slowdown/slowdown0.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 -o category_examples/slowdown/slowdown0.pdf -b bencher6:fasta:Hotspot:default-java:29 --no-zoom --wallclock-only --with-changepoint-means --with-outliers --inset-xlimits 0,20 ${BENCHER6_DATA}

category_examples/slowdown/slowdown1.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 -o category_examples/slowdown/slowdown1.pdf -b bencher5:fasta:V8:default-javascript:13 --no-zoom --wallclock-only --with-changepoint-means --with-outliers ${BENCHER5_DATA}

category_examples/slowdown/slowdown2.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 -o category_examples/slowdown/slowdown2.pdf -b bencher7:richards:JRubyTruffle:default-ruby:29 --no-zoom --wallclock-only --with-changepoint-means --with-outliers ${BENCHER7_DATA}

category_examples/slowdown/slowdown3.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 -o category_examples/slowdown/slowdown3.pdf -b bencher7:spectralnorm:Graal:default-java:24 --no-zoom --wallclock-only --with-changepoint-means --with-outliers ${BENCHER7_DATA}

# no steady state
category_examples/nosteadystate/nosteadystate0.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 -o category_examples/nosteadystate/nosteadystate0.pdf -b bencher5:binarytrees:C:default-c:18 --no-zoom --wallclock-only --with-changepoint-means --with-outliers ${BENCHER5_DATA}

category_examples/nosteadystate/nosteadystate1.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 -o category_examples/nosteadystate/nosteadystate1.pdf -b bencher7:richards:LuaJIT:default-lua:3 --no-zoom --wallclock-only --with-changepoint-means --with-outliers ${BENCHER7_DATA}

category_examples/nosteadystate/nosteadystate2.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 -o category_examples/nosteadystate/nosteadystate2.pdf -b bencher5:binarytrees:HHVM:default-php:2 --no-zoom --wallclock-only --with-changepoint-means --with-outliers ${BENCHER5_DATA}

category_examples/nosteadystate/nosteadystate3.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${WIDTH_2COL},5 -o category_examples/nosteadystate/nosteadystate3.pdf -b bencher5:fasta:PyPy:default-python:18 --no-zoom --wallclock-only --with-changepoint-means --with-outliers ${BENCHER5_DATA}

# Instrumentation plots
# PyPy instrumentation requires a phenomenal amount of memory.
# Don't even try on 16GB or less. Works on 24GB.

examples/new_miscomp.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --with-changepoint-means --with-outliers -o examples/new_miscomp.pdf ${BENCHER7_INSTR_DATA} -b bencher7:richards:Hotspot:default-java:2 --core-cycles "" --no-zoom --export-size ${WIDTH_2COL},6

examples/new_good_comp.pdf:
	${EXPERIMENT_REPO}/bin/plot_krun_results --with-changepoint-means --with-outliers -o examples/new_good_comp.pdf ${BENCHER7_INSTR_DATA} -b bencher7:fasta:PyPy:default-python:4 --core-cycles "" --no-zoom --export-size ${WIDTH_2COL},6


# Tables.

bencher5_octane.table:
	${EXPERIMENT_REPO}/bin/table_classification_summaries_others -s 2 -o bencher5_octane.table ${BENCHER5_OCTANE_DATA}

bencher6_octane.table:
	${EXPERIMENT_REPO}/bin/table_classification_summaries_others -s 1 -o bencher6_octane.table ${BENCHER6_OCTANE_DATA}

bencher7_octane.table:
	${EXPERIMENT_REPO}/bin/table_classification_summaries_others -s 2 -o bencher7_octane.table ${BENCHER7_OCTANE_DATA}

dacapo.table:
	${EXPERIMENT_REPO}/bin/table_classification_summaries_others -s 2 -o dacapo.table ${DACAPO_DATA}

startup.table:
	${EXPERIMENT_REPO}/bin/table_startup_results -o startup.table ${STARTUP_DATA}

bencher5.table:
	${EXPERIMENT_REPO}/bin/table_classification_summaries_main -o bencher5.table ${BENCHER5_DATA}

bencher6.table:
	${EXPERIMENT_REPO}/bin/table_classification_summaries_main -o bencher6.table ${BENCHER6_DATA}

bencher7.table:
	${EXPERIMENT_REPO}/bin/table_classification_summaries_main -o bencher7.table ${BENCHER7_DATA}

.PHONY: tables
tables: bencher5.table bencher6.table bencher7.table startup.table dacapo.table bencher5_octane.table \
	bencher6_octane.table bencher7_octane.table

# Package up the paper for arxiv.org.
# Note that acmart.cls is included in tex live 2016.
ARXIV_FILES=	${DIAGRAMS} \
		${LATEX_SIGPLAN}.tex \
		${TABLES} \
		softdev.sty \
		bib.bib \
		warmup.bbl \
		ACM-Reference-Format.bst \
		summary_macros.tex \
		vm_versions.tex \
		outlier_summaries.tex
ARXIV_BASE=arxiv
${ARXIV_BASE}: ${LATEX_SIGPLAN}.pdf
	mkdir $@
	rsync -Rav ${ARXIV_FILES} $@
	zip -r $@.zip ${ARXIV_BASE}

.PHONY: clean-arxiv
clean-arxiv:
	rm -rf ${ARXIV_BASE}
	rm -rf ${ARXIV_BASE}.zip
