# Introduction to Make

> Multiple exclamation marks are a sure sign of a diseased mind.
>
> --- Terry Pratchett

Using [Jupyter Notebooks](https://jupyter.org/) itself or in  PyCharm, VSCode and other graphical interfaces
are great for prototyping code and exploring data, but eventually we may need to apply our code to thousands of data files,
run it with many different parameters, or combine it with other programs as part of a data analysis pipeline.
The easiest way to do this is often to turn our code into a standalone program that can be run in the Unix shell
just like other command-line tools {cite:p}`Tasc2017`.

In this chapter we will develop some **command-line Python program** that handle input and output in the same way as other shell commands,
can be controlled by several option flags, and provide useful information when things go wrong.
The result will have more scaffolding than useful application code, but that scaffolding stays more or less the same as programs get larger.
