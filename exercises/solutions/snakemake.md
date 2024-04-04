# Snakemake Exercise Solutions

**NOTE** the solution are only meant to be a guide, therefore the file paths might not be 100% accurate. 

## 1. Write two New Rules
```Python
rule zipf_test:
    input:
        'results/jane_eyre.dat',
        'results/frankenstein.dat',
        'results/sherlock_holmes.dat'
    output: 'results/results.txt'
    shell: 'python zipf_test.py results/frankenstein.dat results/jane_eyre.dat results/sherlock_holmes.dat > results/results.txt'

rule dats:
    input:
        'jane_eyre.dat',
        'dracula.dat',
        'sherlock_holmes.dat'

# delete everything so we can re-run things
rule clean:
    shell: 'rm -f results/*.dat results/results.txt'

# Count words in one of the books
rule count_words:
    input: 'data/frankenstein.txt'
    output: 'results/frankenstein.dat'
    shell: 'python wordcount.py data/frankenstein.txt results/frankenstein.dat'

rule count_words_jane:
    input: 'data/jane_eyre.txt'
    output: 'results/jane_eyre.dat'
    shell: 'python wordcount.py data/jane_eyre.txt results/jane_eyre.dat'

rule count_words_sherlock:
    input: 'data/sherlock_holmes.txt'
    output: 'results/sherlock_holmes.dat'
    shell: 'python wordcount.py data/sherlock_holmes.txt results/sherlock_holmes.dat'
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
    output: 'results/dracula.dat'
    shell: 'python wordcount.py {input} {output}'

```
## 4. Updating One Input File

3. only last.dat and results.txt are recreated

## 5. Updating Zipf_test rule

```Python
rule zipf_test:
    input:  'zipf_test.py', 'results/dracula.dat', 'results/frankenstein.dat', 'results/sherlock_holmes.dat'
    output: 'results.txt'
    shell:  'python {input[0]} {input[1]} {input[2]} {input[3]} > {output}'
```

## 6. Putting it all Together

The critical change is to the assignment of `DATS`, building it dynamically from the input `*.txt` file names.

```Python
DATS = expand('{book}.dat', book=glob_wildcards('./data/{book}.txt').book)
```

## 7. Moving the `dat` files

First update the `DATS` variable with the `dats` directory:
```Python
DATS = expand('dats/{file}.dat', file=glob_wildcards('./books/{book}.txt').book)
```

Then update `count_words` so the dat files get created in the same place:

```Python
rule count_words:
    input:
        cmd='wordcount.py',
        book='data/{file}.txt'
    output: 'results/dats/{file}.dat'
    shell: 'python {input.cmd} {input.book} {output}'
```

Finally, update the `clean` rule to remove the `dats` directory:

```Python
rule clean:
      shell: 'rm -rf results/dats/ *.dat results/results.txt'
```
 *Note that in the clean rule there is no harm from keeping the `*.dat` pattern in the `rm` command even though no new files will be created in that location. It will help clean up if you forgot to run `snakemake clean` before updating the Snakefile.*
 

## 8. Creating PNGs

 Modify the `clean` rule and add a new pattern rule `make_plot`:
```Python
# delete everything so we can re-run things
rule clean:
     shell: 'rm -rf dats/ plots/ *.dat results.txt'

# plot one word count dat file
rule make_plot:
     input:
         cmd='plotcount.py',
         dat='dats/{file}.dat'
     output: 'plots/{file}.png'
     shell: 'python {input.cmd} {input.dat} {output}'
```

## 9. Generating Plots
First, we modify the existing code that builds `DATS` to first extract the list of book names, and then to build `DATS` and a new global variable `PLOTS`listing all plots:
```Python

# Build the list of book names. We need to use it multiple times when building
# the lists of files that will be built in the workflow
BOOK_NAMES = glob_wildcards('./data/{book}.txt').book

# The list of all dat files
DATS = expand('dats/{file}.dat', file=BOOK_NAMES)
# The list of all plot files
PLOTS = expand('plots/{file}.png', file=BOOK_NAMES)
```
Now we can define the `all` rule:
```Python
# pseudo-rule that tries to build everything.
# Just add all the final outputs that you want built.
rule all:
    input: 'results.txt', PLOTS
```

## 10. Creating an Archive

First the `create_archive` rule:
```Python
# create an archive with all results
rule create_archive:
    input: 'results.txt', DATS, PLOTS
    output: 'zipf_analysis.tar.gz'
    shell: 'tar -czvf {output} {input}'
```
Then the update to the `clean target`:
```Python
# delete everything so we can re-run things
rule clean:
    shell: 'rm -rf dats/ plots/ *.dat results.txt zipf_analysis.tar.gz'
```

Then the change to `all`. The workflow would still be correct without this step, but since `create_archive` requires building everything, it is simpler to just get `all` to depend on `create_archive`. This means we have just one rule to maintain if we add new outputs later on.

```Python
# pseudo-rule that tries to build everything.
# Just add all the final outputs that you want built.
rule all:
    input: 'zipf_analysis.tar.gz'
```

## 12. What happens if Snakemake does not have enough resources?

Similar to the case where a rule specifies more threads than are available, the rule still runs.

Resource constraints will limit the maximum number of rules that Snakemake will attempt to run at the same time, but not the minimum.
Where sufficient resources are not available, Snakemake will still run at least one task.

Once again, it is up to the code being run by the rule to check that sufficient resources are actually available.

The Bash `if` test approach used for `{threads}` works equally well to check for minimum required resource values. Just use `{resources.gpu}` (or your actual resource name) to access the value.

## 13. Replace all other duplicated strings with global variables
This solution is also available as `.solutions/reduce_duplication/Snakefile-remove-duplicates`.
Possibly the only tricky part is in the `clean` rule where we use
a formatted Python string to build the global variables into the shell
command. We used f-string notation, but `string.format` would also work.

```Python
RESULTS_FILE = 'results.txt'
ARCHIVE_FILE = 'zipf_analysis.tar.gz'

# a single plot file
PLOT_FILE = 'plots/{book}.png'

# a single dat file
DAT_FILE = 'dats/{book}.dat'

# a single input book
BOOK_FILE = 'books/{book}.txt'

# Build the list of book names.
BOOK_NAMES = glob_wildcards(BOOK_FILE).book

# The list of all dat files
ALL_DATS = expand(DAT_FILE, book=BOOK_NAMES)

# The list of all plot files
ALL_PLOTS = expand(PLOT_FILE, book=BOOK_NAMES)

# pseudo-rule that tries to build everything.
# Just add all the final outputs that you want built.
rule all:
    input: ARCHIVE_FILE

# Generate summary table
rule zipf_test:
    input:
        cmd='zipf_test.py',
        dats=ALL_DATS
    output: RESULTS_FILE
    shell:  'python {input.cmd} {input.dats} {output}'

# delete everything so we can re-run things
rule clean:
    shell: f'rm -rf dats/ plots/ {RESULTS_FILE} {ARCHIVE_FILE}'

# Count words in one of the books
rule count_words:
    input:
        cmd='wordcount.py',
        book=BOOK_FILE
    output: DAT_FILE
    shell: 'python {input.cmd} {input.book} {output}'

# plot one word count dat file
rule make_plot:
    input:
        cmd='plotcount.py',
        dat=DAT_FILE
    output: PLOT_FILE
    shell: 'python {input.cmd} {input.dat} {output}'

# create an archive with all results
rule create_archive:
    input: RESULTS_FILE, ALL_DATS, ALL_PLOTS
    output: ARCHIVE_FILE
    shell: 'tar -czvf {output} {input}'
```

## 14 Combining global variables and wildcards in formatted strings

No example code is given here. By this stage you should be able to trust your
own judgement.

**TODO**
If you really need it, a full example of the entire workflow with no duplication and all configurable values moved into a configuration file is in `.solutions/reduce_duplication/Snakefile` and `.solutions/reduce_duplication/config.yaml` in the downloaded code package.

Note that the example uses [f-strings](https://docs.python.org/3/reference/lexical_analysis.html#f-strings), which are only available in Python 3.6
and higher.

If you must use an older version of Python then you can use the older string formatting
methods, although the results will be less concise.
