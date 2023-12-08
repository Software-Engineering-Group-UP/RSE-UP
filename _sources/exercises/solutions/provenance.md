
## Chapter Tracking Provenance

### Exercise 1

You can get an ORCID by registering on [here](https://orcid.org/register).
Please add this 16-digit identifier to all of your published works and to your online profiles.

### Exercise 2

If possible, compare your answers with those of a colleague who works with the same data. Where did you agree and disagree, and why?

### Exercise 3 

1.  51 solicitors were interviewed as the participants.

2.  Interview data, and data from a database on court decisions.

3.  This information is not available within the documentation.
    Information on their jobs and opinions are there,
    but the participant demographics are only described within the associated article.
    The difficulty is that the article is not linked within the documentation or the metadata.

4.  We can search the dataset name and author name trying to find this.
    A search for the grant information with "National Science Foundation (1228602)"
    finds the [grant page](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1228602).
    Two articles are linked there,
    but both the DOI links are broken.
    We can search with the citation for each paper to find them.
    The [Forced Migration article](https://www.fmreview.org/fragilestates/meili)
    uses a different subset of interviews and does not mention demographics,
    nor links to the deposited dataset.
    The [Boston College Law Review article](https://lawdigitalcommons.bc.edu/cgi/viewcontent.cgi?article=3318&context=bclr)
    has the same two problems of different data and no dataset citation.

    Searching more broadly through Meili's work, we can find {cite:p}`Meil2015`.
    This lists the dataset as a footnote and reports the 51 interviews
    with demographic data on reported gender of the interviewees.
    This paper lists data collection as 2010--2014,
    while the other two say 2010--2013.
    We might come to a conclusion that this extra year
    is where the extra 9 interviews come in,
    but that difference is not explained anywhere.

### Exercise 4

For [`borstlab/reversephi_paper`](https://github.com/borstlab/reversephi_paper/):

1.  The software requirements are documented in `README.md`.
    In addition to the tools used in the `zipf/` project (Python, Make and Git),
    the project also requires ImageMagick.
    No information on installing ImageMagick or a required version of ImageMagick is provided.

    To re-create the `conda` environment, you would need the file `my_environment.yml`.
    Instructions for creating and using the environment are provided in `README.md`.

2.  Like `zipf` the data processing and analysis steps are documented in a `Makefile`.
    The `README` includes instructions for re-creating the results using `make all`.

3.  There doesn't seem to be a DOI for the archived code and data,
    but the GitHub repo does have a release `v1.0` with the description "Published manuscript (1.0)" beside it.
    A zip file of this release could be downloaded from GitHub.

For [the figshare page](https://doi.org/10.6084/m9.figshare.7575830) that accompanies the paper {cite:p}`Irvi2019`:

1. The figshare page includes a "Software environment" section.
   To re-create the `conda` environment, you would need the file `environment.yml`.

2. `figure*_log.txt` are log files for each figure in the paper.
   These files show the computational steps performed in generating the figure,
   in the form of a list of commands executed at the command line.

   `code.zip` is a version controlled (using git) file directory
   containing the code written to perform the analysis
   (i.e., it contains the scripts referred to in the log files).
   This code can also be found on GitHub.

3. The figshare page itself is the archive, and includes a version history for the contents.

For the GitHub repo [`blab/h3n2-reassortment`](https://github.com/blab/h3n2-reassortment):

1. `README.md` includes an "Install requirements" section
   that describes setting up the `conda` environment using the file `h3n2_reassortment.yaml`.

    The analysis also depends on components from Nextstrain.
    Instructions for cloning them from GitHub are provided.

2. The code seems to be spread across the directories `jupyter_notebooks`, `hyphy`,
   `flu_epidemiology`, and `src`, but it isn't clear what order the code should be run in,
   or how the components depend on each other.

3. The data itself is not archived, but links are provided
   in the "Install requirements" section of `README.md` to
   documents that describe how to obtain the data.
   Some intermediate data is also provided in the `data/` directory.

   The GitHub repo has a release with files "that are up-to-date with the version
   of the manuscript that was submitted to Virus Evolution on 31 January 2019."

### Exercise 5

<https://web.archive.org/web/20191105173924/https://ukhomeoffice.github.io/accessibility-posters/posters/accessibility-posters.pdf>

### Exercise 6

You'll know you've completed this exercise when you have a URL
that points to zip archive for a specific release of your repository on GitHub,
e.g:  

```text
https://github.com/amira-khan/zipf/archive/KhanVirtanen2020.zip
```

### Exercise 7

Some steps to publishing your project's code would be:

1.  Upload the code on GitHub.
2.  Use a standard folder and file structure as taught in this book.
3.  Include `README`, `CONTRIBUTING`, `CONDUCT`, and `LICENSE` files.
4.  Make sure these files explain how to install and configure the required software
    and tells people how to run the code in the project.
5.  Include a `requirements.txt` file for Python package dependencies.

