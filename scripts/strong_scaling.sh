#!/bin/bash

ITERATIONS=4
GENERATIONS=10

# make a strong scaling by successive powers of 2 on the actual compiled version of pdc_mini_aevol
# $1 : the maximum scaling (must be power of 2)
# $2 : the name of the optimisation
function strong_scaling {

    local MAX_SCALING=$1
    local OPT_NAME=$2

    for ((i=1 ; $MAX_SCALING>=$i ; i=$i * 2))
    do
        ./iter_exec "./pdc_mini_aevol -n ${GENERATIONS} --threads $i" "${ITERATIONS}" "results/strong_scaling_${OPT_NAME}_$i.csv"
    done
}



#    CORES=$1
#    LENGTH=$2
