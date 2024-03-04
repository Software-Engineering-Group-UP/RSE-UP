# Snakemake Exercises

## 1 Write two new rules

1. Write a new rule for creating last.dat from data//last.txt. Call the rule count_words_last.

2. Update the dats rule with this target.

3. Write a new rule called zipf_test to write the summary table to results.txt. The rule needs to:
  - Depend upon each of the three .dat files.
  - Invoke the action python zipf_test.py jane_eyre.dat frankenstein.dat last.dat > results.txt.
  - Be the default target.

4. Update clean so that it removes results.txt.

## 2. Update Dependencies 

What will happen if you now execute:

```Python
touch *.dat
snakemake results.txt

```
1. nothing
2. all files recreated
3. only .dat files recreated
4. only results.txt recreated

## 3. Rewrite .dat rules to use wildcards

Rewrite each `.dat` rule to use the `{input}` and `{output}` wildcards.


## 4. Updating One Input File

What will happen if you now execute:

```bash
touch data/last.txt
snakemake results.txt
```

1. only last.dat is recreated
2. all .dat files are recreated
3. only last.dat and results.txt are recreated
4. all .dat and results.txt are recreated

## 5. Update `count_words_last` to depend on `wordcount.py`

Add zipf_test.py as a dependency of results.txt. We haven't yet covered the techniques required to do this with named wildcards so you will have to use indexing. Yes, this will be clunky, but we'll fix that part later!

Remember that you can do a dry run with snakemake -n -p!
