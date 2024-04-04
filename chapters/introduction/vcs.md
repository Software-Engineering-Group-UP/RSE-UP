# Version Control


> +++ Divide By Cucumber Error. Please Reinstall Universe And Reboot +++
>
> --- Terry Pratchett

A **version control system** tracks changes to files and helps people share those changes with each other.
These things can be done by emailing files to colleagues or by using Microsoft Word and Google Docs, but version control does both more accurately and efficiently.
Originally developed to support software development, over the past fifteen years it has become the cornerstone of **reproducible research**.

Version control works by storing a master copy of your code in a repository, which you can't edit directly.
Instead, you check out a working copy of the code, edit that code, then commit changes back to the repository.
In this way, version control records a complete revision history (i.e., of every commit), so that you can retrieve and compare previous versions at any time.
This is useful from an individual viewpoint, because you don't need to store multiple (but slightly different) copies of the same script as seen in the comix below. 
It's also useful from a collaboration viewpoint, because the system keeps a record of who made what changes and when.

![Git CMDLINE](../figures/git-cmdline/phd-comics.png)

There are many different version control systems, such as CVS, Subversion, and Mercurial, but the most widely used version control system today is **Git**.
Many people first encounter it through a GUI like the [Github desktop client](https://desktop.github.com/) or paid tools like [GitKraken](https://www.gitkraken.com/) or terminal application like [GitUI](https://github.com/extrawurst/gitui).
However, these tools are actually wrappers around Git's original command-line interface,which gives us access to all of Git's features.
This lesson describes how to perform fundamental operations using that interface; Chapter [Git Advanced](https://software-engineering-group-up.github.io/RSE-UP/exercises/git_advanced.html) then introduces more advanced operations that can be used to implement a smoother research workflow.

