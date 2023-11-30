# Anaconda

When people first started using Python for data science,
installing the relevant libraries could be difficult. The main problem was that the Python package installer ([`pip`](https://pypi.org/project/pip/))
only worked for libraries written in pure Python.
Many scientific Python libraries have C and/or Fortran dependencies,
so it was left up to data scientists
(who often do not have a background in system administration)
to figure out how to install those dependencies themselves.
To overcome this problem,
a number of scientific Python **distributions** have been released over the years.
These come with the most popular data science libraries and their dependencies pre-installed,
and some also come with a package manager to assist
with installing additional libraries that weren't pre-installed.
Today the most popular distribution for data science is [Anaconda](https://anaconda.com), which comes with a package (and environment) manager called [`conda`](https://conda.io).
In this appendix we look at some of the most important features of `conda`
for research software engineers.

## Package Management with conda 

According to the [latest documentation](https://docs.anaconda.com/anaconda/),
Anaconda comes with over 250 of the most widely used data science libraries (and their dependencies) pre-installed.
In addition, there are several thousand libraries available via the `conda install` command,
which can be executed at the command line or by using the Anaconda Navigator graphical user interface.
A package manager like conda greatly simplifies the software installation process
by identifying and installing compatible versions of software and all required dependencies.
It also handles the process of updating software as more recent versions become available.
If you don't want to install the entire Anaconda distribution,
you can install [Miniconda](https://docs.conda.io/en/latest/miniconda.html)instead. It essentially comes with `conda` and nothing else.

### Anaconda

What happens if we want to install a Python package
that isn't on the list of the few thousand or so most popular data science packages (i.e., the ones that are automatically available via the `conda install` command)?
The answer is the [Anaconda Cloud](https://anaconda.org/) website,
where the community can post `conda` installation packages.

The utility of the Anaconda Cloud for research software engineers
is best illustrated by an example.
A few years ago, an atmospheric scientist by the name of Andrew Dawson
wrote a Python package called [`windspharm`](https://ajdawson.github.io/windspharm/latest/)
for performing computations on global wind fields in spherical geometry.
While many of Andrew's colleagues routinely process global wind fields,
atmospheric science is a relatively small field and thus the `windspharm` package
will never have a big enough user base to make the list of
popular data science packages supported by Anaconda.
Andrew has therefore posted a `conda` installation package to Anaconda Cloud
([Figure Windspharm](anaconda-windspharm-ajdawson))
so that users can install `windspharm` using `conda`:

```bash
$ conda install -c ajdawson windspharm
```

```{figures} ../../figures/anaconda/cloud-windspharm-ajdawson.png
:name" anaconda-windspharm-ajdawson
Windspharm - AJ Dawson
```

The `conda` documentation has [instructions]( https://docs.conda.io/projects/conda-build/en/latest/user-guide/tutorials/build-pkgs-skeleton.html) for quickly building
a `conda` package for a Python module that is already available on [PyPI](https://pypi.org/) ([Section Distribute packaging](https://software-engineering-group-up.github.io/RSE-UP/chapters/packaging/packaging.html#distributing-packages)).

### conda-forge

It turns out there are often multiple installation packages for the same library
up on Anaconda Cloud (e.g., [Figure Windspharm search](windspharm-search)).
To try and address this duplication problem, [conda-forge](https://conda-forge.org/) was launched.
It aims to be a central repository that contains just a single, up-to-date (and working)
version of each installation package on Anaconda Cloud.
You can therefore expand the selection of packages available via `conda install`
beyond the chosen few thousand by adding the conda-forge channel to your `conda` configuration:

```bash
$ conda config --add channels conda-forge
```

```{figure} ../../figures/anaconda/cloud-windspharm-search.png
:name: cloud-windspharm-search
Windspharm search
```

The conda-forge website has [instructions](https://conda-forge.org/#add_recipe)
for adding a `conda` installation package to the conda-forge repository.

## Environment Management with conda

If you are working on several data science projects at once,
installing all the libraries you need in the same place
(i.e., the system default location) can become problematic.
This is especially true if the projects rely on different versions of the same package,
or if you are developing a new package and need to try new things.
The way to avoid these issues is to create different **virtual environments** for different projects/tasks.
The original environment manager for Python development was [`virtualenv`](https://virtualenv.pypa.io/),
which has been more recently superseded by [`pipenv`]( https://docs.pipenv.org/).
The advantage that `conda` has over these options is that it is language agnostic
(i.e., you can isolate non-Python packages in your environments too) and
supports binary packages (i.e., you don't need to compile the source code after installing),
so it has become the environment manager of choice in data science.
In this book `conda` is used to export the details of an environment
when documenting the computational methodology for a report ([Section Provenance - Code](https://software-engineering-group-up.github.io/RSE-UP/chapters/provenance/tracking_provenance.html#code-provenance))
and to test how a new package installs without disturbing anything
in our main Python installation ([Section Packaging a virtual environment](https://software-engineering-group-up.github.io/RSE-UP/chapters/packaging/packaging.html#virtual-environments)).
