# Building Command-Line Tools with Python 

After the previous chapters, our Zipf repository (found [here](https://gitup.uni-potsdam.de/seg/rse_course/zipf)) should have the following directories and files:

```text
zipf/
|__ README.md
├── bin
│   ├── Zipf.ipynb
│   ├── plotcount.py
│   ├── Wordcount.py
│   ├── zipf_test.py
│   ├── requirements.txt
└── data
    ├── README.md
    ├── dracula.txt
    ├── frankenstein.txt
    ├── jane_eyre.txt
    ├── moby_dick.txt
    ├── sense_and_sensibility.txt
    ├── sherlock_holmes.txt
    └── time_machine.txt
```

> **Python Style**
>
> When writing Python code there are many style choices to make.
> How many spaces should I put between functions?
> Should I use capital letters in variable names?
> How should I order all the different elements of a Python script?
> Fortunately,
> there are well established conventions and guidelines
> for good Python style.
> We follow those guidelines throughout this book
> and discuss them in detail in the chapter on readable code found [here](https://software-engineering-group-up.github.io/RSE-UP/chapters/clean_readable_code.html#python-style).

## Programs and Modules 

To create a Python program that can run from the command line,\index{Python!program vs.\ module}
the first thing we do is to add the following to the bottom of the file:

```Python
if __name__ == '__main__':
```
This strange-looking check tells us whether the file is running as a standalone program or whether it is being imported as a module by some other program.
When we import a Python file as a module in another program, the `__name__` variable is automatically set to the name of the file.\index{\_\_name\_\_ variable (in Python)}\index{Python!\_\_name\_\_ variable}
When we run a Python file as a standalone program, on the other hand, `__name__` is always set to the special string `"__main__"`.
To illustrate this, let's consider a script named `print_name.py` that prints the value of the `__name__` variable:

```Python
print(__name__)
```
When we run this file directly, it will print `__main__`: 

```bash
$ python print_name.py
```

```text
__main__
```

But if we import `print_name.py` from another file or from the Python interpreter, it will print the name of the file, i.e., `print_name`.

```bash
$ python
```

```text
Python 3.7.6 (default, Jan  8 2020, 13:42:34) 
[Clang 4.0.1 (tags/RELEASE_401/final)] :: 
Anaconda, Inc. on darwin
Type "help", "copyright", "credits" or "license"
for more information.
```

```python
>>> import print_name
```
```text
print_name
```

Checking the value of the variable `__name__` therefore tells us whether our file is the top-level program or not. If it is, we can handle command-line options, print help, or whatever else is appropriate;
if it isn't, we should assume that some other code is doing this. 

We could put the main program code directly under the `if` statement like this:

```python
if __name__ == "__main__":
    # code goes here
```

but that is considered poor practice, since it makes testing harder (Chapter **TODO** ref(testing)). Instead, we put the high-level logic in a function, then call that function if our file is being run directly:

```Python 
def main():
    print('Hello World!')

if __name__ == '__main__':
    main()
```

This top-level function is usually called `main`, but we can use whatever name we want.

## Handling Command-Line Options 

The main function in a program usually starts by parsing any options the user gave on the command line.
The most commonly used library for doing this in Python is [`argparse`](https://docs.python.org/3/library/argparse.html), which can handle options with or without arguments, convert arguments from strings to numbers or other types, display help, and many other things.

The simplest way to explain how `argparse` works is by example. 

Let's create a short Python program called `script_template.py`:

```Python
import argparse


def main(args):
    print('Input file:', args.infile)
    print('Output file:', args.outfile)


if __name__ == '__main__':
    USAGE = 'Brief description of what the script does.'
    parser = argparse.ArgumentParser(description=USAGE)
    parser.add_argument('infile', type=str,
                        help='Input file name')
    parser.add_argument('outfile', type=str,
                        help='Output file name')
    
    # since jupyter notebook does not have a command line interface we need to simulate it. 
    # args = parser.parse_args()  # use this when running from command line 
    args = argparse.Namespace(infile='input.txt', outfile='output.txt') # use this when running from jupyter notebook
    main(args)

```


If `script_template.py` is run as a standalone program at the command line, then `__name__ == '__main__'` is true, so the program uses `argparse` to create an argument parser. 
It then specifies that it expects two command-line arguments: an input filename (`infile`) and an output filename (`outfile`).
The program uses `parser.parse_args()` to parse the actual command-line arguments given by the user and stores the result in a variable called `args`,
which it passes to `main`. That function can then get the values using the names specified in the `parser.add_argument` calls.

> **Specifying Types**
>
> We have passed `type=str` to `add_argument` to tell `argparse` that
> we want `infile` and `outfile` to be treated as strings.
> `str` is not quoted because it is not a string itself:
> instead,
> it is the built-in Python function that converts things to strings.
> As we will see below,
> we can pass in other functions like `int`
> if we want arguments converted to numbers.

If we run `script_template.py` at the command line, the output shows us that `argparse` has successfully handled the arguments:

```bash
python script_template_nb.py
```

```output
Input file: input.txt
Output file: output.txt
```

It also displays an error message if we give the program invalid arguments:

```bash
$ python script_template.py in.csv
```

```text
usage: script_template.py [-h] infile outfile
script_template.py: error: the following arguments are
  required: outfile
```

Finally, it automatically generates help information (which we can get using the `-h` option):

```bash
python script_template.py -h 
```

```output

usage: script_template.py [-h] infile outfile

One-line description of what the script does.

positional arguments:
  infile      Input file name
  outfile     Output file name

options:
  -h, --help  show this help message and exit

```

## Documentation 

Our program template is a good starting point, but we improve it right away by adding a bit of documentation.
To demonstrate, let's write a function that doubles a number:

```Python
def double(num):
    'Double the input.'
    return 2 * num
```
The first line of this function is a string that isn't assigned to a variable.
Such a string is called a documentation string, or **docstring** for short. If we call our function it does what we expect:

```python
double(3)
```

```output
6
```
However, we can also ask for the function's documentation, which is stored in `double.__doc__`:

```python
double.__doc__
```
```output
Double the input.
```

Python creates the variable `__doc__` automatically for every function, just as it creates the variable `__name__` for every file.
If we don't write a docstring for a function, `__doc__`'s value is an empty string. 
We can put whatever text we want into a function's docstring, but it is usually used to provide online documentation.

We can also put a docstring at the start of a file, in which case it is assigned to a variable called `__doc__`
that is visible inside the file. If we add documentation to our template, it becomes:

```Python
"""Brief description of what the script does."""

import argparse


def main(args):
    """Run the program."""
    print('Input file:', args.infile)
    print('Output file:', args.outfile)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('infile', type=str,
                        help='Input file name')
    parser.add_argument('outfile', type=str,
                        help='Output file name')
    # since jupyter notebook does not have a command line interface we need to simulate it. 
    # args = parser.parse_args()  # use this when running from command line 
    args = argparse.Namespace(infile='input.txt', outfile='output.txt') # use this when running from jupyter notebook
    main(args)

```
Note that docstrings are usually written using triple-quoted strings, since these can span multiple lines.
Note also how we pass `description=__doc__` to `argparse.ArgumentParser`. This saves us from typing the same information twice, but more importantly ensures that
the help message provided in response to the `-h` option will be the same as the interactive help. 

Let's try this out in an interactive Python session. (Remember, do not type the `>>>` prompt: Python provides this for us.)

```bash
$ python
```
```text
Python 3.11.5 (default, Jan  8 2024, 13:42:34) 
[Clang 4.0.1 (tags/RELEASE_401/final)] :: 
Anaconda, Inc. on darwin
Type "help", "copyright", "credits" or "license"
for more information.
```
```python
>>> import template
>>> template.__doc__
```
```text
'Brief description of what the script does.'
```
```python
>>> help(template)
```
```text
Help on module template:

NAME
    template - Brief description of what the script does.

FUNCTIONS
    main(args)
        Run the program.

FILE
    ./bin_building_cli/template.py
```

As this example shows, if we ask for help on the module, Python formats and displays all of the docstrings for everything in the file.
We talk more about what to put in a docstring in the chapter on documentation found [here](https://software-engineering-group-up.github.io/RSE-UP/chapters/introduction/documentation.html).

## Counting Words

Now that we have a template for command-line Python programs, we can use it to check Zipf's Law for our collection of classic novels.
We start by moving the template into the directory where we store our runnable programs i.e. the `bin_building_cli` or just a `bin` folder. 


Next, let's write a function that counts how often words appear in a file.
The `word_count` function processes a list of text lines to count word frequencies, filter these words by a specified minimum length, and calculate the percentage each word represents of the total word count, ultimately printing the results. It first calls `calculate_word_counts(lines)` to create a dictionary mapping words to their counts, removing delimiters and handling case insensitivity. This dictionary is then converted into a sorted list of tuples using `word_count_dict_to_tuples(counts)`, ordered by decreasing count. The function then filters this list with `filter_word_counts(sorted_counts, min_length)` to include only words of at least the specified length. Next, `calculate_percentages(sorted_counts)` calculates the percentage of the total word count for each word, producing a list of tuples with words, counts, and percentages. Finally, the function `prints` this list, showing the frequency and relative importance of each word in the text.


```Python
import sys

def word_count(lines, min_length=1):
    """
    Load a file, calculate the frequencies of each word in the file and
    save in a new file the words, counts and percentages of the total  in
    descending order. Only words whose length is >= min_length are
    included.
    """
    counts = calculate_word_counts(lines)
    sorted_counts = word_count_dict_to_tuples(counts)
    sorted_counts = filter_word_counts(sorted_counts, min_length)
    percentage_counts = calculate_percentages(sorted_counts)
    print(percentage_counts)

with open(../data/dracula.txt) as input_fd:
        lines = input_fd.read().splitlines()

word_count(lines)

```
If we want the word counts in a format like a text file or CSV for easier processing, we can write another small function that takes our `list` object,
and writes it to standard output as in this case a text file with the name we gave it. 

```Python
import sys 

def save_word_counts(filename, counts):
    """
    Save a list of [word, count, percentage] lists to a file, in the form
    "word count percentage", one tuple per line.
    """
    with open(filename, "w") as output:
        for count in counts:
            output.write("%s\n" % " ".join(str(c) for c in count))


def word_count(lines, min_length=1):
    """
    Load a file, calculate the frequencies of each word in the file and
    save in a new file the words, counts and percentages of the total  in
    descending order. Only words whose length is >= min_length are
    included.
    """
    counts = calculate_word_counts(lines)
    sorted_counts = word_count_dict_to_tuples(counts)
    sorted_counts = filter_word_counts(sorted_counts, min_length)
    percentage_counts = calculate_percentages(sorted_counts)
    save_word_counts(dracula_count.txt, percentage_counts)

with open(../data/dracula.txt) as input_fd:
        lines = input_fd.read().splitlines()

word_count(lines)

```

Here we added the function save_word_counts that takes a filename of our choise and the list object and saves it in a text file. This could also be done in a csv files but a txt file is enough. 

Now to make our `word_count` function available through CLI we have to call it from within the `main` function.

```Python 
# --- other functions above --- 

if __name == `__main__`:
    with open(../data/dracula.txt) as input_fd:
        lines = input_fd.read().splitlines()

    word_count(lines)
```

We could also first rewrite this using argp parse or we write a function that is called within count_words that reads out a file. 

```Python
import sys

def load_text(filename):
    """
    Load lines from a plain-text file and return these as a list, with
    trailing newlines stripped.
    """
    with open(filename) as input_fd:
        lines = input_fd.read().splitlines()
    return lines

# .... Other functions ...

def word_count(input_file, output_file, min_length=1):
    """
    Load a file, calculate the frequencies of each word in the file and
    save in a new file the words, counts and percentages of the total  in
    descending order. Only words whose length is >= min_length are
    included.
    """
    lines = load_text(input_file)
    counts = calculate_word_counts(lines)
    sorted_counts = word_count_dict_to_tuples(counts)
    sorted_counts = filter_word_counts(sorted_counts, min_length)
    percentage_counts = calculate_percentages(sorted_counts)
    save_word_counts(output_file, percentage_counts)


if __name__ == "__main__":
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    min_length = 1
    if len(sys.argv) > 3:
        min_length = int(sys.argv[3])
    word_count(input_file, output_file, min_length)

```

Or we could write this using `argparse` as follows: 

```Python
# ... 
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('infile', type=str,
                        help='Input file name')
    parser.add_argument('outfile', type=str,
                        help='Output file name')
    min_length = 1
    # for now we keep it at 1
    word_count(infile, outfile, min_length)
```

## Pipelining
As discussed in Section on bash tools, most Unix commands follow a useful convention: if the user doesn't specify the names of any input files, they read from **standard input** (stdin). 
Similarly, if no output file is specified, the command sends its results to **standard output** (stdout). This makes it easy to use the command in a pipeline.

Our program always sends its output to standard output as noted above, we can always redirect it to a file with `>`. 
If we want `count_words.py` to read from standard input, we only need to change the handling of `infile` in the argument parser and simplify `main` to match:


```python
def main(args):
    """Run the command line program."""
    count_word(args.infile, args.outfile, 1)
 


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('infile', type=argparse.FileType('r'),
                        nargs='?', default='-',
                        help='Input file name')
    parser.add_argument('outfile', type=str,
                        help='Output file name')   
    args = parser.parse_args()  # use this when running from command line 
    
    main(args)
```

There are two changes to how `add_argument` handles `infile`:

1.  Setting `type=argparse.FileType('r')` tells `argparse` to treat the argument as a filename and open that file for reading.
    This is why we no longer need to call `open` ourselves, and why `main` can pass `args.infile` directly to `count_words`.

2.  The number of expected arguments (`nargs`) is set to `?`.
    This means that if an argument is given it will be used, but if none is provided, a default of `'-'` will be used instead.
    `argparse.FileType('r')` understands `'-'` to mean "read from standard input"; this is another Unix convention that many programs follow.

After these changes,we can create a pipeline like this to count the words in the first 500 lines of a book:

```bash

head -n 500 ../data/dracula.txt | python wordcount.py test.txt 
```
This means that instead of the entire book, only the first 500 lines will be used. 

## Positional and Optional Arguments 

We have met two kinds of command-line arguments while writing `wordcount.py`.
Optional arguments are defined using a leading `-` or `--` (or both), which means that all three of the following definitions are valid:

```python
parser.add_argument('-n', type=int, help='Limit output')
parser.add_argument('--num', type=int, help='Limit output')
parser.add_argument('-n', '--num',
                    type=int, help='Limit output')
```

The convention is for `-` to precede a **short** (single letter) and `--` a **long** (multi-letter) option.
The user can provide optional arguments at the command line in any order they like.

**Positional arguments** have no leading dashes and are not optional:
the user must provide them at the command line in the order in which they are specified to `add_argument` (unless `nargs='?'` is provided to say that the value is optional).

## Collating
Now that we can get word counts for individual books we can collate the counts for several books.
This can be done using a loop that adds up the counts of a word from each of the txt files created by `wordcount.py`.
Using the same template as before, we can write a program called `collate.py`:

```Python
import argparse
from collections import defaultdict


def load_word_counts(filename):
    """
    Load a list of (word, count, percentage) tuples from a file where each
    line is of the form "word count percentage". Lines starting with # are
    ignored.
    """
    counts = []
    with open(filename, "r") as input_fd:
        for line in input_fd:
            if not line.startswith("#"):
                fields = line.split()
                counts.append((fields[0], int(fields[1]), float(fields[2])))
    return counts


def collate_word_counts(filenames):
    """
    Load word counts from multiple files and combine them into a single list
    of (word, count, percentage) tuples. The combined counts are aggregated,
    and percentages are recalculated based on the total counts.
    """
    # Dictionary to hold aggregated word counts
    aggregated_counts = defaultdict(int)
    total_word_count = 0

    # Load and aggregate counts from each file
    for filename in filenames:
        word_counts = load_word_counts(filename)
        for word, count, _ in word_counts:
            aggregated_counts[word] += count
            total_word_count += count

    # Calculate new percentages
    collated_counts = [
        (word, count, (count / total_word_count) * 100.0)
        for word, count in aggregated_counts.items()
    ]

    # Sort the list by count in descending order
    collated_counts.sort(key=lambda x: x[1], reverse=True)

    return collated_counts


if __name__ == '__main__':
    # Set up argument parser
    parser = argparse.ArgumentParser(description='Collate word counts from multiple files.')
    parser.add_argument('filenames', metavar='F', type=str, nargs='+', help='a list of filenames to process')

    # Parse arguments
    args = parser.parse_args()

    # Get the list of filenames
    filenames = args.filenames

    # Collate word counts
    result = collate_word_counts(filenames)

    # Print results
    for word, count, percentage in result:
        print(f"{word} {count} {percentage:.2f}%")

```
The collate_word_counts() function takes a list of filenames as input, each containing word count data in the format "word count percentage". It reads the word counts from each file, aggregates these counts into a single collection, and recalculates the percentage each word represents of the total word count. The function returns a sorted list of tuples, each containing a word, its aggregated count, and its recalculated percentage, ordered by the word counts in descending order.

## Writing Our own Modules

In both `collate.py` and `wordcount.py` we use the function `load_word_counts.py`. aving the same function in two or more places is a bad idea: if we want to improve it or fix a bug, we have to find and change every single script that contains a copy.
The solution is to put the shared functions in a separate file and load that file as a module. This can be done using a `utilities.py` or as shown in our example kept a single occurance of it in `wordcount.py` and importing it with the following statement in `collate.py`:

```Python
import argparse
from collections import defaultdict
from wordcount import load_word_counts
```

now we can run the following command to collate the results: 

```bash
python collate.py data/wc_dracula.txt data/wc_moby_dick.txt data/wc_jane_eyre.txt 
```

The results will then be show as output in the terminal. To save them in a text file we could either write a function for that or for now use the following command:
```bash
python collate.py data/wc_dracula.txt data/wc_moby_dick.txt data/wc_jane_eyre.txt > collated_wc.txt
```

## Ploting
The last thing for us to do is to plot the word count distribution. Recall that [Zipf's Law](https://en.wikipedia.org/wiki/Zipf%27s_law) states the second most common word in a body of text
appears half as often as the most common, the third most common appears a third as often, and so on.
Mathematically, this might be written as "word frequency is proportional to 1/rank."

```Python
import numpy as np
import matplotlib
matplotlib.use("AGG")
import matplotlib.pyplot as plt
import sys
from collections.abc import Sequence
# from collections import Sequence

from wordcount import load_word_counts



def plot_word_counts(counts, limit=10):
    """
    Given a list of (word, count, percentage) tuples, plot the counts as a
    histogram. Only the first limit tuples are plotted.
    """
    # Calculate plot values
    limited_counts = counts[0:limit]
    word_data = [word for (word, _, _) in limited_counts]
    count_data = [count for (_, count, _) in limited_counts]
    position = np.arange(len(word_data))
    width = 1.0

    # Create the plot
    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.set_title("Word Counts")
    ax.set_xticks(position + (width / 2))
    ax.set_xticklabels(word_data)
    ax.bar(position, count_data, width, color="b")


if __name__ == "__main__":
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    limit = 10
    if len(sys.argv) > 3:
        limit = int(sys.argv[3])
    counts = load_word_counts(input_file)
    plot_word_counts(counts, limit)
    plt.savefig(output_file)
```



## Summary
Why is building a simple command-line tool so complex?
One answer is that the conventions for command-line programs have evolved over several decades, so libraries like `argparse` must now support several different generations of option handling.
Another is that the things we want to do genuinely *are* complex:
read from either standard input or a list of files, display help when asked to, respect parameters that might not be there, and so on.
As with many other things in programming (and life), everyone wishes it was simpler, but no one can agree on what to throw away.

The good news is that this complexity is a fixed cost:
our template for command-line tools can be re-used for programs that are much larger than the examples shown in this chapter.
Making tools that behave in ways people expect greatly increases the chances that others will find them useful. 
## Keypoints 
-   Write command-line Python programs that can be run in the **Unix shell** like other command-line tools.
-   If the user does not specify any input files, read from **standard input**}.
-   If the user does not specify any output files, write to **standard output**.
-   Place all `import` statements at the start of a module.
-   Use the value of `__name__` to determine if a file is being run directly or being loaded as a module.
-   Use [`argparse`][argparse] to handle command-line arguments in standard ways.
-   Use **short options** for common controls and **long options** for less common or more complicated ones.
-   Use **docstrings** to document functions and scripts.
-   Place functions that are used across multiple scripts in a separate file that those scripts can import.