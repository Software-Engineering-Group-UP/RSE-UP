 ## Chapter Introduction to Make

### Exercise 1

`make -n target` will show commands without running them.

### Exercise 2 

1.  The `-B` option rebuilds everything, even files that aren't out of date.

2.  The `-C` option tells Make to change directories before executing,
    so that `make -C ~/myproject` runs Make in `~/myproject`
    regardless of the directory it is invoked from.

3.  By default, Make looks for (and runs) a file called `Makefile` or `makefile`.
    If you use another name for your Makefile
    (which is necessary if you have multiple Makefiles in the same directory),
    then you need to specify the name of that Makefile using the `-f` option.

### Exercise 3

`mkdir -p some/path` makes one or more nested directories if they don't exist,
and does nothing (without complaining) if they already exist.
It is useful for creating the output directories for build rules.

### Exercise 4 

The build rule for generating the result for any book should now be:

```makefile
## results/%.csv : regenerate result for any book.
results/%.csv : data/%.txt $(COUNT)
	@bash $(SUMMARY) $< Title
	@bash $(SUMMARY) $< Author
    python $(COUNT) $< > $@
```

where `SUMMARY` is defined earlier in the `Makefile` as

```makefile
SUMMARY=bin/book_summary.sh
```

and the settings build rule now includes:

```makefile
@echo SUMMARY: $(SUMMARY)
```

### Exercise 5 

Since we already have a variable `RESULTS` that contains all of the results files,
all we need is a phony target that depends on them:

```makefile
.PHONY: results # and all the other phony targets

## results : regenerate result for all books.
results : ${RESULTS}
```

### Exercise 6 

If we use a shell **wildcard** in a rule like this:

```makefile
results/collated.csv : results/*.csv
	python $(COLLATE) $^ > $@
```

then if `results/collated.csv` already exists,
the rule tells Make that the file depends on itself.

### Exercise 7 

Our rule is:

```makefile
help :
    @grep -h -E '^##' ${MAKEFILE_LIST} | sed -e 's/## //g' \
    | column -t -s ':'
```

-   The `-h` option to `grep` tells it *not* to print filenames,
    while the `-E` option tells it to interpret `^##` as a pattern.

-   `MAKEFILE_LIST` is an automatically defined variable
    with the names of all the Makefiles in play.
    (There might be more than one because Makefiles can include other Makefiles.)

-   `sed` can be used to do string substitution.

-   `column` formats text nicely in columns.

### Exercise 8

This strategy would be advantageous
if in the future we intended to write a number of different Makefiles
that all use the `countwords.py`, `collate.py` and `plotcounts.py` scripts.

We discuss configuration strategies in more detail in Chapter \@ref(config).

