#!/bin/bash

# make a strong scaling by successive powers of 2 on the actual compiled version of pdc_mini_aevol
# $1 : The name of the optimisation
# $2 : The name of the global CSV file for the results of the strong scaling
# $3 : The
# $4 : The number of iterations of one type of execution
# $5 : The number of generations in one execution
# $6 : The maximum scaling (must be power of 2)
OPT_NAME="$1"
GLOBAL_RESULTS="$2"
RESULTS_DIR="$3"
ITERATIONS=$4
GENERATIONS=$5
MAX_SCALING=$6

GLOBAL_RESULTS_FULLNAME="${RESULTS_DIR}${GLOBAL_RESULTS}"

printf "${OPT_NAME}," >> ${GLOBAL_RESULTS_FULLNAME}

for ((i=1 ; $MAX_SCALING>=$i ; i=$i * 2))
do
    temp_results="${RESULTS_DIR}strong_scaling_${OPT_NAME}_${i}_threads.csv"

    ./iter_exec.sh "../pdc_mini_aevol -n ${GENERATIONS} --threads ${i}" "${ITERATIONS}" "${temp_results}"
    printf "$(tail -n1 ${temp_results})," >> ${GLOBAL_RESULTS_FULLNAME}
done

echo "" >> ${GLOBAL_RESULTS_FULLNAME}

