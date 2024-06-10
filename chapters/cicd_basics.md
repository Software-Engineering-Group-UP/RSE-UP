# CI/CD Basics 

*## THIS WHOLE CHAPTER IS A WORK IN PROGRESS*

There are tons of different CI/CD solutions some of the more popular are:

- [Native GitLab CI/CD](https://docs.gitlab.com/ee/ci/)
- [Native GitHub CI/CD](https://github.com/features/actions)
- [Travis CI](https://travis-ci.org/)
- [Circle CI](https://circleci.com/)
- [TeamCity](https://www.jetbrains.com/teamcity/)
- [Bamboo](https://www.atlassian.com/software/bamboo)
- [Jenkins](https://jenkins.io/)
- [Buddy](https://buddy.works/)
- [CodeShip](https://codeship.com/)
- [CodeFresh](https://g.codefresh.io/)

We'll only focus on Github's solution. At this time we can not run any runners on our universities gitlab instance (at least not to students frreely available ones). 

 However, be aware that all the concepts are taught: including pipelines, stages, jobs, artifacts; all exist in other solutions by similar/different names. For example, GitLab supports two features known as caching and artifacts; but Travis doesn't quite implement the same thing for caching and has no native support for artifacts. Therefore, while it is not discouraged to try out other solutions, there's no "one size fits all" when designing your own CI/CD workflow.

For now follow a tutorial at the carpentries [here](https://awesome-workshop.github.io/continuous-integration-deployment-gitlab/)
<!--
## Exit Codes

In this section you will learn: 

  - Understand exit codes
  - How to print exit codes
  - How to set exit codes in a script
  - How to ignore exit codes
  - Create a script that terminates in success/error

keypoints:
  - Exit codes are used to identify if a command or script executed with errors or not
  - Not everyone respects exit codes

### Start by Exiting

***Please follow allow with your terminal, while going through the sections!*** 

How does a general task know whether or not a script finished correctly or not? You could parse (`grep`) the output:

```bash
ls nonexistent-file
```


```output
ls: cannot access 'nonexistent-file': No such file or directory
```
or somtheing like this:

```output
"nonexistent-file": No such file or directory (os error 2)
```

But every command outputs something differently. Instead, scripts also have an (invisible) exit code:

~~~bash
echo $?
~~~
{: .source}

~~~output
2
~~~

The exit code is `2` indicating failure. What about on success? The exit code is `0` like so:

```bash
echo
echo $?
```
```output

0
```


But this works for any command you run on the command line! For example, if I mistyped `git status`:

```bash
git status
echo $?
```


```output
git: 'stauts' is not a git command. See 'git --help'.

The most similar command is
  status
1
```

and there, the exit code is non-zero -- a failure.

### Exit Code is not a Boolean
You've probably trained your intuition to think of `0` as falsy. However, exit code of `0` means there was no error. If you feel queasy about remembering this, imagine that the question asked is "Was there an error in executing the command?" `0` means "no" and non-zero (`1`, `2`, ...) means "yes".

Try out some other commands on your system, and see what things look like.

## Printing Exit Codes

As you've seen above, the exit code from the last executed command is stored in the `$?` environment variable. Accessing from a shell is easy `echo $?`. What about from python? There are many different ways depending on which library you use. Using similar examples above, we can use the (note: deprecated) `os.system` call:

### Snake Charming
To enter the Python interpreter, simply type `python` in your command line.
Once inside the Python interpreter, simply type `exit()` then press enter, to exit.


```Python
>>> import os,subprocess
>>> ret = os.system('ls')
>>> os.WEXITSTATUS(ret)
0
>>> ret = os.system('ls nonexistent-file')
>>> os.WEXITSTATUS(ret)
1
```

One will note that this returned a different exit code than from the command line (indicating there's some internal implementation in Python). All you need to be concerned with is that the exit code was non-zero (there was an error).

## Setting Exit Codes

So now that we can get those exit codes, how can we set them? Let's explore this in `shell` and in `python`.

### Shell

Create a file called `bash_exit.sh` with the following content:

```bash
#!/usr/bin/env bash

if [ $1 == "hello" ]
then
  exit 0
else
  exit 59
fi
```

and then make it exectuable `chmod +x bash_exit.sh`. Now, try running it with `./bash_exit.sh hello` and `./bash_exit.sh goodbye` and see what those exit codes are.

### Python

Create a file called `python_exit.py` with the following content:

```Python
#!/usr/bin/env python

import sys
if sys.argv[1] == "hello":
  sys.exit(0)
else:
  sys.exit(59)
```

and then make it executable `chmod +x python_exit.py`. Now, try running it with `./python_exit.py hello` and `./python_exit.py goodbye` and see what those exit codes are. Déjà vu?

## Ignoring Exit Codes

To finish up this section, one thing you'll notice sometimes (in ATLAS or CMS) is that a script you run doesn't seem to respect exit codes. A notable example in ATLAS is the use of `setupATLAS` which returns non-zero exit status codes even though it runs successfully! This can be very annoying when you start development with the assumption that exit status codes are meaningful (such as with CI). In these cases, you'll need to ignore the exit code. An easy way to do this is to execute a second command that always gives `exit 0` if the first command doesn't, like so:

```bash
:(){ return 1; };: || echo ignore failure
```

The `command_1 || command_2` operator means to execute `command_2` only if `command_1` has failed (non-zero exit code). Similarly, the `command_1 && command_2` operator means to execute `command_2` only if `command_1` has succeeded. Try this out using one of scripts you made in the previous session:

```bash
> ./python_exit.py goodbye || echo ignore
```

What does that give you?

### Overriding Exit Codes
It's not really recommended to 'hack' the exit codes like this, but this example is provided so that you are aware of how to do it, if you ever run into this situation. Assume that scripts respect exit codes, until you run into one that does not.

**Please have a look at [YAML chapter](https://software-engineering-group-up.github.io/RSE-UP/chapters/yaml.html)before continueing**


## GitLab CI YAML

The GitLab CI configurations are specified using a YAML file called `.gitlab-ci.yml`. Here is an example:

```yaml
image: rikorose/gcc-cmake

before_script:
  - mkdir build

build_code:
  script:
    - cd build
    - cmake ../src
    - cmake --build .
```

### `script` commands

Sometimes, `script` commands will need to be wrapped in single or double quotes. For example, commands that contain a colon (`:`) need to be wrapped in quotes so that the YAML parser knows to interpret the whole thing as a string rather than a “key: value” pair. Be careful when using special characters: `:`, `{`, `}`, `[`, `]`, `,`, `&`, `*`, `#`, `?`, `|`, `-`, `<`, `>`, `=`, `!`, `%`, `@`, `\``.

This is the simplest possible configuration that will work for most code using minimal dependencies with `cmake` and `make`:

1. Define one job `build_code` (the job names are arbitrary) with different commands to be executed.
2. Before every job, the commands defined by `before_script` are executed.

The `.gitlab-ci.yml` file defines sets of jobs with constraints of how and when they should be run. The jobs are defined as top-level elements with a name (in our case `build_code`) and always have to contain the `script` keyword. Let's explore this structure in more depth.

### Overall Structure

Every single parameter we consider for all configurations are keys under jobs. The YAML is structured using job names. For example, we can define three jobs that run in parallel (more on parallel/serial later) with different sets of parameters.

```yaml
job1:
  param1: null
  param2: null

job2:
  param1: null
  param3: null

job3:
  param2: null
  param4: null
  param5: null
```


### Parallel or Serial Execution?

Note that by default, all jobs you define run in parallel. If you want them to run in serial, or a mix of parallel and serial, or as a directed acyclic graph, we'll cover this in a later section.


What can you not use as job names? There are a few reserved keywords (because these are used as global parameters for configuration, in addition to being job-specific parameters):

- `default`
- `image`
- `services`
- `stages`
- `types`
- `before_script`
- `after_script`
- `variables`
- `cache`

Global parameters mean that you can set parameters at the top-level of the YAML file. What does that actually mean? Here's another example:

```yaml
image: rikorose/gcc-cmake

stages: [build, test, deploy]

job1:
  script: make

job2:
  image: rikorose/gcc-cmake:gcc-6
  script: make
```

where `image` and `stages` are global parameters being used. Note that `job2:image` overrides `:image`.

### Job Parameters

What are some of the parameters that can be used in a job? Rather than copy/pasting from the reference (linked below in this session), we'll go to the [Configuration parameters](https://docs.gitlab.com/ee/ci/yaml/#configuration-parameters) section in the GitLab docs. The most important parameter, and the only one needed to define a job, is `script`

```yaml
job one:
  script: make

job two:
  script:
    - python test.py
    - coverage
```


### Understanding the Reference
One will notice that the reference uses colons like `:job:image:name` to refer to parameter names. This is represented in yaml like:
```yaml
job:
  image:
    name: rikorose/gcc-cmake:gcc-6
```
where the colon refers to a child key.


### Reference

The reference guide for all GitLab CI/CD pipeline configurations is found at [https://docs.gitlab.com/ee/ci/yaml/](https://docs.gitlab.com/ee/ci/yaml/). This contains all the different parameters you can assign to a job.

You should also have a look at: [https://docs.gitlab.com/ee/ci/yaml/](https://docs.gitlab.com/ee/ci/yaml/)


-->