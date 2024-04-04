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

Here, the keys are `"project-name"`, `"purpose"`, and `"moons"`, and the values are `"planet earth"`, `"science fair"`, and (hopefully) the number 1, since most YAML implementations try to guess the type of data.

## Scalars
Knowing the following scalars might come in handy!

```YAML
number-value: 42
floating-point-value: 3.141592
boolean-value: true # on, yes -- also work
# strings can be both 'single-quoted` and "double-quoted"
string-value: 'Bonjour'
unquoted-string: Hello World
hexadecimal: 0x12d4
scientific: 12.3015e+05
infinity: .inf
not-a-number: .NAN
null: ~
another-null: null
key with spaces: value
datetime: 2001-12-15T02:59:43.1Z
datetime_with_spaces: 2001-12-14 21:59:43.10 -5
date: 2002-12-14
```


## Inline-Syntax

Since YAML is a superset of JSON, you can also write JSON-style maps and sequences.

```yaml
episodes: [1, 2, 3, 4, 5, 6, 7]
best-jedi: {name: Obi-Wan, side: light}
```

We can also write: 

If we want to create a list of values without keys, we can write it either using square brackets (like a Python array)
or dashed items like a Markdown, so:

  
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

are equivalent. (The indentation isn't absolutely required in this case, but helps make the intention clear.)


If we want to write entire paragraphs, we can use a marker to show that a value spans multiple lines:

## Multiline Strings

In YAML, there are two different ways to handle multiline strings. This is useful, for example, when you have a long code block that you want to format in a pretty way, but don't want to impact the functionality of the underlying CI script. In these cases, multiline strings can help. For an interactive demonstration, you can visit [https://yaml-multiline.info/](https://yaml-multiline.info/).

Put simply, you have two operators you can use to determine whether to keep newlines (`|`, exactly how you wrote it) or to remove newlines (`>`, fold them in). Similarly, you can also choose whether you want a single newline at the end of the multiline string, multiple newlines at the end (`+`), or no newlines at the end (`-`). The below is a summary of some variations:

```yaml
folded_no_ending_newline:
  script:
    - >-
      echo "foo" &&
      echo "bar" &&
      echo "baz"


    - echo "do something else"

unfolded_ending_single_newline:
  script:
    - |
      echo "foo" && \
      echo "bar" && \
      echo "baz"


    - echo "do something else"
```
or 

```yaml
feedback: |
    Neat molten core concept.
    Too much water.
    Could have used more imaginative ending.
```

## Nested
Yaml also supports nesting

```yaml
requests:
  # first item of `requests` list is just a string
  - http://example.com/
  # second item of `requests` list is a dictionary
  - url: http://example.com/
    method: GET
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

## Anchors
YAML also has a handy feature called 'anchors', which let you easily duplicate content across your document. Anchors look like references `&` in C/C++ and named anchors can be dereferenced using `*`.

```yaml
anchored_content: &anchor_name This string will appear as the value of two keys.
other_anchor: *anchor_name

base: &base
  name: Everyone has same name

foo: &foo
  <<: *base
  age: 10

bar: &bar
  <<: *base
  age: 20
```
The `<<` allows you to merge the items in a dereferenced anchor. Both `bar` and `foo` will have a `name` key.

