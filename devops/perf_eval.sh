#!/bin/bash

#The OpenMP compile option
F_OPEN_MP='-fopenmp'

#The -O3 compilation option
O3='-O3'


# The names of the branchs
BRANCH_NAMES='noopt optOrganism optOrganismRunAStepReduction optsAll'

# The compile options for each branch, in the same than BRANCH_NAMES
COMPILE_OPTIONS=('' "${F_OPEN_MP}" "${F_OPEN_MP}" "${O3} ${F_OPEN_MP}")


# The name of the strong scaling CSV results
STRONG_SCALING_CSV='strong_scaling.csv'

# The name of the weak scaling CSV results
WEAK_SCALING_CSV='weak_scaling.csv'

# The directory name of the results
RESULTS_DIR='./'


# The CSV scheme for the strong scaling
STRONG_SCALING_CSV_SCHEME='version,nb_threads,t1,t2,t3,t4,t5,tempsMoyen'

# The CSV scheme for the strong scaling
WEAK_SCALING_CSV_SCHEME='version,nb_threads,t1,t2,t3,t4,t5,tempsMoyen'

# The number of iterations of one type of execution
ITERATIONS=4

# The number of generations in one execution
GENERATIONS=10

# The maximum scaling (must be power of 2)
MAX_SCALING=4


strong_csv_fullname=${RESULTS_DIR}${STRONG_SCALING_CSV}

weak_csv_fullname=${RESULTS_DIR}${WEAK_SCALING_CSV}

# Checkout the results csv from another branch
# $1 : The name of the branch from which checkout is done
function git_checkout_results {

    BRANCH="$1"

    git checkout origin/${BRANCH} ${strong_csv_fullname} ${weak_csv_fullname}
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

    echo "generating graph for strong scaling on ${branch_name}"

    git add ${strong_csv_fullname}
    git commit -m "${strong_csv_fullname}"
    git push

    (( branch_nb++ ))
    prev_branch=${branch_name}
done