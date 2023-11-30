# Tracking Provenance 

> The most important problem is that we are trying to understand the fundamental workings of the universe
> via a language devised for telling one another when the best fruit is.
>
> --- Terry Pratchett

We have now developed, automated, and tested
a workflow for plotting the word count distribution for classic novels.
In the normal course of events,
we would include the outputs from that workflow (e.g., our figures and $\alpha$ values)
in a research paper or a report for a consulting client.

But modern publishing involves much more than producing a PDF
and making it available on a preprint server such as [arXiv](https://arxiv.org) or [bioRxiv](https://www.biorxiv.org/).
It also entails providing the data underpinning the report
and the code used to do the analysis:

> An article about computational science in a scientific publication
> is *not* the scholarship itself,
> it is merely *advertising* of the scholarship.
> The actual scholarship is the complete software development environment
> and the complete set of instructions which generated the figures.
>
> --- Jonathan Buckheit and David Donoho, paraphrasing Jon Claerbout, in {cite:p}`Buck1995`

While some reports, datasets, software packages, and analysis scripts
can't be published without violating personal or commercial confidentiality,
every researcher's default should be to make all these as widely available as possible.
Publishing it under an open license ([Section Team License](https://software-engineering-group-up.github.io/RSE-UP/chapters/work_teams/working_in_teams.html#include-a-license)) is the first step;
the sections below describe what else we can do to capture
the **provenance** of our data analysis.

Our Zipf's Law project files are structured as they were at the end of the previous chapter:

```text
zipf/
├── .gitignore
├── .travis.yml
├── CONDUCT.md
├── CONTRIBUTING.md
├── LICENSE.md
├── Makefile
├── README.md
├── requirements.txt
├── bin
│   ├── book_summary.sh
│   ├── collate.py
│   ├── countwords.py
│   ├── plotcounts.py
│   ├── plotparams.yml
│   ├── script_template.py
│   ├── test_zipfs.py
│   └── utilities.py
├── data
│   ├── README.md
│   ├── dracula.txt
│   └── ...
├── results
│   ├── dracula.csv
│   ├── dracula.png
│   └── ...
└── test_data
    ├── random_words.txt
    └── risk.txt
```

> **Identifying Reports and Authors**
>
> Before publishing anything,
> we need to understand how authors and their works are identified.
> A **Digital Object Identifier** (DOI)
> is a unique identifier for a particular version of a particular digital artifact
> such as a report, a dataset, or a piece of software.
> DOIs are written as `doi:prefix/suffix`,
> but are often also represented as URLs like `http://dx.doi.org/prefix/suffix`.
> In order to be allowed to issue a DOI,
> an academic journal, data archive, or other organization
> must guarantee a certain level of security, longevity and access.
>
> An **ORCID**
> is an Open Researcher and Contributor ID.
> Anyone can get an ORCID for free,
> and should include it in publications
> because people's names and affiliations change over time.

## Data Provenance 

The first step in documenting the data associated with a report
is to determine what (if anything) needs to be published.
If the report involved the analysis of a publicly available dataset
that is maintained and documented by a third party,
it's not necessary to publish a duplicate of the dataset:
the report simply needs to document where to access the data
and what version was analyzed.
This is the case for our Zipf's Law analysis,
since the texts we analyze are available at [Project Gutenberg]( https://www.gutenberg.org/).

It's not strictly necessary to publish intermediate data
produced during the analysis of a publicly available dataset either
(e.g., the CSV files produced by `countwords.py`),
so long as readers have access to the original data and the code/software used to process it.
However,
making intermediate data available can save people time and effort,
particularly if it takes a lot of computing power to reproduce it
(or if installing the required software is complicated).
For example,
NASA has published
the [Goddard Institute for Space Studies Surface Temperature Analysis]( https://www.gutenberg.org/),
which estimates the global average surface temperature
based on thousands of land and ocean weather observations,
because a simple metric of global warming is expensive to produce
and is useful in many research contexts.

If a report involves a new dataset,
such as observations collected during a field experiment,
then that data needs to be published in its raw (unprocessed) form.
The publication of a dataset,
whether raw or intermediate,
should follow the FAIR Principles.

### The FAIR Principles 

The [FAIR Principles](https://data.giss.nasa.gov/gistemp/) describe what research data should look like.
They are still aspirational for most researchers,
but tell us what to aim for [{cite:p}`Good2014`;{cite:p}`Mich2015`;{cite:p}`Hart2016`; {cite:p}`Broc2019`; {cite:p}`Tier2020`.
The most immediately important elements of the FAIR Principles are outlined below.

#### Data should be *findable*

The first step in using or re-using data is to find it.
We can tell we've done this if:

1.  (Meta)data is assigned a globally unique and persistent identifier
    (i.e., a **DOI**).
2.  Data is described with rich metadata.
3.  Metadata clearly and explicitly includes the identifier of the data it describes.
4.  (Meta)data is registered or indexed in a searchable resource,
    such as the data sharing platforms described in [Section](https://software-engineering-group-up.github.io/RSE-UP/chapters/provenance/tracking_provenance.html#where-to-archive-data).

#### Data should be *accessible*

People can't use data if they don't have access to it.
In practice,
this rule means the data should be openly accessible (the preferred solution)
or that authenticating in order to view or download it should be free.
We can tell we've done this if:

1.  (Meta)data is retrievable by its identifier
    using a standard communications protocol like HTTP.
2.  Metadata is accessible even when the data is no longer available.

#### Data should be *interoperable*

Data usually needs to be integrated with other data,
which means that tools need to be able to process it.
We can tell we've done this if:

1.  (Meta)data uses a formal, accessible, shared, and broadly applicable language for knowledge representation.
2.  (Meta)data uses vocabularies that follow FAIR principles.
3.  (Meta)data includes qualified references to other (meta)data.

#### Data should be *reusable*

This is the ultimate purpose of the FAIR Principles and much other work.
We can tell we've done this if:

1.  (Meta)data is described with accurate and relevant attributes.
2.  (Meta)data is released with a clear and accessible data usage license.
3.  (Meta)data has detailed **provenance**.
4.  (Meta)data meets domain-relevant community standards.

### Where to archive data 

Small datasets (i.e., anything under 500 MB) can be stored in version control.If the data is being used in several projects,
it may make sense to create one repository to hold only the data;
these are sometimes referred to as **data packages**,
and they are often accompanied by small scripts to clean up and query the data.

For medium-sized datasets (between 500 MB and 5 GB),
it's better to put the data on platforms
like the [Open Science Framework](https://osf.io/), [Dryad](https://datadryad.org/), 
[Zenodo](https://zenodo.org/), and [Figshare](https://figshare.com/),
which will give the dataset a DOI.
Big datasets (i.e., anything more than 5 GB)
may not be ours in the first place,
and probably need the attention of a professional archivist.

> **Data Journals**
>
> While archiving data at a site like Dryad or Figshare (following the FAIR Principles)
> is usually the end of the data publishing process,
> there is the option of publishing a journal paper to describe the dataset in detail.
> Some research disciplines have journals devoted
> to describing particular types of data
> (e.g., the [Geoscience Data Journal](https://rmets.onlinelibrary.wiley.com/journal/20496060))
> and there are also generic data journals
> (e.g., [Scientific Data](https://www.nature.com/sdata/)).

## Code Provenance 

Our Zipf's Law analysis represents a typical data science project
in that we've written some code
that leverages other pre-existing software packages
in order to produce the key results of a report.
To make a computational workflow like this open, transparent, and reproducible
we must archive three key items:

1.  A copy of any **analysis scripts or notebooks** used to produce the key results
    presented in the report.
2.  A detailed description of the **software environment**
    in which those analysis scripts or notebooks ran.
3.  A description of the **data processing steps** taken in producing each key result,
    i.e., a step-by-step account of which scripts were executed in what order
    for each key result.

\newpage

Unfortunately,
librarians, publishers, and regulatory bodies are still trying to determine
the best way to document and archive material like this,
so a widely accepted set of FAIR Principles for research software
is still under development {cite:p}`Lamp2020`.
In the meantime, the best advice we can give is presented below.
It involves adding information about the software environment
and data processing steps to a GitHub repository that contains
the analysis scripts/notebooks,
before creating a new release of that repository and archiving it (with a DOI)
with [Zenodo][zenodo].

### Software environment 

In order to document the software packages used in our analysis,
we should archive a list of the names and version numbers of each software package.
We can get version information for the Python packages we are using by running:

```bash
$ pip freeze
```

```text
alabaster==0.7.12
anaconda-client==1.7.2
anaconda-navigator==1.9.12
anaconda-project==0.8.3
appnope==0.1.0
appscript==1.0.1
asn1crypto==1.0.1
...
```

Other command-line tools will often have an option like `--version` or `--status`
to access the version information.

Archiving a list of package names and version numbers would mean that our
software environment is technically reproducible,
but it would be left up to the reader of the report
to figure out how to get all those packages installed and working together.
This might be fine for a small number of packages with very few dependencies,
but in more complex cases we probably want to make life easier for the reader
(and for our future selves looking to re-run the analysis).
One way to make things easier is to export a description of
a complete conda environment
([Section packaging virtual environments](https://software-engineering-group-up.github.io/RSE-UP/chapters/packaging/packaging.html#virtual-environments); [Appendix Anaconda](https://software-engineering-group-up.github.io/RSE-UP/chapters/appendix/anaconda.html)), or **TODO** [Appendix setting up virtual environment in mac and linux](https://software-engineering-group-up.github.io/RSE-UP/chapters/appendix/pyenv.html)
which can be saved as YAML using:

```bash
$ conda env export > environment.yml
$ cat environment.yml
```
```text
name: base
channels:
  - conda-forge
  - defaults
dependencies:
  - _ipyw_jlab_nb_ext_conf=0.1.0=py37_0
  - alabaster=0.7.12=py37_0
  - anaconda=2019.10=py37_0
  - anaconda-client=1.7.2=py37_0
  - anaconda-navigator=1.9.12=py37_0
  - anaconda-project=0.8.3=py_0
  - appnope=0.1.0=py37_0
  - appscript=1.1.0=py37h1de35cc_0
  - asn1crypto=1.0.1=py37_0
...
```

That software environment can be re-created on another computer with one line of code:

```
$ conda env create -f environment.yml
```

Since this `environment.yml` file is an important part of reproducing the analysis,
remember to add it to your GitHub repository.

> **Container Images**
>
> More complex tools like [Docker][docker]
> can install our entire environment
> (down to the precise version of the operating system)
> on a different computer {cite:p}`Nust2020`.
> However,
> their complexity can be daunting,
> and there is a lot of debate
> about how well (or whether) they actually make research more reproducible in practice.

### Data processing steps 

The second item that needs to be added to our GitHub repository is a description
of the data processing steps involved in each key result.
Assuming the author list on our report is Amira Khan and Sami Virtanen ([Section](https://software-engineering-group-up.github.io/RSE-UP/chapters/introduction.html#intended-audience),
we could add a new Markdown file called `KhanVirtanen2020.md` to the repository
to describe the steps:

```markdown
The code in this repository was used in generating the results
for the following paper:

Khan A & Virtanen S, 2020. Zipf's Law in classic english texts.
*Journal of Important Research*, 27, 134-139.

The code was executed in the software environment described by
`environment.yml`. It can be installed using
[conda](https://docs.conda.io/en/latest/):
$ conda env create -f environment.yml

Figure 1 in the paper was created by running the following at
the command line:
$ make all
```

We should also add this information as an appendix to the report itself.

### Analysis scripts 

Later in this book we will package and release our Zipf's Law code
so that it can be downloaded and installed by the wider research community,
just like any other Python package ([Chapter Packaging](https://software-engineering-group-up.github.io/RSE-UP/chapters/packaging/packaging.html)).
Doing this is especially helpful if other people might be interested in using and/or extending it,
but often the scripts and notebooks we write to produce a particular figure or table
are too case-specific to be of broad interest.
To fully capture the provenance of the results presented in a report,
these analysis scripts and/or notebooks
(along with the details of the associated software environment and data processing steps)
can simply be archived with a repository like **Figshare** or **Zenodo**,
which specialize in storing the long tail of research projects
(i.e., supplementary figures, data, and code).
Uploading a zip file of analysis scripts to the repository is a valid option,
but more recently the process has been streamlined via direct integration
between GitHub and Zenodo.
As described in [this tutorial][github-zenodo-tutorial],
the process involves creating a new release of our repository in GitHub
that Zenodo copies and then issues a DOI for ([Figure](provenance-release)).

```{figure} ../../figures/provenance/release.png
:name: provenance-release
Release
```

### Reproducibility versus inspectability 

In most cases,
documenting our software environment, analysis scripts, and data processing steps
will ensure that our computational analysis is reproducible/repeatable
at the time our report is published.
But what about five or ten years later?
As we have discussed,
data analysis workflows usually depend on a hierarchy of packages.
Our Zipf's Law analysis depends on a collection of Python libraries,
which in turn depend on the Python language itself.
Some workflows also depend critically on a particular operating system.
Over time some of these dependencies will inevitably be updated or no longer supported,
meaning our workflow will be documented but not reproducible.

Fortunately,
most readers are not looking to exactly re-run a decade-old analysis:
they just want to be able to figure out what was run
and what the important decisions were,
which is sometimes referred to as **inspectability** {cite:p}`Gil2016`; {cite:p}`Brow2017`.
While exact repeatability has a short shelf-life,
inspectability is the enduring legacy of a well-documented computational analysis.

> **Your Future Self Will Thank You**
>
> Data and code provenance is often promoted for the good of people
> trying to reproduce your work,
> who were not part of creating the work in the first place.
> Prioritizing their needs can be difficult:
> how can we justify spending time for other people
> when our current projects need work for the good of the people working on them right now?
>
> Instead of thinking about people who are unknown and unrelated,
> we can think about newcomers to our team
> and the time we will save ourselves in onboarding them.
> We can also think about the time we will save ourselves
> when we come back to this project five months or five years from now.
> Documentation that serves these two groups well
> will almost certainly serve the needs of strangers as well.

## Summary 

The Internet started a revolution in scientific publishing
that shows no sign of ending.
Where an inter-library loan once took weeks to arrive
and data had to be transcribed from published papers
(if it could be found at all),
we can now download one another's work in minutes:
*if* we can find it and make sense of it.
Organizations like [Our Research][our-research] are building tools to help with both;
by using DOIs and ORCIDs,
publishing on preprint servers,
following the FAIR Principles,
and documenting our workflow,
we help ensure that everyone can pursue their ideas as we did.

## Key Points

```{include} ../keypoints/provenance.md

```
