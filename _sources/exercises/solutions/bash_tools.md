
## Chapter Bash-Tools

### Exercise 1

`echo hello > testfile01.txt` writes the string "hello" to `testfile01.txt`,
but the file gets overwritten each time we run the command.

`echo hello >> testfile02.txt` writes "hello" to `testfile02.txt`,
but appends the string to the file if it already exists (i.e., when we run it for the second time).

### Exercise 2

1. No: This results from only running the first line of code (`head`).
2. No: This results from only running the second line of code (`tail`).
3. Yes: The first line writes the first three lines of `dracula.txt`,
the second line appends the last two lines of `dracula.txt` to the same file.
4. No: We would need to pipe the commands to obtain this answer (`head -n 3 dracula.txt | tail -n 2 > extracted.txt`).

### Exercise 3

Try running each line of code in the `data` directory.

1. No: This incorrectly uses redirect (`>`), 
and will result in an error.
2. No: The number of lines desired for `head` is reported incorrectly;
this will result in an error.
3. No: This will extract the first three files from the `wc` results,
which have not yet been sorted into length of lines.
4. Yes: This output correctly orders and connects each of the commands.

### Exercise 4

To obtain a list of unique results from these data,
we need to run:

```bash
$ sort genres.txt | uniq
```

It makes sense that `uniq` is almost always run after using `sort`,
because that allows a computer to compare only adjacent lines.
If `uniq` did not compare only adjacent lines,
it would require comparing each line to all other lines.
For a small set of comparisons,
this doesn't matter much,
but this isn't always possible for large files.

### Exercise 5

When used on a single file,
`cat` prints the contents of that file to the screen.
In this case,
the contents of `titles.txt` are sent as input to `head -n 5`,
so the first five lines of `titles.txt` is output.
These five lines are used as the input for `tail -n 3`,
which results in lines 3--5 as output.
This is used as input to the final command,
which sorts them in reverse order.
These results are written to the file `final.txt`,
the contents of which are:

```text
Sense and Sensibility,1811
Moby Dick,1851
Jane Eyre,1847
```

### Exercise 6

`cut` selects substrings from a line by:

-   breaking the string into pieces wherever it finds a separator (`-d ,`),
which in this case is a comma, and
-   keeping one or more of the resulting fields/columns (`-f 2`).

In this case, 
the output is only the dates from `titles.txt`,
since this is in the second column.

```bash
$ cut -d , -f 2 titles.txt
```

```text
1897
1818
1847
1851
1811
1892
1897
1895
1847
```

### Exercise 7 

1. No: This sorts by the book title.
2. No: This results in an error because `sort` is being used incorrectly.
3. No: There are duplicate dates in the output because they have not been sorted first.
4. Yes: This results in the output shown below.
5. No: This extracts the desired data (below), 
but then counts the number of lines,
resulting in the incorrect answer.

```text
   1 1811
   1 1818
   2 1847
   1 1851
   1 1892
   1 1895
   2 1897
```

If you have difficulty understanding the answers above,
try running the commands or sub-sections of the pipelines
(e.g., the code between pipes).

### Exercise 8

The difference between the versions is whether the code after `echo`
is inside quotation marks.

The first version redirects the output from `echo analyze $file` 
to a file (`analyzed-$file`). 
This doesn't allow us to preview the commands,
but instead creates files (`analyzed-$file`)
containing the text `analyze $file`.

The second version will allow us to preview the commands.
This prints to screen everything enclosed in the quotation marks,
expanding the loop variable name (prefixed with `$`).

Try both versions for yourself to see the output. Be sure to open the
`analyzed-*` files to view their contents.

### Exercise 9

The first version gives the same output on each iteration through
the loop.
Bash expands the wildcard `*.txt` to match all files ending in `.txt`
and then lists them using `ls`.
The expanded loop would look like this
(we'll only show the first two data files):

```bash
$ for datafile in dracula.txt  frankenstein.txt ...
> do
>	ls dracula.txt  frankenstein.txt ...
```

```text
dracula.txt  frankenstein.txt ...
dracula.txt  frankenstein.txt ...
...
```

The second version lists a different file on each loop iteration.
The value of the `datafile` variable is evaluated using `$datafile`,
and then listed using `ls`.

```text
dracula.txt
frankenstein.txt
jane_eyre.txt
moby_dick.txt
sense_and_sensibility.txt
sherlock_holmes.txt
time_machine.txt
```

### Exercise 10

The first version results in only `dracula.txt` output, 
because it is the only file beginning in "d".

The second version results in the following,
because these files all contain a "d" with zero or more characters before and after:

```text
README.md
dracula.txt
moby_dick.txt
sense_and_sensibility.txt
```

### Exercise 11 

Both versions write the first 16 lines (`head -n 16`) 
of each book to a file (`headers.txt`).

The first version results in the text from each file being overwritten in each iteration
because of use of `>` as a redirect.

The second version uses `>>`,
which appends the lines to the existing file.
This is preferable because the final `headers.txt` 
includes the first 16 lines from all files.

### Exercise 12

If a command causes something to crash or hang, it might be useful
to know what that command was, in order to investigate the problem.
Were the command only be recorded after running it, we would not
have a record of the last command run in the event of a crash.


