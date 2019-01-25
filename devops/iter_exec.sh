#!/bin/bash

# makes $2 iterations of one execution and get the mean time
# $1 : the name of the command to execute
# $2 : the iterations count
# $3 : the name of the output file when each time and the mean time is saved
EXEC="$1"
ITERATIONS=$2
OUTPUT_FILE="$3"

timeSum=0;

echo "Execution times of $EXEC" > ${OUTPUT_FILE}

for ((i=0 ; $ITERATIONS - $i ; i++))
do
    echo "execution $i of $EXEC"
    execTime=$( ${EXEC} |tail -n1 )
    let "timeSum=$timeSum + $execTime"
    echo "$execTime" >> ${OUTPUT_FILE}
done

echo "Mean : " >> ${OUTPUT_FILE}

echo "scale=1;$timeSum/$ITERATIONS" | bc | tr -d "\n" >> ${OUTPUT_FILE}
