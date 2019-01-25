#!/bin/bash

# makes $2 iterations of one execution and save the time of each execution and the mean time
# $1 : the name of the command to execute
# $2 : the iterations count
# $3 : the name of the output CSV file where each time and the mean time is saved, scheme : "t1,t2,...,meanTime"
EXEC="$1"
ITERATIONS=$2
OUTPUT_CSV="$3"

timeSum=0;

for (( i=0 ; $ITERATIONS - $i ; i++ ))
do
    echo "execution $i of $EXEC"
    execTime=$( ${EXEC} |tail -n1 )
    execTime=$(echo "scale=3;$execTime/1000" | bc | tr -d "\n")
    timeSum=$(echo "scale=3;${timeSum} + ${execTime}" | bc | tr -d "\n")
    printf "${execTime}," >> ${OUTPUT_CSV}
done

echo "scale=3;$timeSum/$ITERATIONS" | bc >> ${OUTPUT_CSV}
