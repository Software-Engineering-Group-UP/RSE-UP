# Testing Software 

> Opera happens because a large number of things amazingly fail to go wrong.
>
> --- Terry Pratchett

We have written software to count and analyze the words in classic texts,
but how can we be sure it's producing reliable results?
The short is answer is that we can't---not completely---but
we can test its behavior against our expectations to decide if we are sure enough.
This chapter explores ways to do this,
including assertions, unit tests, integration tests, and regression tests.

> **A Scientist's Nightmare**
>
> Why is testing research software important?
> A successful early career researcher in protein crystallography,
> Geoffrey Chang,
> had to retract five published papers---three from
> the journal *Science*---because his code had
> inadvertently flipped two columns of data [{cite:p}`Mill2006`].
> More recently, a simple calculation mistake in a paper by Reinhart and Rogoff
> contributed to making the financial crash of 2008 even worse
> for millions of people [{cite:p}`Borw2013`].
> Testing helps to catch errors like these.

Here's the current structure of our Zipf's Law project files:

```text
zipf/
├── .gitignore
├── CONDUCT.md
├── CONTRIBUTING.md
├── LICENSE.md
├── Makefile
├── README.md
├── bin
│   ├── book_summary.sh
│   ├── collate.py
│   ├── countwords.py
│   ├── plotcounts.py
│   ├── plotparams.yml
│   ├── script_template.py
│   └── utilities.py
├── data
│   ├── README.md
│   ├── dracula.txt
│   └── ...
└── results
    ├── collated.csv
    ├── collated.png
    ├── dracula.csv
    ├── dracula.png
    └── ...
```

## Assertions 

The first step in building confidence in our programs
is to assume that mistakes will happen and guard against them.
This is called **defensive programming**,
and the most common way to do it is to add **assertions** to our code so that it checks itself as it runs.
An assertion is a statement that something must be true at a certain point in a program.
When Python sees an assertion, it checks the assertion's condition.
If it's true, Python does nothing;
if it's false,
Python halts the program immediately and prints a user-defined error message.
For example,
this code halts as soon as the loop encounters an impossible word frequency:

```python
frequencies = [13, 10, 2, -4, 5, 6, 25]
total = 0.0
for freq in frequencies[:5]:
    assert freq >= 0.0, 'Word frequencies must be non-negative'
    total += freq
print('total frequency of first 5 words:', total)
```

```text
---------------------------------------------------------------
AssertionError                Traceback (most recent call last)
<ipython-input-19-33d87ea29ae4> in <module>()
      2 total = 0.0
      3 for freq in frequencies[:5]:
----> 4     assert freq >= 0.0, 'Word frequencies must be
            non-negative'
      5     total += freq
      6 print('total frequency of first 5 words:', total)

AssertionError: Word frequencies must be non-negative
```

Programs intended for widespread use are full of assertions:
10%--20% of the code they contain are there to check that the other 80%--90% are working correctly.
Broadly speaking, assertions fall into three categories:

-   A **precondition** is something that must be true at the start of a function
    in order for it to work correctly.
    For example,
    a function might check that the list it has been given has at least two elements
    and that all of its elements are integers.

-   A **postcondition**
    is something that the function guarantees is true
    when it finishes.
    For example,
    a function could check that the value being returned is an integer
    that is greater than zero,
    but less than the length of the input list.

-   An **invariant** (in
    is something that is true for every iteration in a loop.
    The invariant might be a property of the data (as in the example above),
    or it might be something like,
    "the value of `highest` is less than or equal to the current loop index."

The function `get_power_law_params` in our `plotcounts.py` script
is a good example of the need for a precondition.
Its docstring does not say that its `word_counts` parameter must be a list of numeric word counts;
even if we add that,
a user might easily pass in a list of the words themselves instead.
Adding an assertion makes the requirement clearer,
and also guarantees that the function will fail as soon as it is called
rather than returning an error from `scipy.optimize.minimize_scalar`
that would be more difficult to interpret/debug.

```python
def get_power_law_params(word_counts):
    """
    Get the power law parameters.

    References
    ----------
    Moreno-Sanchez et al (2016) define alpha (Eq. 1),
      beta (Eq. 2) and the maximum likelihood estimation (mle)
      of beta (Eq. 6).

    Moreno-Sanchez I, Font-Clos F, Corral A (2016)
      Large-Scale Analysis of Zipf's Law in English Texts.
      PLoS ONE 11(1): e0147073.
      https://doi.org/10.1371/journal.pone.0147073
    """
    assert type(word_counts) == np.ndarray, \
        'Input must be a numerical (numpy) array of word counts'
    mle = minimize_scalar(nlog_likelihood,
                          bracket=(1 + 1e-10, 4),
                          args=word_counts,
                          method='brent')
    beta = mle.x
    alpha = 1 / (beta - 1)
    return alpha
```

Update `plotcounts.py` with the assertion described above.
You'll see additional examples of assertions throughout this chapter.

## Unit Testing 

Catching errors is good, but preventing them is better,
so responsible programmers test their code.
As the name suggests,
a **unit test** checks the correctness of a single unit of software.
Exactly what constitutes a "unit" is subjective,
but it typically means the behavior of a single function in one situation.
In our Zipf's Law software,
the `count_words` function in `countwords.py` is
a good candidate for unit testing:

```python
def count_words(reader):
    """Count the occurrence of each word in a string."""
    text = reader.read()
    chunks = text.split()
    npunc = [word.strip(string.punctuation) for word in chunks]
    word_list = [word.lower() for word in npunc if word]
    word_counts = Counter(word_list)
    return word_counts
```

\newpage

A single unit test will typically have:

-   a **fixture**,
    which is the thing being tested (e.g., an array of numbers);
-   an **actual result**,
    which is what the code produces when given the fixture;
    and
-   an **expected result**
    that the actual result is compared to.

The fixture is typically a subset or smaller version of the data
the function will typically process.
For instance,
in order to write a unit test for the `count_words` function,
we could use a piece of text small enough for us to count word frequencies by hand.
Let's add the poem *Risk* by Anaïs Nin to our data:

```bash
$ cd ~/zipf
$ mkdir test_data
$ cat test_data/risk.txt
```

```text
And then the day came,
when the risk
to remain tight
in a bud
was more painful
than the risk
it took
to blossom.
```

We can then count the words by hand to construct the expected result:

```python
from collections import Counter


risk_poem_counts = {'the': 3, 'risk': 2, 'to': 2, 'and': 1,
  'then': 1, 'day': 1, 'came': 1, 'when': 1, 'remain': 1,
  'tight': 1, 'in': 1, 'a': 1, 'bud': 1, 'was': 1,
  'more': 1, 'painful': 1, 'than': 1, 'it': 1, 'took': 1,
  'blossom': 1}
expected_result = Counter(risk_poem_counts)
```

We then generate the actual result by calling `count_words`,
and use an assertion to check if it is what we expected:

```python
import sys
sys.path.append('/Users/amira/zipf/bin')
import countwords


with open('test_data/risk.txt', 'r') as reader:
    actual_result = countwords.count_words(reader)
assert actual_result == expected_result
```

There's no output,
which means the assertion (and test) passed.
(Remember, assertions only do something if the condition is false.)

> **Appending the Import Path**
>
> The last code chunk included `sys.path.append`,
> which allowed us to import scripts from elsewhere than 
> our current working directory.
> This isn't a perfect solution,
> but works well enough for quick tests while developing code,
> especially since the tool we'll use for the 
> rest of the chapter handles this issue for us.
> [Import statements][python-import] are notoriously tricky,
> but we'll learn better methods for organizing our code for 
> function imports in Chapter on [Packaging](https://software-engineering-group-up.github.io/RSE-UP/chapters/packaging.html).

## Testing Frameworks 

Writing one unit test is easy enough, but we should check other cases as well.
To manage them, we can use a **test framework**
(also called a **test runner**).
The most widely used test framework for Python is called [`pytest`](https://pytest.org/), which structures tests as follows:

1.  Tests are put in files whose names begin with `test_`.
2.  Each test is a function whose name also begins with `test_`.
3.  These functions use `assert` to check results.

Following these rules,
we can create a `test_zipfs.py` script in your `bin` directory
that contains the test we just developed:

```python
from collections import Counter

import countwords


def test_word_count():
    """Test the counting of words.

    The example poem is Risk, by Anaïs Nin.
    """
    risk_poem_counts = {'the': 3, 'risk': 2, 'to': 2, 'and': 1,
      'then': 1, 'day': 1, 'came': 1, 'when': 1, 'remain': 1,
      'tight': 1, 'in': 1, 'a': 1, 'bud': 1, 'was': 1,
      'more': 1, 'painful': 1, 'than': 1, 'it': 1, 'took': 1,
      'blossom': 1}
    expected_result = Counter(risk_poem_counts)
    with open('test_data/risk.txt', 'r') as reader:
        actual_result = countwords.count_words(reader)
    assert actual_result == expected_result
```

The `pytest` library comes with a command-line tool that is also called `pytest`.
When we run it with no options,
it searches for all files in or below the working directory
whose names match the pattern `test_*.py`.
It then runs the tests in these files and summarizes their results.
(If we only want to run the tests in a particular file,
we can use the command `pytest path/to/test_file.py`.)

```bash
$ pytest
```
```text
==================== test session starts ======================
platform darwin -- Python 3.7.6, pytest-6.2.0, py-1.10.0,
pluggy-0.13.1
rootdir: /Users/amira
collected 1 item

bin/test_zipfs.py .                                     [100%]

===================== 1 passed in 0.02s =======================
```

To add more tests,
we simply write more `test_` functions in `test_zipfs.py`.
For instance,
besides counting words,
the other critical part of our code is the calculation of the $\alpha$ parameter.
Earlier we defined a power law relating $\alpha$
to the word frequency $f$,
the word rank $r$,
and a constant of proportionality $c$ ([Section Git advanced](https://software-engineering-group-up.github.io/RSE-UP/chapters/configuration.html#configuration-file-formats)):

$
r = cf^{\frac{-1}{\alpha}}
$

We also noted that Zipf's Law holds exactly when $\alpha$ is equal to one.
Setting $\alpha$ to one and re-arranging the power law gives us:

$
c = f/r
$

We can use this formula to generate synthetic word count data
(i.e., our test fixture)
with a constant of proportionality set to a hypothetical maximum word frequency of 600
(and thus $r$ ranges from 1 to 600):

```python
import numpy as np


max_freq = 600
counts = np.floor(max_freq / np.arange(1, max_freq + 1))
print(counts)
```

```text
[600. 300. 200. 150. 120. 100.  85.  75.  66.  60.  54.  50.
  46.  42.  40.  37.  35.  33.  31.  30.  28.  27.  26.  25.
 ...
   1.   1.   1.   1.   1.   1.   1.   1.   1.   1.   1.   1.]
```

(We use `np.floor` to round down to the nearest whole number,
because we can't have fractional word counts.)
Passing this test fixture to `get_power_law_params` in `plotcounts.py`
should give us a value of 1.0.
To test this, we can add a second test to `test_zipfs.py`:

```python
from collections import Counter

import numpy as np

import plotcounts
import countwords


def test_alpha():
    """Test the calculation of the alpha parameter.

    The test word counts satisfy the relationship,
      r = cf**(-1/alpha), where
      r is the rank,
      f the word count, and
      c is a constant of proportionality.

    To generate test word counts for an expected alpha of
      1.0, a maximum word frequency of 600 is used
      (i.e. c = 600 and r ranges from 1 to 600)
    """
    max_freq = 600
    counts = np.floor(max_freq / np.arange(1, max_freq + 1))
    actual_alpha = plotcounts.get_power_law_params(counts)
    expected_alpha = 1.0
    assert actual_alpha == expected_alpha


def test_word_count():
    #...as before...
```

Let's re-run both of our tests:

```bash
$ pytest
```

```text
==================== test session starts ======================
platform darwin -- Python 3.7.6, pytest-6.2.1, py-1.10.0,
pluggy-0.13.1
rootdir: /Users/amira
collected 2 items

bin/test_zipfs.py F.                                    [100%]

========================== FAILURES ===========================
_________________________ test_alpha __________________________

  def test_alpha():
      """Test the calculation of the alpha parameter.
    
      The test word counts satisfy the relationship,
        r = cf**(-1/alpha), where
        r is the rank,
        f the word count, and
        c is a constant of proportionality.
    
      To generate test word counts for an expected alpha of
        1.0, a maximum word frequency of 600 is used
        (i.e. c = 600 and r ranges from 1 to 600)
      """
      max_freq = 600
      counts = np.floor(max_freq / np.arange(1, max_freq + 1))
      actual_alpha = plotcounts.get_power_law_params(counts)
      expected_alpha = 1.0
>     assert actual_alpha == expected_alpha
E     assert 0.9951524579316625 == 1.0

bin/test_zipfs.py:26: AssertionError
=================== short test summary info ===================
FAILED bin/test_zipfs.py::test_alpha - assert 0.99515246 == 1.0
================= 1 failed, 1 passed in 3.98s =================

```

The output tells us that one test failed but the other test passed.
This is a very useful feature of test runners like `pytest`:
they continue on and complete all the tests
rather than stopping at the first assertion failure as a regular Python script would.

## Testing Floating-Point Values 

The output above shows that while `test_alpha` failed,
the `actual_alpha` value of 0.9951524579316625 was very close to the expected value of 1.0.
After a bit of thought,
we decide that this isn't actually a failure:
the value produced by `get_power_law_params` is an estimate,
and being off by half a percent is good enough.

This example shows that testing scientific software
almost always requires us to make the same kind of judgment calls
that scientists have to make when doing any other sort of experimental work.
If we are measuring the mass of a proton,
we might expect ten decimal places of accuracy.
If we are measuring the weight of a baby penguin,
on the other hand,
we'll probably be satisfied if we're within five grams.
What matters most is that we are explicit about the bounds we used
so that other people can tell what we actually did.

> **Degrees of Difficulty**
>
> There's an old joke that physicists worry about decimal places,
> astronomers worry about powers of ten,
> and economists are happy if they've got the sign right.

So how should we write tests when we don't know precisely what the right answer is?
The best approach is to write tests that check
if the actual value is within some **tolerance** of the expected value.
The tolerance can be expressed as the **absolute error**, 
which is the absolute value of the difference between two,
or the **relative error**,
which the ratio of the absolute error to the value we're approximating {cite:p}`Gold1991`.
For example,
if we add 9+1 and get 11,
the absolute error is 1 (i.e., $11-10$,
and the relative error is 10%.
If we add $99+1$ and get 101,
on the other hand,
the absolute error is still 1,
but the relative error is only 1%.

For `test_alpha`,
we might decide that an absolute error of 0.01 in the estimation of $\alpha$ is acceptable.
If we are using `pytest`,
we can check that values lie within this tolerance using `pytest.approx`:

```python
from collections import Counter

import pytest
import numpy as np

import plotcounts
import countwords


def test_alpha():
    """Test the calculation of the alpha parameter.

    The test word counts satisfy the relationship,
      r = cf**(-1/alpha), where
      r is the rank,
      f the word count, and
      c is a constant of proportionality.

    To generate test word counts for an expected alpha of
      1.0, a maximum word frequency of 600 is used
      (i.e. c = 600 and r ranges from 1 to 600)
    """
    max_freq = 600
    counts = np.floor(max_freq / np.arange(1, max_freq + 1))
    actual_alpha = plotcounts.get_power_law_params(counts)
    expected_alpha = pytest.approx(1.0, abs=0.01)
    assert actual_alpha == expected_alpha


def test_word_count():
    #...as before...
```

When we re-run `pytest`,
both tests now pass:

```bash
$ pytest
```

```text
==================== test session starts ======================
platform darwin -- Python 3.7.6, pytest-6.2.0, py-1.10.0,
pluggy-0.13.1
rootdir: /Users/amira
collected 2 items

bin/test_zipfs.py ..                                    [100%]

===================== 2 passed in 0.69s =======================
```

> **Testing Visualizations**
>
> Testing visualizations is hard:
> any change to the dimension of the plot,
> however small,
> can change many pixels in a **raster image**,
> and cosmetic changes such as moving the legend up a couple of pixels
> will cause all of our tests to fail.
>
> The simplest solution is therefore to test the data used to produce the image
> rather than the image itself.
> Unless we suspect that the plotting library contains bugs,
> the correct data should always produce the correct plot.

## Integration Testing 

Our Zipf's Law analysis has two steps:
counting the words in a text
and estimating the $\alpha$ parameter from the word count.
Our unit tests give us some confidence that these components work in isolation,
but do they work correctly together?
Checking that is called **integration testing**.

Integration tests are structured the same way as unit tests:
a fixture is used to produce an actual result
that is compared against the expected result.
However,
creating the fixture and running the code
can be considerably more complicated.
For example,
in the case of our Zipf's Law software, an appropriate integration test fixture
might be a text file with a word frequency distribution that has a known $\alpha$ value.
In order to create this text fixture,
we need a way to generate random words.

Fortunately, a Python library called 
[`RandomWordGenerator`](https://github.com/AbhishekSalian/Random-Word-Generator) 
exists to do just that.
We can install it using [`pip`][pip], the Python Package Installer:

```bash
$ pip install Random-Word-Generator
```

Borrowing from the word count distribution we created for `test_alpha`,
we can use the following code to create a text file full of random words
with a frequency distribution that corresponds to an $alpha$ of approximately 1.0:

```python
import numpy as np
from RandomWordGenerator import RandomWord


max_freq = 600
word_counts = np.floor(max_freq / np.arange(1, max_freq + 1))
rw = RandomWord()
random_words = rw.getList(num_of_words=max_freq)
writer = open('test_data/random_words.txt', 'w')
for index in range(max_freq):
    count = int(word_counts[index])
    word_sequence = f'{random_words[index]} ' * count
    writer.write(word_sequence + '\n')
writer.close()
```

We can confirm this code worked by checking the resulting file:

```bash
tail -n 5 test_data/random_words.txt
```

```text
lZnkzoBHRb 
djiroplqrJ 
HmAUGOncHg 
DGLpfTIitu 
KALSfPkrga
```

We can then add this integration test to `test_zipfs.py`:

```python
def test_integration():
    """Test the full word count to alpha parameter workflow."""
    with open('test_data/random_words.txt', 'r') as reader:
        word_counts_dict = countwords.count_words(reader)
    counts_array = np.array(list(word_counts_dict.values()))
    actual_alpha = plotcounts.get_power_law_params(counts_array)
    expected_alpha = pytest.approx(1.0, abs=0.01)
    assert actual_alpha == expected_alpha
```

Finally,
we re-run `pytest` to check that the integration test passes:

```bash
$ pytest
```

```text
===================== test session starts =====================
platform darwin -- Python 3.7.6, pytest-6.2.0, py-1.10.0,
pluggy-0.13.1
rootdir: /Users/amira
collected 3 items

bin/test_zipfs.py ...                                   [100%]

======================= 3 passed in 0.48s =====================
```

## Regression Testing 

So far we have tested two simplified texts:
a short poem and a collection of random words with a known frequency distribution.
The next step is to test with real data,
i.e., an actual book.
The problem is,
we don't know the expected result:
it's not practical to count the words in *Dracula* by hand,
and even if we tried,
the odds are good that we'd make a mistake.

For this kind of situation we can use
**regression testing**.
Rather than assuming that the test's author knows what the expected result should be,
regression tests compare today's answer with a previous one.
This doesn't guarantee that the answer is right---if the original answer is wrong,
we could carry that mistake forward indefinitely---but
it does draw attention to any changes (or "regressions").

In [Section Git advanced zipf-verify](https://software-engineering-group-up.github.io/RSE-UP/chapters/configuration.html#verifying-zipf-s-law))
we calculated an $\alpha$ of 1.0866646252515038 for *Dracula*.
Let's use that value to add a regression test to `test_zipfs.py`:

```python
def test_regression():
    """Regression test for Dracula."""
    with open('data/dracula.txt', 'r') as reader:
        word_counts_dict = countwords.count_words(reader)
    counts_array = np.array(list(word_counts_dict.values()))
    actual_alpha = plotcounts.get_power_law_params(counts_array)
    expected_alpha = pytest.approx(1.087, abs=0.001)
    assert actual_alpha == expected_alpha
```

```bash
$ pytest
```

```text
===================== test session starts =====================
platform darwin -- Python 3.7.6, pytest-6.2.0, py-1.10.0,
pluggy-0.13.1
rootdir: /Users/amira
collected 4 items

bin/test_zipfs.py ....                                  [100%]

====================== 4 passed in 0.56s ======================
```

## Test Coverage 

How much of our code do the tests we have written check?
More importantly,
what parts of our code \emph{aren't} being tested (yet)?
To find out,
we can use a tool to check their **code coverage**.
Most Python programmers use the `coverage` library,
which we can once again install using `pip`:

```bash
$ pip install coverage
```

Once we have it,
we can use it to run `pytest` on our behalf:

```bash
$ coverage run -m pytest
```

```text
===================== test session starts =====================
platform darwin -- Python 3.7.6, pytest-6.2.0, py-1.10.0,
pluggy-0.13.1
rootdir: /Users/amira
collected 4 items

bin/test_zipfs.py ....                                  [100%]

====================== 4 passed in 0.72s ======================
```

The `coverage` command doesn't display any information of its own,
since mixing that in with our program's output would be confusing.
Instead,
it puts coverage data in a file called `.coverage` (with a leading `.`) in the current directory.
To display that data,
we run:

```bash
$ coverage report -m
```

```text
bin/countwords.py      20      7    65%   25-26, 30-38
bin/plotcounts.py      58     37    36%   48-55, 75-77, 82-83, 
                                          88-118, 122-140
bin/test_zipfs.py      31      0   100%
bin/utilities.py        8      5    38%   18-22
-------------------------------------------------
TOTAL                 117     49    58%
```

This summary shows us that
some lines of `countwords.py` or `plotcounts.py`
were not executed when we ran the tests:
in fact,
only 65% and 36% of the lines were run respectively.
This makes sense,
since much of the code in those scripts
is devoted to handling command-line arguments or file I/O
rather than the word counting and parameter estimation functionality
that our unit, integration, and regression tests focus on.

To make sure that's the case,
we can get a more complete report by running `coverage html` at the command line
and opening `htmlcov/index.html`.
Clicking on the name of our `countwords.py` script, for instance,
produces the colorized line-by-line display shown in [Figure python coverage](python-coverage).

```{figure} ../figures/testing/python-coverage.png
:name: python-coverage
Python Coverage
```

This output confirms that all lines relating to word counting were tested,
but not any of the lines related to argument handling or I/O.

> **Commit our Coverage?**
>
> At this point,
> you're probably wondering if you should use version control
> to track the files reporting your code's coverage.
> While it won't necessarily harm your code,
> the reports will become inaccurate
> unless you continue updating your coverage reports
> as your code changes.
> Therefore, we recommend adding `.coverage` and `htmlcov/` 
> to your [`.gitignore` file](https://github.com/github/gitignore).
> In the next section,
> we'll explore an approach that can help you automate tasks 
> like assessing coverage.

Is this good enough?
The answer depends on what the software is being used for and by whom.
If it is for a safety-critical application such as a medical device,
we should aim for 100% code coverage,
i.e.,
every single line in the application should be tested.
In fact,
we should probably go further and aim for 100% **path coverage**
to ensure that every possible path through the code has been checked.
Similarly,
if the software has become popular and is being used by thousands of researchers all over the world,
we should probably check that it's not going to embarrass us.

But most of us don't write software that people's lives depend on,
or that is in a "top 100" list,
so requiring 100% code coverage is like asking for ten decimal places of accuracy
when checking the voltage of a household electrical outlet.
We always need to balance the effort required to create tests
against the likelihood that those tests will uncover useful information.
We also have to accept that no amount of testing
can prove a piece of software is completely correct.
A function with only two numeric arguments has 2^128^ possible inputs.
Even if we could write the tests,
how could we be sure we were checking the result of each one correctly?

\newpage

Luckily,
we can usually put test cases into groups.
For example,
when testing a function that summarizes a table full of data,
it's probably enough to check that it handles tables with:

-   no rows
-   only one row
-   many identical rows
-   rows having keys that are supposed to be unique, but aren't
-   rows that contain nothing but missing values

Some projects develop **checklists**} like this one to remind programmers what they ought to test.
These checklists can be a bit daunting for newcomers,
but they are a great way to pass on hard-earned experience.

## Continuous Integration **TODO** MOVE SECTION TO WORKFLOW

Now that we have a set of tests,
we could run `pytest` every now and again to check our code.
This is probably sufficient for short-lived projects,
but if several people are involved,
or if we are making changes over weeks or months,
we might forget to run the tests
or it might be difficult to identify which change is responsible for a test failure.

The solution is **continuous integration** (CI),\index which runs tests automatically whenever a change is made.
CI tells developers immediately if changes have caused problems,
which makes them much easier to fix.
CI can also be set up to run tests with several different configurations of the software
or on several different operating systems,
so that a programmer using Windows
can be warned that a change breaks things for Mac users and vice versa.

One popular CI tool is **Travis CI**, which integrates well with
**GitHub**. If Travis CI has been set up,
then every time a change is committed to a GitHub repository,
Travis CI creates a fresh environment,
makes a fresh clone of the repository ([Section on working with others work](https://software-engineering-group-up.github.io/RSE-UP/chapters/git_advanced.html#using-other-people-s-work)),
and runs whatever commands the project's managers have set up.

Before setting up our account with Travis CI, however,
we need to prepare our repository to be recognized by the tool.
We'll first add a file called `.travis.yml` to our repository,
which includes instructions for Travis CI.
(The leading `.` in the name hides the file from casual listings on Mac or Linux,
but not on Windows.)
This file must be in the root directory of the repository,
and is written in **YAML**
([Section config formats](https://software-engineering-group-up.github.io/RSE-UP/chapters/configuration.html#configuration-file-formats) and Appendix [YAML](https://software-engineering-group-up.github.io/RSE-UP/chapters/yaml.html).
For our project,
we add the following lines:

```yaml
language: python

python:
- "3.6"

install:
- pip install -r requirements.txt

script:
- pytest
```

> **Python 3.6?**
> 
> An early draft of the book used Python 3.6, 
> and we later updated to 3.7.
> Over the life of a real project,
> software versions change,
> and it's not always feasible or possible to re-do all parts of the project.
> In this case,
> our first build in Travis CI used Python 3.6,
> so that's what we've shown here,
> and later checked that updating to 3.7 didn't break anything.
> We can't expect our software will be perfect the first time around,
> but we can do our best to document what's changed and confirm
> our results are still accurate.

The `language` key tells Travis CI which programming language to use,
so that it knows which of its standard **virtual machines** to use as a starting point for the project.
The `python` key specifies the version or versions of Python to use,
while the `install` key indicates the name of the file (`requirements.txt`)
listing the libraries that need to be installed.
The `script` key lists the commands to run---in this case, `pytest`---which
in turn executes our project scripts
(i.e., `test_zipfs.py`, `plotcounts.py`, `countwords.py` and `utilities.py`).
These scripts import a number of packages that don't come with the
[Python Standard Library](https://docs.python.org/3/library/),
so these are what comprise `requirements.txt`:

```text
numpy
pandas
matplotlib
scipy
pytest
pyyaml
```

Be sure to save both `requirements.txt` and `.travis.yml`
to your project's root directory,
commit to your repository,
and push to GitHub,
or Travis CI will not be able to recognize your project.

We're now ready to set up CI for our project.
The basic steps are as follows:

1.  Create an account on **Travis CLI** (if we don't already have one).
2.  Link our Travis CI account to our GitHub account (if we haven't done so already).
3.  Tell Travis CI to watch the repository that contains our project.

Creating an account with an online service is probably a familiar process,
but linking our Travis CI account to our GitHub account may be something new.
We only have to do this once
to allow Travis CI to access all our GitHub repositories,
but we should always be careful when giving sites access to other sites,
and only trust well-established and widely used services.

We can tell Travis CI which repository we want it to watch
by clicking the "+" next to the "My Repositories" link
on the left-hand side of the Travis CI homepage ([Figure Travis adding a repo](testing-add-repo)).

```{figure} ../figures/testing/travis-add-repo.png
:name: testing-add-repo
Travis Adding a repo
```

To add the GitHub repository we have been using throughout this book,
find it in the repository list
([Figure listing repos](testing-list-repos)).
If the repository doesn't show up,
re-synchronize the list using the green "Sync account" button on the left sidebar.
If it still doesn't appear,
the repository may belong to someone else or be private,
or your required files may be incorrect.
Click the "Trigger a build" button to initiate your first test using Travis CI.

```{figure} ../figures/testing/travis-list-repos.png
:name: testing-list-repo
List repos
```

Once your repository has been activated,
Travis CI follows the instructions in `.travis.yml`
and reports whether the build passed (shown in green)
or produced warnings or errors (shown in red).
To create this report, Travis CI has done the following:

1.  Created a new Linux virtual machine.
2.  Installed the desired version of Python.
3.  Run the commands below the `script` key.
4.  Reported the results at `https://travis-ci.com/USER/REPO`,
    where `USER/REPO`
    identifies the repository for a given user.

Our tests pass and the build completes successfully.
We can view additional details about the test by clicking on the
repository name
([Figure Build pass](testing-build-pass)).

```{figure} ../figures/testing/travis-build-pass.png
:name: testing-build-pass
Build pass

```

This example shows one of the other benefits of CI:
it forces us to be explicit about what we are doing and how we do it,
just as writing a Makefile forces us to be explicit about exactly how we produce results {cite:p}`Zamp2020`.

## When to Write Tests 

We have now met the three major types of test: unit, integration, and regression.
At what point in the code development process should we write these?
The answer depends on who you ask.

Many programmers are passionate advocates of a practice called
**test-driven development**
(TDD).
Rather than writing code and then writing tests,
they write the tests first and then write just enough code to make those tests pass.
Once the code is working,
they clean it up ([Chapter readable code](https://software-engineering-group-up.github.io/RSE-UP/chapters/clean_readable_code.html)) and then move on to the next task.
TDD's advocates claim that this leads to better code because:

1.  Writing tests clarifies what the code is actually supposed to do.

2.  It eliminates **confirmation bias**.
    If someone has just written a function,
    they are predisposed to want it to be right,
    so they will bias their tests towards proving that it is correct
    instead of trying to uncover errors.

3.  Writing tests first ensures that they actually get written.

These arguments are plausible.
However,
studies such as {cite:p}`Fucc2016` and {cite:p}`Fucc2017` don't support them:
in practice,
writing tests first or last doesn't appear to affect productivity.
What *does* have an impact is working in small, interleaved increments,
i.e.,
writing just a few lines of code and testing it before moving on
rather than writing several pages of code and then spending hours on testing.

So how do most data scientists figure out if their software is doing the right thing?
The answer is spot checks:
each time they produce an intermediate or final result,
they scan a table, create a chart, or inspect some summary statistics
to see if everything looks OK.
Their heuristics are usually easy to state,
like "there shouldn't be NAs at this point" or "the age range should be reasonable,"
but applying those heuristics to a particular analysis always depends on
their evolving insight into the data in question.

By analogy with test-driven development,
we could call this process "checking-driven development."
Each time we add a step to our pipeline and look at its output,
we can also add a check of some kind to the pipeline to ensure that
what we are checking for remains true as the pipeline evolves or is run on other data.
Doing this helps reusability---it's amazing how often a one-off analysis
winds up being used many times---but the real goal is comprehensibility.
If someone can get our code and data,
then runs the code on the data,
and gets the same result that we did,
then our computation is reproducible,
but that doesn't mean they can understand it.
Comments help
(either in the code or as blocks of prose in a **computational notebook**),
but they won't check that assumptions and invariants hold.
And unlike comments,
runnable assertions can't fall out of step with what the code is actually doing.

## Summary 

Testing data analysis pipelines is often harder than testing mainstream software applications,
since data analysts often don't know what the right answer is [{cite:p}`Brai2018`].
(If we did,
we would have submitted our report and moved on to the next problem already.)
The key distinction is the difference between **validation**,
which asks whether the specification is correct,
and \gref{verification}{verification},
which asks whether we have met that specification.
The difference between them is the difference between
building the right thing and building something right;
the practices introduced in this chapter will help with both.


```{include} keypoints/testing.md

```
