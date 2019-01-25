#!/bin/bash

# checkout git branch and compile the executable
# $1 : the name of the branch
# $2 : the compilation options (CXX_FLAGS)

BRANCH_NAME=$1
COMPILE_OPTIONS=$2

git fetch
git stash
git stash clear
git checkout -f ${BRANCH_NAME}

rm -f CMakeCache.txt

cd ..
cmake . -DCMAKE_CXX_FLAGS="${COMPILE_OPTIONS}"
make
cd scripts