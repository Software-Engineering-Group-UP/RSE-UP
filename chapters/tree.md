# Project Tree 

The final directory tree for the Zipf's Law project looks like the following:

```
pyzipf/
├── .gitignore
├── CITATION.md
├── CONDUCT.md
├── CONTRIBUTING.md
├── KhanVirtanen2020.md
├── LICENSE.md
├── Makefile
├── README.rst
├── environment.yml
├── requirements.txt
├── requirements_docs.txt
├── setup.py
├── data
│   ├── README.md
│   ├── dracula.txt
│   ├── frankenstein.txt
│   ├── jane_eyre.txt
│   ├── moby_dick.txt
│   ├── sense_and_sensibility.txt
│   ├── sherlock_holmes.txt
│   └── time_machine.txt
├── docs
│   ├── Makefile
│   ├── conf.py
│   ├── index.rst
│   └── source
│   │   ├── collate.rst
│   │   ├── countwords.rst
│   │   ├── modules.rst
│   │   ├── plotcounts.rst
│   │   ├── test_zipfs.rst
│   │   └── utilities.rst
├── results
│   ├── collated.csv
│   ├── collated.png
│   ├── dracula.csv
│   ├── dracula.png
│   ├── frankenstein.csv
│   ├── jane_eyre.csv
│   ├── jane_eyre.png
│   ├── moby_dick.csv
│   ├── sense_and_sensibility.csv
│   ├── sherlock_holmes.csv
│   └── time_machine.csv
├── test_data
│   ├── random_words.txt
│   └── risk.txt
└── pyzipf
    ├── book_summary.sh
    ├── collate.py
    ├── countwords.py
    ├── plotcounts.py
    ├── plotparams.yml
    ├── script_template.py
    ├── test_zipfs.py
    └── utilities.py
```

You can view the complete project,
including the version history,
in [Amira's `zipf` repository on GitHub][amira-repo].

Each file was introduced and subsequently modified
in the following chapters, sections and exercises:

- `pyzipf/`: Introduced as `zipf/` in Section \@ref(getting-started-download-data)
and changed name to `pyzipf/` in Section \@ref(packaging-package).

- `pyzipf/.gitignore`: Introduced in Section \@ref(git-cmdline-ignore),
and updated in various other chapters following
[GitHub's `.gitignore` templates][github-gitignore].

- `pyzipf/CITATION.md`: Introduced in Section \@ref(packaging-software-journals).

- `pyzipf/CONDUCT.md`: Introduced in Section \@ref(teams-coc) and
committed to the repository in Exercise \@ref(teams-ex-boilerplate-coc).

- `pyzipf/CONTRIBUTING.md`: Introduced in Section \@ref(teams-documentation) and
committed to the repository in Exercise \@ref(teams-ex-contributing).

- `pyzipf/KhanVirtanen2020.md`: Introduced in Section \@ref(provenance-code-steps).

- `pyzipf/LICENSE.md`: Introduced in Section \@ref(teams-license-software) and
committed to the repository in Exercise \@ref(teams-ex-boilerplate-license).

- `pyzipf/Makefile`: Introduced and updated throughout Chapter \@ref(automate).
Updated again in Exercise \@ref(config-ex-build-plotparams).

- `pyzipf/README.rst`: Introduced as a `.md` file in Section \@ref(git-advanced-conflict),
updated in Section \@ref(git-advanced-fork) and then converted to a `.rst` file
with further updates in Section \@ref(packaging-readme).

- `pyzipf/environment.yml`: Introduced in Section \@ref(provenance-code-environment).

- `pyzipf/requirements.txt`: Introduced in Section \@ref(testing-ci).

- `pyzipf/requirements_docs.txt`: Introduced in Section \@ref(packaging-sphinx).

- `pyzipf/setup.py`: Introduced and updated throughout Chapter \@ref(packaging).

- `pyzipf/data/*` : Downloaded as part of the setup instructions (Section \@ref(getting-started-download-data)).

- `pyzipf/docs/*`: Introduced in Section \@ref(packaging-sphinx).

- `pyzipf/results/collated.*`: Generated in Section \@ref(automate-pipeline).

- `pyzipf/results/dracula.csv`: Generated in Section \@ref(scripting-collate).

- `pyzipf/results/dracula.png`: Generated in Section \@ref(git-cmdline-changes) and updated in Section \@ref(git-advanced-zipf-verify).

- `pyzipf/results/jane_eyre.csv`: Generated in Section \@ref(scripting-collate).

- `pyzipf/results/jane_eyre.png`: Generated in Section \@ref(scripting-plotting).

- `pyzipf/results/moby_dick.csv`: Generated in Section \@ref(scripting-collate).

- `pyzipf/results/frankenstein.csv`: Generated in Section \@ref(automate-functions).

- `pyzipf/results/sense_and_sensibility.csv`: Generated in Section \@ref(automate-functions).

- `pyzipf/results/sherlock_holmes.csv`: Generated in Section \@ref(automate-functions).

- `pyzipf/results/time_machine.csv`: Generated in Section \@ref(automate-functions).

- `pyzipf/test_data/random_words.txt`: Generated in Section \@ref(testing-integration).

- `pyzipf/test_data/risk.txt`: Introduced in Section \@ref(testing-unit).

- `pyzipf/pyzipf/`: Introduced as `bin/` in Section \@ref(getting-started-organize) and
changed name to `pyzipf/` in Section \@ref(packaging-package).

- `pyzipf/pyzipf/book_summary.sh`: Introduced and updated throughout Chapter \@ref(bash-advanced).

- `pyzipf/pyzipf/collate.py`: Introduced in Section \@ref(scripting-collate) and
updated in Section \@ref(scripting-modules),
throughout Chapter \@ref(errors) and in Section \@ref(packaging-package).

- `pyzipf/pyzipf/countwords.py`: Introduced in Section \@ref(scripting-wordcount) and
updated in Sections \@ref(scripting-modules) and \@ref(packaging-package).

- `pyzipf/pyzipf/plotcounts.py`: Introduced in Exercise \@ref(scripting-ex-better-plotting) and
updated throughout Chapters \@ref(git-cmdline), \@ref(git-advanced) and \@ref(config).

- `pyzipf/pyzipf/plotparams.yml`: Introduced in Section \@ref(config-job-file).

- `pyzipf/pyzipf/script_template.py`: Introduced in Section \@ref(scripting-options) and
updated in Section \@ref(scripting-docstrings).

- `pyzipf/pyzipf/test_zipfs.py`: Introduced and updated throughout Chapter \@ref(testing).

- `pyzipf/pyzipf/utilities.py`: Introduced in Section \@ref(scripting-modules).

