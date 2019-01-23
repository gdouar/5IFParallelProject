#!/bin/bash

# Run the global process of performance evaluation


# Checkout results of another branch
# $1 : Results file name
# $2 : Name of the branch from which checkout
function git_checkout_results {

    RESULTS="$1"
    BRANCH="$2"

    git checkout origin/${BRANCH} ./results/${RESULTS}
}
