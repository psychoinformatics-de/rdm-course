---
title: "Structuring data"
teaching: 90
exercises: 0
questions:
- "What is a good filename?"
- "How to keep data nicely structured?"
objectives:
- "Name good practices in organizing data"
- "Distinguish between text vs binary data"
- "Explore lightweight text files and how they can be useful"
keypoints:
- Use filenames which are machine-readable, human readable, easy to sort and search
- Avoid including identifying information in filenames from the get-go
- Files can be categorized as text or binary
- Lightweight text files can go a long way
- A well thought-out directory structure simplifies computation
- Be modular to facilitate reuse
---

## Introduction

This module is dedicated to good practices in data organization. We
will discuss little things which may seem prosaic but can go a long
way in making your life easier: file names, text files, project
structure.

## How to name a file?

This section is based on the presentations "[Naming
Things](http://www2.stat.duke.edu/~rcs46/lectures_2015/01-markdown-git/slides/naming-slides/naming-slides.pdf)"
(CC0) by Jenny Bryan and "[Project
structure](https://slides.djnavarro.net/project-structure/)" by
Danielle Navarro.

A file name exists to identify its content. There are different
opinions as to what *exactly* is a good file name, but they usually
revolve around the three main principles:

- be machine readable
- be human readable
- make sorting and searching easy

A universal gold standard probably does not exist and we do not claim
to posses one. What we can do, however, is to focus on identifying
patterns in file naming which can make working with data easier.

Let's start with a good example for naming what appears to be a
collection of materials for an English literature class:

~~~
reading01_shakespeare_romeo-and-juliet_act01.docx
reading01_shakespeare_romeo-and-juliet_act02.docx
reading01_shakespeare_romeo-and-juliet_act03.docx
reading02_shakespeare_othello.docx
reading19_plath_the-bell-jar.docx
~~~

A "bad" (meaning harder to work with) way of naming the same files
could look like this:

~~~
Romeo and Juliet Act 1.docx
Romeo and juliet act 2.docx
Shakespeare RJ act3.docx
shakespeare othello I think?.docx
belljar plath (1).docx
~~~

Not only does the first example look much more orderly, it is also
better at accomplishing the three goals above. Let's take a closer
look.

### Machine readable

#### Avoid white spaces

A lot of trouble with white spaces comes from using file names in
command line or in code. In a command line syntax spaces are used to
separate arguments. A file name with spaces needs to be enclosed in
quotes, or the spaces need to be *escaped* with a `\` symbol.

~~~
edit my file.txt    # won't be understood
edit "my file.txt"  # names can be quoted
edit my\ file.txt   # spaces can be escaped
~~~
{: .language-bash}

It can be annoying and adds complexity, but it also causes additional
trouble when names are passed from one script to another (requiring
escaping the escape character or mixing quote symbols).

With that in mind:

~~~
✅ romeo-and-juliet_act01.docx
✅ midsummer-nights-dream.docx

❌ romeo and juliet act 1.docx
❌ midsummer nights dream.docx
~~~

#### Use only letters, numbers, hyphens, and underscores

- Sometimes there are character encoding issues (less common now)
- Some characters (such as `'^.*?$+|`) have special meaning, e.g. `?`
  may mean "match any character"
- Some characters are harder to enter: `ü`, `ł`, ...
- Some are outright forbidden by some operating systems,
  eg. `<>:"/\|?*` on Windows

~~~
✅ what-the-cat.docx
✅ essay_romeo-and-juliet_draft01.docx
	
❌ what-the-cat?.docx
❌ essay "romeo and juliet" draft01.docx
❌ essay "romeo and juliet" draft01(1).docx
~~~

#### Don't rely on letter case

- Some operating systems (or file systems) treat upper and lower case
  differently (`apple` and `Apple` are two files) and some don't
  (`apple` and `Apple` are the same file)
- Do not use letter case to distinguish two files
- Be consistent

~~~
othello.docx
✅ romeo-and-juliet.docx

❌ othello.docx
❌ Othello.docx
❌ Romeo-and-juliet.docx
~~~

#### Use separators in a meaningful way:

- Use `-` to join words into one entity.
- Use `_` to separate entities.

So if a pattern is `[identifier] [author] [title] [section(optional)]`:

~~~
✅ reading01_shakespeare_romeo-and-juliet_act01.docx
✅ reading01_shakespeare_romeo-and-juliet_act02.docx
✅ reading02_shakespeare_othello.docx
✅ reading19_plath_the-bell-jar.docx
~~~

Alternatively, if you need to combine flexibility and unambiguity
(meaning that for a given file you need to include a subset of many
possible entities, and don't want to consult the documentation for
what each filename part represents) you may decide to:

- use `-` for key-value encoding,
- use `_` to separate entities.

For a hypothetical experiment:

~~~
✅ sub-12_sess-pre_task-fingertapping_run-1.dat
✅ sub-12_sess-post_task-fingertapping_run-1.dat
~~~

Most programming languages will have easy ways to split the filenames
by a given character, and you can work from there.

### Human readable

Especially in a free-form content it's nice to use a *slug* (term
borrowed by clean website URLs from newspaper publishing, meaning a
short name):

~~~
✅ "analysis01_descriptive-statistics.R"
✅ "analysis02_preregistered-analysis.R"
✅ "notes01_realising-the-problem.txt"
✅ "analysis03_departing-from-the-plan.R"
✅ "notes02_tentative-write-up.docx"
~~~

### Easy to sort and search

#### Follow ISO 8601 when using dates

Including a date in a file name is rarely needed. For example, if you
want to keep track of changes it is better to use version control
tools. However, sometimes the date can be a crucial piece of
information (e.g. weather data collected daily) or you may wish to
keep things in chronological order when sorting by file names
(e.g. meeting notes). If including dates, follow the ISO 8601 standard
(`YYYY-MM-DD`), which is widely recognized and maintains chronology in
alphabetical ordering:

~~~
2021-09-14_preliminary-meeting.org
2021-09-27_rdm-workshop-planning.org
2021-10-10_progress-report.org
~~~

There's a [relevant xkcd](https://xkcd.com/1179).

#### Zero pad numbers

- You can use numbers as a prefix to order files
- However, it's a double-edged sword: if the order changes, you'll
  need to rename everything
- Usually, `10_abc` will come before `2_abc`, so zero-pad as necessary

~~~
01_preface.docx
02_introduction.docx
03_method.docx
etc...
	
19_appendix-tables.docx
20_appendix-glossary.docx
~~~

#### Include keywords

Consistent keywords make searching (*globbing*) easier (be it
graphical interface, terminal, or code):

~~~
reading01_shakespeare_romeo-and-juliet_act01.docx
reading01_shakespeare_romeo-and-juliet_act02.docx
reading01_shakespeare_romeo-and-juliet_act03.docx
reading02_shakespeare_othello.docx
reading19_plath_the-bell-jar.docx
notes02_shakespeare_othello.docx
notes19_plath_the-bell-jar.docx
~~~

Most tools and programming languages will provide a way to filter file
names. For example, to find materials from unit 19 in bash terminal:

~~~
ls *19_*
~~~
{: .language-bash}

~~~
reading19_plath_the-bell-jar.docx
notes19_plath_the-bell-jar.docx
~~~
{: .output}

Or to find notes in python:

~~~
import glob
glob.glob(notes*)
~~~
{: .language-python}

~~~
notes02_shakespeare_othello.docx
notes19_plath_the-bell-jar.docx
~~~
{: .output}

### Summary

> ## In practice
>
> You need to know what a file contains, and you need to find the file
> you need.
>
> **Machine readable** means that it's easy to operate on file names and
> extract information from them:
>
> - Avoid white spaces
> - Use only letters, numbers, hyphens, and underscores
> - Don't rely on letter case
> - Use separators in a meaningful way
> 
> **Human readable** means that it's easy to figure out what something
> is by looking at its name.
>
> - Include a slug
>
> To make things **easy to sort and search**
> 
> - Follow ISO 8601 when using dates
> - Zero pad numbers
> - Include keywords
{: .callout}

## Avoid leaking undesired information

When dealing with personal data, pseudonymisation is a common
practice. While, for example, a name composed of birth date and
initials may be sufficient to distinguish subjects within a study, a
file with such a name can hardly be considered deidentified.

If a dataset is being version controlled (which means that its history
of changes is being recorded), this poses an additional challenge:
file name changes are also tracked, and the record of the change is
preserved.

This is what it may look like in the case of DataLad:

~~~
touch name-with-identifying-information.dat
datalad save
~~~
{: .language-bash}

A few moments later - oops...!

~~~
git mv name-with-identifying-information.dat a-new-name.dat
datalad save
~~~
{: .language-bash}

However, the rename operation is recorded in dataset
history. Comparing previous state to the current state:

~~~
git diff HEAD~1 HEAD
~~~
{: .language-bash}

~~~
diff --git a/name-with-identifying-information.dat b/a-new-name.dat
similarity index 100%
rename from name-with-identifying-information.dat
rename to a-new-name.dat

~~~
{: .output}


There are ways to "rewrite history", but doing so can be difficult and
potentially destructive.

## File types (text vs binary)

Any dataset will likely store different kinds of data, and use different file formats to do so. There is a myriad of formats; sometimes, the format choice for a given type of data will be obvious (dictated by universally accepted or field-specific standards), sometimes there will be several possibilities. Leaving the formats aside, one broad distinction can be made: text vs binary.

- Text file is a file structured as a sequence of lines containing text, composed of characters. 
- Binary file is anything other than a text file.

A text file can be viewed and edited using a text editor . The *lines* are delimited by a newline character, typically written as `\n`. Note that although some editors will *wrap* lines for display purposes, this is purely visual, as the line endings are stored in the file.

Here's a quick overview of commonly found text and binary files. Note that although we are identifying them by extension, on UNIX-like systems the extensions are just part of a file name and are customary rather than essential.

| Text                                            | Binary                                             |
|-------------------------------------------------|----------------------------------------------------|
| .txt                                            | images: .jpg, .png, .tiff                          |
| markup: .md, .rst, .html                        | documents: docx, .xlsx, .pdf                       |
| source code: .py, .R, .m                        | compiled files: .pyc, .o, .exe                     |
| text-serialised formats: .toml, yaml, json, xml | binary-serialised formats: .pickle, .feather, .hdf |
| delimited files: .tsv, .csv                     | domain-specific: .nii, .edf                        |
| vector graphics: .svg                           | compressed: .zip .gz, .7z                          |
| ...                                             | ...

We'll take a closer look at "markup", "serialised" and "delimited" files a bit later.
Now, note some potentially surprising facts:
- Scalable Vector Graphics (SVG) is actually a text file, where all objects are described with XML notation.
  For example, this is a blue rectangle with a black border: `<rect width="300" height="100" style="fill:rgb(0,0,255);stroke-width:3;stroke:rgb(0,0,0)" />`.
- A Word document (.docx) is not a text file, but actually a zipped XML, and therefore binary.
  It follows the Office Open XML specification.
  Although what you see is mostly text, the file can pack different contents.
  The same goes, for example, for .xlsx.

### Version control

One important feature of text files is that they can be version controlled on a line by line basis. So if you have a long file, but only change it in a few places, changes will be recorded for the specific lines. Moreover, it will be easy to display what the modification involved, by portraying it as lines being taken out and added (in programming slang, this is called a file *diff*).

Compare this to a binary file, which does not have a line structure. It's easy to notice that a file changed, but it's not easy to show what changed inside. Version control systems, including DataLad, will also track binary files, but the (in)ability to distinguish or display lines will make it more similar to a per-file basis.

DataLad introduces one additional distinction between text and binary files. In the configuration we used in the previous module (which is a reasonable choice for many situations), binary files would get annexed (meaning that tracking of information about the file presence and its content would be somewhat separated, with `git-annex` used under the hood) and text files would not (although you might also choose different rules for which files to annex). We have already observed one consequence of annexing: to protect the data from accidental modifications, DataLad will content-lock the annexed files, disabling your permission to edit them (the files can be unlocked manually with `datalad unlock` or automatically when using `datalad run`). Another consequence (which we will discuss in the subsequent module) is that not all data hosting services accept annexed content, and you may need to publish it separately.

### Different flavors of text files

Text files may be simple in their structure, but they can be very powerful in their ability to store content. Tabular data, sets of parameters, key-value metadata, configuration options, free-form descriptions... there's a good chance that you'll find a text-based representation that will be easy to create and easy to work with. With that in mind, let's look at different flavors of text files. All the example formats below are human- and machine-readable. They have all become widely accepted standards and you will likely find a library for reading these files in your favorite programming language.

#### Plain text

A plain text file is just that, plain text.

~~~
Here is plain text.
A very simple file, this
can be read by all.
~~~

#### Markdown

A very common format for representing free-form text is Markdown. Markdown a *lightweight markup language*, meaning that it introduces some unobtrusive syntax for marking headers, emphasis, links, blocks of code, etc:

~~~
# Markdown example

## Some things for which markdown has rules

- Lists
- Marking emphasis with *italics* or **bold**
- Links, such as [example](https://example.com)
- Some `inline code` (and code blocks, not shown)
~~~

Fairly standardized and very popular, Markdown is recognized by many programs and platforms. While it is readable as-is, many code-hosting websites, such as GitHub, will recognize markdown files (giving special attention to those named README) and render them as html in the web interface. Markdown files are a good choice for describing things in a free narrative - your project, dataset, or analysis. This course materials have also been written in Markdown!

There are other markup languages for similar purposes, such as [reStructuredText](https://docutils.sourceforge.io/rst.html) (popular choice in the world of python documentation), [AsciiDoc](https://asciidoc-py.github.io/), or [Org Mode](https://orgmode.org/) (popular among the users of Emacs text editor). Html is also a markup language, but in most cases it is easier to write in one of the lightweight languages and then convert the documents to html.

#### Delimited files: csv, tsv

Moving on from narrative to data, comma-separated files (.csv) and tab-separated files (.tsv) are simple and common ways to represent tabular data. The example below comes from the [Palmer Penguins](https://github.com/allisonhorst/palmerpenguins) dataset:

~~~
species,island,bill_length_mm,bill_depth_mm,flipper_length_mm,body_mass_g,sex,year
Adelie,Torgersen,39.1,18.7,181,3750,male,2007
Adelie,Torgersen,39.5,17.4,186,3800,female,2007
Adelie,Torgersen,40.3,18,195,3250,female,2007
Adelie,Torgersen,NA,NA,NA,NA,NA,2007
Adelie,Torgersen,36.7,19.3,193,3450,female,2007
~~~

#### Configuration and data serialization: toml, yaml & json

Some formats were made for serialization (or interchange) --
converting data objects into an easily transmittable form. They can be
useful for storing configurations, or keeping (meta-)data which is
best represented as key-value pairs. Most programming languages will
have tools for reading and writing these files.

Here are examples of [YAML](https://yaml.org/) (YAML Ain't Markup
Language), [TOML](https://toml.io/en/) (Tom's Obvious Minimal
Language), and [JSON](https://www.json.org/) (JavaScript Object
Notation). The example data were taken from TOML's website:

{::options parse_block_html="true" /}
<div>
<ul class="nav nav-tabs nav-justified" role="tablist">
<li role="presentation" class="active"><a href="#yaml" aria-controls="YAML" role="tab" data-toggle="tab">YAML</a></li>
<li role="presentation"><a href="#toml" aria-controls="TOML" role="tab" data-toggle="tab">TOML</a></li>
<li role="presentation"><a href="#json" aria-controls="JSON" role="tab" data-toggle="tab">JSON</a></li>
</ul>

<div class="tab-content">

<article role="tabpanel" class="tab-pane active" id="yaml">
~~~
title: Example
owner:
  dob: 1979-05-27 07:32:00-08:00
  name: Tom Preston-Werner
database:
  data:
  - - delta
    - phi
  - - 3.14
  enabled: true
  ports:
  - 8000
  - 8001
  - 8002
  temp_targets:
    case: 72.0
    cpu: 79.5
~~~
{: .language-yaml}
</article>

<article role="tabpanel" class="tab-pane" id="toml">
~~~
# This is a TOML document

title = "Example"

[owner]
name = "Tom Preston-Werner"
dob = 1979-05-27T07:32:00-08:00

[database]
enabled = true
ports = [ 8000, 8001, 8002 ]
data = [ ["delta", "phi"], [3.14] ]
temp_targets = { cpu = 79.5, case = 72.0 }
~~~
{: .language-toml}
</article>

<article role="tabpanel" class="tab-pane" id="json">
~~~
{
    "title": "Example",
    "owner": {
        "dob": "1979-05-27 07:32:00-08:00",
        "name": "Tom Preston-Werner"
    },
    "database": {
	"enabled": true,
	"ports": [
            8000,
            8001,
            8002
        ],
        "data": [
            [
                "delta",
                "phi"
            ],
            [
                3.14
            ]
        ],
        "temp_targets": {
            "case": 72.0,
            "cpu": 79.5
        }
    }
}
~~~
{: .language-json}
</article>
</div>
</div>


## Sidecar metadata strategy

Sometimes, it is desirable to combine binary and text files to represent the same data object. This could be useful if the binary format does not have the possibility to store some metadata, or simply because we want to make the metadata easily readable to anybody (i.e. without requiring potentially uncommon software which can open our binary format).

Let's assume our dataset contains photographs of penguins, collected for research purposes. Suppose that we want to keep the penguin species, picture identifier, and image type in the file name (to make this information easily searchable), but there is additional metadata that may be needed for analysis. We can decide to store the image data in a jpeg file (binary) and the metadata in a yaml file (text). Thus, we will use two files with the same base name and different extensions:

~~~
adelie_087_color.jpeg
adelie_087_color.yaml
~~~

Content of the yaml file:

~~~
species: Adelie
island: Torgersen
penguin_count: 1
sex: MALE
photographer: John
~~~
{: .language-yaml}

As a side note, jpeg files do support quite a lot of metadata ([Exif](https://en.wikipedia.org/wiki/Exif)) but most likely they are neither sufficient nor convenient for our research.

### Describing columns in tabular files

Another place where the sidecar files could come useful is alongside the tabular files (csv/tsv).
Remember the penguin csv table above?
The column names were pretty self-explanatory, but a description could make things even clearer.
Other datasets could probably benefit even more from a description like this (also from the Palmer Penguins dataset):

~~~
species: a factor denoting penguin species (Adélie, Chinstrap and Gentoo)}
island: a factor denoting island in Palmer Archipelago, Antarctica (Biscoe, Dream or Torgersen)}
bill_length_mm: a number denoting bill length (millimeters)}
...
~~~
{: .language-yaml}

You could even go a step further, and for each label provide several pieces of information.
These could include: long name, free-form description, definitions of factor levels (especially useful if they are numeric), links to ontologies.
Using yaml syntax, we could rewrite the above description in the following way:

~~~
species:
  description: a factor denoting penguin species
  levels:
    Adélie: P. adeliae
    Chinstrap: P. antarctica
    Gentoo: P. papua
  termURL: https://www.wikidata.org/wiki/Q9147
bill_length_mm:
  description: a number denoting bill length
  units: mm
~~~
{: .language-yaml}


## [WIP] File / directory structure

Above, we have been dealing mostly with file naming and file types.
What remains is a way these files are organised into directories.
This might seem like a trivial issue, but the way files are organised
affects:
- the ease of manual browsing
- the ease of creating script-based analysis
- the ability to use automated tools which rely on a predefined
  structure

In fact, all of us are probably using some sort of rules to organise
our data. These rules may come from a field-specific or lab-specific
standard, or simply follow common sense. In either case, the overall
logic will probably be similar and try to incorporate (in various
orders) levels such as:
- experiment
- subject or specimen
- data acquisition instance (session, repetition)
- data type or measurement method.

Using a consistent pattern within an experiment makes scripting
easier.  Using a consistent pattern across experiment, or across labs,
saves time on repetitive processing steps and simplifies
collaboration, as it is much easier to figure out what goes where.

### Full versus relative paths

A *full path* (absolute path) contains complete information of a file
location. On Linux and MacOS it starts at the *filesystem root*:

~~~
/home/alice/Documents/project/figures/setup.png
/Users/bob/Documents/project/figures/setup.png
~~~

and on Windows it starts with a drive letter:

~~~
C:\\Users\eve\Documents\project\figures\setup.py
~~~

A *relative path* does not contain all these elements: as the name
suggests it is relative to some location (working directory). In the
Linux and MacOS examples below, if the current working directory is in
the `project` folder, the relative path is:

~~~
figures/setup.py
~~~

This has one important implication. If you move the `project` folder
between computers, the full paths will most likely change. Therefore,
if you write scripts for data analysis, you can make them much more
portable by only using relative paths (which will not depend on where
the `project` folder is) and launching them from the same working
directory on all computers.

> ## Tip: use relative paths
>
> Using relative paths in analysis code guarantees huge gains when moving it
> from one computer to another.
> Avoid hardcoding '/home/Alice', or '/Users/Bob', or 'C://RawData/'.
> You can create the code directory in the top level of the dataset.
> Then, use relative paths, which won't depend on where the dataset is placed.
> Alternatively, if you want the code to be in an entirely separate location,
> you can create a simple configuration file (using one of the text formats
> presented earlier), have your scripts read base paths from there and append
> the relative part. If the base paths change, only the config file will have
> to be edited.
{:.callout}

### Example structure: "research compendium"

A research project will usually contain data, code, and various kinds
of text (protocols, reports, questionnaires, metadata) which need to
be organised in some way. Take for example a "[research
compendium](https://research-compendium.science/)" as described in
[The Turing
Way](https://the-turing-way.netlify.app/reproducible-research/compendia.html). A
minimal example looks like this:

~~~
compendium/
├── data
│   ├── my_data.csv
├── analysis
│   └── my_script.R
├── DESCRIPTION
└── README.md
~~~

- Data and methods are separated into folders
- The required computational environment is described in a designated
  file.
- A README document provides a landing page (it's easy to read by
  itself and most data hosting platforms will recognize it and display
  as formatted text)

A more comprehensive example looks like this:

~~~
compendium/
├── CITATION              <- instructions on how to cite
├── code                  <- custom code for this project
│   ├── analyze_data.R
│   └── clean_data.R
├── data_clean            <- intermediate data that has been transformed
│   └── data_clean.csv
├── data_raw              <- raw, immutable data
│   ├── datapackage.json
│   └── data_raw.csv
├── Dockerfile            <- computing environment recipe
├── figures               <- figures
│   └── flow_chart.jpeg
├── LICENSE               <- terms for reuse
├── Makefile              <- steps to automatically generate the results
├── paper.Rmd             <- text and code combined
└── README.md             <- top-level description
~~~

> ## Side note: cookiecutter
>
> If you find yourself needing to re-create the same structure over
> and over again, you might be interested in
> [cookiecutter](https://cookiecutter.readthedocs.io/). Cookiecutter
> allows you to create files and folders based on a template (using
> your own or one that's available) and user input.

### Example structure: YODA principles

One of the [YODA](https://github.com/myyoda/myyoda) (YODA's Organigram
on Data Analysis) principles says "structure study elements in modular
components to facilitate reuse within or outside the context of the
original study". DataLad provides a `yoda` procedure for creating a
dataset. It creates a few basic elements to start with (and, as a side
note, sets the code directory, changelog and readme to be tracked by
git, and everything else annexed):

~~~
datalad create -c yoda "my_analysis"
tree
~~~
{: .language-bash}

~~~
.
├── CHANGELOG.md
├── code
│   └── README.md
└── README.md
~~~
{: .output}

Note that in addition to a general readme there is a lower-level one
in the code directory. Adding descriptions and explanations for people
using the dataset is always a good idea. This minimal structure can be
built up into something like this (example taken from the [DataLad
Handbook](https://handbook.datalad.org/en/latest/basics/101-127-yoda.html#p1-one-thing-one-dataset)):

~~~
├── ci/                         # continuous integration configuration
│   └── .travis.yml
├── code/                       # your code
│   ├── tests/                  # unit tests to test your code
│   │   └── test_myscript.py
│   └── myscript.py
├── docs                        # documentation about the project
│   ├── build/
│   └── source/
├── envs                        # computational environments
│   └── Singularity
├── inputs/                     # dedicated inputs/, will not be changed by an analysis
│   └─── data/
│       ├── dataset1/           # one stand-alone data component
│       │   └── datafile_a
│       └── dataset2/
│           └── datafile_a
├── outputs/                    # outputs away from the input data
│   └── important_results/
│       └── figures/
├── CHANGELOG.md                # notes for fellow humans about your project
├── HOWTO.md
└── README.md
~~~

In this example, two data collections used as inputs are kept as
independent components. Note that on the level of principles, this
example is actually very similar to the research compendium above.

### Example structure: BIDS

[BIDS](https://bids.neuroimaging.io/) (Brain Imaging Data Structure)
is an emerging standard for neuroimaging data organisation. It
standardises patterns for file naming, directory structure, and
metadata representation. This is part of an example dataset:

~~~
.
├── CHANGES
├── dataset_description.json
├── participants.tsv
├── README
├── sub-01
│   ├── anat
│   │   ├── sub-01_inplaneT2.nii.gz
│   │   └── sub-01_T1w.nii.gz
│   └── func
│       ├── sub-01_task-rhymejudgment_bold.nii.gz
│       └── sub-01_task-rhymejudgment_events.tsv
└── task-rhymejudgment_bold.json
~~~

Few things are worth noticing, as this example combines several
elements discussed previously:

- There is a readme
- File names follow a key-value principle, with underscores and dashes
  (the pattern here is `sub-<label>_[task-<name>]_modality`)
- Usage of text files where possible:
  - tsv files are used to store participant tables and event timings.
  - tson files are used for metadata
- Sidecar metadata strategy: each .nii.gz (compressed binary file with
  imaging data) has an accompanying tsv file with timings of
  experimental events.
