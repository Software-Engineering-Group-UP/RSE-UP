
# Exercises - Make 

Our `Makefile` currently reads as follows:

```makefile
.PHONY: all clean help settings

COUNT=bin/countwords.py
COLLATE=bin/collate.py
PLOT=bin/plotcounts.py
DATA=$(wildcard data/*.txt)
RESULTS=$(patsubst data/%.txt,results/%.csv,$(DATA))

## all : regenerate all results.
all : results/collated.png

## results/collated.png: plot the collated results.
results/collated.png : results/collated.csv
	python $(PLOT) $< --outfile $@

## results/collated.csv : collate all results.
results/collated.csv : $(RESULTS) $(COLLATE)
	@mkdir -p results
	python $(COLLATE) $(RESULTS) > $@

## results/%.csv : regenerate result for any book.
results/%.csv : data/%.txt $(COUNT)
	python $(COUNT) $< > $@

## clean : remove all generated files.
clean :
	rm $(RESULTS) results/collated.csv results/collated.png

## settings : show variables' values.
settings :
	@echo COUNT: $(COUNT)
	@echo DATA: $(DATA)
	@echo RESULTS: $(RESULTS)
	@echo COLLATE: $(COLLATE)
	@echo PLOT: $(PLOT)

## help : show this message.
help :
	@grep '^##' ./Makefile
```

A number of the exercises below ask you to make further edits to `Makefile`.

## 1) Report results that would change 

How can you get `make` to show the commands it would run
without actually running them?
(Hint: look at the manual page.)

## 2) Useful options 

1.  What does Make's `-B` option do and when is it useful?
1.  What about the `-C` option?
1.  What about the `-f` option?

## 3) Make sure the output directory exists 

One of our **build recipes** includes `mkdir -p`.
What does this do and why is it useful?

## 4) Print the title and author 

The build rule for regenerating the result for any book is currently:
```makefile
## results/%.csv : regenerate result for any book.
results/%.csv : data/%.txt $(COUNT)
	python $(COUNT) $< > $@
```

Add an extra line to the recipe that uses the `book_summary.sh` script
to print the title and author of the book to the screen.
Use `@bash` so that the command itself isn't printed to the screen
and don't forget to update the settings build rule to include the `book_summary.sh` script.

If you've successfully made those changes,
you should get the following output for *Dracula*:

```bash
$ make -B results/dracula.csv
```

```text
Title: Dracula
Author: Bram Stoker
python bin/countwords.py data/dracula.txt > results/dracula.csv
```

## 4) Create all results 

The default target of our final `Makefile` re-creates `results/collated.csv`.
Add a target to `Makefile`
so that `make results` creates or updates any result files that are missing or out of date,
but does *not* regenerate `results/collated.csv`.

## 5) The perils of shell wildcards 

What is wrong with writing the rule for `results/collated.csv` like this:

```makefile
results/collated.csv : results/*.csv
	python $(COLLATE) $^ > $@
```

(The fact that the result no longer depends on the program used to create it
isn't the biggest problem.)

## 6) Making documentation more readable 

We can format the documentation in our Makefile more readably using this command:

```makefile
## help : show all commands.
help :
	@grep -h -E '^##' ${MAKEFILE_LIST} | sed -e 's/## //g' \
	| column -t -s ':'
```

Using `man` and online search,
explain what every part of this recipe does.

## 7) Configuration 

A next step in automating this analysis might include 
moving the definitions of the `COUNT`, `COLLATE`, and `PLOT` variables
into a separate file called `config.mk`:

```makefile
COUNT=bin/countwords.py
COLLATE=bin/collate.py
PLOT=bin/plotcounts.py
```

and using the `include` command to access those definitions in the existing `Makefile`:

```makefile
.PHONY: results all clean help settings

include config.mk

# ... the rest of the Makefile ...
```

Under what circumstances would this strategy be useful?

