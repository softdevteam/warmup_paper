#!/bin/bash

#
# Requires JSON files with outliers and classifications.
#

EXPERIMENT_REPO=../warmup_experiment/

# Results files must be annotated with classifications and outliers.
# XXX when you next re-generate the tables, please change the filenames to ones
# like DACAPO_DATA, with the version and window size explicit.
BENCHER3_DATA=bencher3_warmup_07.json.bz2
BENCHER5_DATA=bencher5_warmup_07.json.bz2
BENCHER6_DATA=bencher6_warmup_07.json.bz2
OCTANE_DATA="octane_v8.json.bz2 octane_spidermonkey.json.bz2"
DACAPO_DATA="dacapo_graal_results_0_8_linux2_i7_4790_outliers_w200_changepoints.json.bz2 dacapo_hotspot_results_0_8_linux2_i7_4790_outliers_w200_changepoints.json.bz2"
STARTUP_DATA=startup.json.bz2


# Generate octane.table
${EXPERIMENT_REPO}/bin/table_classification_summaries_others -s 2 -o octane.table ${OCTANE_DATA}

# Generate dacapo.table
${EXPERIMENT_REPO}/bin/table_classification_summaries_others -s 2 -o dacapo.table ${DACAPO_DATA}

# Generate startup.table
${EXPERIMENT_REPO}/bin/table_startup_results -o startup.table ${STARTUP_DATA}

# Generate bencherN.table files
${EXPERIMENT_REPO}/bin/table_classification_summaries_main -o bencher3.table ${BENCHER3_DATA}
${EXPERIMENT_REPO}/bin/table_classification_summaries_main -o bencher5.table ${BENCHER5_DATA}
${EXPERIMENT_REPO}/bin/table_classification_summaries_main -o bencher6.table ${BENCHER6_DATA}
