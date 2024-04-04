# Snakemake Continued Part 2

## Resources and parallelism

After the exercises at the end of our last lesson, our Snakefile looks something like this (note the dats and print_book_names rules are no longer required so they have been removed):

```Python
# Build the list of book names. We need to use it multiple times when building
# the lists of files that will be built in the workflow
BOOK_NAMES = glob_wildcards('../../data/{book}.txt').book

# The list of all dat files
DATS = expand('../../results/dats/{file}.dat', file=BOOK_NAMES)

# The list of all plot files
PLOTS = expand('../../results/plots/{file}.png', file=BOOK_NAMES)

# pseudo-rule that tries to build everything.
# Just add all the final outputs that you want built.
rule all:
    input: '../../results/zipf_analysis.tar.gz'

# Generate summary table
rule zipf_test:
    input:
        cmd='../zipf_test.py',
        dats=DATS
    output: '../../results/results.txt'
    shell:  'python {input.cmd} {input.dats} > {output}'

# delete everything so we can re-run things
rule clean:
    shell: 'rm -rf ../../results/dats/ ../../results/plots/ ../../results/results.txt ../../results/zipf_analysis.tar.gz'

# Count words in one of the books
rule count_words:
    input:
        cmd='../wordcount.py',
        book='../../data{book}.txt'
    output: '../../results/dats{book}.dat'
    shell: 'python {input.cmd} {input.book} {output}'

# plot one word count dat file
rule make_plot:
    input:
        cmd='../plotcount.py',
        dats='../../results/dats{book}.dat'
    output: '../../results/plots{book}.png'
    shell: 'python {input.cmd} {input.dats} {output}'

# create an archive with all results
rule create_archive:
    input: '../../results/results.txt', DATS, PLOTS
    output: '../../results/zipf_analysis.tar.gz'
    shell: 'tar -czvf {output} {input}'


```

At this point, we have a complete data analysis pipeline. Very cool. But how do we make it run as efficiently as possible?

### Running in Parallel

```output
Provided cores: 1
Rules claiming more threads will be scaled down.
```
So far, Snakemake has been running in single-threaded mode, using just one CPU core. This means that even when Snakemake can identify tasks that could run at the same time, such as counting words in different books, it still runs them one at a time. Let's see how to change that, and scale up our pipeline to run in parallel.

The only change we need to make is run Snakemake with the `-j` argument. `-j` tells Snakemake the maximum number or CPU cores that it can use. You can also use the long-form `--cores`. The long-form is particularly useful in shell scripts to make your script self-documenting.

```bash
snakemake clean
snakemake -j 4    # 4 cores is usually a safe assumption when working on a laptop/desktop
```
```Output
Provided cores: 4
Rules claiming more threads will be scaled down.
# more output follows
```
Our pipeline ran in parallel and finished roughly 4 times as quickly! The takeaway here is that all we need to do to scale from a serial pipeline is run `snakemake` with the `-j` option. By analysing the dependencies between rules, Snakemake automatically identifies which tasks can run at the same time. All you need to do is describe your workflow and Snakemake does the rest.

Note you can also use `snakemake --cores 4` or `snakemake --jobs 4`. The `-j`, `--cores` and `--jobs` arguments all mean the same thing.

### Self-documention

*Using the long-form of command-line arguments can be useful in scripts. They make the code more understandable since you don't need to remember what `-j` does. `--cores` is most useful in scripts that run snakemake locally, while `--jobs` is most often used when running on a HPC cluster.
When typing manually on the command-line, the short versions are faster.*

### How many CPUs does your computer have?

Now that our pipeline can use multiple CPUs, how do we know how many CPUs to provide to the `-j` option? Note that for all of these options, it's best to use CPU cores, and not CPU threads. **Linux** - You can use the `lscpu` command. Look for the number listed alongside `CPU(s):`.

**All platforms** - Python's `psutil` module can be used to fetch the number of cores in your computer.
Using `logical=False` returns the number of true CPU cores. `logical=True` gives the number of CPU threads on your system.

In a Python interpreter, try the following:
```python
import psutil
psutil.cpu_count(logical=False)
```
### Managing CPUs

Each rule has a number of optional keywords aside from the usual `input`,
`output`, and `shell`/`run`. The `threads` keyword is used to specify how
many CPU cores a rule needs while executing. Though in reality threads are
not the same as CPU cores, the two terms are interchangeable when working
with Snakemake.

Let's pretend that our `count_words` rule is multithreaded and requires 4
CPU cores. We can specify this with the `threads` keyword in our rule. We
will also modify the rule to print out the number of cores it thinks it is
using.

**Note**
> Please note that just giving something 4 threads in Snakemake does not
> make it run in parallel! It just tells Snakemake to reserve that number
> of cores from the total available (indicated by the value passed to `-j`).
>
> In this case `wordcount.py` is actually still running with 1 core, we
> are simply using it as a demonstration of how to go about running
> something with multiple cores since we don't have any truly parallel tasks.
{:.callout}

```Python
rule count_words:
    input:
        cmd='wordcount.py',
        book='data/{file}.txt'
    output: 'dats/{file}.dat'
    threads: 4
    shell:
        '''
        echo "Running {input.cmd} with {threads} cores."
        python {input.cmd} {input.book} {output}
        '''
```


**Windows Note**
> When running on Windows using Git Bash and Anaconda, the previous code will
> not work. Multiline strings containing multiple shell commands are not
> executed correctly. The simplest workaround is to add `&&\` to the end of all
> lines except the last inside the multiline shell command:

> ```Python
> rule count_words:
>     input:
>         cmd='wordcount.py',
>         book='books/{file}.txt'
>     output: 'dats/{file}.dat'
>     threads: 4
>     shell:
>         '''
>         echo "Running {input.cmd} with {threads} cores." &&\
>         python {input.cmd} {input.book} {output}
>         '''
> ```
> 

Now, when we run `snakemake -j 4`, the `count_words` rules are run one at a
time. All of our other rules will still run in parallel. Unless otherwise
specified with `{threads}`, rules will use 1 core by default.

```Output
Provided cores: 4
Rules claiming more threads will be scaled down.
Job counts:
	count	jobs
	1	all
	4	count_words
	1	make_archive
	4	make_plot
	1	zipf_test
	11

rule count_words:
    input: wordcount.py, data/dracula.txt
    output: dats/dracula.dat
    jobid: 3
    wildcards: file=dracula
    threads: 4

Running wordcount.py with 4 cores.
Finished job 3.
1 of 11 steps (9%) done

# other output follows
```

What happens when we don't have 4 cores available? What if we tell Snakemake
to run with 2 cores instead?

```bash
snakemake -j 2
```


```Output
Provided cores: 2
Rules claiming more threads will be scaled down.
Job counts:
	count	jobs
	1	all
	4	count_words
	1	make_archive
	4	make_plot
	1	zipf_test
	11

rule count_words:
    input: wordcount.py, data/dracula.txt
    output: dats/dracula.dat
    jobid: 6
    wildcards: file=dracula
    threads: 2

Running wordcount.py with 2 cores.
Finished job 6.
1 of 11 steps (9%) done

# more output below
```

The answer is given by `Rules claiming more threads will be scaled down.`.
When Snakemake doesn't have enough cores to run a rule (as defined by
`{threads}`), that rule will run with the maximum available number
of cores instead. After all, Snakemake's job is to get our workflow done. It
automatically scales our workload to match the maximum number of cores
available without us editing the Snakefile.

#### If you absolutely must have a minimum number of cores for a rule
If you have a task that cannot run with less than a specific
number of cores, then you can check the value of `{threads}` using a Bash if
test:
```bash
    shell:
        '''
        if [ {threads} -lt 4 ]
        then
            echo Not enough threads for task
            exit 1
        fi
        # Your actual command goes here
        '''
```
This code tests if the current value of `{threads}` is less than 4. If it is,
then it exits with an error code of 1. You can use any value you like so long
as it is not 0. An exit code of 0 indicates success.
If the value of `{threads}` is at least the same as your minimum requirement
then the rest of the shell section will execute.
If you have a Python `run` command then you should use regular Python to do a
similar check.
Note that unfortunately this approach does not work on Windows.

#### Tasks Still Need to Know How Many Cores are Available
How the number of threads required by a rule matches the number of cores
allowed to Snakemake by the `-j N` argument determines how many instances
of that rule Snakemake will run at the same time. It does not mean that
the code being executed will magically know what the limits are.
The previous code example showed how the `{threads}` wildcard can be used
to get the actual number of cores allocated to an action.
This value can be passed in as a command-line argument or set to an
environment variable.
{:.callout}

### Chaining multiple commands

Up until now, most of our commands have fit on one line. To execute multiple
bash commands, the only modification we need to make is use a Python
multiline string (begin and end with `"""` or `'''`).

One important addition we should be aware of is the `&&` operator. `&&` is a
bash operator that runs commands as part of a chain. If the first command
fails, the remaining steps are not run. This is more forgiving than bash's
default "hit an error and keep going" behavior. After all, if the first
command failed, it's unlikely the other steps will work.

Let's modify `count_words` to chain the `echo` and `python` commands (Windows users
may have already done this):

```Python
rule count_words:
    input:
        cmd='wordcount.py',
        book='data/{file}.txt'
    output: 'dats/{file}.dat'
    threads: 4
    shell:
        '''
        echo "Running {input.cmd} with {threads} cores." &&
        python {input.cmd} {input.book} {output}
        '''
```
### Managing other types of resources

Not all compute resources are CPUs. Examples might include limited amounts of
RAM, number of GPUs, database locks, or perhaps we simply don't want multiple
processes writing to the same file at once. All non-CPU resources are handled
using the `resources` keyword.

For our example, let's pretend that creating a plot with `plotcount.py`
requires dedicated access to a GPU (it doesn't), and only one GPU is
available. How do we indicate this to Snakemake so that it knows to give
dedicated access to a GPU for rules that need it? Let's modify the
`make_plot` rule as an example:

```Python
rule make_plot:
    input:
        cmd='plotcount.py',
        dat='dats/{file}.dat'
    output: 'plots/{file}.png'
    resources: gpu=1
    shell: 'python {input.cmd} {input.dat} {output}'
```

We can execute our pipeline using the following (using 4 cores and 1 gpu):

```bash
snakemake clean
snakemake -j 4 --resources gpu=1
```

```output
Provided cores: 4
Rules claiming more threads will be scaled down.
Provided resources: gpu=1
# other output removed for brevity
```

If you examine the output carefully, you should be able to see that the
`make_plot` rules are no longer run in parallel. Since you have indicated
that just one GPU is available, and each instance of `make_plot` requires one
GPU, Snakemake runs the rules one at a time.

Resources are entirely arbitrary - like wildcards, they can be named
anything. Snakemake knows nothing about them aside from the fact that they
have a name and a value. In this case `gpu` indicates simply that there is a
resource called `gpu` used by `make_plot`. We provided 1 `gpu` to the
workflow, and the `gpu` is considered in use as long as the rule is running.
Once the `make_plot` rule completes, the `gpu` it consumed is added back to
the pool of available `gpu`s.

But what happens if we run our pipeline without specifying the number of GPUs?

```bash
snakemake clean
snakemake -j 4
```

```output
Provided cores: 4
Rules claiming more threads will be scaled down.
Unlimited resources: gpu
```

If you have specified that a rule needs a certain resource, but do not
specify how many you have, Snakemake will assume that the resources in
question are unlimited.

Note that this is opposite to `--cores` which defaults to 1.


### Other uses for `resources`

Resources do not have to correspond to actual compute resources.

Perhaps one rule is particularly I/O heavy, and it's best if only a limited number of these jobs run at a time.
Or maybe a type of rule uses a lot of network bandwidth as it downloads data.

In all of these cases, `resources` can be used to constrain access to arbitrary compute resources so that each rule can run efficiently.
Snakemake will run your rules in such a way as to maximize throughput given your resource constraints.


## Make your workflow portable and reduce duplication


Duplication in file names, paths, and pattern strings is a common source of
errors in snakefiles. For example, have a look at how often the directory
names are mentioned (`dats`, `plots` etc) in the examples from this workshop.

This episode presents a pattern for reducing file name duplication and making
your workflows less error-prone. In addition, this approach makes your
workflows more portable by moving all configurable items into a separate
configuration file.

For these exercises, you should start with either your completed Snakefile
from the end of the previous episode, or else use the example Snakefile
`.solutions/reduce_duplication/Snakefile-start`. Copy it to your working directory
and rename to `Snakefile`.

## Removing Duplication

First, examine the Snakefile to identify duplicated file names, paths, and patterns.
Move each one to a common global variable at the top of the Snakefile.

For example, we currently refer to single input books in two locations:

```pytnon
BOOK_NAMES = glob_wildcards('data/{book}.txt').book
```

```python
rule count_words:
    input:
        cmd='wordcount.py',
        book='data/{file}.txt'
```

The different wildcard names (`{book}, {file}`) are a distraction. Both
patterns refer to an input file.

Similarly, the strings that identify a single plot and a single dat file
are duplicated.

#### Identify Duplication 
How many times does the dat file pattern occur? It should be **3** times.
```python
DATS = expand('dats/{file}.dat', file=BOOK_NAMES)
```
```Python
rule count_words:
    input:
        cmd='wordcount.py',
        book='data/{file}.txt'
    output: 'dats/{file}.dat'
    shell: 'python {input.cmd} {input.book} {output}'
```

```Python
rule make_plot:
    input:
        cmd='plotcount.py',
        dat='dats/{file}.dat'
    output: 'plots/{file}.png'
    shell: 'python {input.cmd} {input.dat} {output}'
```

Once duplicated file patterns have been identified, they can be moved to
global variables at the start of the Snakefile and then just refered to by
name.

Here is what the changes for input files might look like:

```Python
# a single input book
BOOK_FILE = 'data/{book}.txt'

# Build the list of book names.
BOOK_NAMES = glob_wildcards(BOOK_FILE).book

rule count_words:
    input:
        cmd='wordcount.py',
        book=BOOK_FILE
    output: 'dats/{book}.dat'
    shell: 'python {input.cmd} {input.book} {output}'
```

Note that we have adopted `{book}` as the wildcard name, rather than the
inconsistent use of `{book}` and `{file}`.

### Global variables also work for `glob_wildcards` and `expand`

Another point to note is the previous code used `BOOK_FILE` for a rule input and for a call to `glob_wildcards`. Remember this when updating the calls to `expand` in the next challenge. 


### The Benefits So Far

These changes bring a lot of benefits to Snakefiles, and most of these benefits increase as your Snakefiles become more complex. Defining each file pattern just once reduces the chance of error, and makes changing patterns easier. Having all the file patterns and lists defined at the start of the file also makes things easier to read. Finally, using the global variable names elsewhere in the file tends to make rules easier to read. Instead of trying to remember what the right pattern is, or what a given pattern means, the extra level of abstraction should improve readability. For example, the `create_archive` rule now looks something like this:

```Python
rule create_archive:
    input: RESULTS_FILE, ALL_DATS, ALL_PLOTS
    output: ARCHIVE_FILE
    shell: 'tar -czvf {output} {input}'
```

The intent of the rule should be clear, and the intricacies of paths and file
name patterns are not confusing things.

#### Use Consistent Naming Conventions
We suggest the following global variable naming conventions:
- `*_FILE` for single files or wildcard patterns
- `ALL_*` for lists of files (frequently built using `expand`)
-
You can of course use your own conventions. Consistency is the key.

### Improving Portability

Imagine that we now want to share this workflow with a colleague, but they
have their input files in a different location. Additionally, they require a
different directory layout for the results, and a different results file
name.

In other words, they think our workflow is great, but they want to customise
and configure it.

Of course, they can just modify the Snakefile, but this can get annoying when
the Snakefile is shared (such as through a shared directory or via Git).

A better approach is to use configuration files. Snakemake supports `json`
and `yaml` formats, we use `yaml` here as it is easier to edit and read.

First, move all values that need to be configurable into a configuration file
alongside the Snakefile. Here we show the input file directory that has been
added to a new file called `config.yaml` (it's just a text file):

```Yaml
input_dir: data/
```

In the Snakefile we first load the configuration with the `configfile` keyword:

```Python
configfile: 'config.yaml'
```

Once that has been done, the configuration is accessed through the `config` dictionary created by Snakemake:

```Python
INPUT_DIR = config['input_dir']
```

Finally, we use Python string formatting to build `BOOK_FILE`. Note that the
we need to escape the wildcard in double curly braces. This ensures the
formatted string contains `{book}`. Failure to do this will cause an
exception since the string formatting code will be expecting a token called
`book` (try it and see!).

```Python
BOOK_FILE = f'{INPUT_DIR}{{book}}.txt'
```
The rest of the workflow remains unchanged.


**Don't put your configuration file in source control**
Instead:
- create a sample configuration with a different name such as `config_template.yaml`.
- instruct users to copy the template to the real configuration file (`config.yaml`).
- make sure the configuration file name is in the `.gitignore` file (or equivalent).



## HPC cluster architecture

Most HPC clusters are run using a **scheduler**. 
The scheduler is a piece of software that decides when a job will run, and on which nodes. 

It allows a set of users to share a shared computing system as efficiently as possible. In order to use it, users typically must write their commands to be run into a shell script and then "submit" it to the scheduler. 

A good analogy would be a university's room booking system.  No one gets to use a room without going through the booking system.  The booking system decides which rooms people get based on their requirements (# of students, time allotted, etc.).


**Some Assumptions**
HPC clusters vary in their configuration, available software, and use. In order to keep this episode focused, some assumptions have been made:

- Your cluster uses the Slurm scheduler. If your system uses a different scheduler such as PBS then you may need to adjust the batch system command used to submit jobs.

- Your cluster uses environment modules to manage the software available to you. While some module names are used here, the actual modules may not be the same on your system. Please consult your HPC user support if you have difficulty finding the correct modules to use.

Right now we have a reasonably effective pipeline that scales nicely on our local computer. However, for the sake of this course, we'll pretend that our workflow actually takes significant computational resources and needs to be run on a **HPC cluster**.

Normally, updating a workflow to run on a HPC cluster requires a lot of work.
Batch scripts need to be written, and you'll need to monitor and babysit the
status of each of your jobs. This is especially difficult if one batch job
depends on the output from another. Even moving from one cluster to another
(especially ones using a different scheduler) requires a large investment of
time and effort. Frequently most of the batch scripts need to be rewritten.

Snakemake does all of this for you. All details of running the pipeline on the
cluster are handled by Snakemake - this includes writing batch scripts,
submitting, and monitoring jobs. In this scenario, the role of the scheduler is
limited to ensuring each Snakemake rule is executed with the resources it needs.

We'll explore how to port our example Snakemake pipeline by example. Our current
Snakefile is shown below. If you have skipped the previous episode, or if your
current Snakefile does not match, then please update to the following code. If
you require a configuration file, you can use
`.solutions/reduce_duplication/config.yaml`.
**TODO**

```Python
#------------------------------------------------------------
# load the configuration
configfile: 'config.yaml'

INPUT_DIR = config['input_dir']
PLOT_DIR = config['plot_dir']
DAT_DIR = config['dat_dir']
RESULTS_FILE = config['results_file']
ARCHIVE_FILE = config['archive_file']

#------------------------------------------------------------
# Single file patterns
#
# Now define all the wildcard patterns that either depend on
# directory and file configuration, or are used more than once.

# Note the use of single curly braces for global variables
# and double curly braces for snakemake wildcards

# a single plot file
PLOT_FILE = f'{PLOT_DIR}{{book}}.png'

# a single dat file
DAT_FILE = f'{DAT_DIR}{{book}}.dat'

# a single input book
BOOK_FILE = f'{INPUT_DIR}{{book}}.txt'

#------------------------------------------------------------
# File lists
#
# Now we can use the single file patterns in conjunction with
# glob_wildcards and expand to build the lists of all expected files.

# the list of book names
BOOK_NAMES = glob_wildcards(BOOK_FILE).book

# The list of all dat files
ALL_DATS = expand(DAT_FILE, book=BOOK_NAMES)

# The list of all plot files
ALL_PLOTS = expand(PLOT_FILE, book=BOOK_NAMES)

#------------------------------------------------------------
# Rules
#
# Note that when using this pattern, it is rare for a rule to
# define filename patterns directly. Nearly all inputs and outputs
# can be specified using the existing global variables.

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
    # This shell command only contains wildcards, so it does not
    # require an f-string or double curly braces.
    shell:  'python {input.cmd} {input.dats} > {output}'

# delete everything so we can re-run things
# This rules uses an f-string and single curly braces since all values
# are global variables rather than wildcards.
rule clean:
    shell: f'rm -rf {DAT_DIR} {PLOT_DIR} {RESULTS_FILE} {ARCHIVE_FILE}'

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

To run Snakemake on a cluster, we need to tell it how it to submit jobs. This is
done using the `--cluster` argument. In this configuration, Snakemake runs on
the cluster login node and submits jobs. Each cluster job executes a single rule
and then exits. Snakemake detects the creation of output files, and submits new
jobs (rules) once their dependencies are created. Snakemake has many options
available to fine-tune the interactions with the scheduler, including resource
requests, and the maximum number of jobs to submit at any time. We will explore
the essential options here.

### Transferring our workflow

The first step will be to transfer our files to the cluster and log
on via SSH. While this part won't be needed for passing the course, we included this, to show you how the typical workflow will be executed on a cluster.

**Please Follow Your System Procedures**

Generic advice for transferring files and logging on to a HPC cluster is given here. Please follow your system's own user guidelines. If your HPC system allows graphical desktops, you could run a browser on the login node and download the code samples for this workshop directly to the cluster.

The essential thing is to be logged into the cluster login node, with your Snakefile and other data files available.

```Bash
snakemake clean
tar -czvf pipeline.tar.gz .
# transfer the pipeline via scp
scp pipeline.tar.gz yourUsername@pearcey-login.hpc.csiro.au
# log on to the cluster
ssh -X yourUsername@pearcey-login.hpc.csiro.au
```

At this point we've archived our entire pipeline, sent it to the cluster, and
logged on. Let's create a folder for our pipeline and unpack it there:

```bash
mkdir pipeline
mv pipeline.tar.gz pipeline
cd pipeline
tar -xvzf pipeline.tar.gz
```

#### CSIRO Clusters

On the CSIRO Pearcey system, snakemake and all required Python packages are available in the `python/3.6.1` module. Load it with:
```bash
module load python/3.6.1
```

If Snakemake and Python are not already installed on your cluster, you can
install them using the following commands:

```bash
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b
echo 'export PATH=~/miniconda3/bin:~/.local/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
conda install -y matplotlib numpy graphviz
pip install --user snakemake
```

Assuming you've transferred your files and everything is set to go, the command
`snakemake -n` should work without errors.

#### Cluster configuration with `cluster.yaml`

Snakemake uses a YAML-formatted configuration file to retrieve cluster
submission parameters (JSON is also supported, but not shown here). An example
(using SLURM) is shown below.

```yaml
__default__:
    time: 0:5:0
    mem: 1G

count_words:
    time: 0:10:0
    mem: 2G
```

This file has several components. The values under `__default__` represent a set
of default configuration values that will be used for all rules. The defaults
won't always be perfect, however - chances are some rules may need to run with
non-default amounts of memory, cores, or time limits. We are using the
`count_words` rule as an example of this.

This is sufficient configuration for these exercises. For more information, please consult the [Cluster Configuration](https://snakemake.readthedocs.io/en/stable/snakefiles/configuration.html#cluster-configuration) documentation.

#### Local rule execution

Some Snakemake rules perform trivial tasks where job submission might be
overkill (i.e. less than 1 minute worth of compute time). It would be a better
idea to have these rules execute locally (i.e. where the `snakemake` command is
run) instead of as a job. Snakemake lets you indicate which rules should always
run locally with the `localrules` keyword. Let's define `all`, `clean`, and
`make_archive` as local rules near the top of our `Snakefile` (in the example
code we added this line just before the `all` rule).

```Python
localrules: all, clean, make_archive
```

### Running our workflow on the cluster

Ok, time for the moment we've all been waiting for - let's run our workflow on
the cluster. To run our Snakefile, we'll run the following command:

```bash
snakemake --jobs 100 --cluster-config cluster.yaml --cluster "sbatch --mem={cluster.mem} --time {cluster.time} --cpus-per-task {threads}"
```

**Job submission options will vary**
Some HPC systems require additional options when submitting jobs, such as an account or partitiion name. Please consult your system guidelines for the additional arguments.

While things execute, you may wish to SSH to the cluster in another window so
you can watch the pipeline's progress with `watch squeue -u $(whoami)`.

Now, let's dissect the command we just ran:

- **`--jobs 100`** - `--jobs` or `-j` no longer controls the number of cores
  when running on a cluster. Instead, it controls the maximum number of jobs
  that snakemake can submit at a time. This does not come into play here, but
  generally a sensible default is slightly below the maximum number of jobs you
  are allowed to have submitted at a time on your system.

- **`--cluster-config`** - This specifies the location of a configuration file
  to read cluster configuration values from. This should point to the
  `cluster.yaml` file we wrote earlier.

- **`--cluster`** - This is the submission command that should be used for the
  scheduler. Note that command flags that normally are put in batch scripts are
  put here (most schedulers allow you to add submission flags like this when
  submitting a job). The values come from our `--cluster-config` file. You can
  access individual values with `{cluster.propertyName}`. Note that we also use
  `{threads}` here.  When submitting jobs, Snakemake will use the current value
  of `threads` given in the Snakefile for each rule.

**Notes on `$PATH`**

*As with any cluster jobs, jobs started by Snakemake need to have the commands they are running on `$PATH`. For some schedulers (SLURM), no modifications are necessary - variables are passed to the jobs by default. You just need to load all the required environment modules prior to running Snakemake.*


#### Dealing with Busy Systems

When some clusters are busy, there may be a delay between when a job completes
and when the output file appears on the file system being monitored by
Snakemake. If this delay is too long, Snakemake will decide that the rule has
failed. If this appears to be happening, you can instruct Snakemake to wait
longer with the `--latency-wait` argument:

```Bash
snakemake --latency-wait 60 --jobs 100 --cluster-config cluster.yaml --cluster "sbatch --mem={cluster.mem} --time {cluster.time} --cpus-per-task {threads}"
```

The value is a wait time in seconds.

## Finishing remarks

Now that we know how to write and scale a pipeline, here are some tips and
tricks for making the process go more smoothly.

1. **dry-run is your friend**

Whenever you edit your Snakefile, you should perform a dry-run with
`snakemake clean && snakemake -n` or `snakemake clean && snakemake --dry-run`
immediately afterwards. This will check for errors and make sure that the
pipeline is able to run. The clean is required to force the dry run to test
the entire pipeline.

The most common source of errors is a mismatch in filenames (Snakemake
doesn't know how to produce a particular output file) - `snakemake -n` will
catch this as long as the troublesome output files haven't already been made,
and the `snakemake clean` should take care of that.

2. **Configuring logging**

By default, Snakemake prints all output from stderr and stdout from rules.
This is useful, but if a failure occurs (or we otherwise need to inspect the
logs) it can be extremely difficult to determine what happened or which rule
had an issue, especially when running in parallel.

The solution to this issue is to redirect the output from each rule/ set of
inputs to a dedicated logfile. We can do this using the `log` keyword. Let's
modify our `count_words` rule to be slighly more verbose and redirect this
output to a dedicated logfile.

Two things before we start:

- `&>` is a handy operator in bash that redirects both stdout and stderr to a file.
- `&>>` does the same thing as `&>`, but appends to a file instead of overwriting it.

```Python
# count words in one of our "books"
rule count_words:
    input:
        wc='wordcount.py',
        book='books/{file}.txt'
    output: 'dats/{file}.dat'
    threads: 4
    log: 'dats/{file}.log'
    shell:
        '''
        echo "Running {input.wc} with {threads} cores on {input.book}." &> {log}
        python {input.wc} {input.book} {output} &>> {log}
        '''
```

```bash
snakemake clean
snakemake -j 8
cat dats/abyss.log
```

```output
# snakemake output omitted
Running wordcount.py with 4 cores on books/abyss.txt.
```


Notice how the pipeline no longer prints to the terminal output, and instead
redirects to a logfile.

*Choosing a good log file location*
Though you can put a log anywhere (and name it anything), it is often a good practice to put the log in the same directory where the rule's output will be created. If you need to investigate the output for a rule and associated logfiles, this means that you only have to check one location!


3. **Token files**

Often, a rule does not generate a unique output, and merely modifies a file.
In these cases it is often worthwhile to create a placeholder, or "token
file" as output. A token file is simply an empty file that you can create
with the touch command (`touch some_file.txt` creates an empty file called
`some_file.txt`).

You can then use the token file as an input to other rules that shouldn't run
until after the rule that generates the token.

An example rule using this technique is shown below:

```Python
rule token_example:
    input:  'some_file.txt'
    output: 'some_file.tkn'   # marks some_file.txt as modified
    shell:
        '''
        some_command --do-things {input} &&
            touch {output}
        '''
```

4. **Directory locks**

Only one instance of Snakemake can run in a directory at a time. If a
Snakemake run fails without unlocking the directory (if you killed the
process, for instance), you can run `snakemake --unlock` to unlock it.

5. **Python as a fallback**

Remember, you can use Python imports and functions anywhere in a Snakefile.
If something seems a little tricky to implement - Python can do it. The `os`,
`shutil`, and `subprocess` packages are useful tools for using Python to
execute command line actions. In particular, `os.system('some command')` will
run a command on the command-line and block until execution is complete.

6. **Creating a workflow diagram**

Assuming graphviz is installed (`conda install graphviz`), you can create a
diagram of your workflow with the command: `snakemake --dag | dot -Tsvg >
dag.svg`. This creates a plot of your "directed acyclic graph" (a plot of all
of the rules Snakemake thinks it needs to complete), which you can view using
any picture viewing program. In fact this was the tool used to create all of
the diagrams in this lesson:

```bash
snakemake --dag | dot -Tsvg > dag.svg
eog dag.svg     # eog is an image viewer installed on many linux systems
```

```{figure} ../../figures/snakemake/final.svg
:name: Snakemake Graph Example
From 5 Resources and Parallel processing
```

Rules that have yet to be completed are indicated with solid outlines.
Already completed tasks will be indicated with dashed outlines. In this case,
We ran `snakemake clean`, just before creating the diagram - no rules have
been run yet.

> CSIRO Clusters
>
> On CSIRO clusters, you can load the `imagemagick` module to view the
> diagrams:
> ```bash
> module load imagemagick
> snakemake --dag | dot -Tpng | display
> ```

7. **Viewing the GUI**

Snakemake has an experimental web browser GUI. I personally haven't used it
for anything, but it's cool to know it's there and can be used to view your
workflow on the fly.

`snakemake --gui`

Note that this requires the installation of additional Python packages.

8. **Where to go for documentation / help**

The Snakemake documentation is located at
[snakemake.readthedocs.io](http://snakemake.readthedocs.io)

