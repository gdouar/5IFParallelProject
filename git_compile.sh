#!/bin/bash

# checkout git branch and compile the executable
# $1 : the name of the branch
# $2 : the compilation options (CXX_FLAGS)

BRANCH_NAME=$1
COMPIL_OPTIONS=$2

git stash
git stash clear
git checkout ${BRANCH_NAME}

cmake . -DCMAKE_CXX_FLAGS="$COMPIL_OPTIONS"

make
