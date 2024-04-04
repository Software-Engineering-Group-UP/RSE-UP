# Introduction to Configuration

> Always be wary of any helpful item that weighs less than its operating manual.
>
> --- Terry Pratchett

In previous chapters we used command-line options to control our scripts and programs.
If they are more complex,
we may want to use up to four layers of configuration:

1.  A system-wide configuration file for general settings.
2.  A user-specific configuration file for personal preferences.
3.  A job-specific file with settings for a particular run.
4.  Command-line options to change things that commonly change.

This is sometimes called **overlay configuration**
because each level overrides the ones above it:
the user's configuration file overrides the system settings,
the job configuration overrides the user's defaults,
and the command-line options overrides that.
This is more complex than most research software needs initially {cite:p}`Xu2015`,
but being able to read a complete set of options from a file
is a big boost to reproducibility.

