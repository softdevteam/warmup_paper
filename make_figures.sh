#!/bin/bash
# XXX Refactoring in progress.
# XXX if you edit this file, please move the figure into a make target.

# Export size, suitable for --wallclock-only.
EXPORT=4,4

EXPERIMENT_REPO=../warmup_experiment/
BENCHER5_DATA=annotated_results/warmup_results_0_8_linux2_i7_4790_outliers_w200_changepoints.json.bz2
BENCHER6_DATA=annotated_results/warmup_results_0_8_openbsd1_i7_4790_outliers_w200_changepoints.json.bz2
BENCHER7_DATA=annotated_results/warmup_results_0_8_linux3_e3_1240_outliers_w200_changepoints.json.bz2

# Use this for side-by-side plots, then adjust the height manually until it
# looks ok. Make sure the cell width in tex is .49\textwidth.
WIDTH_2COL=5

#
# In paper examples.
#

# new_miscomp
${EXPERIMENT_REPO}/bin/plot_krun_results --export-size 4,10 -o examples/new_miscomp.pdf -b bencher5:richards:Hotspot:default-java:1 ${BENCHER5_DATA}

# new_good_comp
${EXPERIMENT_REPO}/bin/plot_krun_results --export-size 4,10 -o examples/new_good_comp.pdf -b bencher5:fannkuch_redux:Hotspot:default-java:1 ${BENCHER5_DATA}

# new_slowdown
${EXPERIMENT_REPO}/bin/plot_krun_results --export-size 4,10 -o examples/new_slowdown.pdf -b bencher5:richards:Hotspot:default-java:1 ${BENCHER5_DATA}

#
# Appendix C examples.
#

# Flat examples.
${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${EXPORT} --wallclock-only -o category_examples/flat/flat0.pdf -b bencher6:binarytrees:C:default-c:0 ${BENCHER6_DATA}
${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${EXPORT} --wallclock-only -o category_examples/flat/flat1.pdf -b bencher6:fannkuch_redux:LuaJIT:default-lua:6 ${BENCHER6_DATA}
${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${EXPORT} --wallclock-only -o category_examples/flat/flat2.pdf -b bencher6:nbody:LuaJIT:default-lua:9 ${BENCHER6_DATA}
${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${EXPORT} --wallclock-only -o category_examples/flat/flat3.pdf -b bencher5:fasta:C:default-c:0 ${BENCHER5_DATA}

# Warmup examples.
${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${EXPORT} --wallclock-only -o category_examples/warmup/warmup0.pdf -b bencher6:binarytrees:Hotspot:default-java:4 ${BENCHER6_DATA}
${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${EXPORT} --wallclock-only -o category_examples/warmup/warmup1.pdf -b bencher6:fannkuch_redux:Hotspot:default-java:1 ${BENCHER6_DATA}
${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${EXPORT} --wallclock-only -o category_examples/warmup/warmup2.pdf -b bencher6:richards:PyPy:default-python:1 ${BENCHER6_DATA}
${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${EXPORT} --wallclock-only -o category_examples/warmup/warmup3.pdf -b bencher5:binarytrees:HHVM:default-php:5 ${BENCHER5_DATA}
${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${EXPORT} --wallclock-only -o category_examples/warmup/warmup4.pdf -b bencher5:nbody:HHVM:default-php:5 ${BENCHER5_DATA}

# Slowdown examples.
${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${EXPORT} --wallclock-only -o category_examples/slowdown/slowdown0.pdf -b bencher6:fasta:Hotspot:default-java:1 ${BENCHER6_DATA}
${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${EXPORT} --wallclock-only -o category_examples/slowdown/slowdown1.pdf -b bencher5:fasta:V8:default-javascript:5 ${BENCHER5_DATA}
${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${EXPORT} --wallclock-only -o category_examples/slowdown/slowdown2.pdf -b bencher5:richards:Hotspot:default-java:3 ${BENCHER5_DATA}
${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${EXPORT} --wallclock-only -o category_examples/slowdown/slowdown3.pdf -b bencher3:spectralnorm:Graal:default-java:1 ${BENCHER3_DATA}

# No steady state examples.
${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${EXPORT} --wallclock-only -o category_examples/nosteadystate/nosteadystate0.pdf -b bencher6:fasta:PyPy:default-python:1 ${BENCHER6_DATA}
${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${EXPORT} --wallclock-only -o category_examples/nosteadystate/nosteadystate1.pdf -b bencher5:binarytrees:C:default-c:1 ${BENCHER5_DATA}
${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${EXPORT} --wallclock-only -o category_examples/nosteadystate/nosteadystate2.pdf -b bencher5:fannkuch_redux:Hotspot:default-java:1 ${BENCHER5_DATA}
${EXPERIMENT_REPO}/bin/plot_krun_results --export-size ${EXPORT} --wallclock-only -o category_examples/nosteadystate/nosteadystate3.pdf  -b bencher3:fasta:PyPy:default-python:5 bencher3_warmup_07.json.bz2
