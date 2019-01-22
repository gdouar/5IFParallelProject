#!/bin/bash

# makes $2 iterations of one execution and get the mean time
# $1 : the name of the command to execute
# $2 : the iterations count
# $3 : the name of the output file
function iter_exec {

    EXEC=$1
    ITERATIONS=$2
    OUTPUT_FILE=$3

    timeSum=0;

    echo "Temps d'execution de $EXEC" > ${OUTPUT_FILE}

    for ((i=0 ; ITERATIONS - $i ; i++))
    do
        echo "execution $i de $EXEC"
        execTime=$( ${EXEC} |tail -n1 )
        let "timeSum=$timeSum + $execTime"
        echo "$execTime" >> ${OUTPUT_FILE}
    done

    echo "Moyenne : " >> ${OUTPUT_FILE}

    echo "scale=1;$timeSum/$ITERATIONS" | bc | tr -d "\n" >> ${OUTPUT_FILE}
}

iter_exec "$1" "$2" "$3"

#    CORES=$1
#    LENGTH=$2
