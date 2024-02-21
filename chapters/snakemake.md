# Snake Make 

## Section 0: setup (readthedocs snakemake)

## Section 1: Introduction (carpenters)

1. Introduction to the example workflow
    1. layout of example package
    2. book files
    3. running the wordcount script manually
    4. running plotcount
    5. testing for zipf's law
    6. bash version of a workflow and discussion of limitations

## Section 2: Snakemake

3. Snakefiles
    1. count words
    2. running snakemake
    3. clean rule
    4. default rule is first in the file
4. Wildcards
   1. Keep it DRY
   2. highlight duplication in current Snakefile
   3. introduce wildcards
   4. cleaning up dependencies
5. Pattern rules
   1. identify remaining duplication in word count rules: they have a common pattern
   2. wildcards
   3. replace all count words rules with a single pattern rule
6. Snakefiles are Python code
   1. importing and calling python functions
   2. simplify dynamic handling of input files
7. Adding remaining stages to pipeline
   1. Creating png plots
   2. Creating an archive.
   3. Adding more books
8. Resources and parallelism
9. Submitting to a SLURM cluster

## Advanced: Decorating the example workflow

## Additional features 
benchmarking .... 

## Section 3: Best Practices (read the docs snakemake)


-----------------------------------------------------------
EXERCISES
- Exercise use the genome example as exercise example. 
- use additional example from readthedocs
