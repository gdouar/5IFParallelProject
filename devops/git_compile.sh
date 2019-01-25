#!/bin/bash

# checkout git branch and compile the executable
# $1 : the name of the branch
# $2 : the compilation options (CXX_FLAGS)

BRANCH_NAME=$1
COMPILE_OPTIONS=$2

# checkout
git fetch
git stash
git stash clear
git checkout -f ${BRANCH_NAME}
git pull

# compilation
cd ..
rm -f CMakeCache.txt
cmake . -DCMAKE_CXX_FLAGS="${COMPILE_OPTIONS}"
make
cd devops