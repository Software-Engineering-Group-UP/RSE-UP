# Adding CI/CD to a project on Gitlab

To continue please create a repository on Gitlab.com. We call the first one `hello_cicd` and the second one `bye_cicd`

```bash
cd hello_cicd
echo "hello world" >> .gitlab-ci.yml
git checkout -b feature/add-ci
git add .gitlab-ci.yml
git commit -m "my first ci/cd"
git push -u origin feature/add-ci
```


## Feature Branches

Since we're adding a new feature (CI/CD) to our project, we'll work in a feature branch. This is just a human-friendly named branch to indicate that it's adding a new feature.


Now, if you navigate to the GitLab webpage for that project and branch, you'll notice a shiny new button

```{figure} ../figures/cicd/first_push.png
:name: first_push
First commit  CI failure 
```
which will link to the newly added `.gitlab-ci.yml`. But wait a minute, there's also a big red `x` on the page too!

What happened??? Let's find out. Click on the red `x` which takes us to the `pipelines` page for the commit. On this page, we can see that this failed because the YAML was invalid...


```{figure} ../figures/cicd/failure_status.png
:name: fail_state
Failure Status of the Pipeline  
```

We should fix this. If you click through again on the red `x` on the left for the pipeline there, you can get to the detailed page for the given pipeline to find out more information

```{figure} ../figures/cicd/failure_info.png
:name: fail_info
Failure Information of the Pipeline  
```
### Validating CI/CD YAML Configuration

Every single project you make on GitLab comes with a linter for the YAML you write. This linter can be found at `<project-url>/-/ci/lint`. For example, if I have a project at [https://gitlab.cern.ch/MultiBJets/MBJ_Analysis](https://gitlab.cern.ch/MultiBJets/MBJ_Analysis), then the linter is at [https://gitlab.cern.ch/MultiBJets/MBJ_Analysis/-/ci/lint](https://gitlab.cern.ch/MultiBJets/MBJ_Analysis/-/ci/lint).

This can also be found by going to `CI/CD -> Pipelines` or `CI/CD -> Jobs` page and clicking the `CI Lint` button at the top right.


### But what's a linter?
From [wikipedia](https://en.wikipedia.org/wiki/Lint_(software)): `lint`, or a linter, is a tool that analyzes source code to flag programming errors, bugs, stylistic errors, and suspicious constructs. The term originates from a Unix utility that examined C language source code.

Lastly, we'll open up a merge request for this branch, since we plan to merge this back into master when we're happy with the first iteration of the CI/CD.

## Work In Progress?

If you expect to be working on a branch for a bit of time while you have a merge request open, it's good etiquette to mark it as a Work-In-Progress (WIP).

```{figure} ../figures/cicd/merge_request.png
:name: merge_request
WIP merge request
```

## Fixing the YAML

Now, our YAML is currently invalid, but this makes sense because we didn't actually define any script to run. Let's go ahead and update our first job that simply echoes "Hello World".

```yaml
hello world:
  script: echo "Hello World"
```

**TODO** before CONTINUING NEED CONTACT WITH ADMIN running PIPELINES.... 
