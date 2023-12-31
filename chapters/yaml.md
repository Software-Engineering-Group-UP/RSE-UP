# YAML

YAML is a way to write nested data structures in plain text
that is often used to specify configuration options for software.
The acronym stands for "YAML Ain't Markup Language,"
but that's misleading:
YAML doesn't use tags like HTML, but can still be quite fussy about what is allowed to appear where.

Throughout this book we use YAML to configure our plotting script ([Chapter on Configuration](https://software-engineering-group-up.github.io/RSE-UP/chapters/configuration.html)), **TODO** continuous integration with Travis CI (Section ref(testing-ci)),
software environment with `conda` (Section [Software Environment](https://software-engineering-group-up.github.io/RSE-UP/chapters/tracking_provenance.html#software-environment)), and a documentation website with Read the Docs (Section [Packaging - adding documentation](https://software-engineering-group-up.github.io/RSE-UP/chapters/python_packaging.html#creating-a-web-page-for-documentation)).
While you don't need to be an expert in YAML to complete tasks like these,
this appendix outlines some basics that can help make things easier.

A simple YAML file has one key-value pair on each line
with a colon separating the key from the value:

```yaml
project-name: planet earth
purpose: science fair
moons: 1
```

Here,
the keys are `"project-name"`, `"purpose"`, and `"moons"`,
and the values are `"planet earth"`,
`"science fair"`,
and (hopefully) the number 1,
since most YAML implementations try to guess the type of data.

If we want to create a list of values without keys,
we can write it either using square brackets (like a Python array)
or dashed items (like a Markdown,
so:

```yaml
rotation-time: ["1 year", "12 months", "365.25 days"]
```

and:

```yaml
rotation-time:
    - 1 year
    - 12 months
    - 365.25 days
```

are equivalent.
(The indentation isn't absolutely required in this case,
but helps make the intention clear.)
If we want to write entire paragraphs,
we can use a marker to show that a value spans multiple lines:

```yaml
feedback: |
    Neat molten core concept.
    Too much water.
    Could have used more imaginative ending.
```

We can also add comments using `#` just as we do in many programming languages.

YAML is easy to understand when used this way,
but it starts to get tricky as soon as sub-lists and sub-keys appear.
For example,
this is part of the YAML configuration file for formatting this book:

```yaml
bookdown::gitbook:
  highlight: tango
  config:
    download: ["pdf", "epub"]
    toc:
      collapse: section
      before: |
        <li><a href="./">Merely Useful</a></li>
    sharing: no
```

It corresponds to the following Python data structure:

```python
{
  'bookdown::gitbook': {
    'highlight': 'tango',
    'config': {
      'download': [
        'pdf',
        'epub'
      ],
      'toc': {
        'collapse': 'section',
        'before': '<li><a href="./">Merely Useful</a></li>\n'
      }
      'sharing': False
    }
  }
}
```
