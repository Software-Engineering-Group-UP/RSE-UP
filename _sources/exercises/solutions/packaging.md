## Chapter Packaging

### Exercise 1 

A `description` and `long_description` argument need to be provided
when the `setup` function is called in `setup.py`.
On the TestPyPI webpage,
the user interface displays description in the grey banner
and long_description in the section named "Project Description."

Other metadata that might be added includes the author email address,
software license details and a link to the documentation at Read the Docs.

### Exercise 2

The new `requirements_dev.txt` file will have this inside it:

```text
pytest
```

### Exercise 3

The answers to the relevant questions from the checklist are shown below.

- *Repository*: Is the source code for this software available at the repository url?
  - Yes. The source code is available at PyPI.

- *License*: Does the repository contain a plain-text LICENSE file
with the contents of an OSI approved software license?
  - Yes. Our GitHub repository contains LICENSE.md (Section [Include a license](https://software-engineering-group-up.github.io/RSE-UP/chapters/working_in_teams.html#include-a-license)).

- *Installation*: Does installation proceed as outlined in the documentation?
  - Yes. Our README says the package can be installed via pip.
   
- *Functionality*: Have the functional claims of the software been confirmed?
  - Yes. The command-line programs `countwords`, `collate`, and `plotcounts`
    perform as described in the README. 

- *A statement of need*: Do the authors clearly state what problems the software
is designed to solve and who the target audience is?
  - Yes. The "Motivation" section of the README explains this.

- *Installation instructions*: Is there a clearly stated list of dependencies?
Ideally these should be handled with an automated package management solution.
  - Yes. In our `setup.py` file the `install_requires` argument lists dependencies.

- *Example usage*: Do the authors include examples of how to use the software
(ideally to solve real-world analysis problems).
  - Yes. There are examples in the README.

- *Functionality documentation*: Is the core functionality of the software documented
to a satisfactory level (e.g., API method documentation)?
  - Yes. This information is available on Read the Docs.
  
- *Automated tests*: Are there automated tests or manual steps described
so that the functionality of the software can be verified?
  - We have unit tests written and available (`test_zipfs.py`),
    but our documentation needs to be updated to tell people
    to run `pytest` in order to manually run those tests.

- *Community guidelines*: Are there clear guidelines for third parties wishing
to 1) Contribute to the software 2) Report issues or problems
with the software 3) Seek support?
  - Yes. Our CONTRIBUTING file explains this ([Section - Making it obvious to newcomers](https://software-engineering-group-up.github.io/RSE-UP/chapters/working_in_teams.html#make-all-this-obvious-to-newcomers)).

### Exercise 4

The directory tree for the `pratchett` package is:

```text
pratchett
├── pratchett
│   └── quotes.py
├── README.md
└── setup.py
```

`README.md` should contain a basic description of the package and how to install/use it,
while `setup.py` should contain:

```python
from setuptools import setup


setup(
    name='pratchett',
    version='0.1',
    author='Amira Khan',
    packages=['pratchett'],
)
```

The following sequence of commands will create the development environment,
activate it,
and then install the package:

```bash
$ conda create -n pratchett python
$ conda activate pratchett
(pratchett)$ cd pratchett
(pratchett)$ pip install -e .
```
