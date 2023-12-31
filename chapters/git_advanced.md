# Going Further with Git

> It's got three keyboards and a hundred extra knobs, including twelve with '?' on them.
>
> --- Terry Pratchett

Two of Git's advanced features let us to do much more than just track our work.
**Branches** let us work on multiple things simultaneously in a single repository; **pull requests** (PRs) let us submit our work for review,
get feedback, and make updates. Used together, they allow us to go through the write-review-revise cycle familiar to anyone who has ever written a journal paper in hours rather than weeks.

Your `zipf` project directory should now include:

```text
zipf/
├── .gitignore
├── bin
│   ├── book_summary.sh
│   ├── collate.py
│   ├── countwords.py
│   ├── plotcounts.py
│   ├── script_template.py
│   └── utilities.py
├── data
│   ├── README.md
│   ├── dracula.txt
│   ├── frankenstein.txt
│   └── ...
└── results
    ├── dracula.csv
    ├── dracula.png
    ├── jane_eyre.csv
    ├── jane_eyre.png
    └── moby_dick.csv
```


All of these files should also be tracked in your version history.
We'll use them and some additional analyses to explore Zipf's Law
using Git's advanced features.

## What's a Branch? 

So far we have only used a sequential timeline with Git:
each change builds on the one before,
and *only* on the one before.
However,
there are times when we want to try things out
without disrupting our main work.
To do this, we can use **branches** to work on separate tasks in parallel.
Each branch is a parallel timeline; changes made on the branch only affect that branch unless and until we explicitly combine them with work done in another branch. 

We can see what branches exist in a repository using this command:

```bash
$ git branch
```

```text
* master
```

When we initialize a repository, Git automatically creates a branch called `master`. It is often considered the "official" version of the repository.
The asterisk `*` indicates that it is currently active,
i.e., that all changes we make will take place in this branch by default.
(The active branch is like the **current working directory** in the shell.)

> **Default Branches**
> 
> In mid-2020,
> GitHub changed the name of the default branch
> (the first branch created when a repository is initialized) 
> from "master" to "main."
> Owners of repositories may also change the name of the default branch. 
> This means that the name of the default branch may be different among repositories
> based on when and where it was created,
> as well as who manages it.

In the previous chapter, we foreshadowed some experimental changes that we could try and make to `plotcounts.py`.

Making sure our project directory is our working directory, we can inspect our current `plotcounts.py`:

```bash
$ cd ~/zipf
$ cat bin/plotcounts.py
```

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
    ax = df.plot.scatter(x='word_frequency',
                         y='rank', loglog=True,
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

We used this version of `plotcounts.py` to display the word counts for *Dracula* on a log-log plot ([Figure: cmdline, loglog plot](git-cmdline-loglog-plot)).
The relationship between word count and rank looked linear,
but since the eye is easily fooled,
we should fit a curve to the data.
Doing this will require more than just a trivial change to the script,
so to ensure that this version of `plotcounts.py` keeps working
while we try to build a new one,
we will do our work in a separate branch.
Once we have successfully added curve fitting to `plotcounts.py`,
we can decide if we want to merge our changes back into the `master` branch.

```{figure} ../figures/git-cmdline/plot-loglog.png
:name: git-cmdline-loglog-plot
Git Command line LogLog plot
```

## Creating a Branch 

To create a new branch called `fit`,
we run:

```bash
$ git branch fit
```

We can check that the branch exists by running `git branch` again:

```bash
$ git branch
```

```text
* master
  fit
```

Our branch is there, but the asterisk `*` shows that we are still in the `master` branch. (By analogy, creating a new directory doesn't automatically move us into that directory.) As a further check, let's see what our repository's status is:

```bash
$ git status
```

```text
On branch master
nothing to commit, working directory clean
```

To switch to our new branch we can use the `checkout` command that we first saw in Chapter [git command line](https://software-engineering-group-up.github.io/RSE-UP/chapters/intro_version_control.html):

```bash
$ git checkout fit
$ git branch
```

```text
  master
* fit
```

In this case, we're using `git checkout` to check out a whole repository,
i.e., switch it from one saved state to another.

We should choose the name to signal the purpose of the branch,
just as we choose the names of files and variables to indicate what they are for.
We haven't made any changes since switching to the `fit` branch,
so at this point `master` and `fit` are at the same point in the repository's history.
Commands like `ls` and `git log` therefore show that the files and history haven't changed.

> **Where Are Branches Saved?**
>
> Git saves every version of every file in the `.git` directory
> that it creates in the project's root directory.
> When we switch from one branch to another,
> it replaces the files we see with
> their counterparts from the branch we're switching to.
> It also rearranges directories as needed
> so that those files are in the right places.

## What Curve Should We Fit?

Before we make any changes to our new branch, we need to figure out how to fit a line to the word count data. Zipf's Law says:

> The second most common word in a body of text
> appears half as often as the most common,
> the third most common appears a third as often, and so on.

In other words
the frequency of a word $f$ is proportional to its inverse rank $r$:

$ \large f \propto \frac{1}{r^\alpha} $

with a value of $\alpha$ close to one.
The reason $\alpha$ must be close to one for Zipf's Law to hold
becomes clear if we include it in a modified version of the earlier definition:

> The most frequent word will occur approximately $2^\alpha$ times
> as often as the second most frequent word,
> $3^\alpha$ times as often as the third most frequent word, and so on.

This mathematical expression for Zipf's Law is an example of a **power law**.
In general, when two variables $x$ and $y$ are related through a power law, so that 
$ y = ax^b $ 
taking logarithms of both sides yields a linear relationship:

$ \log(y) = \log(a) + b\log(x) $

Hence, plotting the variables on a log-log scale reveals this linear relationship. If Zipf's Law holds, we should have

$ \large r = cf^{\frac{-1}{\alpha}} $

where $c$ is a constant of proportionality.
The linear relationship between the log word frequency and log rank is then

$ \large \log(r) = \log(c) - \frac{1}{\alpha}\log(f) $

This suggests that the points on our log-log plot should fall on a straight  line with a slope of $- \tfrac{1}{\alpha}$ and intercept $\log(c)$.
To fit a line to our word count data we therefore need to estimate the value of $\alpha$; we'll see later that $c$ is completely defined.

In order to determine the best method for estimating $\alpha$, we turn to {cite:p}`More2016`, which suggests using a method called **maximum likelihood estimation**. The likelihood function is the probability of our observed data
as a function of the parameters in the statistical model that we assume generated it. We estimate the parameters in the model by choosing them to maximize this likelihood; computationally, it is often easier to minimize the negative log likelihood function. {cite:p}`More2016` define the likelihood using a parameter $\beta$, which is related to the $\alpha$ parameter in our definition of Zipf's Law through $\large \alpha = \tfrac{1}{\beta-1}$.
Under their model, the value of $c$ is the total number of unique words,
or equivalently the largest value of the rank.


Expressed as a Python function, the negative log likelihood function is:

```python
import numpy as np


def nlog_likelihood(beta, counts):
    """Log-likelihood function."""
    likelihood = - np.sum(np.log((1/counts)**(beta - 1)
                          - (1/(counts + 1))**(beta - 1)))
    return likelihood
```

Obtaining an estimate of \(\beta\) (and thus \(\alpha\)) then becomes a numerical optimization problem, for which we can use the [`scipy.optimize`](https://docs.scipy.org/doc/scipy/reference/optimize.html) library.
Again following @More2016, we use Brent's Method with \(1 < \beta \leq 4\).

```python
from scipy.optimize import minimize_scalar


def get_power_law_params(word_counts):
    """Get the power law parameters."""
    mle = minimize_scalar(nlog_likelihood,
                          bracket=(1 + 1e-10, 4),
                          args=word_counts,
                          method='brent')
    beta = mle.x
    alpha = 1 / (beta - 1)
    return alpha
```

We can then plot the fitted curve on the plot axes (`ax`) defined in the `plotcounts.py` script:

```python
def plot_fit(curve_xmin, curve_xmax, max_rank, alpha, ax):
    """
    Plot the power law curve that was fitted to the data.

    Parameters
    ----------
    curve_xmin : float
        Minimum x-bound for fitted curve
    curve_xmax : float
        Maximum x-bound for fitted curve
    max_rank : int
        Maximum word frequency rank.
    alpha : float
        Estimated alpha parameter for the power law.
    ax : matplotlib axes
        Scatter plot to which the power curve will be added.
    """
    xvals = np.arange(curve_xmin, curve_xmax)
    yvals = max_rank * (xvals**(-1 / alpha))
    ax.loglog(xvals, yvals, color='grey')
```

where the maximum word frequency rank corresponds to $c$, and $-1 / \alpha$ the exponent in the power law. We have followed the [`numpydoc`](https://numpydoc.readthedocs.io/en/latest/) format for the detailed docstring
in `plot_fit`---see Chapter [documentation][https://software-engineering-group-up.github.io/RSE-UP/chapters/writing_documentation.html] for more information about docstring formats.

## Verifying Zipf's Law 

Now that we can fit a curve to our word count plots, we can update `plotcounts.py` so the entire script reads as follows:

```python
"""Plot word counts."""

import argparse

import numpy as np
import pandas as pd
from scipy.optimize import minimize_scalar


def nlog_likelihood(beta, counts):
    """Log-likelihood function."""
    likelihood = - np.sum(np.log((1/counts)**(beta - 1)
                          - (1/(counts + 1))**(beta - 1)))
    return likelihood


def get_power_law_params(word_counts):
    """Get the power law parameters."""
    mle = minimize_scalar(nlog_likelihood,
                          bracket=(1 + 1e-10, 4),
                          args=word_counts,
                          method='brent')
    beta = mle.x
    alpha = 1 / (beta - 1)
    return alpha


def plot_fit(curve_xmin, curve_xmax, max_rank, alpha, ax):
    """
    Plot the power law curve that was fitted to the data.

    Parameters
    ----------
    curve_xmin : float
        Minimum x-bound for fitted curve
    curve_xmax : float
        Maximum x-bound for fitted curve
    max_rank : int
        Maximum word frequency rank.
    alpha : float
        Estimated alpha parameter for the power law.
    ax : matplotlib axes
        Scatter plot to which the power curve will be added.
    """
    xvals = np.arange(curve_xmin, curve_xmax)
    yvals = max_rank * (xvals**(-1 / alpha))
    ax.loglog(xvals, yvals, color='grey')


def main(args):
    """Run the command line program."""
    df = pd.read_csv(args.infile, header=None,
                     names=('word', 'word_frequency'))
    df['rank'] = df['word_frequency'].rank(ascending=False,
                                           method='max')
    ax = df.plot.scatter(x='word_frequency',
                         y='rank', loglog=True,
                         figsize=[12, 6],
                         grid=True,
                         xlim=args.xlim)

    word_counts = df['word_frequency'].to_numpy()
    alpha = get_power_law_params(word_counts)
    print('alpha:', alpha)

    # Since the ranks are already sorted, we can take the last
    # one instead of computing which row has the highest rank
    max_rank = df['rank'].to_numpy()[-1]

    # Use the range of the data as the boundaries
    # when drawing the power law curve
    curve_xmin = df['word_frequency'].min()
    curve_xmax = df['word_frequency'].max()

    plot_fit(curve_xmin, curve_xmax, max_rank, alpha, ax)
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

We can then run the script to obtain the $\alpha$ value for *Dracula*
and a new plot with a line fitted.

```bash
$ python bin/plotcounts.py results/dracula.csv --outfile
  results/dracula.png
```

```text
alpha: 1.0866646252515038
```

So according to our fit, the most frequent word will occur approximately $2^{1.1}=2.1$ times as often as the second most frequent word, $3^{1.1}=3.3$ times as often as the third most frequent word, and so on. [Figure: dracula fit](git-advanced-dracula-fit) shows the plot.

```{figure} ../figures/git-advanced/dracula-fit.png
:name: git-advanced-dracula-fit.png

Dracula Fit
```

The script appears to be working as we'd like, so we can go ahead and commit our changes to the `fit` development branch:

```bash
$ git add bin/plotcounts.py results/dracula.png
$ git commit -m "Added fit to word count data"
```

```text
[fit 38c209b] Added fit to word count data
 2 files changed, 57 insertions(+)
 rewrite results/dracula.png (99%)
```

If we look at the last couple of commits using `git log`, we see our most recent change:

```bash
$ git log --oneline -n 2
```

```text
38c209b (HEAD -> fit) Added fit to word count data
ddb00fb (origin/master, master) removing inverse rank
        calculation
```

(We use `--oneline` and `-n 2` to shorten the log display.) But if we switch back to the `master` branch:

```bash
$ git checkout master
$ git branch
```

```text
  fit
* master
```

and look at the log,
our change is not there:

```bash
$ git log --oneline -n 2
```

```text
ddb00fb (HEAD -> master, origin/master) removing inverse rank
        calculation
7de9877 ignoring __pycache__
```

We have not lost our work:
it just isn't included in this branch.
We can prove this by switching back to the `fit` branch and checking the log again:

```bash
$ git checkout fit
$ git log --oneline -n 2
```

```text
38c209b (HEAD -> fit) Added fit to word count data
ddb00fb (origin/master, master) removing inverse rank
        calculation
```

We can also look inside `plotcounts.py` and see our changes.
If we make another change and commit it, that change will also go into the `fit` branch. For instance, we could add some additional information to one of our docstrings to make it clear what equations were used in estimating \(\alpha\).

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
    mle = minimize_scalar(nlog_likelihood,
                          bracket=(1 + 1e-10, 4),
                          args=word_counts,
                          method='brent')
    beta = mle.x
    alpha = 1 / (beta - 1)
    return alpha
```

```bash
$ git add bin/plotcounts.py
$ git commit -m "Adding Moreno-Sanchez et al (2016) reference"
```

```text
[fit 1577404] Adding Moreno-Sanchez et al (2016) reference
 1 file changed, 14 insertions(+), 1 deletion(-)
```

Finally, if we want to see the differences between two branches,
we can use `git diff` with the same double-dot `..` syntax used to view differences between two revisions:

```bash
$ git diff master..fit
```

```diff
diff --git a/bin/plotcounts.py b/bin/plotcounts.py
index c511da1..6905b6e 100644
--- a/bin/plotcounts.py
+++ b/bin/plotcounts.py
@@ -2,7 +2,62 @@
 
 import argparse
 
+import numpy as np
 import pandas as pd
+from scipy.optimize import minimize_scalar
+
+
+def nlog_likelihood(beta, counts):
+    """Log-likelihood function."""
+    likelihood = - np.sum(np.log((1/counts)**(beta - 1)
+                          - (1/(counts + 1))**(beta - 1)))
+    return likelihood
+
+
+def get_power_law_params(word_counts):
+    """
+    Get the power law parameters.
+
+    References
+    ----------
+    Moreno-Sanchez et al (2016) define alpha (Eq. 1),
+      beta (Eq. 2) and the maximum likelihood estimation (mle)
+      of beta (Eq. 6).
+
+    Moreno-Sanchez I, Font-Clos F, Corral A (2016)
+      Large-Scale Analysis of Zipf's Law in English Texts.
+      PLoS ONE 11(1): e0147073.
+      https://doi.org/10.1371/journal.pone.0147073
+    """
+    mle = minimize_scalar(nlog_likelihood,
+                          bracket=(1 + 1e-10, 4),
+                          args=word_counts,
+                          method='brent')
+    beta = mle.x
+    alpha = 1 / (beta - 1)
+    return alpha
+
+
+def plot_fit(curve_xmin, curve_xmax, max_rank, alpha, ax):
+    """
+    Plot the power law curve that was fitted to the data.
+
+    Parameters
+    ----------
+    curve_xmin : float
+        Minimum x-bound for fitted curve
+    curve_xmax : float
+        Maximum x-bound for fitted curve
+    max_rank : int
+        Maximum word frequency rank.
+    alpha : float
+        Estimated alpha parameter for the power law.
+    ax : matplotlib axes
+        Scatter plot to which the power curve will be added.
+    """
+    xvals = np.arange(curve_xmin, curve_xmax)
+    yvals = max_rank * (xvals**(-1 / alpha))
+    ax.loglog(xvals, yvals, color='grey')
 
 
 def main(args):
@@ -16,6 +71,21 @@ def main(args):
                          figsize=[12, 6],
                          grid=True,
                          xlim=args.xlim)
+
+    word_counts = df['word_frequency'].to_numpy()
+    alpha = get_power_law_params(word_counts)
+    print('alpha:', alpha)
+
+    # Since the ranks are already sorted, we can take the last
+    # one instead of computing which row has the highest rank
+    max_rank = df['rank'].to_numpy()[-1]
+
+    # Use the range of the data as the boundaries
+    # when drawing the power law curve
+    curve_xmin = df['word_frequency'].min()
+    curve_xmax = df['word_frequency'].max()
+
+    plot_fit(curve_xmin, curve_xmax, max_rank, alpha, ax)
     ax.figure.savefig(args.outfile)
 
 
diff --git a/results/dracula.png b/results/dracula.png
index 57a7b70..5f10271 100644
Binary files a/results/dracula.png and b/results/dracula.png
differ
```

> **Why Branch?**
>
> Why go to all this trouble?
> Imagine we are in the middle of debugging a change like this
> when we are asked to make final revisions
> to a paper that was created using the old code.
> If we revert `plotcount.py` to its previous state we might lose our changes.
> If instead we have been doing the work on a branch,
> we can switch branches,
> create the plot,
> and switch back in complete safety.

## Merging

We could proceed in three ways at this point:

1.  Add our changes to `plotcounts.py` once again in the `master` branch.
2.  Stop working in `master` and start using the `fit` branch for future development.
3. **Merge** the `fit` and `master` branches.

The first option is tedious and error-prone; the second will lead to a bewildering proliferation of branches, but the third option is simple, fast, and reliable. To start, let's make sure we're in the `master` branch:

```bash
$ git checkout master
$ git branch
```

```text
  fit
* master
```

We can now merge the changes in the `fit` branch into our current branch
with a single command:

```bash
$ git merge fit
```

```text
Updating ddb00fb..1577404
Fast-forward
 bin/plotcounts.py   |  70 ++++++++++++++++++++++++++++++++++++++
                           +++++++++++++++++++++++++++++++
 results/dracula.png | Bin 23291 -> 38757 bytes
 2 files changed, 70 insertions(+)
```

Merging doesn't change the source branch `fit`, but once the merge is done,
all of the changes made in `fit` are also in the history of `master`:

```bash
$ git log --oneline -n 4
```

```text
1577404 (HEAD -> master, fit) Adding Moreno-Sanchez et al
        (2016) reference
38c209b Added fit to word count data
ddb00fb (origin/master) removing inverse rank calculation
7de9877 ignoring __pycache__
```

Note that Git automatically creates a new commit (in this case, `1577404`)
to represent the merge. If we now run `git diff master..fit`, Git doesn't print anything because there aren't any differences to show.

Now that we have merged all of the changes from `fit` into `master`
there is no need to keep the `fit` branch, so we can delete it:

```bash
$ git branch -d fit
```

```text
Deleted branch fit (was 1577404).
```

> **Not Just the Command Line**
>
> We have been creating, merging, and deleting branches on the command line,
> but we can do all of these things using [GitKraken](https://www.gitkraken.com)or [gitUI](https://github.com/extrawurst/gitui)
> and other GUIs. 
> The operations stay the same;
> all that changes is how we tell the computer what we want to do.

## Handling Conflicts

A **conflict** occurs when a line has been changed in different ways in two separate branches or when a file has been deleted in one branch but edited in the other. Merging `fit` into `master` went smoothly because there were no conflicts between the two branches, but if we are going to use branches,
we must learn how to merge conflicts.

To start, use `nano` to add the project's title to a new file called `README.md` in the `master` branch, which we can then view:

```bash
$ cat README.md
```

```text
# Zipf's Law
```

```bash
$ git add README.md
$ git commit -m "Initial commit of README file"
```

```text
[master 232b564] Initial commit of README file
 1 file changed, 1 insertion(+)
 create mode 100644 README.md
```

Now let's create a new development branch called `docs` to work on improving the documentation for our code. We will use `git checkout -b` to create a new branch and switch to it in a single step:

```bash
$ git checkout -b docs
```

```text
Switched to a new branch 'docs'
```

```bash
$ git branch
```

```text
* docs
  master
```

On this new branch, let's add some information to the README file:

```text
# Zipf's Law

These Zipf's Law scripts tally the occurrences of words in text
files and plot each word's rank versus its frequency.
```

```bash
$ git add README.md
$ git commit -m "Added repository overview"
```

```text
[docs a0b88e5] Added repository overview
 1 file changed, 3 insertions(+)
```

In order to create a conflict, let's switch back to the `master` branch. 
The changes we made in the `docs` branch are not present:

```bash
$ git checkout master
```

```text
Switched to branch 'master'
```

```bash
$ cat README.md
```

```text
# Zipf's Law
```

Let's add some information about the contributors to our work:

```text
# Zipf's Law

## Contributors

- Amira Khan <amira@zipf.org>
```

```
$ git add README.md
$ git commit -m "Added contributor list"
```

```text
[master 45a576b] Added contributor list
 1 file changed, 4 insertions(+)
```

We now have two branches,
`master` and `docs`,
in which we have changed `README.md` in different ways:

```bash
$ git diff docs..master
```

```diff
diff --git a/README.md b/README.md
index f40e895..71f67db 100644
--- a/README.md
+++ b/README.md
@@ -1,4 +1,5 @@
 # Zipf's Law
 
-These Zipf's Law scripts tally occurrences of words in text
-files and plot each word's rank versus its frequency.
+## Contributors
+
+- Amira Khan <amira@zipf.org>
```

When we try to merge `docs` into `master`,
Git doesn't know which of these changes to keep:

```bash
$ git merge docs master
```

```text
Auto-merging README.md
CONFLICT (content): Merge conflict in README.md
Automatic merge failed; fix conflicts and then commit the result.
```

If we look in `README.md`,
we see that Git has kept both sets of changes,
but has marked which came from where:

```bash
$ cat README.md
```

```text
# Zipf's Law

<<<<<<< HEAD
## Contributors

- Amira Khan <amira@zipf.org>
=======
These Zipf's Law scripts tally the occurrences of words in text
files and plot each word's rank versus its frequency.
>>>>>>> docs
```

The lines from `<<<<<<< HEAD` to `=======` are what was in `master`,
while the lines from there to `>>>>>>> docs` show what was in `docs`.
If there were several conflicting regions in the same file,
Git would mark each one this way.

We have to decide what to do next: keep the `master` changes,
keep those from `docs`, edit this part of the file to combine them,
or write something new. Whatever we do, we must remove the `>>>`, `===`, and `<<<` markers. Let's combine the two sets of changes so the resulting file reads:

```text
# Zipf's Law

These Zipf's Law scripts tally the occurrences of words in text
files and plot each word's rank versus its frequency.

## Contributors

- Amira Khan <amira@zipf.org>
```

We can now add the file and commit the change, just as we would after any other edit:

```bash
$ git add README.md
$ git commit -m "Merging README additions"
```

```text
[master 55c63d0] Merging README additions
```

Our branch's history now shows a single sequence of commits, with the `master` changes on top of the earlier `docs` changes:

```bash
$ git log --oneline -n 4
```

```text
55c63d0 (HEAD -> master) Merging README additions
45a576b Added contributor list
a0b88e5 (docs) Added repository overview
232b564 Initial commit of README file
```

If we want to see what really happened, we can add the `--graph` option to `git log`:

```bash
$ git log --oneline --graph -n 4
```

```text
*   55c63d0 (HEAD -> master) Merging README additions
|\  
| * a0b88e5 (docs) Added repository overview
* | 45a576b Added contributor list
|/  
* 232b564 Initial commit of README file
```

At this point we can delete the `docs` branch:

```bash
$ git branch -d docs
```

```text
Deleted branch docs (was a0b88e5).
```

Alternatively, we can keep using `docs` for documentation updates.
Each time we switch to it, we merge changes *from* `master` *into* `docs`,
do our editing (while switching back to `master` or other branches as needed
to work on the code), and then merge *from* `docs` *to* `master` once the documentation is updated.

> **Remember to Push**
>
> If you are using a remote repository,
> don't forget to use `git push`
> to keep your version on GitHub up to date
> with your local version.

## A Branch-Based Workflow 

What is the best way to incorporate branching into our regular coding practice?
If we are working on our own computer, this workflow will help us keep track of what we are doing:

1.  `git checkout master` to make sure we are in the `master` branch.

2.  `git checkout -b name-of-feature` to create a new branch.
    We *always* create a branch when making changes,
    since we never know what else might come up.
    The branch name should be as descriptive as a variable name or filename would be.

3.  Make our changes.
    If something occurs to us along the way---for example,
    if we are writing a new function and realize that
    the documentation for some other function should be updated---we do *not*
    do that work in this branch just because we happen to be there.
    Instead,
    we commit our changes,
    switch back to `master`,
    and create a new branch for the other work.

4.  When the new feature is complete,
    we `git merge master name-of-feature`
    to get any changes we merged into `master` after creating `name-of-feature`
    and resolve any conflicts.
    This is an important step:
    we want to do the merge and test that everything still works in our feature branch,
    not in `master`.

5.  Finally,
    we switch back to `master` and `git merge name-of-feature master`
    to merge our changes into `master`.
    We should not have any conflicts,
    and all of our tests should pass.

Most experienced developers use this **branch-per-feature workflow**, but what exactly is a "feature"? These rules make sense for small projects:

1.  Anything cosmetic that is only one or two lines long
    can be done in `master` and committed right away.
    Here, "cosmetic" means changes to comments or documentation:
    nothing that affects how code runs, not even a simple variable renaming.

2.  A pure addition that doesn't change anything else is a feature and goes into a branch. 
    For example, if we run a new analysis and save the results,
    that should be done on its own branch because it might take several tries to get the analysis to run, and we might interrupt ourselves to fix things that we discover aren't working.

3.  Every change to code that someone might want to undo later in one step is a feature.
    For example, if a new parameter is added to a function,
    then every call to the function has to be updated.
    Since neither alteration makes sense without the other,
    those changes are considered a single feature and should be done in one branch.

The hardest thing about using a branch-per-feature workflow is sticking to it for small changes. As the first point in the list above suggests, most people are pragmatic about this on small projects; on large ones, where dozens of people might be committing, even the smallest and most innocuous change needs to be in its own branch so that it can be reviewed (which we discuss below).

## Using Other People's Work

So far we have used Git to manage individual work,
but it really comes into its own when we are working with other people.
We can do this in two ways:

1.  Everyone has read and write access to a single shared repository.

2.  Everyone can read from the project's main repository,
    but only a few people can commit changes to it.
    The project's other contributors **fork** the main repository
    to create one that they own,
    do their work in that,
    and then submit their changes to the main repository.

The first approach works well for teams of up to half a dozen people
who are all comfortable using Git, but if the project is larger,
or if contributors are worried that they might make a mess in the `master` branch, the second approach is safer.

Git itself doesn't have any notion of a "main repository",
but \gref{forges}{forge} like Github, Gitlab, Bitbucket or selfhosted solutions like Gitea all encourage people to use Git in ways that effectively create one.
Suppose, for example, that Sami wants to contribute to the Zipf's Law code that
Amira is hosting on GitHub at `https://github.com/amira-khan/zipf`.
Sami can go to that URL and click on the "Fork" button in the upper right corner
([Figure: fork button](git-advanced-fork-button)).
GitHub immediately creates a copy of Amira's repository within Sami's account on GitHub's own servers.

```{figure} ../figures/git-advanced/fork-button.png
:name: git-advanced-fork-button

Git Fork button
```

When the command completes, the setup on GitHub now looks like [Figure: after fork](git-advanced-after-fork).Nothing has happened yet on Sami's own machine:
the new repository exists only on GitHub.
When Sami explores its history, they see that it contains all of the changes Amira made.

```{figure} ../figures/git-advanced/after-fork.png
:name: git-advanced-after-fork

Git: After Fork
```

A copy of a repository is called a **clone** In order to start working on the project, Sami needs a clone of *their* repository (not Amira's) on their own computer. We will modify Sami's prompt to include their desktop user ID (`sami`
 and working directory (initially `~`) to make it easier to follow what's happening:


```bash
sami:~ $ git clone https://github.com/sami-virtanen/zipf.git
```

```text
Cloning into 'zipf'...
remote: Enumerating objects: 64, done.
remote: Counting objects: 100% (64/64), done.
remote: Compressing objects: 100% (43/43), done.
remote: Total 64 (delta 20), reused 63 (delta 19), pack-reused 0
Receiving objects: 100% (64/64), 2.20 MiB | 2.66 MiB/s, done.
Resolving deltas: 100% (20/20), done.
```

This command creates a new directory with the same name as the project,
i.e., `zipf`. When Sami goes into this directory and runs `ls` and `git log`,
they see that all of the project's files and history are there:

```bash
sami:~ $ cd zipf
sami:~/zipf $ ls
```

```text
README.md       bin             data             results
```

```bash
sami:~/zipf $ git log --oneline -n 4
```

```text
55c63d0 (HEAD -> master, origin/master, origin/HEAD) 
        Merging README additions
45a576b Added contributor list
a0b88e5 Added repository overview
232b564 Initial commit of README file
```

Sami also sees that Git has automatically created a **remote** for their repository that points back at their repository on GitHub:

```bash
sami:~/zipf $ git remote -v
```

```text
origin  https://github.com/sami-virtanen/zipf.git (fetch)
origin  https://github.com/sami-virtanen/zipf.git (push)
```

Sami can pull changes from their fork and push work back there, but needs to do one more thing before getting the changes from Amira's repository:

```bash
sami:~/zipf $ git remote add upstream
              https://github.com/amira-khan/zipf.git
sami:~/zipf $ git remote -v
```

```text
origin      https://github.com/sami-virtanen/zipf.git (fetch)
origin      https://github.com/sami-virtanen/zipf.git (push)
upstream    https://github.com/amira-khan/zipf.git (fetch)
upstream    https://github.com/amira-khan/zipf.git (push)
```

Sami has called their new remote `upstream` because it points at the repository
from which theirs is derived. They could use any name, but `upstream` is a nearly universal convention. 

With this remote in place, Sami is finally set up. Suppose, for example,
that Amira has modified the project's `README.md` file to add Sami as a contributor. (Again, we show Amira's user ID and working directory in her prompt to make it clear who's doing what):

```text
# Zipf's Law

These Zipf's Law scripts tally the occurrences of words in text
files and plot each word's rank versus its frequency.

## Contributors

- Amira Khan <amira@zipf.org>
- Sami Virtanen
```

Amira commits her changes and pushes them to *her* repository on GitHub:

```bash
amira:~/zipf $ git commit -a -m "Adding Sami as a contributor"
```

```text
[master 35fca86] Adding Sami as a contributor
 1 file changed, 1 insertion(+)
```

```bash
amira:~/zipf $ git push origin master
```

```text
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 4 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 315 bytes | 315.00 KiB/s, done.
Total 3 (delta 2), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (2/2), completed with 2 local
        objects.
To https://github.com/amira-khan/zipf.git
   55c63d0..35fca86  master -> master
```

\newpage

Amira's changes are now on her desktop and in her GitHub repository
but not in either of Sami's repositories (local or remote).
Since Sami has created a remote that points at Amira's GitHub repository,
though, they can easily pull those changes to their desktop:

```bash
sami:~/zipf $ git pull upstream master
```

```text
From https://github.com/amira-khan/zipf
 * branch            master     -> FETCH_HEAD
 * [new branch]      master     -> upstream/master
Updating 55c63d0..35fca86
Fast-forward
 README.md | 1 +
 1 file changed, 1 insertion(+)
```

Pulling from a repository owned by someone else is no different than pulling from a repository we own. In either case, Git merges the changes and asks us to resolve any conflicts that arise. 
The only significant difference is that, as with `git push` and `git pull`,
we have to specify both a remote and a branch:
in this case, `upstream` and `master`.

## Pull Requests

Sami can now get Amira's work, but how can Amira get Sami's?
She could create a remote that pointed at Sami's repository on GitHub
and periodically pull in Sami's changes, but that would lead to chaos, since we could never be sure that everyone's work was in any one place at the same time.
Instead,
almost everyone uses **pull requests**. They aren't part of Git itself,
but are supported by all major online **forges**.

A pull request is essentially a note saying, "Someone would like to merge branch A of repository B into branch X of repository Y."
The pull request does not contain the changes, but instead points at two particular branches. That way, the difference displayed is always up to date
if either branch changes.

But a pull request can store more than just the source and destination branches:
it can also store comments people have made about the proposed merge.
Users can comment on the pull request as a whole, or on particular lines,
and mark comments as out of date if the author of the pull request updates the code that the comment is attached to. Complex changes can go through several rounds of review and revision before being merged,
which makes pull requests the review system we all wish journals actually had.

To see this in action, suppose Sami wants to add their email address to `README.md`. They create a new branch and switch to it:

```bash
sami:~/zipf $ git checkout -b adding-email
```

```text
Switched to a new branch 'adding-email'
```

then make a change and commit it:

```bash
sami:~/zipf $ git commit -a -m "Adding my email address"
```

```text
[adding-email 3e73dc0] Adding my email address
 1 file changed, 1 insertion(+), 1 deletion(-)
```

```bash
sami:~/zipf $ git diff HEAD~1
```

```diff
diff --git a/README.md b/README.md
index e8281ee..e1bf630 100644
--- a/README.md
+++ b/README.md
@@ -6,4 +6,4 @@ and plot each word's rank versus its frequency.
 ## Contributors
 
 - Amira Khan <amira@zipf.org>
-- Sami Virtanen
+- Sami Virtanen <sami@zipf.org>
```

Sami's changes are only in their local repository. They cannot create a pull request until those changes are on GitHub, so they push their new branch to their repository on GitHub:

```bash
sami:~/zipf $ git push origin adding-email
```

```text
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 4 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 315 bytes | 315.00 KiB/s, done.
Total 3 (delta 2), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (2/2), completed with 2 local
  objects.
remote: 
remote: Create a pull request for 'adding-email' on GitHub by
  visiting:
  https://github.com/sami-virtanen/zipf/pull/new/adding-email
remote: 
To https://github.com/sami-virtanen/zipf.git
 * [new branch]      adding-email -> adding-email
```

When Sami goes to their GitHub repository in the browser, GitHub notices that they have just pushed a new branch and asks them if they want to create a pull request ([Figure: after push](git-advanced-after-sami-pushes)).

```{figure} ../figures/git-advanced/after-sami-pushes.png
:name: git-advanced-after-sami-pushes

Git after Push
```

When Sami clicks on the button, GitHub displays a page showing the default source and destination of the pull request and a pair of editable boxes for the pull request's title and a longer comment ([Figure: pull request start](git-advanced-pull-request-start)).

```{figure} ../figures/git-advanced/open-pull-request.png
:name: git-advanced-pull-request-start
Start a pull request
```

If they scroll down, Sami can see a summary of the changes that will be in the pull request ([Figure: pull request summary](git-advanced-pull-request-summary)).

```{figure} ../figures/git-advanced/open-pull-request-detail.png
:name: git-advanced-pull-request-summary
Git pull request summary
```

The top (title) box is autofilled with the previous commit message,
so Sami adds an extended explanation to provide additional context
before clicking on "Create Pull Request"
([Figure: fill in pull request](git-advanced-pull-request-fill-in)).
When they do, GitHub displays a page showing the new pull request,
which has a unique serial number ([Figure :New pull request](git-advanced-pull-request-new)).
Note that this pull request is displayed in Amira's repository rather than Sami's, since it is Amira's repository that will be affected if the pull request is merged.

```{figure} ../figures/git-advanced/fill-in-pull-request.png
:name: git-advanced-pull-request-fill-in
Git Fill in pull request
```

```{figure} ../figures/git-advanced/new-pull-request.png
:name: git-advanced-pull-request-new
Git new pull request
```

Amira's repository now shows a new pull request
([Figure: view Pull requests](git-advanced-pull-request-viewing)).
Clicking on the "Pull requests" tab brings up a list of PRs
([Figure: list pull requests](git-advanced-pull-request-list))
and clicking on the pull request link itself displays its details
([Figure: pull request details](git-advanced-pull-request-details)).
Sami and Amira can both see and interact with these pages,
though only Amira has permission to merge.

```{figure} ../figures/git-advanced/viewing-new-pull-request.png
:name: git-advanced-pull-request-viewing
View pull request
```

```{figure} ../figures/git-advanced/pr-list.png
:name: git-advanced-pull-request-list
Git pull request list
```

```{figure} ../figures/git-advanced/pr-details.png
:name: git-advanced-pull-request-details

Git pull request details
```

Since there are no conflicts,GitHub will let Amira merge the PR immediately using the "Merge pull request" button. She could also discard or reject it without merging using the "Close pull request" button. Instead,
she clicks on the "Files changed" tab to see what Sami has changed
([Figure: Pull request - request changes](git-advanced-pull-request-changes)).

```{figure} ../figures/git-advanced/pr-changes.png
:name: git-advanced-pull-request-changes
Pull request changes
```

If she moves her mouse over particular lines, a white-on-blue cross appears near the numbers to indicate that she can add comments
([Figure: Pull request - comment marker](git-advanced-pull-request-comment-marker)).
She clicks on the marker beside her own name and writes a comment:
She only wants to make one comment rather than write a lengthier multi-comment review, so she chooses "Add single comment" ([Figure: Pull request - write a comment](git-advanced-pull-request-write-comment)).
GitHub redisplays the page with her remarks inserted ([Figure: Pull Request with comment](git-advanced-pull-request-pr-with-comment)).


```{figure} ../figures/git-advanced/pr-comment-marker.png
:name: git-advanced-pull-request-comment-marker
Pull request comment marker
```

```{figure} ../figures/git-advanced/pr-writing-comment.png
:name: git-advanced-pull-request-write-comment
Pull request write a comment
```

```{figure} ../figures/git-advanced/pr-with-comment.png
:name: git-advanced-pull-request-pr-with-comment
Pull request with comment
```

While Amira is working, GitHub has been emailing notifications to both Sami and Amira. When Sami clicks on the link in their email notification, it takes them to the PR and shows Amira's comment. Sami changes `README.md`, commits, and pushes, but does *not* create a new pull request or do anything to the existing one.
As explained above, a PR is a note asking that two branches be merged,
so if either end of the merge changes, the PR updates automatically.

Sure enough, when Amira looks at the PR again a few moments later she sees Sami's changes ([Figure: Pull Request with fix](git-advanced-pull-request-pr-with-fix)).
Satisfied, she goes back to the "Conversation" tab and clicks on "Merge".
The icon at the top of the PR's page changes text and color to show that the merge was successful
([Figure: - Pull Request - succesfull merge](git-advanced-pull-request-successful-merge)).

```{figure} ../figures/git-advanced/pr-with-fix.png
:name: git-advanced-pull-request-pr-with-fix
Pull request with fix
```

```{figure} ../figures/git-advanced/pr-successful-merge.png
:name: git-advanced-pull-request-successful-merge
PR successful merge
```

To get those changes from GitHub to her desktop repository,
Amira uses `git pull`:

```bash
amira:~/zipf $ git pull origin master
```

```text
From https://github.com/amira-khan/zipf
 * branch            master     -> FETCH_HEAD
Updating 35fca86..a04e3b9
Fast-forward
 README.md | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
```

To get the change they just made from their `adding-email` branch into their `master` branch, Sami could use `git merge` on the command line. It's a little clearer, though, if they also use `git pull` from their `upstream` repository (i.e., Amira's repository) so that they're sure to get any other changes that Amira may have merged:

```bash
sami:~/zipf $ git checkout master
```

```text
Switched to branch 'master'
Your branch is up to date with 'origin/master'.
```

```bash
sami:~/zipf $ git pull upstream master
```

```text
From https://github.com/amira-khan/zipf
 * branch            master     -> FETCH_HEAD
Updating 35fca86..a04e3b9
Fast-forward
 README.md | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
```

Finally, Sami can push their changes back to the `master` branch
in their own remote repository:

```bash
sami:~/zipf $ git push origin master
```

```text
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
To https://github.com/sami-virtanen/zipf.git
   35fca86..a04e3b9  master -> master
```

All four repositories are now synchronized.

## Handling Conflicts in Pull Requests

Finally, suppose that Amira and Sami have decided to collaborate more extensively on this project. 
Amira has added Sami as a collaborator to the GitHub repository.
Now Sami can make contributions directly to the repository,
rather than via a pull request from a forked repository.

Sami makes a change to `README.md` in the `master` branch on GitHub.
Meanwhile, Amira is making a conflicting change to the same file in a different branch. When Amira creates her pull request, GitHub will detect the conflict and report that the PR cannot be merged automatically ([Figure: - Pull Request Conflict](git-advanced-pr-conflict)).

```{figure} ../figures/git-advanced/pr-conflict.png
:name: git-advanced-pr-conflict
Pull request conflict
```

Amira can solve this problem with the tools she already has.
If she has made her changes in a branch called `editing-readme`, the steps are:

1.  Pull Sami's changes from the `master` branch of the GitHub repository
    into the `master` branch of her desktop repository.

2.  Merge *from* the `master` branch of her desktop repository
    *to* the `editing-readme` branch in the same repository.

3.  Push her updated `editing-readme` branch to her repository on GitHub.
    The pull request from there back to the `master` branch of the main repository
    will update automatically.

GitHub and other forges do allow people to merge conflicts through their browser-based interfaces, but doing it on our desktop means we can use our favorite editor to resolve the conflict.
It also means that if the change affects the project's code,
we can run everything to make sure it still works.

But what if Sami or someone else merges another change while Amira is resolving this one, so that by the time she pushes to her repository there is another, different, conflict? In theory this cycle could go on forever;
in practice, it reveals a communication problem that Amira (or someone) needs to address. If two or more people are constantly making incompatible changes to the same files, they should discuss who's supposed to be doing what,
or rearrange the project's contents so that they aren't stepping on each other's toes.

## Summary 

Branches and pull requests seem complicated at first, but they quickly become second nature. Everyone involved in the project can work at their own pace on what they want to, picking up others' changes and submitting their own whenever they want. More importantly, this workflow gives everyone has a chance to review each other's work. As we discuss in Section *[Checking style](https://software-engineering-group-up.github.io/RSE-UP/chapters/clean_readable_code.html#checking-style),
doing reviews doesn't just prevent errors from creeping in:
it is also an effective way to spread understanding and skills.

## Keypoints

```{include} keypoints/git-advanced.md

```
