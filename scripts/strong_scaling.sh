#!/bin/bash

# Make a strong scaling by successive powers of 2 on the actual compiled version of pdc_mini_aevol
# $1 : the name of the optimisation
OPT_NAME="$1"

# The name of the global CSV file for the results of the strong scaling
GLOBAL_RESULTS="../results/strong_scaling.csv"

# The number of iteration of one type of execution
ITERATIONS=4

# The number of generations in one execution
GENERATIONS=1000

# The maximum scaling (must be power of 2)
MAX_SCALING=16

printf "${OPT_NAME}," >> ${GLOBAL_RESULTS}

for ((i=1 ; $MAX_SCALING>=$i ; i=$i * 2))
do
    TEMP_RESULTS="../results/strong_scaling_${OPT_NAME}_${i}_threads.csv"

    ./iter_exec.sh "../pdc_mini_aevol -n ${GENERATIONS} --threads ${i}" "${ITERATIONS}" "${TEMP_RESULTS}"
    printf "$(tail -n1 ${TEMP_RESULTS})," >> ${GLOBAL_RESULTS}
done

echo "" >> ${GLOBAL_RESULTS}

