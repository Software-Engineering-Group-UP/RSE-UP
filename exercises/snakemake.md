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

## 6. Putting it all together

Using the `expand()` and `glob_wildcards()` functions, modify the pipeline so that it automatically detects and analyzes all the files in the `data/` folder.
**Hint**
 Use `expand()` and `glob_wildcards()` together to create the value of `DATS`.



## 7 .Moving Output Files into a Subdirectory

Currently our workflow is generating a lot of files in the main directory. This is not so bad with small numbers of files, but it can get messy as the file count grows. One approach to this is to generate outputs into their own directories, named after the file types. For example:

```output
zipf
├── data
│   ├── dracula.txt
│   ├── frankenstein.txt
│   ├── moby_dick.txt
│   └── time_machine.txt
├── dats
│   ├── dracula.dat
│   ├── frankenstein.dat
│   ├── moby_dick.dat
│   └── time_machine.dat
├── snakemake
│   ├── wordcount.py
│   ├── zipf_test.py
│   ├── plotcount.py
│   ├── results.txt
│   ├── run_pipeline.sh
│   └── snakefile
...
```

There are many potential arrangements, so you are free to choose whatever makes sense for your project. Snakemake is not prescriptive, it will put files wherever you tell it. So here we will learn how to move the `dat` files into a `dats` directory.

Alter the rules in your Snakefile so that the `dat` files are created in
their own `dats/` folder.
Note that creating this folder beforehand is unnecessary.
Snakemake automatically create any folders for you, as needed.

**Hint**
 
Make sure your `Snakefile` is up to date with the end of the preceeding lesson. Use the provided solution files if necessary.Look for all the locations that reference the `dat` files and update to add the `dats/` directory.

  
## 8. Creating PNGs

Your Task is to update your Snakefile so that it can create `.png`
files from `dat` files using `plotcount.py`.

* The new rule should be called `make_plot`.
* All `.png` files should be created in a directory called `plots`. If you are using a Windows system, you could create the plots in the top-level directory instead in order to avoid the Windows subdirectory bug. You may need to change back to the `plots` directory after we introduce the `all` rule.

As well as a new rule you may also need to update existing rules.

Remember that when testing a pattern rule, you can't just ask Snakemake to execute the rule by name. You need to ask Snakemake to build a specific file.

So instead of `snakemake count_words` you need something like `snakemake dats/last.dat`.



## 9. Generating Plots

### Default Rules

The default rule is the rule that Snakemake runs if you don't specify a rule
on the command-line (e.g.: if you just run `snakemake`).

The default rule is simply the first rule in a Snakefile. While the default
rule can be anything you like, it is common practice to call the default rule
`all`, and have it run the entire workflow.

### Add an `all` rule
Add an `all` rule to your Snakefile.

*Note that `all` rules often don't need to do any processing of their own.*
It is suffient to make them depend on all the final outputs from other rules.
In this case, the outputs are `results.txt` and all the PNG files.

**Hint**

 It is easiest to use `glob_wildcards` and `expand` to build the list of all expected `.png` files.

## 10. Creating an Archive


Let's add a processing rule that depends on all previous stages of the workflow.In this case, we will create an archive tar file.


Update your pipeline to:
- Create an archive file called `zipf_analysis.tar.gz`
- The archive should contain all `dat` files, plots, and the Zipf summary table (`results.txt`).

- Update `all` to expect `zipf_analysis.tar.gz` as input.
- Remove the archive when `snakemake clean` is called.

The syntax to create an archive is:
```Bash
tar -czvf zipf_analysis.tar.gz file1 directory2 file3 etc
```


After these exercises our final workflow should look something like the following:

```{figure} ../../figures/snakemake/final_workflow.png
:name: final_workflow
Final Workflow
```

## 11. Adding more books

We can now do a better job at testing Zipf's rule by adding more books.
The books we have used come from the [Project Gutenberg](http://www.gutenberg.org/) website.

Project Gutenberg offers thousands of free ebooks to download.

**Exercise instructions:**

- go to [Project Gutenberg](http://www.gutenberg.org/) and use the search box to find another book, for example ['The Picture of Dorian Gray'](https://www.gutenberg.org/ebooks/174) from Oscar Wilde.

- download the 'Plain Text UTF-8' version and save it to the `books` folder;
- choose a short name for the file - optionally, open the file in a text editor and remove extraneous text at the beginning and end (look for the phrase `End of Project Gutenberg's [title], by [author]`)

- run `snakemake` and check that the correct commands are run
- check the results.txt file to see how this book compares to the others

**BEFORE go further please check out the Section Snakemake Continued Part 2**

## 12. What happens if Snakemake does not have enough resources?

Modify your Snakefile and the snakemake arguments to test what happens when you have less resources available than the number required by a rule. 
For example, you might set `gpu=2` in `make_plot`, and then run `snakemake --resources gpu=1`.

What do you think will happen? What actually happens?

## 13. Replace all other duplicated strings with global variables

 You will need to update:
- the string for `dat` files (`dats/{file}.dat`)
- the string for plot files (`plots/{file}.png`)
- the archive file `zipf_analysis.tar.gz`
- the results file `results.txt`

**Hint**
A formatted string can be used to get the global variables into the `clean` shell command.
If you have inconsistent wildcard names, make them the same.


## 14. Combining global variables and wildcards in formatted strings

The safest way to mix global variables and wildcards in a formatted string is to remember the following:
- Global variables are surrounded in single curly braces (e.g. `{INPUT_DIR}`).
- Wildcards are surrounded with double curly braces {% raw %}(e.g. `{{book}}`){% endraw %}.
- Use upper-case for globals and lower-case for wildcards.

Make your workflow configurable
Move all other configurable values into `config.yaml` and adjust the Snakefile.

*Remember* to test your workflow as you go.

## 15. Submitting a workflow with nohup

`nohup some_command &` runs a command in the background and lets it keep running if you log off. Try running the pipeline in cluster mode using `nohup` (run `snakemake clean` beforehand). 

Where does the Snakemake log go to?

Why might this technique be useful?

You can kill the running Snakemake process with `killall snakemake`.
Notice that if you try to run Snakemake again, it says the directory is locked.
You can unlock the directory with `snakemake --unlock`.

## 16. Running Snakemake itself as a batch job

Can we also submit the `snakemake --cluster` pipeline as a batch job?

Is this a good idea? What are some problems of this approach?
