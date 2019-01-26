#!/bin/bash

#The OpenMP compile option
F_OPEN_MP='-fopenmp'

#The -O3 compilation option
O3='-O3'



# The names of the branchs
BRANCH_NAMES='noopt optOrganism optOrganismRunAStepReduction optsAll'

# The compile options for each branch, in the same than BRANCH_NAMES
COMPILE_OPTIONS=('' "${F_OPEN_MP}" "${F_OPEN_MP}" "${O3} ${F_OPEN_MP}")



# The directory name of the results
RESULTS_DIR='./'

# The name of the strong scaling CSV results
STRONG_SCALING_CSV='strong_scaling.csv'

# The name of the weak scaling CSV results
WEAK_SCALING_CSV='weak_scaling.csv'

# The name of the strong scaling graph
STRONG_SCALING_GRAPH='strong_scaling.png'

# The name of the weak scaling graph
WEAK_SCALING_GRAPH='weak_scaling.png'

# The CSV scheme for the strong scaling
STRONG_SCALING_CSV_SCHEME='version,nb_threads,t1,t2,t3,t4,t5,tempsMoyen'

# The CSV scheme for the strong scaling
WEAK_SCALING_CSV_SCHEME='version,nb_threads,t1,t2,t3,t4,t5,tempsMoyen'



# The number of iterations of one type of execution
ITERATIONS=5

# The number of generations in one execution
GENERATIONS=10

# The maximum scaling (must be power of 2)
MAX_SCALING=4

# The start size of the side of the population grid for the weak scaling
START_SIDE=16


strong_csv_fullname=${RESULTS_DIR}${STRONG_SCALING_CSV}
weak_csv_fullname=${RESULTS_DIR}${WEAK_SCALING_CSV}
strong_graph_fullname=${RESULTS_DIR}${STRONG_SCALING_GRAPH}
weak_graph_fullname=${RESULTS_DIR}${WEAK_SCALING_GRAPH}

# Checkout the results csv from another branch
# $1 : The name of the branch from which checkout is done
function git_checkout_results {

    BRANCH="$1"

    git checkout ${BRANCH} ${strong_csv_fullname} ${weak_csv_fullname}
}

# Commit the results csv
function git_commit_results {

    git add "${strong_csv_fullname}" "${weak_csv_fullname}"
    git commit -m "${strong_csv_fullname}"
}

# Run the global process of performance evaluation (weak and strong scaling)

prev_branch=
branch_nb=0

for branch_name in ${BRANCH_NAMES}
do
    # checkout and compile the branch
    echo "checkout branch ${branch_name} with compilation options : ${COMPILE_OPTIONS[${branch_nb}]}"
    ./git_compile.sh "${branch_name}" "${COMPILE_OPTIONS[${branch_nb}]}"

    # if it is not the first branch on which the perf eval is done, retrieve the previous results
    if [[ -n ${prev_branch} ]]
    then
        echo "checkout the results from ${prev_branch}"
        git_checkout_results ${prev_branch}
    else
        # else create the results files
        echo "create results files"
        mkdir -p ${RESULTS_DIR}
        echo ${STRONG_SCALING_CSV_SCHEME} > ${strong_csv_fullname}
        echo ${WEAK_SCALING_CSV_SCHEME} > ${weak_csv_fullname}
    fi

    echo "make strong scaling on ${branch_name}"
    ./strong_scaling.sh "${branch_name}" "${STRONG_SCALING_CSV}" "${RESULTS_DIR}" ${ITERATIONS} ${GENERATIONS} ${MAX_SCALING}

    echo "make weak scaling on ${branch_name}"
    ./weak_scaling.sh "${branch_name}" "${WEAK_SCALING_CSV}" "${RESULTS_DIR}" ${ITERATIONS} ${GENERATIONS} ${MAX_SCALING} ${START_SIDE}

    echo "generating graphs for strong scaling on ${branch_name}"
    Rscript ./graph-scaling.r --file=${strong_csv_fullname} --graph=${strong_graph_fullname}

    echo "generating graphs for weak scaling on ${branch_name}"
    Rscript ./graph-scaling.r --file=${weak_csv_fullname} --graph=${weak_graph_fullname}

    git_commit_results

    (( branch_nb++ ))
    prev_branch=${branch_name}
done
