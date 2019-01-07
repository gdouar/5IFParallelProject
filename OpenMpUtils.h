//
// Created by pierre-louis on 07/01/19.
//

#ifndef PDC_MINI_AEVOL_OPENMPUTILS_H

typedef struct OmpCompare
{
    double val;
    int index;
} OmpCompare;

#pragma omp declare reduction(minindex : OmpCompare : omp_out = omp_in.val < omp_out.val ? omp_in : omp_out)

#define PDC_MINI_AEVOL_OPENMPUTILS_H

#endif //PDC_MINI_AEVOL_OPENMPUTILS_H
