
## Chapter Introduction to Version Control 

### Exercise 1

Amira does not need to make the `heaps-law` subdirectory a Git repository
because the `zipf` repository will track everything inside it regardless of how deeply nested.

Amira *shouldn't* run `git init` in `heaps-law` because nested Git repositories can interfere with each other.
If someone commits something in the inner repository,
Git will not know whether to record the changes in that repository,
the outer one,
or both.

### Exercise 2

`git status` now shows:

```text
On branch master
Untracked files:
  (use "git add <file>..." to include in what will be committed)
	example.txt

nothing added to commit but untracked files present
(use "git add" to track)
```

Nothing has happened to the file;
it still exists but Git no longer has it in the staging area.
`git rm --cached` is equivalent to `git restore --staged`.
With newer versions of Git,
older commands will still work,
and you may encounter references to them when reading help documentation.
If you created this file in your `zipf` project,
we recommend removing it before proceeding.

### Exercise 3

If we make a few changes to `.gitignore` such that it now reads:

```text
__pycache__ this is a change

this is another change
```

then `git diff` would show:

```diff
diff --git a/.gitignore b/.gitignore
index bee8a64..5c83419 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1 +1,3 @@
-__pycache__
+__pycache__ this is a change
+
+this is another change
```

Whereas `git diff --word-diff` shows:

```diff
diff --git a/.gitignore b/.gitignore
index bee8a64..5c83419 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1 +1,3 @@
__pycache__ {+this is a change+}

{+this is another change+}
```

Depending on the nature of the changes you are viewing,
the latter may be easier to interpret 
since it shows exactly what has been
changed.

### Exercise 4

1.  Maybe: would only create a commit if the file has already been staged.
2.  No: would try to create a new repository,
which results in an error if a repository already exists.
3.  Yes: first adds the file to the staging area, then commits.
4.  No: would result in an error,
as it would try to commit a file "my recent changes" with the message "myfile.txt."

### Exercise 5

1.  Go into your home directory with `cd ~`.
2.  Create a new folder called `bio` with `mkdir bio`.
3.  Make the repository your working directory with `cd bio`.
4.  Turn it into a repository with `git init`.
5.  Create your biography using `nano` or another text editor.
6.  Add it and commit it in a single step with `git commit -a -m "Some message"`.
7.  Modify the file.
8.  Use `git diff` to see the differences.

### Exercise 6

1.  Create `employment.txt` using an editor like Nano.
2.  Add both `me.txt` and `employment.txt` to the staging area with `git add *.txt`.
3.  Check that both files are there with `git status`.
4.  Commit both files at once with `git commit`.

### Exercise 7 

GitHub displays timestamps in a human-readable relative format
(i.e., "22 hours ago" or "three weeks ago"),
since this makes it easy for anyone in any time zone
to know what changes have been made recently.
However, if we hover over the timestamp
we can see the exact time at which the last change to the file occurred.

### Exercise 8 

The answer is 1.

The command `git add motivation.txt` adds the current version of `motivation.txt` to the staging area.
The changes to the file from the second `echo` command are only applied to the working copy,
not the version in the staging area.

As a result,
when `git commit -m "Motivate project"` is executed,
the version of `motivation.txt` committed to the repository is the content from the first `echo`.

However,
the working copy still has the output from the second `echo`;
`git status` would show that the file is modified.
`git restore HEAD motivation.txt` therefore replaces the working copy with
the most recently committed version of `motivation.txt`
(the content of the first `echo`),
so `cat motivation.txt` prints:

```text
Zipf's Law describes the relationship between the frequency and
rarity of words.
```

### Exercise 10

Add this line to `.gitignore`:

```text
results/plots/
```

### Exercise 11

Add the following two lines to `.gitignore`:

```text
*.dat           # ignore all data files
!final.dat      # except final.data
```

The exclamation point `!` includes a previously excluded entry.

Note also that if we have previously committed `.dat` files in this repository,
they will not be ignored once these rules are added to `.gitignore`.
Only future `.dat` files will be ignored.

### Exercise 12

The left button (with the picture of a clipboard)
copies the full identifier of the commit to the clipboard.
In the shell,
`git log` shows the full commit identifier for each commit.

The middle button (with seven letters and numbers)
shows all of the changes that were made in that particular commit;
green shaded lines indicate additions and red lines indicate removals.
We can show the same thing in the shell using `git diff`
or `git diff FROM..TO`
(where `FROM` and `TO` are commit identifiers).

The right button lets us view all of the files in the repository at the time of that commit.
To do this in the shell,
we would need to check out the repository as it was at that commit
using `git checkout ID`, where `ID` is the tag, branch name, or commit identifier.
If we do this,
we need to remember to put the repository back to the right state afterward.

### Exercise 13

Committing updates our local repository.
Pushing sends any commits we have made locally
that aren't yet in the remote repository
to the remote repository.

### Exercise 14

When GitHub creates a `README.md` file while setting up a new repository,
it actually creates the repository and then commits the `README.md` file.
When we try to pull from the remote repository to our local repository,
Git detects that their histories do not share a common origin and refuses to merge them.

```bash
$ git pull origin master
```

```text
warning: no common commits
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (3/3), done.
From https://github.com/frances/eniac
 * branch            master     -> FETCH_HEAD
 * [new branch]      master     -> origin/master
fatal: refusing to merge unrelated histories
```

We can force Git to merge the two repositories with the option `--allow-unrelated-histories`.
Please check the contents of the local and remote repositories carefully before doing this.

### Exercise 15

The `checkout` command restores files from the repository,
overwriting the files in our working directory.
`HEAD` indicates the latest version.

1. No: this can be dangerous;
without a filename,
`git checkout` will restore all files in the current directory (and all directories below it)
to their state at the commit specified.
This command will restore `data_cruncher.sh` to the latest commit version,
but will also reset any other files we have changed to that version,
which will erase any unsaved changes you may have made to those files.
2. Yes: this restores the latest version of only the desired file.
3. No: this gets the version of `data_cruncher.sh` from the commit before `HEAD`,
which is not what we want.
4. Yes: the unique ID (identifier) of the last commit is what `HEAD` means.
5. Yes: this is equivalent to the answer to 2.
6. No: `git restore` assumes `HEAD`,
so Git will assume you're trying to restore a file called `HEAD`,
resulting in an error.

### Exercise 16 

1. Compares what has changed between the
current `bin/plotcounts.py` and the same file nine commits ago.
2.  It returns an error: 
`fatal: ambiguous argument 'HEAD~9': unknown revision or path not in the working tree.`
We don't have enough commits in history for the command to properly execute.
3.  It compares changes (either staged or unstaged)
to the most recent commit.

### Exercise 17

No, using `git checkout` on a staged file does not unstage it.
The changes are in the staging area and checkout would affect
the working directory.

### Exercise 18

Each line of output corresponds to a line in the file, 
and includes the commit identifier,
who last modified the line,
when that change was made,
and what is included on that line.
Note that the edit you just committed is not present here;
`git blame` only shows the current lines in the file,
and doesn't report on lines that have been removed.

