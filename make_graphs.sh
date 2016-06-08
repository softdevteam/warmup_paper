#!/bin/sh

# Pass paths on the CLI
OUTDIR=$1
B3=$2
B5=$3
B6=$4

PLOT="python2.7 plot_krun_results.py --f ${B3} -f ${B5} -f ${B6}"

mkdir -p ${OUTDIR}

# Good warmup
${PLOT} --benchmark bencher3:richards:Graal:default-java:2 \
    --inset-xlimits 0,9 -o ${OUTDIR}/good_fast.pdf || exit $?

${PLOT} --benchmark bencher5:fasta:V8:default-javascript:0 \
    -o ${OUTDIR}/good_tiers.pdf || exit $?

# Inconsistent
${PLOT} \
    --one-page \
    --benchmark bencher5:fasta:PyPy:default-python:2 \
    --benchmark bencher5:fasta:PyPy:default-python:3 \
    -o ${OUTDIR}/bad_inconsistent.pdf || exit $?

# Cycles 
${PLOT} --benchmark bencher3:fannkuch_redux:Hotspot:default-java:0 \
    -o ${OUTDIR}/bad_cycles.pdf || exit $?

# Slowdown
${PLOT} --benchmark bencher6:fannkuch_redux:LuaJIT:default-lua:9 \
    --inset-xlimits 0,100 -o ${OUTDIR}/bad_slowdown.pdf || exit $?

# Phases
${PLOT} --benchmark bencher6:fasta:LuaJIT:default-lua:4 \
    -o ${OUTDIR}/bad_phases.pdf || exit $?


