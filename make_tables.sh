#!/bin/bash

#
# Requires JSON files with outliers and classifications.
#

EXPERIMENT_REPO=../warmup_experiment/
BENCHER3_DATA=bencher3_warmup_07.json.bz2
BENCHER5_DATA=bencher5_warmup_07.json.bz2
BENCHER6_DATA=bencher6_warmup_07.json.bz2
OCTANE_DATA=octane.v8.json.bz2 octane.spidermonkey.json.bz2
DACAPO_DATA=dacapo.graal.json.bz2 dacapo.hotspot.json.bz2
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
