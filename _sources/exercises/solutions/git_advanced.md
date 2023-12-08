## Chapter Git Advanced

### Exercise 1 

1.  `--oneline` shows each commit on a single line
    with the **short identifier** at the start
    and the title of the commit beside it.
    `-n NUMBER` limits the number of commits to show.

2.  `--since` and `--after` can be used to show commits
    in a range of dates or times;
    `--author` can be used to show commits by a particular person;
    and `-w` tells Git to ignore whitespace when comparing commits.

### Exercise 2 

An online search for "show Git branch in Bash prompt" turns up several approaches,
one of the simplest of which is to add this line to our `~/.bashrc` file:

```text
export PS1="\\w + \$(git branch 2>/dev/null | grep '^*' |
colrm 1 2) \$ "
```

Breaking it down:

1.  Setting the `PS1` variable defines the primary shell **prompt**.

1.  `\\w` in a shell prompt string means "the current directory."

1.  The `+` is a literal `+` sign between the current directory and the Git branch name.

1.  The command that gets the name of the current Git branch is in `$(...)`.
    (We need to escape the `$` as `\$` so Bash doesn't just run it once
    when defining the string.)

1.  The `git branch` command shows *all* the branches,
    so we pipe that to `grep` and select the one marked with a `*`.

1.  Finally, we remove the first column (i.e., the one containing the `*`)
    to leave just the branch name.

So what's `2>/dev/null` about?
That redirects any error messages to `/dev/null`,
a special "file" that consumes input without saving it.
We need that because sometimes we will be in a directory
that isn't inside a Git repository,
and we don't want error messages showing up in our shell prompt.

*None of this is obvious,*
and we didn't figure it out ourselves.
Instead,
we did a search and pasted various answers into [explainshell.com](http://explainshell.com)
until we had something we understood and trusted.

### Exercise 3 

<https://github.com/github/gitignore/blob/master/Python.gitignore>
ignores 76 files or patterns.
Of those,
we recognized less than half.
Searching online for some of these,
like `"*.pot file"`,
turns up useful explanations.
Searching for others like `var/` does not;
in that case,
we have to look at the category (in this case, "Python distribution")
and set aside time to do more reading.

### Exercise 4 

1.  `git diff master..same` does not print anything
    because there are no differences between the two branches.

2.  `git merge same master` prints `merging`
    because Git combines histories even when the files themselves do not differ.
    After running this command,
    `git history` shows a commit for the merge.

### Exercise 5

1.  Git refuses to delete a branch with unmerged commits
    because it doesn't want to destroy our work.

2.  Using the `-D` (capital-D) option to `git branch` will delete the branch anyway.
    This is dangerous because any content that exists only in that branch will be lost.

3.  Even with `-D`, `git branch` will not delete the branch we are currently on.

### Exercise 6 

1.  Chartreuse has repositories on GitHub and their desktop
    containing identical copies of `README.md` and nothing else.
2.  Fuchsia has repositories on GitHub and their desktop
    with exactly the same content as Chartreuse's repositories.
3.  `fuchsia.txt` is in both of Fuchsia's repositories
    but not in Chartreuse's repositories.
4.  `fuchsia.txt` is still in both of Fuchsia's repositories
    but still not in Chartreuse's repositories.
5.  `chartreuse.txt` is in both of Chartreuse's repositories
    but not yet in either of Fuchsia's repositories.
6.  `chartreuse.txt` is in Fuchsia's desktop repository
    but not yet in their GitHub repository.
7.  `chartreuse.txt` is in both of Fuchsia's repositories.
8.  `fuchsia.txt` is in Chartreuse's GitHub repository
    but not in their desktop repository.
9.  All four repositories contain both `fuchsia.txt` and `chartreuse.txt`.

