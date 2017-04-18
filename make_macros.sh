#!/bin/bash

#
# Requires JSON files with outliers and classifications.
#

EXPERIMENT_REPO=../warmup_experiment/
BENCHER5_DATA=bencher5_warmup_07.json.bz2
BENCHER6_DATA=bencher6_warmup_07.json.bz2
BENCHER7_DATA=bencher7_warmup_07.json.bz2

# Generate outlier_summaries.tex
${EXPERIMENT_REPO}/bin/create_outlier_macros -o outlier_summaries.tex ${BENCHER5_DATA} ${BENCHER6_DATA} ${BENCHER7_DATA}

# Generate summary_macros.tex
${EXPERIMENT_REPO}/bin/create_summary_macros -o summary_macros.tex ${BENCHER5_DATA} ${BENCHER6_DATA} ${BENCHER7_DATA}

# Generate georges_macros.tex and geroges.tex (a table, which we do not use).
${EXPERIMENT_REPO}/bin/table_georges_comparison -o georges.tex ${BENCHER5_DATA} ${BENCHER6_DATA} ${BENCHER7_DATA}
rm georges.tex
