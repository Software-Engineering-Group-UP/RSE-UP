
## Chapter Bash Basics 

### Exercise 1


The `-l` option makes `ls` use a **l**ong listing format, showing not only
the file/directory names but also additional information such as the file size
and the time of its last modification. If you use both the `-h` option and the `-l` option,
this makes the file size "**h**uman readable", i.e., displaying something like `5.3K`
instead of `5369`.

### Exercise 2

The command `ls -R -t` results in the contents of 
each directory sorted by time of last change.

### Exercise 3

1. No: `.` stands for the current directory.
2. No: `/` stands for the root directory.
3. No: Amira's home directory is `/Users/Amira`.
4. No: This goes up two levels, i.e., ends in `/Users`.
5. Yes: `~` stands for the user's home directory, in this case `/Users/amira`.
6. No: This would navigate into a directory `home` in the current directory if it exists.
7. Yes: Starting from the home directory `~`, this command goes into `data` then back (using `..`) to the home directory.
8. Yes: Shortcut to go back to the user's home directory.
9. Yes: Goes up one level.
10. Yes: Same as the previous answer, but with an unnecessary `.` (indicating the current directory).

### Exercise 4

1. No: There *is* a directory `backup` in `/Users`.
2. No: This is the content of `Users/sami/backup`,
   but with `..` we asked for one level further up.
3. No: Same as previous explanation, but results shown as directories
   (which is what the `-F` option specifies).
4. Yes: `../backup/` refers to `/Users/backup/`.

### Exercise 5

 1. No: `pwd` is not the name of a directory.
 2. Yes: `ls` without directory argument lists files and directories
    in the current directory.
 3. Yes: Uses the absolute path explicitly.

### Exercise 6

The `touch` command updates a file's timestamp.
If no file exists with the given name, `touch` will create one.
Assuming you don't already have `my_file.txt` in your working directory,
`touch my_file.txt` will create the file.
When you inspect the file with `ls -l`, note that the size of
`my_file.txt` is 0 bytes.  In other words, it contains no data.
If you open `my_file.txt` using your text editor, it is blank.


Some programs do not generate output files themselves, but
instead require that empty files have already been generated.
When the program is run, it searches for an existing file to
populate with its output.  The touch command allows you to
efficiently generate a blank text file to be used by such
programs.

### Exercise 7

```bash
$ remove my_file.txt? y
```

The `-i` option will prompt before (every) removal
(use <kbd>y</kbd> to confirm deletion or <kbd>n</kbd> to keep the file).
The Unix shell doesn't have a trash bin, so all the files removed will disappear forever.
By using the `-i` option, we have the chance to check that we are deleting
only the files that we want to remove.

### Exercise 8

```bash
$ mv ../data/chapter1.txt ../data/chapter2.txt .
```

Recall that `..` refers to the parent directory (i.e., one above the current directory)
and that `.` refers to the current directory.

### Exercise 9

1. No: While this would create a file with the correct name,
the incorrectly named file still exists in the directory and would need to be deleted.
2. Yes: This would work to rename the file.
3. No: The period (`.`) indicates where to move the file, but does not provide a new filename;
identical filenames cannot be created.
4. No: The period (`.`) indicates where to copy the file, but does not provide a new filename;
identical filenames cannot be created.

### Exercise 10

We start in the `/Users/amira/data` directory, 
containing a single file, `books.dat`.
We create a new folder called `doc`
and move (`mv`) the file `books.dat` to that new folder.
Then we make a copy (`cp`) of the file we just moved named `books-saved.dat`.  

The tricky part here is the location of the copied file.
Recall that `..` means "go up a level," so the copied file is now in `/Users/amira`.
Notice that `..` is interpreted with respect to the current working
directory, **not** with respect to the location of the file being copied.
So, the only thing that will show using ls (in `/Users/amira/data`) is the `doc` folder.

1. No: `books-saved.dat` is located at `/Users/amira`
2. Yes.
3. No: `books.dat` is located at `/Users/amira/data/doc`
4. No: `books-saved.dat` is located at `/Users/amira`

### Exercise 11

If given more than one filename followed by a directory name (i.e., the destination directory must
be the last argument), `cp` copies the files to the named directory.

If given three filenames, 
`cp` throws an error because it is expecting a directory name as the last argument.

### Exercise 12

1. Yes: Shows all files whose names contain two different characters (`?`) 
followed by the letter `n`,
then zero or more characters (`*`) followed by `txt`.

2. No: Shows all files whose names start with zero or more characters (`*`) 
followed by `e_`,
zero or more characters (`*`), 
then `txt`. 
The output includes the two desired books, but also `time_machine.txt`.

3. No: Shows all files whose names start with zero or more characters (`*`) 
followed by `n`,
zero or more characters (`*`), 
then `txt`. 
The output includes the two desired books, 
but also `frankenstein.txt` and `time_machine.txt`.

4. No: Shows all files whose names start with zero or more characters (`*`) 
followed by `n`,
a single character `?`,
`e`,
zero or more characters (`*`), 
then `txt`. 
The output shows `frankenstein.txt` and `sense_and_sensibility.txt`.

### Exercise 13

```bash
$ mv *.txt data
```

Amira needs to move her files `books.txt` and `titles.txt` to the `data` directory.
The shell will expand `*.txt` to match all `.txt` files in the current directory.
The `mv` command then moves the list of `.txt` files to the `data` directory.

### Exercise 14

1. Yes: This accurately re-creates the directory structure.

2. Yes: This accurately re-creates the directory structure.

3. No: The first line of this code set gives an error:

   ```text
   mkdir: 2016-05-20/data: No such file or directory
   ```
   `mkdir` won't create a subdirectory for a directory that doesn't yet exist 
   (unless you use an option like `-p` that explicitly creates parent directories).

4. No: This creates `raw` and `processed` directories at the same level as `data`:

   ```text
   2016-05-20/
       ├── data
       ├── processed
       └── raw
   ```

### Exercise 15

1. A solution using two wildcard expressions:

    ```bash
    $ ls s*.txt
    $ ls t*.txt
    ```

2. When there are no files beginning with `s` and ending in `.txt`, 
or when there are no files beginning with `t` and ending in `.txt`. 


### Exercise 16

1. No: This would remove only `.csv` files with one-character names.
2. Yes: This removes only files ending in `.csv`.
3. No: The shell would expand `*` to match everything in the current directory,
so the command would try to remove all matched files and an additional
file called `.csv`.
4. No: The shell would expand `*.*` to match all files with any extension,
so this command would delete all files in the current directory.

### Exercise 17

`novel-????-[ab]*.{txt,pdf}` matches:

-   Files whose names start with `novel-`,
-   which is then followed by exactly four characters
    (since each `?` matches one character),
-   followed by another literal `-`,
-   followed by either the letter `a` or the letter `b`,
-   followed by zero or more other characters (the `*`),
-   followed by `.txt` or `.pdf`.

