## Chapter Bash Advanced

### Exercise 1

```bash
$ cd ~/zipf
```
Change into the `zipf` directory,
which is located in the home directory (designated by `~`).

```bash
$ for file in $(find . -name "*.bak")
> do
>   rm $file
> done
```
Find all the files ending in `.bak` and remove them one by one.

```bash
$ rm bin/summarize_all_books.sh
```
Remove the `summarize_all_books.sh` script.

```bash
$ rm -r results
```
Recursively remove each file in the `results` directory
and then remove the directory itself.
(It is necessary to remove all the files first because you
cannot remove a non-empty directory.)

### Exercise 2

Running this script with the given parameters will print
the first and last line from each file in the directory ending in `.txt`.

1. No: This answer misinterprets the lines printed.
2. Yes.
3. No: This answer includes the wrong files.
4. No: Leaving off the quotation marks would result in an error.

### Exercise 3

One possible script (`longest.sh`) to accomplish this task:

```bash
# Shell script which takes two arguments:
#    1. a directory name
#    2. a file extension
# and prints the name of the file in that directory
# with the most lines which matches the file extension.
#
# Usage: bash longest.sh directory/ txt

wc -l $1/*.$2 | sort -n | tail -n 2 | head -n 1
```

### Exercise 4

1. `script1.sh` will print the names of all files in the directory on a single line,
e.g., `README.md dracula.txt frankenstein.txt jane_eyre.txt moby_dick.txt script1.sh sense_and_sensibility.txt sherlock_holmes.txt time_machine.txt`.
Although `*.txt` is included when running the script,
the commands run by the script do not reference `$1`.
2. `script2.sh` will print the contents of the first three files ending in `.txt`;
the three variables (`$1`, `$2`, `$3`) refer to the first, second, and third argument
entered after the script, respectively.
3. `script3.sh` will print the name of each file ending in `.txt`,
since `$@` refers to *all* the arguments (e.g., filenames) given to a shell script.
The list of files would be followed by `.txt`:
`dracula.txt frankenstein.txt jane_eyre.txt moby_dick.txt sense_and_sensibility.txt sherlock_holmes.txt time_machine.txt.txt`.

### Exercise 5

1. No: This command extracts any line containing "he", 
either as a word or within a word.
2. No: This results in the same output as the answer for #1.
`-E` allows the search term to represent an extended regular expression,
but the search term is simple enough that it doesn't make a difference in the result.
3. Yes: `-w` means to return only matches for the word "he".
4. No: `-i` means to invert the search result;
this would return all lines *except* the one we desire.

### Exercise 6

```bash
# Obtain unique years from multiple comma-delimited
# lists of titles and publication years
#
# Usage: bash year.sh file1.txt file2.txt ...

for filename in $*
do
  cut -d , -f 2 $filename | sort -n | uniq
done
```

### Exercise 7

One possible solution:

```bash
for sister in Elinor Marianne
do
	echo $sister:
	grep -o -w $sister sense_and_sensibility.txt | wc -l
done
```

The `-o` option prints only the matching part of a line.

An alternative (but possibly less accurate)
solution is:

```bash
for sister in Elinor Marianne
do
	echo $sister:
	grep -o -c -w $sister sense_and_sensibility.txt
done
```

This solution is potentially less accurate
because `grep -c` only reports the number of lines matched.
The total number of matches reported by this method
will be lower if there is more than one match per line.

### Exercise 8 

1. Yes: This returns `data/jane_eyre.txt`.
2. Maybe: This option may work on your computer,
but may not behave consistently across all shells 
because expansion of the wildcard (`*e.txt`) may prevent piping from working correctly.
We recommend enclosing `*e.txt` in quotation marks,
as in answer 1.
3. No: This searches the contents of files for lines matching "machine",
rather than the filenames.
4. See above.

### Exercise 9 

1. Find all files with a `.dat` extension recursively from the current directory.
2. Count the number of lines each of these files contains.
3. Sort the output from step 2 numerically.

### Exercise 10 

The following command works if your working directory is `Desktop/`
and you replace "username" with that of your current computer.
`-mtime` needs to be negative because it is referencing a day prior to the current date.

```bash
$ find . -type f -mtime -1 -user username
```
