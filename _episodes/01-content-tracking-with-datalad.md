---
title: "Content tracking with DataLad"
teaching: 90
exercises: 0
questions:
- "What does version control mean for datasets"
- "How to create a datalad datasets"
objectives:
- "Cover basics of version control"
- "Work locally to create a dataset"
- "Introduce basic datalad commands"
keypoints:
- "TBD"
---

> ## Dev note
> 
> This chapter should introduce the following datalad commands:
> - datalad help
> - datalad create
> - datalad save
> - datalad run (?)
> 
> And the following things:
> - binary vs text distinction
> - git log (tig)
>
> The content / narrative is based on the [introduction to datalad for Yale](https://handbook.datalad.org/en/latest/code_from_chapters/yale.html) chapter from the handbook.
>
> Work in Progress
{: .callout}

## Setting up

In order to code along, you should have a recent DataLad version.  The
workshop was developed based on DataLad version `0.15`. If you are
unsure about your version of DataLad, you can check it using the
following command:

~~~
datalad --version
~~~
{: .language-bash}

You should have a configured `Git` identity. If you are unsure if you
have configured your Git identity already, you can check if your name
and email are printed to the terminal when you run:

~~~
git config --get user.name
git config --get user.email
~~~
{: .language-bash}

If nothing is returned, you need to configure your Git
identity. (TODO: explain how)

For some examples, you will also need python with pillow library
installed. The best way to do this is to create a virtual environment
(TODO: explain how).

If you are using Binder, everything has been prepared for you.


## Introduction

In this lesson we will gradually build up a dataset, discovering
version control and basic datalad concepts in the process. We will use
images and simple text files as example data.


## How to use DataLad

DataLad is a command line tool and it has a Python API. It is operated
in your terminal using the command line (as done above), or used it in
scripts such as shell scripts, Python scripts, Jupyter Notebooks, and
so forth. We will only use the command line interface during the
workshop.

The first important skill is asking for help. To do so, you can type:

~~~
datalad --help
~~~
{: .language-bash}

This will display a help message, which you can scroll up and down
using arrows and exit with `q`. The first line is a usage note:

~~~
Usage: datalad [global-opts] command [command-opts]
~~~
{: .output}

This means that to use DataLad you will need to type in the main
command (`datalad`) followed by a subcommand. The (sub-)commands are
listed in the help message. The most important for now are `datalad
create` and `datalad save`, and we will explain them in detail during
this lesson.

Both the main command and the subcommand can accept options. Options
usually start with a dash (single letter, e.g. `-m`) or two dashes
(longer names, e.g. `--help` which we have just used). Some commands
will have both the long form and the short form.

You can also request help for a specific command, for example:

~~~
datalad create --help
~~~
{: .language-bash}


## Getting started: create an empty dataset

All actions we do happen in or involve DataLad datasets. Creating a
dataset from scratch is done with the `datalad create` command.

`datalad create` only needs a name, and it will subsequently create a
new directory under this name and instruct DataLad to manage it. Here,
the command also has an additional option, the `-c text2git`
option. With the -c option, datasets can be configured in a certain
way at the time of creation, and `text2git` is a so-called `run
procedure`

~~~
datalad create -c text2git my-dataset
~~~
{: .language-bash}

`bids-data` dataset is now a new directory, and you can change
directories (`cd`) inside it:

~~~
cd my-dataset
~~~

The "text2git" procedure pre-created a useful dataset configuration
that will make version control workflows with files of varying sizes and
types easier.

TODO: inspect what happened inside with ls -a and tig?


## Version control

Version controlling a file means to record its changes over time,
associate those changes with an author, date, and identifier, creating
a lineage of file content, and being able to revert changes or restore
previous file versions. Datalad datasets can version control their
contents, regardless of size. Let's start small, and just create a
`README`.

We will be using a text editor called nano to work without leaving the
command line. You can, of course, use an editor of your
preference. Open the editor by typing `nano` and write the file
content:

~~~
# Example dataset

This is an example datalad dataset.

~~~
{: .language-markdown}

Nano displays the available commands on the bottom. To save (Write
Out) the file, hit Ctrl-O, type the file name (`README.md`), and hit
enter. Then, use Ctrl-X to exit.

`datalad status` can report on the state of a dataset, and we will use
it a lot. As we added a new file, the README show up as being
*untracked* if you run it:

~~~
datalad status
~~~
{: .language-bash}

~~~
TODO
~~~
{: .output}

In order to save a modification in a dataset use the `datalad save`
command.  `datalad save` will save the current state of your dataset:
It will save both modifications to known files and yet untracked
files. The `-m/--message` option lets you attach a concise summary of
your changes. Such a *commit message* makes it easier for others and
your later self to understand a dataset's history:

~~~
datalad save -m "Add a short README"
~~~
{: .language-bash}

TODO: see that it got recorded in history

Let's add some "image data", represented here by jpeg images. For demonstration purposes, we will use photos available with a permissive license from Unsplash. Start by creating a directory for our data. Let's call it inputs, to make it clear what it represents.

~~~
mkdir -p inputs/images
~~~

Then, let's put a file in it. To avoid leaving terminal, we will use the linux `wget` command. This is just for convenience - an effect would be the same if we opened the link in the browser and saved the file from there.

~~~
wget --content-disposition --directory-prefix=inputs/images/ "https://unsplash.com/photos/3Xd5j9-drDA/download?force=true"
~~~
{: .language-bash}

While we're at it, lets open the readme file (`nano README.md`) and
make a note on how we organise the data (save and exit with Ctrl-O,
enter, Ctrl-X):

~~~
# Example dataset

This is an example datalad dataset.

Raw data is kept in `inputs` folder:
- penguin photos are in `inputs/images`

~~~
{: .language-markdown}

Okay, time to check the `datalad status`:

~~~
TODO
~~~
{: .output}

The README file now differs from its last known state, and it shows up
as being *modified*, while the image is listed as new. This is a good
moment to record these changes. Note that `datalad save` will save
**all** modifications in the dataset at once! If you have several
modified files, you can supply a path to the file or files you want to
save. We will do this, and record two separate changes:

~~~
datalad save -m "Add first penguin image" inputs/images/derek-oyen-3Xd5j9-drDA-unsplash.jpg
datalad save -m "Update readme" README.md
~~~
{: .language-bash}

We can see that these changes got recorded with `tig`.

For now, we have manually downloaded the file and saved it to the
dataset. However, saving a file from a URL is a common scenario,
whether we are using a public repository or a local network
storage. For that, datalad has a `datalad addurls` method. Let's use
it to download another file:

TO BE CONTINUED...
