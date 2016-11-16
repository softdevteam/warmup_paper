#!/bin/bash

#
# Requires JSON files with outliers and classifications.
#

EXPERIMENT_REPO=../warmup_experiment/
BENCHER3_DATA=bencher3_warmup_07.json.bz2
BENCHER5_DATA=bencher5_warmup_07.json.bz2
BENCHER6_DATA=bencher6_warmup_07.json.bz2

# Generate outlier_summaries.tex
${EXPERIMENT_REPO}/bin/create_outlier_macros -o outlier_summaries.tex ${BENCHER3_DATA} ${BENCHER5_DATA} ${BENCHER6_DATA}

# Generate summary_macros.tex
${EXPERIMENT_REPO}/bin/create_summary_macros -o summary_macros.tex ${BENCHER3_DATA} ${BENCHER5_DATA} ${BENCHER6_DATA}
