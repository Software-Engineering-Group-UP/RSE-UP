# Snakemake Continued

Snakemake stands out among data processing tools for its versatility and user-friendliness. It empowers researchers to create reproducible and scalable analyses through a human-readable, Python-based language. If you're familiar with the make tool, picking up Snakemake will be a breeze.

## Building the Workflow: The Snakefile

The heart of Snakemake lies in the Snakefile, acting as its build file. It defines a series of rules dictating the workflow's execution. Each rule details how to produce a specific target (output) using its required dependencies (inputs) and the necessary actions.

### Getting started - Executing Snakemake:

By default, running Snakemake without specifying a target prompts it to search for a file named Snakefile. Upon execution, it provides details about the workflow, including the number of steps, involved rules, input and output files.
Therefore we need to create a `snakefile`. For the purpose of the course we start with an example that counts words. 

```python
# Count words in one of the books
rule count_words:
    input: '../data/dracula.txt'
    output: '../data/dracula.dat'
    shell: 'python wordcount.py ../data/dracula.txt ../data/dracula.dat'
```
This is a **build file**, which for Snakemake is called a
Snakefile - a file executed by Snakemake. Note that aside from a few keyword
additions like `rule`, it follows standard Python 3 syntax.

The parts included in to the snakefile are explained as follows:

- **Comments**: Lines starting with # provide explanations and are ignored by Snakemake.

- **Target**: This represents the desired outcome, denoted by a filename (e.g., dracula.dat).

- **Dependencies**: These are files (e.g., data/dracula.txt) needed to create or update the target.

- **Action**: This shell command (e.g., python wordcount.py data/dracula.txt dracula.dat) is responsible for generating or updating the target using the dependencies.

*Snakemake follows Python 3 syntax*, introducing keywords like rule. Indentation, whether using tabs or spaces, adheres to Python conventions. A rule combines target, dependencies, and actions, forming a "recipe" for a specific step in the workflow. 

The rule we just created describes how to build the output `dracula.dat` using
the action `python wordcount.py` and the input `data/dracula.txt`.

Information that was implicit in our shell script - that we are generating a
file called `dracula.dat` and that creating this file requires
`data/dracula.txt` - is now made explicit by Snakemake's syntax.

Let's first ensure we start from scratch and delete the `.dat`, `.png`, and
`results.txt` files we created earlier:

```bash
rm *.dat *.png results.txt
```

to run snakemake we just have to call it while being in the same directory:
```bash
snakemake
```
Depending on your system the following error message may appear:
```output
Assuming unrestricted shared filesystem usage for local execution.
Error: cores have to be specified for local execution (use --cores N with N being a number >= 1 or 'all')
```

Instead run the following:
```bash
snakemake --cores all
```

By default, Snakemake tells us what it's doing as it executes actions:

```output
Assuming unrestricted shared filesystem usage for local execution.
Building DAG of jobs...
Using shell: /usr/bin/bash
Provided cores: 8
Rules claiming more threads will be scaled down.
Job stats:
job            count
-----------  -------
count_words        1
total              1

Select jobs to execute...
Execute 1 jobs...

[Sun Feb 18 15:30:44 2024]
localrule count_words:
    input: ../data/dracula.txt
    output: ../data/dracula.dat
    jobid: 0
    reason: Missing output files: ../data/dracula.dat
    resources: tmpdir=/tmp

[Sun Feb  18 15:30:44 2024]
Finished job 0.
1 of 1 steps (100%) done
Complete log: .snakemake/log/2024-02-18T153044.591897.snakemake.log
```

If there are errors, check your syntax. Remember, aside from new keywords
like `rule` and `input`, Snakemake follows Python syntax. Let's see if we got
what we expected:

```bash
head -5 ../data/dracula.dat
```
The output should look like this:

```output
the 8089 4.836269931901207
and 5976 3.5729446301201144
i 4846 2.897337630114136
to 4745 2.836951517724221
of 3748 2.240862863736645
```

If you now try to rerun snakemake the following error will occur: 
```output
Assuming unrestricted shared filesystem usage for local execution.
Building DAG of jobs...
Nothing to be done (all requested files are present and up to date).
```

This basicly means that since the output files are already present the workflow is not re-run. To re-run the snakefile just delete the `.dat`.  

At the same time snakemake checks the last modification time, if `.dat` is younger than the input `.txt` file it won't rerun but if changes where done and save to the `.txt` file and there by make the modification *younger* than the `.dat`, snakemake will re-run the workflow. 

An argument for this approach would be that only rebuilding files when required, makes processing more efficient.  

It also important to note snakefiles do not need to be named `snakefile`, you only need to tell snakemake the name on usage. This means you can have snakefiles for multiple workflows stored in the same location. 

For example using the `-s` flag / option:
```bash
snakemake -s snakefileXYZ
```

### Snakefiles as Documentation

By explicitly recording the inputs to and outputs from steps in our analysis and the dependencies between files, Snakefiles act as a type of documentation, reducing the number of things we have to remember.

We can add additional rules to the snakefile i.e.:
```python
rule count_words:
    input: '../data/dracula.txt'
    output: '../data/dracula.dat'
    shell: 'python wordcount.py ../data/dracula.txt ../data/dracula.dat'

rule count_words_moby_dick:
	input: 	'../data/moby_dick.txt'
	output: '../data/moby.dat'
	shell: 	'python wordcount.py ../data/moby_dick.txt ../data/moby.dat'

```

If you run snakemake now, nothing will happen, since snakemake will by default choose the firt rule, ignoring the others. to change this you need to ru the following command instead:

```bash
snakemake --cores all ../data/moby.dat
```
This will give the following output: 
```output
Assuming unrestricted shared filesystem usage for local execution.
Building DAG of jobs...
Using shell: /usr/bin/bash
Provided cores: 8
Rules claiming more threads will be scaled down.
Job stats:
job                      count
---------------------  -------
count_words_moby_dick        1
total                        1

Select jobs to execute...
Execute 1 jobs...

[Sun Feb  18 16:14:46 2024]
localrule count_words_moby_dick:
    input: ../data/moby_dick.txt
    output: ../data/moby.dat
    jobid: 0
    reason: Missing output files: ../data/moby.dat
    resources: tmpdir=/tmp

[Sun Feb  18 16:14:46 2024]
Finished job 0.
1 of 1 steps (100%) done
Complete log: .snakemake/log/2024-02-18T161446.301442.snakemake.log
```
### Nothing to be Done and MissingRuleException

As you might have seen earlier, if the output file already exists snakemake will return the sentence: '`nothing to be done`'.

But if you try to invoke a rule that does exists, the missing rule exception will be triggered. This looks like this:

```bash
$ snakemake what.dat

MissingRuleException:
No rule to produce what.dat (if you use input functions make sure that they
don't raise unexpected exceptions).
```
You need check the spelling of `what.dat` to fix this. 

### Remove all Rule

One could also create a rule that deletes all output, this could look like the following:

```Python
# delete everything so we can re-run things
rule clean:
    shell: 'rm -f *.dat'
```

### Dependencies

Often workflows have dependencies or files that need be created before running a certain rule. In the following example, the rule `dats` relies on the input files dracula.dat and moby_dick.dat.  

```Python
rule dats:
    input:
          'dracula.dat'
          'moby_dick.dat'
```

If you run snakemake now, snakemake will first check whether or not the input files exist and if not snakemake will look for rules that generate the input files and run them. It is important to note that dependencies must form a directed acyclic graph. A target cannot depend on a dependency which itself, or one of its dependencies, depends on that target.

The output of 

```bash
snakemake --cores 1 dats
```
will look like this 
```Output
Provided cores: 1
Rules claiming more threads will be scaled down.
Job counts:
        count   jobs
        1       count_words
        1       count_words_abyss
        1       dats
        3

rule count_words_abyss:
    input: ../data/moby_dick.txt
    output: ../data/moby_dick.dat
    jobid: 1

Finished job 1.
1 of 3 steps (33%) done

rule count_words:
    input: ../data/dracula.txt
    output: ../data/dracula.dat
    jobid: 2

Finished job 2.
2 of 3 steps (67%) done

localrule dats:
    input: ../data/dracula.dat, ../data/moby_dick.dat
    jobid: 0

Finished job 0.
3 of 3 steps (100%) done
```

While the snakefile should look as follows:
```Python
rule dats:
     input:
         '../data/dracula.dat',
         '../data/moby_dick.dat'

# delete everything so we can re-run things
rule clean:
    shell:  'rm -f *.dat'

# Count words in one of the books
rule count_words:
    input: 	'../data/dracula.txt'
    output: '../data/dracula.dat'
    shell: 	'python wordcount.py ../data/dracula.txt ../data/dracula.dat'

rule count_words_abyss:
    input: 	'../data/moby_dick.txt'
    output: '../data/moby_dick.dat'
    shell: 	'python wordcount.py ../data/moby_dick.txt ../data/moby_dick.dat'
```
the directed graph of the dependencies looks like this: 

```{figure} ../figures/snakemake/dats_graph.svg
:name: dats graph
Dats Graph
```
### Debugging

At this point, it becomes important to see what snakemake is doing behind the scenes. What commands is snakemake actually running? Snakemake has a special option (-p), that prints every command it is about to run. Additionally, we can also perform a dry run with -n. A dry run does nothing, and simply prints out commands instead of actually executing them. Very useful for debugging!

```bash
snakemake clean
snakemake -n -p dracula.dat

```

```Output
Building DAG of jobs...
Job counts:
	count	jobs
	1	count_words
	1

rule count_words:
    input: ../data/dracula.txt
    output: ../data/dracula.dat
    jobid: 0 

python wordcount.py ../data/dracula.txt ../data/dracula.dat
Job counts:
	count	jobs
	1	count_words
	1
This was a dry-run (flag -n). The order of jobs does not reflect the order of execution.
```
**Before you continue with the book below, it is advised to first look at the exercise: [Write two new rules](https://software-engineering-group-up.github.io/RSE-UP/exercises/snakemake.html) since it would come in handy for the next section. 

## Wildcards

When you have completed the exercise, you notice that there is a lot of duplications and repetitions. It is always good practice to not repeat yourself. 
Let's start from the top on go rule by rule and refactor the snakefile.
```Python
rule zipf_test:
    input: 'data/jane_eyre.dat','data/frankenstein.dat', 'data/sherlock_holmes.dat'
    output: 'data/results.txt'
    shell: 'python zipf_test.py data/frankenstein.dat data/jane_eyre.dat data/sherlock_holmes.dat > data/results.txt'

```
Here we can shorten the shell command by using variables. 
This could look like the following, were we add an `{input}` and `{output}` **wildcards**.

```Python
rule zipf_test:
    input: 'data/jane_eyre.dat', 'data/frankenstein.dat', 'data/sherlock_holmes.dat'
    output: 'data/results.txt'
    shell: 'python zipf_test.py {input} > {output}'
  
```

## Handling dependencies differently

For many rules, we will need to make finer distinctions between inputs. It is not always appropriate to pass all inputs as a lump to your action. For example, our rules for `.dat` use their first (and only) dependency specifically as the input file to `wordcount.py`. If we add additional dependencies (as we will soon do) then we don't want these being passed as input files to `wordcount.py`: it expects just one input file.

Let's see this in action. We need to add wordcount.py as a dependency of each of our data files so that the rules will be executed if the script changes. In this case, we can use `{input[0]}` to refer to the first dependency, and `{input[1]}` to refer to the second:

```Python
rule count_words:
    input: 'wordcount.py', 'data/dracula.txt'
    output: 'dracula.dat'
    shell: 'python {input[0]} {input[1]} {output}'
```

Alternatively, we can name our dependencies:
```Python
rule count_words_frankenstein:
    input:
        cmd='wordcount.py',
        book='data/frankenstein.txt'
    output: 'frankenstein.dat'
    shell: 'python {input.cmd} {input.book} {output}'
```

Let's mark `wordcount.py` as updated, and re-run the pipeline:

```bash
touch wordcount.py
snakemake
```
```Output
Provided cores: 1
Rules claiming more threads will be scaled down.
Job counts:
	count	jobs
	1	count_words
	1	count_words_frankenstein
	1	zipf_test
	3

rule count_words_frankenstein:
    input: wordcount.py, data/frankenstein.txt
    output: data/frankenstein.dat
    jobid: 2

Finished job 2.
1 of 3 steps (33%) done

rule count_words:
    input: wordcount.py, data/dracula.txt
    output: data/dracula.dat
    jobid: 1

Finished job 1.
2 of 3 steps (67%) done

rule zipf_test:
    input: data/frankenstein.dat, data/last.dat, data/dracula.dat
    output: results.txt
    jobid: 0

Finished job 0.
3 of 3 steps (100%) done
```

Notice how `jane_eyre.dat` (which does not depend on `wordcount.py`) is not rebuilt.

Intuitively, we should also add `wordcount.py` as dependency for `results.txt`, as the final table should be rebuilt if we remake the .dat files. However, it turns out we don't have to! Let's see what happens to `results.txt` when we update `wordcount.py`:
```Bash
touch wordcount.py
snakemake results.txt
```

then we get:
```bash
Provided cores: 1
Rules claiming more threads will be scaled down.
Job counts:
	count	jobs
	1	count_words
	1	count_words_frankenstein
	1	zipf_test
	3

rule count_words_frankenstein:
    input: wordcount.py, data/data/frankenstein.txt
    output: data/frankenstein.dat
    jobid: 2

Finished job 2.
1 of 3 steps (33%) done

rule count_words:
    input: wordcount.py, data/dracula.txt
    output: data/dracula.dat
    jobid: 1

Finished job 1.
2 of 3 steps (67%) done

rule zipf_test:
    input: data/frankenstein.dat, data/last.dat, dracula.dat
    output: results.txt
    jobid: 0

Finished job 0.
3 of 3 steps (100%) done
```

The whole pipeline is triggered, even the creation of the `results.txt` file! To understand this, note that according to the dependency graph, `results.txt` depends on the `.dat` files. The update of `wordcount.py` triggers an update of the *.dat files. Thus, Snakemake sees that the dependencies (the `.dat` files) are newer than the target file (`results.txt`) and it therefore recreates `results.txt`. This is an example of the power of Snakemake: updating a subset of the files in the pipeline triggers rerunning the appropriate downstream steps.

## Patterns

Our Snakefile still has a ton of repeated content. The rules for each .dat file all follow a consistent pattern. We can replace these rules with a single pattern rule which can be used to build any `.dat` file from a `.txt` file in `data/`:

```Python
rule count_words:
    input:
        cmd='wordcount.py',
        book='data/{book}.txt'
    output: '{book}.dat'
    shell: 'python {input.cmd} {input.book} {output}'
```

Here `{book}` is an arbitrary wildcard that we can use as a placeholder for any generic book to analyze. Note that we don't have to use `{book}` as the name of our *wildcard* - it can be anything we want!

This rule can be interpreted as: "In order to build a file named [something].dat (the target) find a file named `data/[that same something].txt` (the dependency) and run `wordcount.py [the dependency] [the target]`."

### Update your Snakefile now
Replace all your `count_words` rules with the given pattern rule now.

Let's test the new pattern rule. We use the -p option to show that it is running things correctly:

```bash
snakemake clean
snakemake -p dats
```

We should see the same output as before. Note that we can still use snakemake to build individual `.dat` targets as before, and that our new rule will work no matter what stem is being matched.

```bash
snakemake -p sierra.dat
```

which gives the output below:

```Output
Provided cores: 1
Rules claiming more threads will be scaled down.
Job counts:
	count	jobs
	1	count_words
	1

rule count_words:
    input: wordcount.py, data/time_machine.txt
    output: data/time_machine.dat
    jobid: 0
    wildcards: file=time_machine

python wordcount.py data/time_machine.txt data/time_machine.dat
Finished job 0.
1 of 1 steps (100%) done
```

### Using wildcards continued

Our arbitrary wildcards like `{book}` can only be used in input: and output: fields. They cannot be used directly in actions. If you need to refer to the current value of a wildcard in an action you need to qualify it with wildcards.. For example: `{wildcards.file}.`

Running Pattern Rules
Note that although Snakemake lets you execute a non-pattern rule by name, such as snakemake clean, you cannot execute a pattern rule this way:

```bash
snakemake count_words
```

```Output
Building DAG of jobs...
WorkflowError:
Target rules may not contain wildcards. Please specify concrete files or a rule without wildcards.

```


As the error message indicates, you need to ask for specific files. For example,
```bash
 snakemake last.dat.

```

Our Snakefile is now much shorter and cleaner:
```Python
# generate summary table
rule zipf_test:
    input: 'zipf_test.py', 'data/sherlock_holmes.dat', 'data/frankenstein.dat', 'data/dracula.dat'
    output: 'results.txt'
    shell: 'python {input[0]} {input[1]} {input[2]} {input[3]} > {output}'

rule dats:
     input: 'data/dracula.dat', 'data/frankenstein.dat', 'data/sherlock_holmes.dat'

# delete everything so we can re-run things
rule clean:
    shell: 'rm -f *.dat results.txt'

# count words in one of our "books"
rule count_words:
    input:
        cmd='wordcount.py',
        book='data/{book}.txt'
    output: '{book}.dat'
    shell: 'python {input.cmd} {input.book} {output}'
```

Now all that is left to do is update you snakefile
