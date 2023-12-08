## Chapter Error Handling 

### Exercise 1

Add a new command-line argument to `collate.py`:

```python
parser.add_argument('-v', '--verbose',
                    action="store_true", default=False,
                    help="Set logging level to DEBUG")
```

and two new lines to the beginning of the `main` function:

```python
log_level = logging.DEBUG if args.verbose else logging.WARNING
logging.basicConfig(level=log_level)
```

such that the full `collate.py` script now reads as follows:

```python
"""
Combine multiple word count CSV-files
into a single cumulative count.
"""

import csv
import argparse
from collections import Counter
import logging

import utilities as util


ERRORS = {
    'not_csv_suffix' : '{fname}: File must end in .csv',
    }


def update_counts(reader, word_counts):
    """Update word counts with data from another reader/file."""
    for word, count in csv.reader(reader):
        word_counts[word] += int(count)


def main(args):
    """Run the command line program."""
    log_lev = logging.DEBUG if args.verbose else logging.WARNING
    logging.basicConfig(level=log_lev)
    word_counts = Counter()
    logging.info('Processing files...')
    for fname in args.infiles:
        logging.debug(f'Reading in {fname}...')
        if fname[-4:] != '.csv':
            msg = ERRORS['not_csv_suffix'].format(fname=fname)
            raise OSError(msg)
        with open(fname, 'r') as reader:
            logging.debug('Computing word counts...')
            update_counts(reader, word_counts)
    util.collection_to_csv(word_counts, num=args.num)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('infiles', type=str, nargs='*',
                        help='Input file names')
    parser.add_argument('-n', '--num',
                        type=int, default=None,
                        help='Output n most frequent words')
    parser.add_argument('-v', '--verbose',
                        action="store_true", default=False,
                        help="Set logging level to DEBUG")
    args = parser.parse_args()
    main(args)
```

### Exercise 2

Add a new command-line argument to `collate.py`:

```python
parser.add_argument('-l', '--logfile',
                    type=str, default='collate.log',
                    help='Name of the log file')
```

and pass the name of the log file to `logging.basicConfig`
using the `filename` argument:

```python
logging.basicConfig(level=log_lev, filename=args.logfile)
```

such that the `collate.py` script now reads as follows:

```python
"""
Combine multiple word count CSV-files
into a single cumulative count.
"""

import csv
import argparse
from collections import Counter
import logging

import utilities as util


ERRORS = {
    'not_csv_suffix' : '{fname}: File must end in .csv',
    }


def update_counts(reader, word_counts):
    """Update word counts with data from another reader/file."""
    for word, count in csv.reader(reader):
        word_counts[word] += int(count)


def main(args):
    """Run the command line program."""
    log_lev = logging.DEBUG if args.verbose else logging.WARNING
    logging.basicConfig(level=log_lev, filename=args.logfile)
    word_counts = Counter()
    logging.info('Processing files...')
    for fname in args.infiles:
        logging.debug(f'Reading in {fname}...')
        if fname[-4:] != '.csv':
            msg = ERRORS['not_csv_suffix'].format(fname=fname)
            raise OSError(msg)
        with open(fname, 'r') as reader:
            logging.debug('Computing word counts...')
            update_counts(reader, word_counts)
    util.collection_to_csv(word_counts, num=args.num)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('infiles', type=str, nargs='*',
                        help='Input file names')
    parser.add_argument('-n', '--num',
                        type=int, default=None,
                        help='Output n most frequent words')
    parser.add_argument('-v', '--verbose',
                        action="store_true", default=False,
                        help="Set logging level to DEBUG")
    parser.add_argument('-l', '--logfile',
                        type=str, default='collate.log',
                        help='Name of the log file')
    args = parser.parse_args()
    main(args)
```

### Exercise 3

1. The loop in `collate.py` that reads/processes each input file
   should now read as follows:

```python
for fname in args.infiles:
    try:
        logging.debug(f'Reading in {fname}...')
        if fname[-4:] != '.csv':
            msg = ERRORS['not_csv_suffix'].format(fname=fname)
            raise OSError(msg)
        with open(fname, 'r') as reader:
            logging.debug('Computing word counts...')
            update_counts(reader, word_counts)
    except Exception as error:
        logging.warning(f'{fname} not processed: {error}')
```

2. The loop in `collate.py` that reads/processes each input file
   should now read as follows:

```python
for fname in args.infiles:
    try:
        logging.debug(f'Reading in {fname}...')
        if fname[-4:] != '.csv':
            msg = ERRORS['not_csv_suffix'].format(
                fname=fname)
            raise OSError(msg)
        with open(fname, 'r') as reader:
            logging.debug('Computing word counts...')
            update_counts(reader, word_counts)
    except FileNotFoundError:
        msg = f'{fname} not processed: File does not exist'
        logging.warning(msg)
    except PermissionError:
        msg = f'{fname} not processed: No read permission'
        logging.warning(msg)
    except Exception as error:
        msg = f'{fname} not processed: {error}'
        logging.warning(msg)
```

### Exercise 4

1. The `try/except` block in `collate.py` should begin as follows:

   ```python
   try:
       process_file(fname, word_counts)
   except FileNotFoundError:
   # ... the other exceptions
   ```

2. The following additions need to be made to `test_zipfs.py`.

   ```python
   import collate
   ```

   ```python
   def test_not_csv_error():
       """Error handling test for csv check"""
       fname = 'data/dracula.txt'
       word_counts = Counter()
       with pytest.raises(OSError):
           collate.process_file(fname, word_counts)
   ```

3. The following unit test needs to be added to `test_zipfs.py`.

   ```python
   def test_missing_file_error():
       """Error handling test for missing file"""
       fname = 'fake_file.csv'
       word_counts = Counter()
       with pytest.raises(FileNotFoundError):
           collate.process_file(fname, word_counts)
   ```

4. The following sequence of commands is required to test the code coverage.

   ```bash
   $ coverage run -m pytest
   $ coverage html
   ```

   Open `htmlcov/index.html` and click on `bin/collate.py` to view a coverage summary.
   The lines of `process_files` that include the `raise OSError` and
   `open(fname, 'r')` commands should appear in green after clicking the green "run" box
   in the top left-hand corner of the page.

### Exercise 5

1. The convention is to use `ALL_CAPS_WITH_UNDERSCORES` when defining global variables.

2. Python's f-strings interpolate variables that are in scope:
   there is no easy way to interpolate values from a lookup table.
   In contrast,
   `str.format` can be given any number of named keyword arguments (Appendix \@ref(style)),
   so we can look up a string and then interpolate whatever values we want.

3. Once `ERRORS` has been moved to the `utilities` module,
   all references to it in `collate.py` must be updated to `util.ERRORS`.

### Exercise 6

A **traceback** is an object that records where an exception was
raised), what **stack frames** were on the **call stack** when the error occurred, and other details that are helpful for debugging. Python's [traceback]( https://docs.python.org/3/library/traceback.html) library can be used to get an
