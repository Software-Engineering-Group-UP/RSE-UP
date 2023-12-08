## Chapter Python CLI

### Exercise 1

Running a Python statement directly from the command line is useful as a basic calculator
and for simple string operations,
since these commands occur in one line of code.
More complicated commands will require multiple statements;
when run using `python -c`,
statements must be separated by semi-colons:

```python
$ python -c "import math; print(math.log(123))"
```

Multiple statements,
therefore,
quickly become more troublesome to run in this manner.

### Exercise 2

The `my_ls.py` script could read as follows:

```python
"""List the files in a given directory with a given suffix."""

import argparse
import glob


def main(args):
    """Run the program."""
    dir = args.dir if args.dir[-1] == '/' else args.dir + '/'
    glob_input = dir + '*.' + args.suffix
    glob_output = sorted(glob.glob(glob_input))
    for item in glob_output:
        print(item)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('dir', type=str, help='Directory')
    parser.add_argument('suffix', type=str,
                        help='File suffix (e.g. py, sh)')
    args = parser.parse_args()
    main(args)
```

### Exercise 3

The `sentence_endings.py` script could read as follows:

```python
"""Count the occurrence of different sentence endings."""

import argparse


def main(args):
    """Run the command line program."""
    text = args.infile.read()
    for ending in ['.', '?', '!']:
        count = text.count(ending)
        print(f'Number of {ending} is {count}')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('infile', type=argparse.FileType('r'),
                        nargs='?', default='-',
                        help='Input file name')
    args = parser.parse_args()
    main(args)
```

### Exercise 4

While there may be other ways for `plotcounts.py` 
to meet the requirements of the exercise,
we'll be using this script in subsequent chapters so
we recommend that the script reads as follows:

```python
"""Plot word counts."""

import argparse

import pandas as pd


def main(args):
    """Run the command line program."""
    df = pd.read_csv(args.infile, header=None,
                     names=('word', 'word_frequency'))
    df['rank'] = df['word_frequency'].rank(ascending=False,
                                           method='max')
    df['inverse_rank'] = 1 / df['rank']
    ax = df.plot.scatter(x='word_frequency',
                         y='inverse_rank',
                         figsize=[12, 6],
                         grid=True,
                         xlim=args.xlim)
    ax.figure.savefig(args.outfile)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('infile', type=argparse.FileType('r'),
                        nargs='?', default='-',
                        help='Word count csv file name')
    parser.add_argument('--outfile', type=str,
                        default='plotcounts.png',
                        help='Output image file name')
    parser.add_argument('--xlim', type=float, nargs=2,
                        metavar=('XMIN', 'XMAX'),
                        default=None, help='X-axis limits')
    args = parser.parse_args()
    main(args)
```
