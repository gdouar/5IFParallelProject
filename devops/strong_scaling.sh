#!/bin/bash

# make a strong scaling by successive powers of 2 on the actual compiled version of pdc_mini_aevol
# $1 : The name of the optimisation
# $2 : The name of the global CSV file for the results of the strong scaling, scheme :
# "opt_name,nb_threads,t1,t2,...,mean_time"
# $3 : The directory of the results
# $4 : The number of iterations of one type of execution
# $5 : The number of generations in one execution
# $6 : The maximum scaling (must be power of 2)
OPT_NAME="$1"
GLOBAL_CSV="$2"
RESULTS_DIR="$3"
ITERATIONS=$4
GENERATIONS=$5
MAX_SCALING=$6

GLOBAL_CSV_FULLNAME="${RESULTS_DIR}${GLOBAL_CSV}"

printf "${OPT_NAME}," >> ${GLOBAL_CSV_FULLNAME}

for (( i=1 ; $MAX_SCALING>=$i ; i=$i * 2 ))
do
    echo "executions with ${i} threads"
    printf "${OPT_NAME},${i}," >> ${GLOBAL_CSV_FULLNAME}
    ./iter_exec.sh "../pdc_mini_aevol -n ${GENERATIONS} --threads ${i}" "${ITERATIONS}" "${GLOBAL_CSV_FULLNAME}"
done

echo "" >> ${GLOBAL_CSV_FULLNAME}

