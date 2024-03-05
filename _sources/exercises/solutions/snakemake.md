# Snakemake Exercise Solutions

## 1. Write two New Rules
```Python
rule zipf_test:
    input:
        'data/jane_eyre.dat',
        'data/frankenstein.dat',
        'data/sherlock_holmes.dat'
    output: 'data/results.txt'
    shell: 'python zipf_test.py data/frankenstein.dat data/jane_eyre.dat data/sherlock_holmes.dat > data/results.txt'

rule dats:
    input:
        'isles.dat',
        'abyss.dat',
        'sherlock_holmes.dat'

# delete everything so we can re-run things
rule clean:
    shell: 'rm -f data/*.dat data/results.txt'

# Count words in one of the books
rule count_words:
    input: 'data/frankenstein.txt'
    output: 'data/frankenstein.dat'
    shell: 'python wordcount.py data/frankenstein.txt data/frankenstein.dat'

rule count_words_jane:
    input: 'data/jane_eyre.txt'
    output: 'data/jane_eyre.dat'
    shell: 'python wordcount.py data/jane_eyre.txt data/jane_eyre.dat'

rule count_words_sherlock:
    input: 'data/sherlock_holmes.txt'
    output: 'data/sherlock_holmes.dat'
    shell: 'python wordcount.py data/sherlock_holmes.txt data/sherlock_holmes.dat'
```
## 2. Update Dependencies

 Only `results.txt` recreated.

The rules for `*.dat` are not executed because their corresponding `.txt` files haven't been modified.

if you run :
```bash
touch data/*.txt
snakemake results.txt
```

## 3. Rewrite .dat rules to use wildcards

```Python
rule count_words:
    input: 'data/dracula.txt'
    output: 'data/dracula.dat'
    shell: 'python wordcount.py {input} {output}'

```
## 4. Updating One Input File

3. only last.dat and results.txt are recreated

## 5. Updating Zipf_test rule

```Python
rule zipf_test:
    input:  'zipf_test.py', 'data/dracula.dat', 'data/frankenstein.dat', 'data/last.dat'
    output: 'results.txt'
    shell:  'python {input[0]} {input[1]} {input[2]} {input[3]} > {output}'
```
