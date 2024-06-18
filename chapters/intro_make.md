# Automating Analyses with Make 

This Chapter on Make is not relevant for the taught course but we decided to keep it here just in case somebody would be interessted! 

Our Zipf's Law project currently includes these files:

```text
zipf/
├── .gitignore
├── CONDUCT.md
├── CONTRIBUTING.md
├── LICENSE.md
├── README.md
├── bin
│   ├── book_summary.sh
│   ├── collate.py
│   ├── countwords.py
│   ├── plotcounts.py
│   ├── script_template.py
│   └── utilities.py
├── data
│   ├── README.md
│   ├── dracula.txt
│   ├── frankenstein.txt
│   └── ...
└── results
    ├── dracula.csv
    ├── dracula.png
    └── ...
```

Now that the project's main building blocks are in place,
we're ready to automate our analysis using a build manager.
We will use a program called [Make]( https://www.gnu.org/software/make/
) to do this
so that every time we add a new book to our data,
we can create a new plot of the word count distribution with a single command.
Make works as follows:

1.  Every time the **operating system** creates, reads, or changes a file,
    it updates a **timestamp** on the file to show when the operation took place.
    Make can compare these timestamps
    to figure out whether files are newer or older than one another.

2.  A user can describe which files depend on each other
    by writing **rules** in a **Makefile**.
    For example, one rule could say that `results/moby_dick.csv` depends on `data/moby_dick.txt`,
    while another could say that the plot `results/comparison.png`
    depends on all of the CSV files in the `results` directory.

3.  Each rule also tells Make how to update an out-of-date file.
    For example,
    the rule for *Moby Dick* could tell Make to run `bin/countwords.py`
    if the result file is older than either the raw data file or the program.

4.  When the user runs Make,
    the program checks all of the rules in the Makefile
    and runs the commands needed to update any that are out of date.
    If there are **transitive dependencies**---i.e.,
    if A depends on B and B depends on C---then Make will trace them through
    and run all of the commands it needs to in the right order.

This chapter uses a version of Make called [GNU Make]( https://www.gnu.org/software/make/
).
It comes with MacOS and Linux;
please see Section **getting-started-install-software** for Windows installation instructions.

> **Keep Tracking with Version Control**
>
> We encourage you to use the Git workflow
> from Chapters [git command line](https://software-engineering-group-up.github.io/RSE-UP/chapters/intro_version_control.html) and [git advanced](https://software-engineering-group-up.github.io/RSE-UP/chapters/git_advanced.html)
> throughout the rest of this book,
> though we won't continue to remind you.

## Updating a Single File 

To start automating our analysis,
let's create a file called `Makefile` in the root of our project
and add the following:

```makefile
# Regenerate results for "Moby Dick"
results/moby_dick.csv : data/moby_dick.txt
	python bin/countwords.py \
		data/moby_dick.txt > results/moby_dick.csv
```

As in the shell and many other programming languages,
`#` indicates that the first line is a comment.
The second and third lines form a **build rule**: the **target**et} of the rule is `results/moby_dick.csv`,
its single **prerequisite** is the file `data/moby_dick.txt`,
and the two are separated by a single colon `:`.
There is no limit on the length of statement lines in Makefiles,
but to aid readability we have used a backslash (`\`) character to split
the lengthy third line in this example.

The target and prerequisite tell Make what depends on what.
The line below them describes the **recipe**
that will update the target if it is out of date.
The recipe consists of one or more shell commands,
each of which *must* be prefixed by a single tab character.
Spaces cannot be used instead of tabs here,
which can be confusing as they are interchangeable in most other programming languages.
In the rule above,
the recipe is "run `bin/countwords.py` on the raw data file
and put the output in a CSV file in the `results` directory."

To test our rule, run this command in the shell:

```bash
$ make
```

Make automatically looks for a file called `Makefile`,
follows the rules it contains,
and prints the commands that were executed.
In this case it displays:

```text
python bin/countwords.py \
  data/moby_dick.txt > results/moby_dick.csv
```

> **Indentation Errors**
>
> If a `Makefile` indents a rule with spaces rather than tabs,
> Make produces an error message like this:
>
> ```text
> Makefile:3: *** missing separator.  Stop.
> ```

When Make follows the rules in our Makefile,
one of three things will happen:

1.  If `results/moby_dick.csv` doesn't exist,
    Make runs the recipe to create it.
2.  If `data/moby_dick.txt` is newer than `results/moby_dick.csv`,
    Make runs the recipe to update the results.
3.  If `results/moby_dick.csv` is newer than its prerequisite,
    Make does nothing.

In the first two cases,
Make prints the commands it runs,
along with anything those commands print to the screen
via **standard output** or **standard error**.
There is no screen output in this case,
so we only see the command.

No matter what happened the first time we ran `make`,
if we run it again right away it does nothing
because our rule's target is now up to date.
It tells us this by displaying the message:

```text
make: `results/moby_dick.csv' is up to date.
```

We can check that it is telling the truth by listing the files with their timestamps,
ordered by how recently they have been updated:

```bash
$ ls -l -t data/moby_dick.txt results/moby_dick.csv
```

```text
-rw-r--r-- 1 amira staff  274967 Nov 29 12:58
  results/moby_dick.csv
-rw-r--r-- 1 amira staff 1253891 Nov 27 20:56
  data/moby_dick.txt
```

\newpage

As a further test:

1.  Delete `results/moby_dick.csv` and run `make` again.
    This is case #1, so Make runs the recipe.
2.  Use `touch data/moby_dick.txt` to update the timestamp on the data file,
    then run `make`.
    This is case #2,
    so again,
    Make runs the recipe.

> **Managing Makefiles**
>
> We don't have to call our file `Makefile`:
> if we prefer something like `workflows.mk`,
> we can tell Make to read recipes from that file using
> `make -f workflows.mk`.

## Managing Multiple Files In this case,
the first target is `results/moby_dick.csv`,
which is already up to date.
To update something else,
we need to tell Make specifically what we want:

```bash
$ make results/jane_eyre.csv
```

```text
python bin/countwords.py \
  data/jane_eyre.txt > results/jane_eyre.csv
```

If we have to run `make` once for each result,
we're right back where we started.
However,
we can add a rule to our Makefile to update all of our results at once.
We do this by creating a **phony target**
that doesn't correspond to an actual file.
Let's add this line to the top of our Makefile:

```makefile
# Regenerate all results.
all : results/moby_dick.csv results/jane_eyre.csv
```

There is no file called `all`,
and this rule doesn't have any recipes of its own,
but when we run `make all`,
Make finds everything that `all` depends on,
then brings each of those prerequisites up to date ([Figure automate all](automate-all)).

```{figure} ../figures/automate/make-dependency-graph.png
:name: automate-all
Automate All
```

The order in which rules appear in the Makefile
does not necessarily determine the order in which recipes are run.
Make is free to run commands in any order
so long as nothing is updated before its prerequisites are up to date.

We can use phony targets to automate and document other steps in our workflow.
For example,
let's add another target to our Makefile to delete all of the result files we have generated
so that we can start afresh.
By convention this target is called `clean`,
and we'll place it below the two existing targets:

```makefile
# Remove all generated files.
clean :
	rm -f results/*.csv
```

The `-f` flag to `rm` means "force removal":
if it is present,
`rm` won't complain if the files we have told it to remove are already gone.
If we now run:

```bash
$ make clean
```

Make will delete any results files we have.
This is a lot safer than typing `rm -f results/*.csv` at the command line each time,
because if we mistakenly put a space before the `*`
we would delete all of the CSV files in the project's root directory.

Phony targets are very useful,
but there is a catch.
Try doing this:

```bash
$ mkdir clean
$ make clean
```

```text
make: `clean' is up to date.
```

Since there is a directory called `clean`,
Make thinks the target `clean` in the Makefile refers to this directory.
Since the rule has no prerequisites,
it can't be out of date,
so no recipes are executed.

We can unconfuse Make by putting this line at the top of Makefile
to explicitly state which targets are phony:

```makefile
.PHONY : all clean
```

## Updating Files When Programs Change 

Our current Makefile says that each result file depends on the corresponding data file.
That's not entirely true:
each result also depends on the program used to generate it.
If we change our program,
we should regenerate our results.
To get Make to do that,
we can change our prerequisites to include the program:

```makefile
# Regenerate results for "Moby Dick"
results/moby_dick.csv : data/moby_dick.txt bin/countwords.py
	python bin/countwords.py \
    	data/moby_dick.txt > results/moby_dick.csv

# Regenerate results for "Jane Eyre"
results/jane_eyre.csv : data/jane_eyre.txt bin/countwords.py
	python bin/countwords.py \
		data/jane_eyre.txt > results/jane_eyre.csv
```

To run both of these rules,
we can type `make all`.
Alternatively,
since `all` is the first target in our Makefile,
Make will use it if we just type `make` on its own:

```bash
$ touch bin/countwords.py
$ make
```

```text
python bin/countwords.py \
  data/moby_dick.txt > results/moby_dick.csv
python bin/countwords.py \
  data/jane_eyre.txt > results/jane_eyre.csv
```

The exercises will explore how we can write a rule
to tell us whether our results will be different
after a change to a program
without actually updating them.
Rules like this can help us test our programs:
if we don't think an addition or modification ought to affect the results,
but it would,
we may have some debugging to do.

## Reducing Repetition in a Makefile 

Our Makefile now mentions `bin/countwords.py` four times.
If we ever change the name of the program or move it to a different location,
we will have to find and replace each of those occurrences.
More importantly,
this redundancy makes our Makefile harder to understand,
just as scattering **magic numbers** through programs
makes them harder to understand.



The solution is the same one we use in programs:
define and use variables.
Let's modify the results regeneration code by 
creating targets for the word-counting script and the command used to run it.
The entire file should now read:

```makefile
.PHONY : all clean

COUNT=bin/countwords.py
RUN_COUNT=python $(COUNT)

# Regenerate all results.
all : results/moby_dick.csv results/jane_eyre.csv

# Regenerate results for "Moby Dick"
results/moby_dick.csv : data/moby_dick.txt $(COUNT)
	$(RUN_COUNT) data/moby_dick.txt > results/moby_dick.csv

# Regenerate results for "Jane Eyre"
results/jane_eyre.csv : data/jane_eyre.txt $(COUNT)
	$(RUN_COUNT) data/jane_eyre.txt > results/jane_eyre.csv

# Remove all generated files.
clean :
	rm -f results/*.csv
```

Each definition takes the form `NAME=value`.
Variables are written in upper case by convention
so that they'll stand out from filenames
(which are usually in lower case),
but Make doesn't require this.
What *is* required is using parentheses to refer to the variable,
i.e.,
to use `$(NAME)` and not `$NAME`.

> **Why the Parentheses?**
>
> For historical reasons,
> Make interprets `$NAME` to be a variable called `N` followed by the three characters "AME".
> If no variable called `N` exists,
> `$NAME` becomes `AME`,
> which is almost certainly not what we want.

As in programs,
variables don't just cut down on typing.
They also tell readers that several things are always and exactly the same,
which reduces **cognitive load**.

## Automatic Variables 

We could add a third rule to analyze a third novel and a fourth to analyze a fourth,
but that won't scale to hundreds or thousands of novels.
Instead,
we can write a generic rule that does what we want for every one of our data files.

To do this,
we need to understand Make's
**automatic variables**.
The first step is to use the very cryptic expression `$@` in the rule's recipe
to mean "the target of the rule."
It lets us turn this:

```makefile
# Regenerate results for "Moby Dick"
results/moby_dick.csv : data/moby_dick.txt $(COUNT)
	$(RUN_COUNT) data/moby_dick.txt > results/moby_dick.csv
```

into this:

```makefile
# Regenerate results for "Moby Dick"
results/moby_dick.csv : data/moby_dick.txt $(COUNT)
	$(RUN_COUNT) data/moby_dick.txt > $@
```

Make defines a value of `$@` separately for each rule,
so it always refers to that rule's target.
And yes,
`$@` is an unfortunate name:
something like `$TARGET` would have been easier to understand,
but we're stuck with it now.

The next step is to replace the explicit list of prerequisites in the recipe
with the automatic variable `$^`,
which means "all the prerequisites in the rule":

```makefile
# Regenerate results for "Moby Dick"
results/moby_dick.csv : data/moby_dick.txt $(COUNT)
	$(RUN_COUNT) $^ > $@
```

However,
this doesn't work.
The rule's prerequisites are the novel and the word-counting program.
When Make expands the recipe,
the resulting command tries to process the program `bin/countwords.py`
as if it was a data file:

```bash
python bin/countwords.py data/moby_dick.txt bin/countwords.py >
  results/moby_dick.csv
```

Make solves this problem with another automatic variable `$<`,
which means "only the first prerequisite".
Using it lets us rewrite our rule as:

```makefile
# Regenerate results for "Moby Dick"
results/moby_dick.csv : data/moby_dick.txt $(COUNT)
	$(RUN_COUNT) $< > $@
```

If you use this approach,
the rule for *Jane Eyre* should be updated as well.
The next section,
however,
includes instructions for generalizing rules.

## Generic Rules 

`$< > $@` is even harder to read than `$@` on its own,
but we can now replace all the rules for generating results files
with one **pattern rule** using the **wildcard** `%`,
which matches zero or more characters in a filename.
Whatever matches `%` in the target also matches in the prerequisites,
so the rule:

```makefile
results/%.csv : data/%.txt $(COUNT)
	$(RUN_COUNT) $< > $@
```

will handle *Jane Eyre*, *Moby Dick*, *The Time Machine*, and every other novel in the `data/` directory.
`%` cannot be used in recipes,
which is why `$<` and `$@` are needed.

With this rule in place, our entire Makefile is reduced to:

```makefile
.PHONY: all clean

COUNT=bin/countwords.py
RUN_COUNT=python $(COUNT)

# Regenerate all results.
all : results/moby_dick.csv results/jane_eyre.csv \
  results/time_machine.csv

# Regenerate result for any book.
results/%.csv : data/%.txt $(COUNT)
	$(RUN_COUNT) $< > $@

# Remove all generated files.
clean :
	rm -f results/*.csv
```

We now have fewer lines of text,
but we've also included a third book.
To test our shortened Makefile,
let's delete all of the results files:

```bash
$ make clean
```

```text
rm -f results/*.csv
```

and then re-create them:

```bash
$ make  # Same as `make all` as "all" is the first target
```

```text
python bin/countwords.py data/moby_dick.txt >
  results/moby_dick.csv
python bin/countwords.py data/jane_eyre.txt >
  results/jane_eyre.csv
python bin/countwords.py data/time_machine.txt >
  results/time_machine.csv
```

We can still rebuild individual files if we want,
since Make will take the target filename we give on the command line
and see if a pattern rule matches it:

```bash
$ touch data/jane_eyre.txt
$ make results/jane_eyre.csv
```

```text
python bin/countwords.py data/jane_eyre.txt >
  results/jane_eyre.csv
```

## Defining Sets of Files 

Our analysis is still not fully automated:
if we add another book to `data`,
we have to remember to add its name to the `all` target in the Makefile as well.
Once again we will fix this in steps.

To start,
imagine that all the results files already exist
and we just want to update them.
We can define a variable called `RESULTS`
to be a list of all the results files
using the same wildcards we would use in the shell:

```makefile
RESULTS=results/*.csv
```

We can then rewrite `all` to depend on that list:

```makefile
# Regenerate all results.
all : $(RESULTS)
```

However,
this only works if the results files already exist.
If one doesn't,
its name won't be included in `RESULTS`
and Make won't realize that we want to generate it.

What we really want is to generate the list of results files
based on the list of books in the `data/` directory.
We can create that list using Make's `wildcard` function:

```makefile
DATA=$(wildcard data/*.txt)
```

This calls the function `wildcard` with the argument `data/*.txt`.
The result is a list of all the text files in the `data` directory,
just as we would get with `data/*.txt` in the shell.
The syntax is odd because functions were added to Make long after it was first written,
but at least they have readable names.

To check that this line does the right thing,
we can add another phony target called `settings`
that uses the shell command `echo` to print the names and values of our variables:

```makefile
.PHONY: all clean settings

# ...everything else...

# Show variables' values.
settings :
	echo COUNT: $(COUNT)
	echo DATA: $(DATA)
```

Let's run this:

```bash
$ make settings
```

```text
echo COUNT: bin/countwords.py
COUNT: bin/countwords.py
echo DATA: data/dracula.txt data/frankenstein.txt
  data/jane_eyre.txt data/moby_dick.txt
  data/sense_and_sensibility.txt
  data/sherlock_holmes.txt data/time_machine.txt
DATA: data/dracula.txt data/frankenstein.txt
  data/jane_eyre.txt data/moby_dick.txt
  data/sense_and_sensibility.txt data/sherlock_holmes.txt
  data/time_machine.txt
```

The output appears twice
because Make shows us the command it's going to run before running it.
Putting `@` before the command in the recipe prevents this,
which makes the output easier to read:

```makefile
settings :
	@echo COUNT: $(COUNT)
	@echo DATA: $(DATA)
```

```bash
$ make settings
```

```text
COUNT: bin/countwords.py
DATA: data/dracula.txt data/frankenstein.txt
  data/jane_eyre.txt data/moby_dick.txt
  data/sense_and_sensibility.txt data/sherlock_holmes.txt
  data/time_machine.txt

```

We now have the names of our input files.
To create a list of corresponding output files,
we use Make's `patsubst` function
(short for **pat**tern **subst**itution):

```makefile
RESULTS=$(patsubst data/%.txt,results/%.csv,$(DATA))
```

The first argument to `patsubst` is the pattern to look for,
which in this case is a text file in the `data` directory.
We use `%` to match the **stem** of the file's name,
which is the part we want to keep.

The second argument is the repla** we **ttern rule,
Make replaces `%` in this argument with whatever matched `%` in the pattern,
which creates the name of the result file we want.
Finally, the third argument is what to do the substitution in,
which is our list of books' names.

Let's check the `RESULTS` variable by adding another command to the `settings` target:

```makefile
settings :
	@echo COUNT: $(COUNT)
	@echo DATA: $(DATA)
	@echo RESULTS: $(RESULTS)
```

```bash
$ make settings
```

```text
COUNT: bin/countwords.py
DATA: data/dracula.txt data/frankenstein.txt data/jane_eyre.txt
  data/moby_dick.txt data/sense_and_sensibility.txt
  data/sherlock_holmes.txt data/time_machine.txt
RESULTS: results/dracula.csv results/frankenstein.csv
  results/jane_eyre.csv results/moby_dick.csv
  results/sense_and_sensibility.csv
  results/sherlock_holmes.csv results/time_machine.csv
```

Excellent:
`DATA` has the names of the files we want to process
and `RESULTS` automatically has the names of the corresponding result files.

Why haven't we included `RUN_COUNT` when assessing our variables' values?
This is another place we can streamline our script,
by removing `RUN_COUNT` from the list of variables 
and changing our regeneration rule:

```makefile
# Regenerate result for any book.
results/%.csv : data/%.txt $(COUNT)
	python $(COUNT) $< > $@
```

Since the phony target `all` depends on `$(RESULTS)`
(i.e., all the files whose names appear in the variable `RESULTS`)
we can regenerate all the results in one step:

```bash
$ make clean
```

```text
rm -f results/*.csv
```

```bash
$ make  # Same as `make all` since "all" is the first target
```

```text
python bin/countwords.py data/dracula.txt > results/dracula.csv
python bin/countwords.py data/frankenstein.txt >
  results/frankenstein.csv
python bin/countwords.py data/jane_eyre.txt >
  results/jane_eyre.csv
python bin/countwords.py data/moby_dick.txt >
  results/moby_dick.csv
python bin/countwords.py data/sense_and_sensibility.txt >
  results/sense_and_sensibility.csv
python bin/countwords.py data/sherlock_holmes.txt >
  results/sherlock_holmes.csv
python bin/countwords.py data/time_machine.txt >
  results/time_machine.csv
```

Our workflow is now just two steps:
add a data file and run Make.
This is a big improvement over running things manually,
particularly as we start to add more steps like merging data files and generating plots.

## Documenting a Makefile 

Every well-behaved program should tell people how to use it {cite:p}`Tasc2017`.
If we run `make --help`,
we get a (very) long list of options that Make understands,
but nothing about our specific workflow.
We could create another phony target called `help` that prints a list of available commands:

```makefile
.PHONY: all clean help settings

# ...other definitions...

# Show help.
help :
	@echo "all : regenerate all results."
	@echo "results/*.csv : regenerate result for any book."
	@echo "clean : remove all generated files."
	@echo "settings : show variables' values."
	@echo "help : show this message."
```

but sooner or later
we will add a target or rule and forget to update this list.

A better approach is to format some comments in a special way
and then extract and display those comments when asked to.
We'll use `##` (a double comment marker) to indicate the lines we want displayed
and `grep` (Section [bash advanced find](https://software-engineering-group-up.github.io/RSE-UP/chapters/bash_advanced.html#finding-things-in-files) to pull these lines out of the file:

```makefile
.PHONY: all clean help settings

COUNT=bin/countwords.py
DATA=$(wildcard data/*.txt)
RESULTS=$(patsubst data/%.txt,results/%.csv,$(DATA))

## all : regenerate all results.
all : $(RESULTS)

## results/%.csv : regenerate result for any book.
results/%.csv : data/%.txt $(COUNT)
	python $(COUNT) $< > $@

## clean : remove all generated files.
clean :
	rm -f results/*.csv

## settings : show variables' values.
settings :
	@echo COUNT: $(COUNT)
	@echo DATA: $(DATA)
	@echo RESULTS: $(RESULTS)

## help : show this message.
help :
	@grep '^##' ./Makefile
```

Let's test:

```bash
$ make help
```

```text
## all : regenerate all results.
## results/%.csv : regenerate result for any book.
## clean : remove all generated files.
## settings : show variables' values.
## help : show this message.
```

The exercises will explore how to format this more readably.

## Automating Entire Analyses 

To finish our discussion of Make,
let's automatically generate a collated list of word frequencies.
The target is a file called `results/collated.csv`
that depends on the results generated by `countwords.py`.
To create it,
we add or change these lines in our Makefile:

```makefile
# ...phony targets and previous variable definitions...

COLLATE=bin/collate.py

## all : regenerate all results.
all : results/collated.csv

## results/collated.csv : collate all results.
results/collated.csv : $(RESULTS) $(COLLATE)
	mkdir -p results
	python $(COLLATE) $(RESULTS) > $@

# ...other rules...

## settings : show variables' values.
settings :
	@echo COUNT: $(COUNT)
	@echo DATA: $(DATA)
	@echo RESULTS: $(RESULTS)
	@echo COLLATE: $(COLLATE)

# ...help rule...
```

The first two lines tell Make about the collation program,
while the change to `all` tells it what the final target of our pipeline is.
Since this target depends on the results files for single novels,
`make all` will regenerate all of those automatically.

The rule to regenerate `results/collated.csv` should look familiar by now:
it tells Make that all of the individual results have to be up-to-date
and that the final result should be regenerated if the program used to create it has changed.
One difference between the recipe in this rule and the recipes we've seen before
is that this recipe uses `$(RESULTS)` directly instead of an automatic variable.
We have written the rule this way because
there isn't an automatic variable that means "all but the last prerequisite,"
so there's no way to use automatic variables that wouldn't result in us trying to process our program.

Likewise,
we can also add the `plotcounts.py` script to this workflow
and update the `all` and `settings` rules accordingly.
Note that there is no `>` needed before the `$@`
because the default action of `plotcounts.py` is to write to a file
rather than to standard output.

```makefile
# ...phony targets and previous variable definitions...

PLOT=bin/plotcounts.py

## all : regenerate all results.
all : results/collated.png

## results/collated.png: plot the collated results.
results/collated.png : results/collated.csv
	python $(PLOT) $< --outfile $@

# ...other rules...

## settings : show variables' values.
settings :
	@echo COUNT: $(COUNT)
	@echo DATA: $(DATA)
	@echo RESULTS: $(RESULTS)
	@echo COLLATE: $(COLLATE)
	@echo PLOT: $(PLOT)

# ...help...
```

Running `make all` should now generate the new `collated.png` plot ([Figure automate collated](automate-collated)):

```bash
$ make all
```

```text
python bin/collate.py results/time_machine.csv
  results/moby_dick.csv results/jane_eyre.csv
  results/dracula.csv results/sense_and_sensibility.csv
  results/sherlock_holmes.csv results/frankenstein.csv >
  results/collated.csv
python bin/plotcounts.py results/collated.csv --outfile
  results/collated.png
alpha: 1.1712445413685917
```

```{figure} ../figures/automate/collated.png
:name: automate-collated
Automate Collated
```



Finally,
we can update the `clean` target
to only remove files created by the Makefile.
It is a good habit to do this rather than using the asterisk wildcard to remove all files,
since you might manually place files in the results directory
and forget that these will be cleaned up when you run `make clean`.

```makefile
# ...phony targets and previous variable definitions...

## clean : remove all generated files.
clean :
	rm $(RESULTS) results/collated.csv results/collated.png
```

## Summary 

Make's reliance on shell commands instead of direct calls to functions in Python sometimes makes it clumsy to use.
However,
that also makes it very flexible:
a single Makefile can run shell commands and programs written in a variety of languages,
which makes it a great way to assemble pipelines out of whatever is lying around.

Programmers have created many replacements for Make in the 45 years since it was first created---so many, in fact, that none have attracted enough users to displace it.

If you would like to explore them, check out [Snakemake](https://snakemake.readthedocs.io/) (for Python) or the [section](https://software-engineering-group-up.github.io/RSE-UP/chapters/snakemake.html) on workflows using snake make.


If you want to go deeper, {cite:p}`Smit2011` describes the design and implementation of several build managers.

## Key Points 

```{include} keypoints/automate.md
```
