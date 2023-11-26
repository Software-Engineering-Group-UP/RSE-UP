# The Basics of the Unix Shell 

> Ninety percent of most magic merely consists of knowing one extra fact.
>
> --- Terry Pratchett

Computers do four basic things: store data, run programs,
talk with each other, and interact with people.
They do the interacting in many different ways, of which **graphical user interfaces** (GUIs) are the most widely used.
The computer displays icons to show our files and programs,
and we tell it to copy or run those by clicking with a mouse.
GUIs are easy to learn but hard to automate,
and don't create a record of what we did.

In contrast,
when we use a **command-line interface** (CLI) we communicate with the computer by typing commands,and the computer responds by displaying text.
CLIs existed long before GUIs; they have survived because they are efficient,
easy to automate, and automatically record what we have done.

The heart of every CLI is a **read-evaluate-print loop** (REPL). 
When we type a command and press <kbd>Return</kbd> (also called <kbd>Enter</kbd>)

the CLI **r**eads the command,
**e**valuates it (i.e., executes it),
**p**rints the command's output,
and **l**oops around to wait for another command.
If you have used an interactive console for Python,
you have already used a simple CLI.

This lesson introduces another CLI that lets us interact with our computer's operating system.
It is called a "command shell",
or just **shell** for short, and in essence is a program that runs other programs on our behalf.
Those "other programs" can do things as simple as telling us the time
or as complex as modeling global climate change;
as long as they obey a few simple rules,
the shell can run them without having to know what language they are written in
or how they do what they do.

```{figure} ../../figures/bash-basics/the-shell.png
:name: the_shell

The Shell
```

> **What's in a Name?**
>
> Programmers have written many different shells over the last forty years,
> just as they have created many different text editors and plotting packages.
> The most popular shell today is called Bash\index{Bash}\index{Unix shell!Bash}
> (an acronym of **B**ourne **A**gain **SH**ell,
> and a weak pun on the name of its predecessor,
> the Bourne shell).
> Other shells may differ from Bash in minor ways,
> but the core commands and ideas remain the same.
> In particular, the most recent versions of MacOS use a shell called the Z Shell or `zsh`;
> we will point out a few differences as we go along.

Please see Section [getting started](https://software-engineering-group-up.github.io/RSE-UP/chapters/getting_started/etting_started.html#downloading-the-data) for instructions
on how to install and launch the shell on your computer.

## Exploring Files and Directories 

Our first shell commands will let us explore our folders and files,
and will also introduce us to several conventions that most Unix tools follow.
To start,
when Bash runs it presents us with a **prompt** to indicate that it is waiting for us to type something. This prompt is a simple dollar sign by default:

```bash
$
```

However, different shells may use a different symbol: in particular,
the `zsh` shell, which is the default on newer versions of MacOS, uses `%`.
As we'll see in Section **TODO**ref(bash-advanced-vars), we can customize the prompt to give us more information.

> **Don't Type the Dollar Sign**
>
> We show the `$` prompt so that it's clear what you are supposed to type,
> particularly when several commands appear in a row,
> but you should *not* type it yourself.

Let's run a command to find out who the shell thinks we are:

```bash
$ whoami
```

```text
amira
```

> **Learn by Doing**
> 
> Amira is one of the learners described in Section [intended audience](https://software-engineering-group-up.github.io/RSE-UP/chapters/introduction.html#intended-audience). 
> For the rest of the book,
> we'll present code and examples from her perspective.
> You should follow along on your own computer,
> though what you see might deviate in small ways because of differences in operating system
> (and because your name probably isn't Amira).

Now that we know who we are,
we can explore where we are and what we have.
The part of the operating system that manages files and directories (also called **folders**
is called the **filesystem**.
Some of the most commonly used commands in the shell create, inspect, rename, and delete files and directories.
Let's start exploring them by running the command `pwd`, which stands for **p**rint **w**orking **d**irectory.
The "print" part of its name is straightforward;
the "working directory" part refers to the fact that
the shell keeps track of our **current working directory** at all times. Most commands read and write files in the current working directory unless we tell them to do something else, so knowing where we are before running a command is important.

```bash
$ pwd
```

```text
/Users/amira
```

Here, the computer's response is `/Users/amira`,
which tells us that we are in a directory called `amira`
that is contained in a top-level directory called `Users`.
This directory is Amira's **home directory** to understand what that means,
we must first understand how the filesystem is organized.
On Amira's computer the bash_basic_filesystem looks as follows:


```{figure} ../../figures/bash-basics/sample-filesystem.png
:name: bash_basic_filesystem

Bash basic filesystem
```

At the top is the **root directory** that holds everything else, which we can refer to using a slash character `/` on its own.
Inside that directory are several other directories,
including `bin` (where some built-in programs are stored),
`data` (for miscellaneous data files),
`tmp` (for temporary files that don't need to be stored long-term),
and `Users` (where users' personal directories are located).
We know that `/Users` is stored inside the root directory `/` because its name begins with `/`,
and that our current working directory `/Users/amira` is stored inside `/Users`
because `/Users` is the first part of its name.
A name like this is called a **path** because it tells us how to get from one place in the filesystem (e.g., the root directory)
to another (e.g., Amira's home directory).

> **Slashes**
>
> The `/` character means two different things in a path.
> At the front of a path or on its own,
> it refers to the root directory.
> When it appears inside a name, it is a separator.
> Windows uses backslashes (`\\`) instead of forward slashes as separators.

Underneath `/Users`,
we find one directory for each user with an account on this machine.
Jun's files are stored in `/Users/jun`,
Sami's in `/Users/sami`,
and Amira's in `/Users/amira`.
This is where the name "home directory" comes from:
when we first log in,
the shell puts us in the directory that holds our files.

> **Home Directory Variations**
>
> Our home directory will be in different places on different operating systems.
> On Linux it may be `/home/amira`,
> and on Windows it may be `C:\Documents and Settings\amira` or `C:\Users\amira`
> (depending on the version of Windows).
> Our examples show what we would see on MacOS.

Now that we know where we are,
let's see what we have using the command `ls` short for "listing",
which prints the names of the files and directories in the current directory:

```bash
$ ls
```

```text
Applications   Downloads     Music        todo.txt
Desktop        Library       Pictures     zipf
Documents      Movies        Public       
```

Again,
our results may be different depending on our operating system
and what files or directories we have.

We can make the output of `ls` more informative using the `-F` **option**, also sometimes called a **switch** or a **flag**. 
Options are exactly like arguments to a function in Python; in this case,
`-F` tells `ls` to decorate its output to show what things are.
A trailing `/` indicates a directory,
while a trailing `*` tells us something is a runnable program.
Depending on our setup,
the shell might also use colors to indicate whether each entry is a file or directory.

```bash
$ ls -F
```

```text
Applications/   Downloads/     Music/        todo.txt
Desktop/        Library/       Pictures/     zipf/
Documents/      Movies/        Public/       
```

Here,
we can see that almost everything in our home directory is a **subdirectory**the only thing that isn't is a file called `todo.txt`.

> **Spaces Matter**
>
> `1+2` and `1 + 2` mean the same thing in mathematics,
> but `ls -F` and `ls-F` are very different things in the shell.
> The shell splits whatever we type into pieces based on spaces,
> so if we forget to separate `ls` and `-F` with at least one space,
> the shell will try to find a program called `ls-F` and (quite sensibly)
> give an error message like `ls-F: command not found`.

Some options tell a command how to behave,
but others tell it what to act on.
For example,
if we want to see what's in the `/Users` directory,
we can type:

```bash
$ ls /Users
```

```text
amira   jun     sami
```

We often call the file and directory names that we give to commands **arguments
to distinguish them from the built-in options. We can combine options and arguments:

```bash
$ ls -F /Users
```

```text
amira/  jun/    sami/
```

but we must put the options (like `-F`)
before the names of any files or directories we want to work on,
because once the command encounters something that *isn't* an option
it assumes there aren't any more:

```bash
$ ls /Users -F
```

```text
ls: -F: No such file or directory
amira   jun     sami
```

> **Command Line Differences**
>
> Code can sometimes behave in unexpected ways on different computers,
> and this applies to the command line as well.
> For example,
> the following code actually *does* work on some Linux operating systems:
>
> ```bash
> $ ls /Users -F
> ```
>
> Some people think this is convenient;
> others (including us) believe it is confusing,
> so it's best to avoid doing this.

## Moving Around

Let's run `ls` again.
Without any arguments,
it shows us what's in our current working directory:

```bash
$ ls -F
```

```text
Applications/   Downloads/     Music/        todo.txt
Desktop/        Library/       Pictures/     zipf/
Documents/      Movies/        Public/       
```

If we want to see what's in the `zipf` directory
we can ask `ls` to list its contents:

```bash
$ ls -F zipf
```

```text
data/
```

Notice that `zipf` doesn't have a leading slash before its name.
This absence tells the shell that it is a **relative path** i.e.,
that it identifies something starting from our current working directory.
In contrast,
a path like `/Users/amira` is an **absolute path** it is always interpreted from the root directory down, so it always refers to the same thing.
Using a relative path is like telling someone to go two kilometers north and then half a kilometer east;
using an absolute path is like giving them the latitude and longitude of their destination.

We can use whichever kind of path is easiest to type,
but if we are going to do a lot of work with the data in the `zipf` directory,
the easiest thing would be to change our current working directory
so that we don't have to type `zipf` over and over again.
The command to do this is `cd`, which stands for **c**hange **d**irectory.
This name is a bit misleading because the command doesn't change the directory;
instead, it changes the shell's idea of what directory we are in.
Let's try it out:

```bash
$ cd zipf
```

`cd` doesn't print anything.
This is normal:
many shell commands run silently unless something goes wrong,
on the theory that they should only ask for our attention when they need it.
To confirm that `cd` has done what we asked,
we can use `pwd`:

```bash
$ pwd
```

```text
/Users/amira/zipf
```

```bash
$ ls -F
```

```text
data/
```

> **Missing Directories and Unknown Options**
>
> If we give a command an option that it doesn't understand,
> it will usually print an error message, and (if we're lucky)
> tersely remind us of what we should have done:
>
> ```bash
> $ cd -j
> ``` 
>
> ```text
> -bash: cd: -j: invalid option
> cd: usage: cd [-L|-P] [dir]
> ```
>
> On the other hand,
> if we get the syntax right but make a mistake in the name of a file or directory,
> it will tell us that:
>
> ```bash
> $ cd whoops
> ```
>
> ```text
> -bash: cd: whoops: No such file or directory
> ```

We now know how to go down the directory tree,
but how do we go up?
This doesn't work:

```bash
$ cd amira
```

```text
cd: amira: No such file or directory
```

because `amira` on its own is a relative path meaning
"a file or directory called `amira` *below our current working directory.*"
To get back home,
we can either use an absolute path:

```bash
$ cd /Users/amira
```

or a special relative path called `..` (two periods in a row with no spaces),which always means "the directory that contains the current one."
The directory that contains the one we are in is called the **parent directory**and sure enough,
`..` gets us there:

```bash
$ cd ..
$ pwd
```

```text
/Users/amira
```

`ls` usually doesn't show us this special directory---since it's always there,
displaying it every time would be a distraction.
We can ask `ls` to include it using the `-a` option,
which stands for "all".
Remembering that we are now in `/Users/amira`:

```bash
$ ls -F -a
```

```text
./              Documents/     Music/        zipf/
../             Downloads/     Pictures/     
Applications/   Library/       Public/ 
Desktop/        Movies/        todo.txt
```

The output also shows another special directory called `.` (a single period),
which refers to the current working directory.
It may seem redundant to have a name for it,
but we'll see some uses for it soon.

> **Combining Options**
>
> You'll occasionally need to use multiple options in the same command.
> In most command-line tools,
> multiple options can be combined with a single `-`
> and no spaces between the options:
>
> ```bash
> $ ls -Fa
> ```
>
> This command is synonymous with the previous example.
> While you may see commands written like this,
> we don't recommend you use this approach in your own work.
> This is because some commands take **long options**
> with multi-letter names, and it's very easy to mistake `--no` 
> (meaning "answer 'no' to all questions")
> with `-no` (meaning `-n -o`).

The special names `.` and `..` don't belong to `cd`:
they mean the same thing to every program.
For example,
if we are in `/Users/amira/zipf`,
then `ls ..` will display a listing of `/Users/amira`.
When the meanings of the parts are the same no matter how they're combined,
programmers say they are **orthogonal**.
*NOTE* The ability to use various features of software in any order or combination
Orthogonal systems tend to be easier for people to learn
because there are fewer special cases to remember.

> **Other Hidden Files**
>
> In addition to the hidden directories `..` and `.`,
> we may also come across files with names like `.jupyter`.
> These usually contain settings or other data for particular programs;
> the prefix `.` is used to prevent `ls` from cluttering up the output
> when we run `ls`.
> We can always use the `-a` option to display them.

`cd` is a simple command,
but it allows us to explore several new ideas.
First,
several `..` can be joined by the path separator
to move higher than the parent directory in a single step.
For example, `cd ../..` will move us up two directories
(e.g., from `/Users/amira/zipf` to `/Users`),
while `cd ../Movies` will move us up from `zipf` and back down into `Movies`.

What happens if we type `cd` on its own without giving a directory?

```bash
$ pwd
```

```text
/Users/amira/Movies
```

```bash
$ cd
$ pwd
```

```text
/Users/amira
```

No matter where we are,
`cd` on its own always returns us to our home directory.
We can achieve the same thing using the special directory name `~`, which is a shortcut for our **home directory**:

```bash
$ ls ~
```

```text
Applications   Downloads     Music        todo.txt
Desktop        Library       Pictures     zipf
Documents      Movies        Public       
```


(`ls` doesn't show any trailing slashes here because we haven't used `-F`.)
We can use `~` in paths,
so that (for example) `~/Downloads` always refers to our download directory.

Finally,
`cd` interprets the shortcut `-` (a single dash) to mean the last directory we were in.
Using this is usually faster and more reliable than trying to remember and type the path,
but unlike `~`,
it only works with `cd`:
`ls -` tries to print a listing of a directory called `-`
rather than showing us the contents of our previous directory.

## Creating New Files and Directories

We now know how to explore files and directories,
but how do we create them?
To find out,
let's go back to our `zipf` directory:

```bash
$ cd ~/zipf
$ ls -F
```

```text
data/
```

To create a new directory,
we use the command `mkdir` (short for **m**a**k**e **d**irectory):

```bash
$ mkdir docs
```

Since `docs` is a relative path
(i.e., does not have a leading slash)
the new directory is created below the current working directory:

```bash
$ ls -F
```

```text
data/  docs/
```

Using the shell to create a directory is no different than using a graphical tool.
If we look at the current directory with our computer's file browser
we will see the `docs` directory there too.
The shell and the file explorer are two different ways of interacting with the files;
the files and directories themselves are the same.

> **Naming Files and Directories**
>
> Complicated names of files and directories can make our life painful.
> Following a few simple rules can save a lot of headaches:\index{filesystem!naming conventions}\index{naming conventions!filesystem}
>
> 1. **Don't use spaces.**
>    Spaces can make a name easier to read,
>    but since they are used to separate arguments on the command line,
>    most shell commands interpret a name like `My Thesis` as two names `My` and `Thesis`.
>    Use `-` or `_` instead,
>    e.g., `My-Thesis` or `My_Thesis`.
>
> 2. **Don't begin the name with `-` (dash)**
>    to avoid confusion with command options like `-F`.
>
> 3. **Stick with letters, digits, `.` (period or 'full stop'), `-` (dash) and `_` (underscore).**
>    Many other characters mean special things in the shell.
>    We will learn about some of those special characters during this lesson,
>    but the characters cited here are always safe.
>
> If we need to refer to files or directories that have spaces or other special characters in their names,
> we can surround the name in quotes (`""`).
> For example, `ls "My Thesis"` will work where `ls My Thesis` does not.

Since we just created the `docs` directory,
`ls` doesn't display anything when we ask for a listing of its contents:

```bash
$ ls -F docs
```

Let's change our working directory to `docs` using `cd`,
then use a very simple text editor called **nano** to create a file called `draft.txt` nano_editor :

```bash
$ cd docs
$ nano draft.txt
```

```{figure} ../../figures/bash-basics/nano-editor.png
:name: nano_editor

Nano Editor
```

When we say "Nano is a text editor" we really do mean "text":
it can only work with plain character data,
not spreadsheets, images, Microsoft Word files, or anything else invented after 1970.
We use it in this lesson because it runs everywhere,
and because it is as simple as something can be and still be called an editor.
However,
that last trait means that we *shouldn't* use it for larger tasks
like writing a program or a paper.

> **Recycling Pixels**
>
> Unlike most modern editors,
> Nano runs *inside* the shell window instead of opening a new window of its own.
> This is a holdover from an era when graphical terminals were a rarity
> and different applications had to share a single screen.

Once Nano is open we can type in a few lines of text,
then press <kbd>Ctrl</kbd>+<kbd>O</kbd>
(the Control key and the letter 'O' at the same time)
to save our work.
Nano will ask us what file we want to save it to;
press <kbd>Return</kbd> to accept the suggested default of `draft.txt`.
Once our file is saved,
we can use <kbd>Ctrl</kbd>+<kbd>X</kbd> to exit the editor and return to the shell.

> **Control, Ctrl, or ^ Key**
>
> The Control key,
> also called the "Ctrl" key,
> can be described in a bewildering variety of ways.
> For example,
> <kbd>Control</kbd> plus <kbd>X</kbd> may be written as:
>
> -   `Control-X`
> -   `Control+X`
> -   `Ctrl-X`
> -   `Ctrl+X`
> -   `C-x`
> -   `^X`
>
> When Nano runs,
> it displays some help in the bottom two lines of the screen
> using the last of these notations:
> for example,
> `^G Get Help` means "use <kbd>Ctrl</kbd>+<kbd>G</kbd> to get help"
> and `^O WriteOut` means "use <kbd>Ctrl</kbd>+<kbd>O</kbd> to write out the current file."

Nano doesn't leave any output on the screen after it exits,
but `ls` will show that we have indeed created a new file `draft.txt`:

```bash
$ ls
```

```text
draft.txt
```

> **Dot Something**
>
> All of Amira's files are named "something dot something."
> This is just a convention:
> we can call a file `mythesis` or almost anything else.
> However,
> both people and programs use two-part names to help them tell different kinds of files apart.
> The part of the filename after the dot
> is called the **filename extension**
> and indicates what type of data the file holds:
> `.txt` for plain text,
> `.pdf` for a PDF document,
> `.png` for a PNG image, and so on.
> This is just a convention:
> saving a PNG image of a whale as `whale.mp3`
> doesn't somehow magically turn it into a recording of whalesong,
> though it *might* cause the operating system to try to open it with a music player
> when someone double-clicks it.

## Moving Files and Directories

Let's go back to our `zipf` directory:

```bash
cd ~/zipf
```

The `docs` directory contains a file called `draft.txt`.
That isn't a particularly informative name,
so let's change it using `mv` (short for **m**o**v**e):

```bash
$ mv docs/draft.txt docs/prior-work.txt
```

The first argument tells `mv` what we are "moving",
while the second is where it's to go.
"Moving" `docs/draft.txt` to `docs/prior-work.txt`
has the same effect as renaming the file:

```bash
$ ls docs
```

```text
prior-work.txt
```

We must be careful when specifying the destination
because `mv` will overwrite existing files without warning.
An option `-i` (for "interactive") makes `mv` ask us for confirmation before overwriting.
`mv` also works on directories,
so `mv analysis first-paper` would rename the directory without changing its contents.

Now suppose we want to move `prior-work.txt` into the current working directory.
If we don't want to change the file's name,
just its location,
we can provide `mv` with a directory as a destination
and it will move the file there.
In this case,
the directory we want is the special name `.` that we mentioned earlier:

```bash
$ mv docs/prior-work.txt .
```

\newpage

`ls` now shows us that `docs` is empty:

```bash
$ ls docs
```

and that our current directory now contains our file:

```bash
$ ls
```

```text
data/  docs/  prior-work.txt
```

If we only want to check that the file exists,
we can give its name to `ls`
just like we can give the name of a directory:

```bash
$ ls prior-work.txt
```

```text
prior-work.txt
```

## Copying Files and Directories 

The `cp` command **c**o**p**ies files.
It works like `mv` except it creates a file instead of moving an existing one:

```bash
$ cp prior-work.txt docs/section-1.txt
```

We can check that `cp` did the right thing
by giving `ls` two arguments
to ask it to list two things at once:

```bash
$ ls prior-work.txt docs/section-1.txt
```

```text
docs/section-1.txt  prior-work.txt
```

Notice that `ls` shows the output in alphabetical order.
If we leave off the second filename and ask it to show us a file and a directory
(or multiple directories)
it lists them one by one:

```bash
$ ls prior-work.txt docs
```

```text
prior-work.txt

docs:
section-1.txt
```

Copying a directory and everything it contains is a little more complicated.
If we use `cp` on its own,
we get an error message:

```bash
$ cp docs backup
```

```text
cp: docs is a directory (not copied).
```

If we really want to copy everything,
we must give `cp` the `-r` option (meaning **recursive**:

```bash
$ cp -r docs backup
```

Once again we can check the result with `ls`:

```bash
$ ls docs backup
```

```text
docs/:
section-1.txt

backup/:
section-1.txt
```

> **Copying Files to and from Remote Computers**
>
> For many researchers,
> a motivation for learning how to use the shell
> is that it's often the only way to connect to a remote computer
> (e.g., located at a supercomputing facility or in a university department).
>
> Similar to the `cp` command,
> there exists a **s**ecure **c**o**p**y (`scp`) command for
> copying files between computers.
> See Appendix **TODO**(ssh) for details, including how to set up
> a secure connection to a remote computer via the shell.

## Deleting Files and Directories 
Let's tidy up by removing the `prior-work.txt` file we created in our `zipf` directory.
The command to do this is `rm` (for **r**e**m**ove):

```bash
$ rm prior-work.txt
```

We can confirm the file is gone using `ls`:

```bash
$ ls prior-work.txt
```

```text
ls: prior-work.txt: No such file or directory
```

Deleting is forever:
unlike most GUIs, the Unix shell doesn't have a trash bin that we can recover deleted files from.
Tools for finding and recovering deleted files do exist, but there is no guarantee they will work, since the computer may recycle the file's disk space at any time.
In most cases, when we delete a file it really is gone.

In a half-hearted attempt to stop us from erasing things accidentally,
`rm` refuses to delete directories:

```bash
$ rm docs
```

```text
rm: docs: is a directory
```

We can tell `rm` we really want to do this
by giving it the recursive option `-r`:

```bash
$ rm -r docs
```

`rm -r` should be used with great caution:
in most cases,
it's safest to add the `-i` option (for **i**nteractive)
to get `rm` to ask us to confirm each deletion.
As a halfway measure,
we can use `-v` (for **v**erbose)
to get `rm` to print a message for each file it deletes.
This option works the same way with `mv` and `cp`.

## Wildcards 

`zipf/data` contains the text files for several ebooks
from [Project Gutenberg](https://www.gutenberg.org):

```bash
$ ls data
```

```text
README.md         moby_dick.txt
dracula.txt       sense_and_sensibility.txt
frankenstein.txt  sherlock_holmes.txt
jane_eyre.txt     time_machine.txt
```

The `wc` command (short for **w**ord **c**ount) tells us how many lines, words, and letters there are in one file:

```bash
$ wc data/moby_dick.txt
```

```text
 22331  215832 1276222 data/moby_dick.txt
```

> **What's in a Word?**
>
> `wc` only considers spaces to be word breaks:
> if two words are connected by a long dash---like "dash" and "like"
> in this sentence---then `wc` will count them as one word.

We could run `wc` more times to find out how many lines there are in the other files,
but that would be a lot of typing
and we could easily make a mistake.
We can't just give `wc` the name of the directory as we do with `ls`:

```bash
$ wc data
```

```text
wc: data: read: Is a directory
```

Instead,
we can use **wildcards** to specify a set of files at once.
The most commonly used wildcard is `*` (a single asterisk).
It matches zero or more characters, so `data/*.txt` matches all of the text files in the `data` directory:

```text
$ ls data/*.txt
```

```text
data/dracula.txt       data/sense_and_sensibility.txt
data/frankenstein.txt  data/sherlock_holmes.txt
data/jane_eyre.txt     data/time_machine.txt
data/moby_dick.txt
```

while `data/s*.txt` only matches the two whose names begin with an 's':

```bash
$ ls data/s*.txt
```

```text
data/sense_and_sensibility.txt  data/sherlock_holmes.txt
```

Wildcards are expanded to match filenames *before* commands are run,
so they work exactly the same way for every command.
This means that we can use them with `wc` to (for example)
count the number of words in the books with names that contain an underscore:

```bash
$ wc data/*_*.txt
```

```text
  21054  188460 1049294 data/jane_eyre.txt
  22331  215832 1253891 data/moby_dick.txt
  13028  121593  693116 data/sense_and_sensibility.txt
  13053  107536  581903 data/sherlock_holmes.txt
   3582   35527  200928 data/time_machine.txt
  73048  668948 3779132 total
```

or the number of words in Frankenstein:

```bash
$ wc data/frank*.txt
```

```text
  7832  78100 442967 data/frankenstein.txt
```

The exercises will introduce and explore other wildcards.
For now,
we only need to know that
it's possible for a wildcard expression to *not* match anything.
In this case,
the command will usually print an error message:

```bash
$ wc data/*.csv
```

```text
wc: data/*.csv: open: No such file or directory
```

## Reading the Manual 

`wc` displays lines, words, and characters by default,
but we can ask it to display only the number of lines:

```bash
$ wc -l data/s*.txt
```

```text
  13028 sense_and_sensibility.txt
  13053 sherlock_holmes.txt
  26081 total
```

`wc` has other options as well.
We can use the `man` command (short for **man**ual) to find out what they are:

```bash
$ man wc
```

> **Paging through the Manual**
>
> If our screen is too small to display an entire manual page at once,
> the shell will use a **paging program** called `less` to show it
> piece by piece.
> We can use <kbd>↑</kbd> and <kbd>↓</kbd> to move line-by-line
> or <kbd>Ctrl</kbd>+<kbd>Spacebar</kbd> and <kbd>Spacebar</kbd>
> to skip up and down one page at a time.
> (<kbd>B</kbd> and <kbd>F</kbd> also work.)
>
> To search for a character or word,
> use <kbd>/</kbd> followed by the character or word to search for.
> If the search produces multiple hits,
> we can move between them using <kbd>N</kbd> (for "next").
> To quit, press <kbd>Q</kbd>.

Manual pages contain a lot of information---often more than we really want.
Man callouts include excerpts from the manual on your screen,
and highlights a few of features useful for beginners.

```{figure} ../../figures/bash-basics/man-callouts.png
:name: man_callouts

Bash basics manual
```
Some commands have a `--help` option that provides a succinct summary of possibilities,
but the best place to go for help these days is probably the [TLDR](https://tldr.sh/) website.
The acronym stands for "too long, didn't read,"
and its help for `wc` displays this:

```
wc
Count words, bytes, or lines.

Count lines in file:
wc -l {{file}}

Count words in file:
wc -w {{file}}

Count characters (bytes) in file:
wc -c {{file}}

Count characters in file (taking multi-byte character sets into
account):
wc -m {{file}}

edit this page on github
```

As the last line suggests,
all of its examples are in a public GitHub repository
so that users like you can add the examples you wish it had.
For more information,
we can search on [Stack Overflow](https://stackoverflow.com/questions/tagged/bash)
or browse the [GNU manuals](https://www.gnu.org/manual/manual.html)
(particularly those for the [core GNU utilities](https://www.gnu.org/software/coreutils/manual/coreutils.html),
which include many of the commands introduced in this lesson).
In all cases,
though,
we need to have some idea of what we're looking for in the first place:
someone who wants to know how many lines there are in a data file
is unlikely to think to look for `wc`.

## Summary 

The original Unix shell is celebrating its fiftieth anniversary.
Its commands may be cryptic,
but few programs have remained in daily use for so long.
The next chapter will explore how we can combine and repeat commands
in order to create powerful, efficient workflows.

## Key Points 
```{include}  ../keypoints/bash_basics.md

```
