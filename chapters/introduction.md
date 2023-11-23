```{include} ../../links.md
```
(welcome)=
# Welcome 

Software is now as essential to research as telescopes, test tubes, and reference libraries.
This means that researchers **need** to know how to build, check, use, and share programs.
However,
most introductions to programming focus on developing commercial applications,
not on exploring problems whose answers aren't yet known.
Our goal is to show you how to do that,
both on your own and as part of a team.

We believe every researcher should know
how to write short programs that clean and analyze data in a reproducible way
and how to use version control to keep track of what they have done.
But just as some astronomers spend their careers designing telescopes,
some researchers focus on building the software that makes research possible.
People who do this are called **research software engineers**;
the aim of this book is to get you ready for this role by helping you go from
writing code for yourself to creating tools that help your entire field advance.
(welcome:big-picture)
## The Big Picture

Our approach to research software engineering is based on three related concepts:

-   **Open Science**: Making data, methods, and results
    freely available to all by publishing them under **open license**.

-   **Reproducible research**: Ensuring that anyone
    with access to the data and software can feasibly reproduce results, both to
    check them and to build on them. 

-   **Sustainable software**: The ease with which to
    maintain and extend it rather than to replace it. Sustainability isn't
    just a property of the software: it also depends on the skills and culture
    of its users.

People often conflate these three ideas, but they are distinct.
For example, if you share your data and the programs that analyze it,
but don't document what steps to take in what order, your work is open but not reproducible. 
Conversely, if you completely automate your analysis, but your data is only available to people in your lab, your work is reproducible but not open.
Finally, if a software package is being maintained by a couple of post-docs
who are being paid a fraction of what they could earn in industry
and have no realistic hope of promotion because their field doesn't value tool building, then sooner or later it will become \gref{abandonware}{abandonware},
at which point openness and reproducibility become less relevant.

Nobody argues that research should be irreproducible or unsustainable,
but "not against it" and actively supporting it are very different things.
Academia doesn't yet know how to reward people for writing useful software,
so while you may be thanked, the effort you put in may not translate into academic job security or decent pay.

Some people worry that if they make their data and code publicly available,
someone else will use it and publish a result they could have come up with themselves.
This is almost unheard of in practice, but that doesn't stop it being used as a scare tactic. 
Other people are afraid of looking foolish or incompetent by sharing code that might contain bugs.
This isn't just **impostor syndrome**:
members of marginalized groups are frequently judged more harshly than others,
so being wrong in public is much riskier for them.

With this course, we hope to give researchers the tools and knowledge to be
better research software developers, to be more efficient in their work, make
less mistakes, and work more openly and reproducibly.
We hope that by having more researchers with these skills and knowledge,
research culture can improve to address the issues raised above.

(welcome:intended-audience)=
## Intended Audience 

This book is written for researchers who are already using Python for their data analysis, but who want to take their coding and software development to the next level. You don't have to be highly proficient with Python,
but you should already be comfortable doing things like reading data from files
and writing loops, conditionals, and functions.
The following personas are examples of the types of people that are our target audience.

Amira Khan
:   completed a master's in library science five years ago
    and has since worked for a small aid organization.
    She did some statistics during her degree,
    and has learned some R and Python by doing data science courses online,
    but has no formal training in programming.
    Amira would like to tidy up the scripts, datasets, and reports she has created
    in order to share them with her colleagues.
    These lessons will show her how to do this.

Jun Hsu
:   completed an Insight Data Science fellowship last year after doing a PhD in geology
    and now works for a company that does forensic audits.
    He uses a variety of machine learning and visualization packages,
    and would now like to turn some of his own work into an open source project.
    This book will show him how such a project should be organized
    and how to encourage people to contribute to it.

Sami Virtanen
:   became a competent programmer during a bachelor's degree in applied math
    and was then hired by the university's research computing center.
    The kinds of applications they are being asked to support
    have shifted from fluid dynamics to data analysis;
    this guide will teach them how to build and run data pipelines
    so that they can pass those skills on to their users.
    
(welcome:what-you-learn)=
## What You Will Learn

Rather than simply providing reference material about good coding practices,
the book follows Amira and Sami as they work together to write an actual software package
to address a real research question.
The data analysis task that we focus on
relates to a fascinating result in the field of quantitative linguistics.
[Zipf's Law][zipfs-law] states that the second most common word in a body of text
appears half as often as the most common,
the third most common appears a third as often, and so on.
To test whether Zipf's Law holds for a collection of classic novels
that are freely available from [Project Gutenberg][project-gutenberg],
we write a software package that counts and analyzes the word frequency distribution
in any arbitrary body of text.

In the process of writing and publishing a Python package to verify Zipf's Law,
we will show you how to do the following:

-   Organize small and medium-sized data science projects.
-   Use the Unix shell to efficiently manage your data and code.
-   Write Python programs that can be used on the command line.
-   Use Git and GitHub to track and share your work.
-   Work productively in a small team where everyone is welcome.
-   Use Make to automate complex workflows.
-   Enable users to configure your software without modifying it directly.
-   Test your software and know which parts have not yet been tested.
-   Find, handle, and fix errors in your code.
-   Publish your code and research in open and reproducible ways.
-   Create Python packages that can be installed in standard ways.

(welcome:using-the-book)=
## Using this Book

This book was written to be used as the material for a (potentially) semester-long
course at the university level,
although it can also be used for independent self-study.
Participatory live-coding is the anticipated style for teaching the material,
rather than lectures simply talking about the code presented {cite:p}`Brow2018, Wils2018`
The chapters and their content are generally designed to be used in the order
given.

Chapters are structured with the introduction at the start, content in the middle,
and exercises at the end. Callout boxes are interspersed throughout the content
to be used as a supplement to the main text,
but not a requirement for the course overall.
Early chapters have many small exercises;
later chapters have fewer but larger exercises.
In order to break up long periods of live-coding while teaching,
it may be preferable to stop and complete some of the exercises
at key points throughout the chapter,
rather than waiting until the end. 
**TODO ADD REF WHEN DONE**
Possible exercise solutions are provided (Appendix ref(solutions)),
in addition to learning objectives (Appendix ref(objectives)) 
and key points (Appendix ref(keypoints)) for each chapter. 

(welcome:contributing)=
## Contributing and Re-Use

The source for the book can be found at the ['RSE-UP' GitHub repository](https://software-engineering-group-up.github.io/RSE-UP) and
any corrections, additions, or contributions are very welcome.
Everyone whose work is included will be credited in the acknowledgments.
Check out our
[contributing guidelines](https://github.com/Software-Engineering-Group-UP/RSE-UP/blob/main/CONTRIBUTION.md)
as well as our
[Code of Conduct](https://github.com/Software-Engineering-Group-UP/RSE-UP/blob/main/CODE_OF_CONDUCT.md)
for more information on how to contribute.

The content and code of this book can be freely re-used as it is
[licensed](https://github.com/Software-Engineering-Group-UP/RSE-UP/blob/main/LICENSE.md)
under a 
[Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/)
(CC-BY 4.0)
and a
[MIT License](https://github.com/Software-Engineering-Group-UP/RSE-UP/blob/main/LICENSE-MIT.md),
so the material can be used, re-used, and modified, 
as long as there is attribution to this source.

(welcome:ackknowledgements)
## Acknowledgements

This book was created on basis of the book 'Research Software Engineering with Python: Building Software that Makes Research Possible', that was created by: 
Damien Irving and Kate Hertweck and Luke Johnston and Joel Ostblom and Charlotte Wickham and Greg Wilson. 

The online version can be found [here!](https://merely-useful.tech/py-rse/)

