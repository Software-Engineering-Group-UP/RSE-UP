# Introduction to Snakemake

This section will give you a brief introduction into what snake make is and how to set it up. 

## Introduction to Snakemake - What is it? 

Imagine a complex scientific analysis with multiple steps, each requiring specific inputs and generating outputs. Keeping track of individual commands, handling data dependencies, and ensuring reproducibility can become a real headache. This is where Snakemake comes in, offering a powerful solution for automating and managing your workflows.

Snakemake operates through a simple yet versatile concept: defining rules in a configuration file called a "Snakefile." These rules specify the relationships between tasks, their inputs and outputs. Snakemake, acting like a smart conductor, analyzes these rules and creates an execution plan. It automatically identifies dependencies between tasks, ensuring that only completed tasks' outputs are used as inputs for subsequent ones. This eliminates the risk of errors due to manual execution and facilitates reproducibility, allowing you to easily rerun your analysis with the same results.{cite:p}`molder2021sustainable`

But why choose Snakemake over other options? Here are some compelling reasons:

- Simplicity: Snakemake utilizes Python syntax, making it easy to learn and use, even for those without extensive coding experience.

- Cross-platform compatibility: Regardless of your operating system (Windows, Mac, or Linux), Snakemake runs seamlessly, ensuring your workflow remains portable.

- Scalability: Whether you're working on a personal computer or a high-performance computing cluster, Snakemake can efficiently utilize available resources by parallelizing tasks whenever possible.

- Flexibility: Snakemake integrates seamlessly with various tools and languages, allowing you to leverage existing code and data formats within your workflow.

- Reproducibility: By capturing the entire analysis process in the Snakefile, Snakemake guarantees consistent and verifiable results, facilitating collaboration and sharing within scientific communities.

Whether you're working in genomics, bioinformatics, or any domain requiring complex data analysis, Snakemake offers a valuable tool for streamlining your work, improving its efficiency and reproducibility. Its intuitive approach and powerful features make it an excellent choice for researchers and scientists seeking to automate their workflows and achieve reliable results.


## Installation


Snakemake is available on PyPi as well as through Bioconda and also from source code.
You can use one of the following ways for installing Snakemake.

Thanks to the Snakemake Team for providing the installation [Documentation](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html).  

### Installation via Conda/Mamba

If you already use Conda for other parts of the project you are working on it is recommended to install Snakemake through Conda as well,
because it also enables Snakemake to handle other software dependencies.

First, you need to install a Conda-based Python3 distribution.
The recommended choice is Mambaforge_ which not only provides the required Python and Conda commands, 
but also includes Mamba_ an extremely fast and robust replacement for the Conda_ package manager which is highly recommended.
The default conda solver is a bit slow and sometimes has issues with [selecting the latest package releases](https://github.com/conda/conda/issues/9905). 
Therefore, we recommend to in any case use Mamba_.

In case you don't use Mambaforge_ you can always install Mamba_ into any other Conda-based Python distribution with

```bash

    $ conda install -n base -c conda-forge mamba
```

### Full installation

Snakemake can be installed with all goodies needed to run in any environment and for creating interactive reports via


```bash

    $ mamba create -c conda-forge -c bioconda -n snakemake snakemake
```

from the [Bioconda](https://bioconda.github.io) channel.
This will install snakemake into an isolated software environment, that has to be activated with


```bash
    $ mamba activate snakemake
    $ snakemake --help
```

Installing into isolated environments is best practice in order to avoid side effects with other packages.

### Notes on Bioconda as a package source


Note that Snakemake is available via Bioconda for historical, reproducibility, and continuity reasons (although it is not limited to biology applications at all).
However, it is easy to combine Snakemake installation with other channels, e.g., by prefixing the package name with ``::bioconda``, i.e.,


```bash

    $ mamba activate base
    $ mamba create -n some-env -c conda-forge bioconda::snakemake ...
```


### Installation via pip

Instead of conda, snakemake can be installed with pip.
However, note that snakemake has non-python dependencies, such that the pip based installation has a limited functionality if those dependencies are not manually installed in addition.

A list of Snakemake's dependencies can be found within its [meta.yaml conda recipe](https://bioconda.github.io/recipes/snakemake/README.html)

**IMPORTANT** If you have problems installing snakemake using pip and you get an error message like this: `ERROR: Failed building wheel for datrie` you first need to install the Python development headers.

In Fedora this would be:
```Bash
sudo dnf install python3-devel
```
On Ubuntu this would be:
```Bash
sudo apt-get install python-dev
```

On Windows this would be:
```bash
pip install --upgrade setuptools
pip install --upgrade wheel
pip install --upgrade python-dev
```

After that you can just use the following command to install snakemake:
```bash 
pip install snakemake
```

### Installation of a development version via pip


If you want to quickly try out an unreleased version from the snakemake repository (which you cannot get via bioconda, yet), for example to check whether a bug fix works for you workflow, you can get the current state of the main branch with:


```bash
    $ mamba create --only-deps -n snakemake-dev snakemake
    $ mamba activate snakemake-dev
    $ pip install git+https://github.com/snakemake/snakemake
```

You can also install the current state of another branch or the repository state at a particular commit.
For information on the syntax for this, see [the pip documentation on git support](https://pip.pypa.io/en/stable/topics/vcs-support/#git).


## Example Workflow based on Zipf's Law

By now you should be familiar with what Zipf's Law is, in the following subsection we will present you an example workflow using snakemake and Zipf's Law as data. 

We are interested in understanding the frequency of words in various books, testing how closely each book conforms to Zipf's Law.

We've compiled our raw data (the books we want to analyze) and have prepared
several Python scripts that together make up our analysis pipeline.

Let's take quick look at one of the books using the command 

```bash

$ head data zipf/data/dracula.txt
````
Will give the following result.
```text

The Project Gutenberg EBook of Dracula, by Bram Stoker

This eBook is for the use of anyone anywhere at no cost and with
almost no restrictions whatsoever.  You may copy it, give it away or
re-use it under the terms of the Project Gutenberg License included
with this eBook or online at www.gutenberg.org/license



Title: Dracula
```
Our directory has the Python scripts and data files we we will be working
with:

```bash 
|- data
|  |- dracula.txt
|  |- jane_eyre.txt
|  |- moby_dick.txt
|  |- ... .md
|- snakemake
|  |- plotcount.py
|  |- wordcount.py
|  |- zipf_test.py
```


There may be some other files as well, but the ones listed above are the
ones we are concerned with at present.

The first step is to count the frequency of each word in a book. For this, we
use the `wordcound.py` script. The first argument (`books/isles.txt`) to
wordcount.py is the file to analyze, and the last argument (`isles.dat`)
specifies the output file to write:

```bash
python snakemake/wordcount.py data/dracula.txt dracula.dat

````


Let's take a quick peek at the result:

~~~
head -5 isles.dat
~~~
{: .language-bash}

This shows us the first 5 lines in the output file:

```bash
the 8089 4.836269931901207   
and 5976 3.5729446301201144   
i 4846 2.897337630114136   
to 4745 2.836951517724221   
of 3748 2.240862863736645  
a 3013 1.8014193725823135   
he 2581 1.5431342185977268
...
```


We can see that the file consists of one row per word. Each row shows the
word itself, the number of occurrences of that word, and the number of
occurrences as a percentage of the total number of words in the text file.
The file is sorted by descending frequency, so the first 5 lines
are the 5 most frequent words in the input text.

Let's visualize the results. The script `plotcount.py` reads in a data file
and plots the 10 most frequently occurring words as a text-based bar plot:

```bash
python snakemake/plotcount.py data/dracula.dat ascii
```
***in case the error: cannot import Sequence from Collections either add or remove the .abc from 'from collections.abc import Sequence'***
```bash
the   ########################################################################
and   #####################################################
i     ###########################################
to    ##########################################
of    #################################
a     ###########################
he    #######################
in    #######################
that  ######################
it    ###################
```


`plotcount.py` can also create the plot as an image file:

```bash
python snakemakeplotcount.py data/dracula.dat data/dracula.png
```

Finally, let's test Zipf's law for these two books:

```bash
python snakemake/zipf_test.py data/moby_dick.dat data/dracula.dat
```

```bash
Book            First   Second  Ratio
data/dracula    8089    5976    1.35
data/moby_dick  14519   6734    2.16
```


> ### Zipf's Law
>
> Recall that Zipf's Law predicts that the most frequent word will
> occur approximately twice as often as the second most frequent word.


Together these scripts implement a common workflow:

1. Read a data file.
2. Perform an analysis on this data file.
3. Write the analysis results to a new file.
4. Plot a graph of the analysis results.
5. Save the graph as an image, so we can put it in a paper.
6. Make a summary table of the analyses, which requires aggregation of all previous results.

Running `wordcount.py` and `plotcount.py` at the shell prompt, as we have
been doing, is fine for one or two files. If, however, we had 5 or 10 or 20
text files, or if the number of steps in the pipeline were to expand, this
could turn into a lot of work. Plus, no one wants to sit and wait for a
command to finish, even just for 30 seconds.

The most common solution to the tedium of data processing is to write
a shell script that runs the whole pipeline from start to finish.

Using your text editor of choice (e.g. nano), add the following to a new file named
`run_pipeline.sh`.

```bash
# USAGE: bash run_pipeline.sh
# to produce plots for isles and abyss
# and the summary table for the Zipf's law tests

python wordcount.py books/isles.txt isles.dat
python wordcount.py books/abyss.txt abyss.dat

python plotcount.py isles.dat isles.png
python plotcount.py abyss.dat abyss.png

# Generate summary table
python zipf_test.py abyss.dat isles.dat > results.txt 
```

Run the script and check that the output is the same as before:

```bash
bash run_pipeline.sh
cat results.txt
```

This shell script solves several problems in computational reproducibility:

1. It explicitly documents our pipeline,
    making communication with colleagues (and our future selves) more efficient.
2. It allows us to type a single command, `bash run_pipeline.sh`, to
    reproduce the full analysis.
3. It prevents us from *repeating* typos or mistakes.
    You might not get it right the first time, but once you fix something
    it'll stay fixed.

Despite these benefits it has a few shortcomings.

Let's adjust the width of the bars in our plot produced by `plotcount.py`.

Edit `plotcount.py` so that the bars are 0.8 units wide instead of 1 unit.
(Hint: replace `width = 1.0` with `width = 0.8` in the definition of
`plot_word_counts`.)

Now we want to recreate our figures. We *could* just `bash run_pipeline.sh`
again. That would work, but it could also be a big pain if counting words
takes more than a few seconds. The word counting routine hasn't changed; we
shouldn't need to recreate those files.

Alternatively, we could manually rerun the plotting for each word-count file.
(Experienced shell scripters can make this easier on themselves using a
for-loop.)

```bash
for book in abyss isles; do
    python plotcount.py $book.dat $book.png
done
```


Another popular option is to comment out a subset of the lines in
`run_pipeline.sh`:

```bash
# USAGE: bash run_pipeline.sh
# to produce plots for isles and abyss
# and the summary table

# These lines are commented out because they don't need to be rerun.
#python wordcount.py books/isles.txt isles.dat
#python wordcount.py books/abyss.txt abyss.dat

python plotcount.py isles.dat isles.png
python plotcount.py abyss.dat abyss.png

# This line is also commented out because it doesn't need to be rerun.
python zipf_test.py abyss.dat isles.dat > results.txt
```

Then, we would run our modified shell script using `bash run_pipeline.sh`.

But commenting out these lines, and subsequently uncommenting them, can be a
hassle and source of errors in complicated pipelines. What happens if we have
hundreds of input files? No one wants to enter the same command a hundred
times, and then edit the result.

What we really want is an executable *description* of our pipeline that
allows software to do the tricky part for us: figuring out what tasks need to
be run where and when, then perform those tasks for us.

