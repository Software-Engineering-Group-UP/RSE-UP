# Introduction to Workflows

This section will give an introdution to workflows in general and more specificly make and snakemake. 

While the Advanced part is still a **WIP** the outline will be as follows:

## Introduction
0. Introduction to Workflows and Make

## Snakemake

1. Introduction to the example workflow
    1. layout of example package
    2. book files
    3. running the wordcount script manually
    4. running plotcount
    5. testing for zipf's law
    6. bash version of a workflow and discussion of limitations

2. Snakefiles
    1. count words
    2. running snakemake
    3. clean rule
    4. default rule is first in the file

3. Wildcards
   1. Keep it DRY
   2. highlight duplication in current Snakefile
   3. introduce wildcards
   4. cleaning up dependencies
4. Pattern rules
   1. identify remaining duplication in word count rules: they have a common pattern
   2. wildcards
   3. replace all count words rules with a single pattern rule
5. Snakefiles are Python code
   1. importing and calling python functions
   2. simplify dynamic handling of input files
6. Adding remaining stages to pipeline
   1. Creating png plots
   2. Creating an archive.
   3. Adding more books
7. Resources and parallelism
8. Submitting to a SLURM cluster

## Advanced: Decorating the example workflow 
**need for discussion WIP**

9. benchmarking .... 

