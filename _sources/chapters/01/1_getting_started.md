# Getting Started

**TODO CHECK CITE**
> Everything starts somewhere, though many physicists disagree.
>
> --- Terry Pratchett\index{Pratchett, Terry}

**TODO CHECK QUOTE** 

As with many research projects,
the first step in our Zipf's Law analysis
is to download the research data
and install the required software.
Before doing that,
it's worth taking a moment to think about
how we are going to organize everything.
We will soon have a number of books from [Project Gutenberg][project-gutenberg]
in the form of a series of text files,
plots we've produced showing the word frequency distribution in each book,
as well as the code we've written to produce those plots
and to document and release our software package.
If we aren't organized from the start,
things could get messy later on.

## Project Structure

Project organization is like a diet:
everyone has one,
it's just a question of whether it's healthy or not.
In the case of a project,
"healthy" means that people can find what they need and do what they want without becoming frustrated.
This depends on how well organized the project is
and how familiar people are with that style of organization.

As with good coding style,
small pieces in predictable places with readable names are easier to find and use
than large chunks that vary from project to project and have names like "stuff".
We can be messy while we are working and then tidy up later,
but experience teaches that we will be more productive if we make tidiness a habit.

In building the Zipf's Law project,
we'll follow a widely used template
for organizing small and medium-sized data analysis projects **TODO** {cite:p}`Nobl2009`.
The project will live in a directory called `zipf`,
which will also be a Git repository stored on GitHub (Chapter **TODO** \@ref(git-cmdline)).
The following is an abbreviated version of the project directory tree
as it appears toward the end of the book:

```text
zipf/
├── .gitignore
├── CITATION.md
├── CONDUCT.md
├── CONTRIBUTING.md
├── LICENSE.md
├── README.md
├── Makefile
├── bin
│   ├── book_summary.sh
│   ├── collate.py
│   ├── countwords.py
│   └── ...
├── data
│   ├── README.md
│   ├── dracula.txt
│   ├── frankenstein.txt
│   └── ...
├── docs
│   └── ...
├── results
│   ├── collated.csv
│   ├── dracula.csv
│   ├── dracula.png
│   └── ...
└── ...
```

The full, final directory tree is documented in Appendix **TODO CORRECT REF TO**

### Standard information

Our project will contain a few standard files
that should be present in every research software project,
open source or otherwise:

-   `README` includes basic information on our project.
     We'll create it in Chapter **TODO REF TO GIT_ADVANCED SECTION**,
     and extend it in Chapter **TODO REF TO PACKAGING**.

-   `LICENSE` is the project's license. We'll add it in Section **TODO REF TO LICENSE**.

-   `CONTRIBUTING` explains how to contribute to the project. We'll add it in Section **TODO REF teams-documentation**.

-   `CONDUCT` is the project's Code of Conduct. We'll add it in Section **TODO REF Teams-coc**

-   `CITATION` explains how to cite the software. We'll add it in Section **TODO REF packaging-software-journals**.

Some projects also include a `CONTRIBUTORS` or `AUTHORS` file that
lists everyone who has contributed to the project,
while others include that information in the `README` (we do this in Chapter **TODO REF git-advanced**
or make it a section in `CITATION`.
These files are often called **boilerplate,
meaning they are copied without change from one use to the next.

### Organizing project content

Following **TODO CITE** @Nobl2009,
the directories in the repository's root are organized according to purpose:

-   Runnable programs go in `bin/`
    (an old Unix abbreviation for "binary", meaning "not text").
    This will include both shell scripts,
    e.g., `book_summary.sh` developed in Chapter **TODO** ref(bash-advanced),
    and Python programs,
    e.g., `countwords.py`, developed in Chapter **TODO ref(scripting).

-   Raw data goes in `data/`
    and is never modified after being stored.
    You'll set up this directory
    and its contents in Section **TODO** ref(getting-started-download-data).

-   Results are put in `results/`.
    This includes cleaned-up data,
    figures,
    and everything else created using what's in `bin` and `data`.
    In this project,
    we'll describe exactly how `bin` and `data` are used
    with `Makefile` created in Chapter **TODO** ref(automate).

-   Finally,
    documentation and manuscripts go in `docs/`.
    In this project,
    `docs` will contain automatically generated
    documentation for the Python package, created in
    Section **TODO** ref(packaging-sphinx).

This structure works well for many computational research projects and
we encourage its use beyond just this book.
We will add some more folders and files not directly addressed by **TODO**@Nobl2009
when we talk about testing (Chapter **TODO** ref(testing)),
provenance (Chapter **TODO** ref(provenance)),
and packaging (Chapter **TODO** ref(packaging)).

## Downloading the Data

The data files used in the book are archived
at an online repository called Figshare (which we discuss in detail in Section **TODO** ref(provenance-data-where))
and can be accessed at:

<https://doi.org/10.6084/m9.figshare.13040516>

We can download a zip file containing the data files by clicking
"download all" at this URL
and then unzipping the contents into a new `zipf/data` **directory**
(also called a **folder**)
that follows the project structure described above.
Here's how things look once we're done:

```text
zipf/
└── data
    ├── README.md
    ├── dracula.txt
    ├── frankenstein.txt
    ├── jane_eyre.txt
    ├── moby_dick.txt
    ├── sense_and_sensibility.txt
    ├── sherlock_holmes.txt
    └── time_machine.txt
```

## Installing the Software

In order to conduct our analysis, we need to install the following software:

1. A **Shell** ( Bash, ZSH, Fish,...)
2. **Git** version control
3. A text editor
4. **TODO add officiel link** [Python 3][python] or using [Anaconda][anaconda]
5. **TODO**[GNU Make][gnu-make]

*Note* While Anaconda seems easy to install, depending on the use case it might be more efficient and simpler to use Python [Pip][pip] to install some necessary packages. 

Comprehensive software installation instructions for Windows, Mac, and Linux operating systems
(with video tutorials) are maintained by [The Carpentries][carpentries]
as part of their workshop website template at:

<https://carpentries.github.io/workshop-template/#setup>

We can follow those instructions to install the Bash shell, Git, a text editor and Anaconda.
We recommend Anaconda as the method for installing Python,
as it includes Conda as well as many of the packages we'll use in this book.

You can check if Make is already on your computer by typing `make -v` into the Bash shell.
If it is not, you can install it as follows:

- *Linux (Debian/Ubuntu)*: Install it from the Bash shell using `sudo apt-get install make`.
- *Mac*: Install **TODO** [Xcode][xcode] (via the App Store).
- *Windows*: Follow the **TODO** [installation instructions][ubc-mds-make-windows] maintained by the
  Master of Data Science program at the University of British Columbia.

> **conda in the Shell on Windows**
>
> If you are using Windows and the `conda` command isn't available at the Bash shell,
> you'll need to open the Anaconda Prompt program (via the Windows start menu)
> and run the command `conda init bash` (this only needs to be done once).
> After that, your shell will be configured to use conda going forward.

> **Software Versions**
> 
> Throughout the book,
> we'll be showing you examples of the output you can expect to see.
> This output is derived from running a Mac with:
> Git version 2.29.2, Python version 3.7.6,
> GNU bash version 3.2.57(1)-release (x86_64-apple-darwin19),
> GNU Make 3.81, and conda 4.9.2.
> In some cases,
> what you see printed to the screen may differ slightly 
> based on software version.
> We'll help you understand how to interpret the output
> so you can keep working and troubleshoot regardless of software version.

## Summary 

Now that our project structure is set up,
our data is downloaded,
and our software is installed,
we are ready to start our analysis.

\newpage

## Exercises

### Getting ready 

Make sure you've downloaded the required data files
(following Section **TODO** [download-data](#DownloadingtheData)
and installed the required software (following Section \@ref(getting-started-install-software))
before progressing to the next chapter.

## Key Points

- Make tidiness a habit, rather than cleaning up your project files later.
- Include a few standard files in all your projects, such as README, LICENSE, CONTRIBUTING, CONDUCT and CITATION.
- Put runnable code in a `bin/` directory.
- Put raw/original data in a `data/` directory and never modify it.
- Put results in a `results/` directory. This includes cleaned-up data and figures (i.e., everything created using what's in `bin` and `data`).
- Put documentation and manuscripts in a `docs/` directory.
- Refer to The Carpentries [software installation guide][carpentries-install-instructions] if you're having trouble. 


```{include} ./links.md
```
```{bibliography} ./bibliography.bib
```

