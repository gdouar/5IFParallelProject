#!/bin/bash

#The OpenMP compile option
F_OPEN_MP='-fopemp'

#The -O3 compilation option
O3='-O3'


# The names of the branchs
BRANCH_NAMES='noopt optOrganism optOrganismRunAStepReduction optsAll'

# The compile options for each branch, in the same than BRANCH_NAMES
COMPILE_OPTIONS=('' "${F_OPEN_MP}" "${F_OPEN_MP}" "${O3} ${F_OPEN_MP}")


# The name of the strong scaling CSV results
STRONG_SCALING_RESULTS='strong_scaling.csv'

# The name of the weak scaling CSV results
WEAK_SCALING_RESULTS='weak_scaling.csv'

# The directory name of the results
RESULTS_DIR='../results/'


# The number of iterations of one type of execution
ITERATIONS=4

# The number of generations in one execution
GENERATIONS=1000

# The maximum scaling (must be power of 2)
MAX_SCALING=16




# Checkout the results csv from another branch
# $1 : The name of the branch from which checkout is done
function git_checkout_results {

    BRANCH="$1"

    git checkout origin/${BRANCH} ${RESULTS_DIR}${STRONG_SCALING_RESULTS} ${RESULTS_DIR}${WEAK_SCALING_RESULTS}
}




# Run the global process of performance evaluation (weak and strong scaling)

prev_branch=
branch_nber=0

for branch_name in ${BRANCH_NAMES}
do
    # checkout and compile the branch
    ./git_compile.sh ${branch_name} ${COMPILE_OPTIONS[${branch_nber}]}

    # if it is not the first branch on which the perf eval is done, retrieve the previous results
    if [[ -n ${prev_branch} ]]
    then
        git_checkout_results ${prev_branch}
    else
        mkdir -p ${RESULTS_DIR}
    fi

    ./strong_scaling.sh ${branch_name} ${STRONG_SCALING_RESULTS} ${ITERATIONS} ${GENERATIONS} ${MAX_SCALING}

    (( branch_nber++ ))
    prev_branch=${branch_name}
done