---
title: "Content tracking with DataLad"
teaching: 30
exercises: 60
questions:
- "What does version control mean for datasets?"
- "How to create a DataLad dataset?"
objectives:
- "Learn basics of version control"
- "Work locally to create a dataset"
- "Practice basic DataLad commands"
keypoints:
- "With version control, lineage of all files is preserved"
- "You can record and revert changes made to the dataset"
- "DataLad can be used to version control a dataset and all its files"
- "You can manually save changes with `datalad save`"
- "You can use `datalad download-url` to preserve file origin"
- "You can use `datalad run` to capture outputs of a command"
- "\"Large\" files are annexed, and protected from accidental modifications"
---

## Introduction

Alice is a PhD student. She works on a fairly typical research
project, which involves collection and processing of data. The exact
kind of data she works with is not relevant for us, what's relevant is
that getting from the first sample to the final result is a cumulative
process.

When Alice is working locally, she likes to have an automated record
of when a given file was last changed, where it came from, what input
files were used to generate a given output, or why some things were
done. Even if she won't be sharing the data with anyone, these records
might be essential for her future self, when she needs to return to
the project after some time. Moreover, Alice's project is exploratory,
and she often makes large changes to her analysis scripts. She enjoys
the comfort of being able to return all files to a previously recorded
state if she makes a mistake or figures out a better solution. This is
*local* version control.

Alice's work is not confined to a single computer. She has a laptop
and a desktop, and she uses a remote server to run some time-consuming
analysis steps. She likes having an automatic and efficient way to
synchronise her project files between these places. Moreover, some of
the data within the project is collected or analysed by her
colleagues, possibly from another team. She uses the same mechanism to
synchronise the data with a centralized storage (e.g. network storage
owned by her lab), preserving origin and authorship of files, and
combining simultaneous contributions. This is *distributed* version
control.

Finally, Alice wants to have a mechanism to publish, completely or
selectively, her raw data, or outputs, or both. Or to work selectively
with a large collection of files - keeping all of them on a server,
and only fetching some to her laptop.

These are typical data management issues which we will touch upon during
this workshop. From the technical point of view we will be using
DataLad, a data management multi-tool that can assist you in handling
the entire life cycle of digital objects. It is a command-line tool,
free and open source, and available for all major operating
systems. The first module will deal only with local version control. In the
next one, we will set the technical details aside and talk about good
practices in file management. Later during the workshop we will
discuss distributed version control, publish a dataset, and see what
it looks like from the perspective of data consumers. In the last
module we will talk about more complex scenarios with linked datasets.

In this lesson we will gradually build up an example dataset,
discovering version control and basic DataLad concepts in the
process. Along the way, we will introduce basic DataLad commands - a
technical foundation for all the operations outlined above. Since
DataLad is agnostic about the kind of data it manages, we will use
photographs and text files to represent our dataset content. We will
add these files, record their origin, make changes, track these
changes, and undo things we don't want to keep.


## Setting up

In order to code along, you should have a recent DataLad version. The
workshop was developed based on DataLad version `0.16`. Installation
instructions are included in the [Setup]({{ page.root }}{% link
setup.md %}) page. If you are unsure about your version of DataLad,
you can check it using the following command:

~~~
datalad --version
~~~
{: .language-bash}

You should should have a configured Git identity, consisting of your
name and email (and the command above will display a complaint if you
don't). That identity will be used to identify you as the author of
all dataset operations. If you are unsure if you have configured your
Git identity already, you can check if your name and email are printed
to the terminal when you run:

~~~
git config --get user.name
git config --get user.email
~~~
{: .language-bash}

If nothing is returned (or the values are incorrect), you can set them
with:

~~~
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com
~~~
{: .language-bash}

With the `--global` option, you need to do this once on a given
system, as the values will be stored for your user account. Of course
you can change or override them later.

Note for participants using their own computers. Some examples used to
illustrate data processing require python with pillow library. If you
are using a virtual environment, now is a good time to activate it
(e.g. `source ~/.venvs/rdm-workshop/bin/activate`). You'll find more
details in the [Setup]({{ page.root }}{% link setup.md %}) page.


## How to use DataLad

DataLad is a command line tool and it has a Python API. It is operated
in your terminal using the command line (as done above), or used in
scripts such as shell scripts, Python scripts, Jupyter Notebooks, and
so forth. We will only use the command line interface during the
workshop.

The first important skill in using a program is asking for help. To do
so, you can type:

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
command (`datalad`) followed by a sub-command. The (sub-)commands are
listed in the help message. The most important for now are `datalad
create` and `datalad save`, and we will explain them in detail during
this lesson.

Both the main command and the sub-command can accept options. Options
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
option. With the `-c` option, datasets can be pre-configured in a
certain way at the time of creation, and `text2git` is one of the
available *run procedures* (later we'll explain why we chose to use it
in this example):

~~~
datalad create -c text2git my-dataset
~~~
{: .language-bash}

~~~
[INFO   ] Creating a new annex repo at /home/bob/Documents/rdm-workshop/my-dataset
[INFO   ] Running procedure cfg_text2git
[INFO   ] == Command start (output follows) =====
[INFO   ] == Command exit (modification check follows) =====
create(ok): /home/bob/Documents/rdm-workshop/my-dataset (dataset)
~~~
{: .output}

The last output line confirms that the create operation was
successful. Now, `my-dataset` is a new directory, and you can change
directories (`cd`) inside it:

~~~
cd my-dataset
~~~
{: .language-bash}

Let's inspect what happened. Let's start by listing all contents,
including hidden ones (on UNIX-like system, files or folders starting
with a dot are treated as hidden): 

~~~
ls -a
~~~
{: .language-bash}

~~~
.  ..  .datalad  .git  .gitattributes
~~~
{: .output}

The `.` and `..` represent current and parent directory,
respectively. More interestingly, there are two hidden folders,
`.datalad` and `.git` as well as a hidden `.gitattributes` file. They
are essential for dataset functioning, but typically we have no need
to touch them.

Next, we can invoke `tig`, a tool which we will use to view the
dataset history. Tig displays a list of *commits* - a record of
changes made to the document. Each commit has a date, author, and
description, and is identified by a unique 40-character sequence
(displayed at the bottom) called *shasum* or *hash*. You can move up
and down the commit list using up and down arrows on your keyboard,
use enter to display commit details, and `q` to close detail view or
Tig itself.

We can see that DataLad has already created two commits on our
behalf. They are shown with the most recent on top:

~~~
tig
~~~
{: .language-bash}

~~~
2021-10-18 16:58 +0200 John Doe o [main] Instruct annex to add text files to Git
2021-10-18 16:58 +0200 John Doe I [DATALAD] new dataset
~~~
{: .output}

## Version control

Version controlling a file means to record its changes over time,
associate those changes with an author, date, and identifier, creating
a lineage of file content, and being able to revert changes or restore
previous file versions. DataLad datasets can version control their
contents, regardless of size. Let's start small, and just create a
`README`.

We will use a text editor called nano to work without leaving the
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
it a lot. As we added a new file, `README` will show up as being
*untracked* if you run `datalad status`:

~~~
datalad status
~~~
{: .language-bash}

~~~
untracked: README.md (file)
~~~
{: .output}

In order to save a modification in a dataset use the `datalad save`
command.  `datalad save` will save the current state of your dataset:
It will save both, modifications to known files and yet untracked
files. The `-m/--message` option lets you attach a concise summary of
your changes. Such a *commit message* makes it easier for others and
your later self to understand a dataset's history:

~~~
datalad save -m "Add a short README"
~~~
{: .language-bash}

Let's verify that it got recorded in history:

~~~
tig
~~~
{: .language-bash}

~~~
2021-10-18 17:20 +0200 John Doe o [main] Add a short README
2021-10-18 16:58 +0200 John Doe o Instruct annex to add text files to Git
2021-10-18 16:58 +0200 John Doe I [DATALAD] new dataset
~~~
{: .output}

Let's add some "image data", represented here by jpeg images. For demonstration
purposes, we will use photos available with a permissive license from
[Unsplash](https://unsplash.com/). Start by creating a directory for your data.
Let's call it *inputs/images*, to make it clear what it represents.

~~~
mkdir -p inputs/images
~~~

Then, let's put a file in it. To avoid leaving terminal, we will use the Linux
`wget` command. This is just for convenience - the effect would be the same if
we opened the link in the browser and saved the file from there.
The `-O` option specifies the output file - since this is a photo of chinstrap
penguins, and we may expect multiple of those, let's name the file `chinstrap_01.jpg`.
We are specyfying the URL as a string (i.e. in quotation marks), to avoid
confusing our computer with the `?` character, which can be interpreted as a
placeholder for any character.

~~~
wget -O inputs/images/chinstrap_01.jpg "https://unsplash.com/photos/3Xd5j9-drDA/download?force=true"
~~~
{: .language-bash}

We can view the current file / folder structure by using the Linux
`tree` command:

~~~
tree
~~~
{: .language-bash}

~~~
.
├── inputs
│   └── images
│       └── chinstrap_01.jpg
└── README.md
~~~
{: .output}

While we're at it, lets open the readme file (`nano README.md`) and
make a note on how we organize the data. Note the unobtrusive markdown
syntax for headers, monospace, and list items, which may be used for
rendering by software or websites. With nano, save and exit with:
Ctrl-O, enter, Ctrl-X:

~~~
# Example dataset

This is an example DataLad dataset.

Raw data is kept in `inputs` folder:
- penguin photos are in `inputs/images`

~~~
{: .language-markdown}

Okay, time to check the `datalad status`:

~~~
untracked: inputs (directory)
 modified: README.md (file)
~~~
{: .output}

The inputs directory has some new contents, and it is shown as
*untracked*.  The README file now differs from its last known state,
and it shows up as *modified*. This is a good moment to record these
changes. Note that `datalad save` would save **all** modifications in
the dataset at once! If you have several modified files, you can
supply a path to the file or files you want to save. We will do it this
way, and record two separate changes:

~~~
datalad save -m "Add first penguin image" inputs/images/chinstrap_01.jpg
datalad save -m "Update readme" README.md
~~~
{: .language-bash}

We can see that these changes got recorded with `tig`.

For now, we have manually downloaded the file and saved it to the
dataset. However, saving a file from an URL is a common scenario,
whether we are using a public repository or a local network
storage. For that, DataLad has a `datalad download-url` method. Let's
use it to download another file (this command also provides the `-O`
option to specify an output path, similar to wget):

~~~
datalad download-url -O inputs/images/chinstrap_02.jpg "https://unsplash.com/photos/8PxCm4HsPX8/download?force=true"
~~~
{: .language-bash}

Afterwards, `datalad status` shows us that there is nothing to
save. The `download-url` command not only downloaded the file, but
also performed a `datalad save` on our behalf. We can use `tig` to
inspect the commit message:

~~~
[DATALAD] Download URLs
	
URLs:
  https://unsplash.com/photos/8PxCm4HsPX8/download?force=true
~~~
{: .output}

This is a notable improvement compared to the previous image, because
in addition to recording the addition of the picture we also stored
its source. What's more, DataLad is aware of that source, and has all
the information needed to remove and reobtain the file on
demand... but that's another topic altogether.

To practice saving changes and to make our example dataset more
similar to the real-life datasets, let's add some more files, this
time in the form of sidecar metadata. Let's suppose we want to store
the picture author, license under which the file is available, and,
let's say, the number of penguins visible in the photo. For each
image, we will create a yaml file (a simple text file following a set
of rules to store variables) with the same name but different
extension:

~~~
nano inputs/images/chinstrap_01.yaml
~~~
{: .language-bash}

~~~
photographer: Derek Oyen
license: Unsplash License
penguin_count: 3
~~~
{: .language-yaml}

~~~
nano inputs/images/chinstrap_02.yaml
~~~
{: .language-bash}

~~~
photographer: Derek Oyen
license: Unsplash License
penguin_count: 2
~~~
{: .language-yaml}

We can use the already familiar `datalad save` command to record
these changes (addition of two files):

~~~
datalad save -m "Add sidecar metadata to photos"
~~~
{: .language-bash}

### Breaking things (and repairing them)

A huge appeal of version control lies in the ability to return to a
previously recorded state, which enables experimentation without
having to worry about breaking things. Let's demonstrate by breaking
things on purpose. Open the `README.md` file, remove most of its
contents and save. You can use `cat README.md` to display the file
contents and make sure that they are, indeed, gone. The `datalad
status` reports that the file changed, but the change has not been
saved in the dataset history:

~~~
datalad status
~~~
{: .language-bash}

~~~
modified: README.md (file)
~~~
{: .output}

In this situation, you can restore the file to its previously recorded
state by running:

~~~
git restore README.md
~~~
{: .language-bash}

Note that `git` is the program used by DataLad under the
hood for version control. While most dataset operations can be
performed using `datalad` commands, some will require calling `git`
directly. After running `git restore`, you can use `datalad status` to
see that the dataset is now clean, and `cat README.md` to see that the original
file contents are back as if nothing happened - disaster
averted. Finally, check `tig` to see that the dataset history remained
unaffected.

Now, let's take things one step further and actually `datalad save`
some undesired changes. Open the `README.md`, wreak havoc, and save
it:

~~~
nano README.md
~~~
{: .language-bash}

~~~
# Example dataset

HAHA all description is gone
~~~

This time we are committing these changes to the dataset history:

~~~
datalad save -m "Break things"
~~~
{: .language-bash}

The file was changed, and the changes have been committed. Luckily, `git`
has a method for undoing such changes, `git revert`, which can work
even if subsequent `save` operations have been performed on the
dataset. To call it, we need to know the *commit hash* (unique
identifier) of the change which we want to revert. It is displayed by
`tig` at the bottom of the window and looks like this:
`8ddaaad243344f38cd778b013e7e088a5b2aa11b` (note: because of the
algorithm used by `git`, yours will be different). Don't worry, we only
need the first couple characters. Find your commit hash and call `git
revert` taking the first few characters (seven should be plenty):

~~~
git revert --no-edit 8ddaaad
~~~
{: .language-bash}

With the `--no-edit` option, `git revert` will create a default commit
message; without it it would open your default editor and let you
edit the commit message. Like previously, after reverting the changes, `datalad
status` shows that there is nothing to save and `cat README.md` proves
that the removed file contents are back. This time, `tig` shows that
`git revert` created a new commit that
reverted the changes (note that recent commits can also be completely removed
from history with `git reset` but this is beyond the scope of this
lesson).

### Data processing

We have demonstrated building a dataset history by collecting data and
changing it manually. Now it is time to demonstrate some script-based
data processing. Let's assume that our project requires us to convert
the original files to greyscale. We can do this with a simple Python
script. First, let's create two new directories to keep code and
outputs, i.e. processing results, in designated places:

~~~
mkdir code
mkdir -p outputs/images_greyscale
~~~
{: .language-bash}

Now, let's "write" our custom script. You can download it using wget
(below), or copy its content from
[here](https://github.com/psychoinformatics-de/rdm-course/blob/gh-pages/data/greyscale.py)
and then save it as part of the dataset:

~~~
wget -O code/greyscale.py https://github.com/psychoinformatics-de/rdm-course/raw/gh-pages/data/greyscale.py
datalad save -m "Add an image processing script"
~~~
{: .language-bash}

This script for greyscale conversion takes two arguments, `input_file`
and `output file`. You can check this with `python code/greyscale.py
--help`. Let's apply it for the first image, and place the output in the
`outputs/images_greyscale` directory, slightly changing the name:

~~~
python code/greyscale.py inputs/images/chinstrap_01.jpg outputs/images_greyscale/chinstrap_01_grey.jpg
~~~
{: .language-bash}

Note that our working directory is in the root of the dataset, and we
are calling the script using *relative paths* (meaning that they are
relative to the working directory, and do not contain the full path to
any of the files). This is a good practice: the call looks the same
regardless of where the dataset is on our drive.

You should be able to verify that the output file has been created and
that the image is, indeed, converted to greyscale. Now all that
remains is to save the change in the dataset:

~~~
datalad save -m "Convert the first image to greyscale"
~~~
{: .language-bash}

Let's take a look at our history with `tig`. It already looks pretty
good: we have recorded all our operations. However, this record is
only as good as our descriptions. We can take it one step further.

Datalad has the ability to record the exact command which was used,
and all we have to do for this is to prepend `datalad run` to our command. We can
also provide the commit message to `datalad run`, just as we could with
`datalad save`. Let's try this on the other image:

~~~
datalad run -m "Convert the second image to greyscale" python code/greyscale.py inputs/images/chinstrap_02.jpg outputs/images_greyscale/chinstrap_02_grey.jpg
~~~
{: .language-bash}

As we can see, `datalad run` executes the given command and follows
that by automatically calling `datalad save` to store all changes
resulting from this command in the dataset. Let's take a look at the
full commit message with `tig` (highlight the commit you want to see
and press enter):

~~~
[DATALAD RUNCMD] Convert second image to grayscale

=== Do not change lines below ===
{
"chain": [],
"cmd": "python code/greyscale.py inputs/images/chinstrap_02.jpg outputs/images_greyscale/chinstrap_02_grey.jpg",
"dsid": "b4ee3e2b-e132-4957-9987-ca8aad2d8dfc",
"exit": 0,
"extra_inputs": [],
"inputs": [],
"outputs": [],
"pwd": "."
}
^^^ Do not change lines above ^^^
~~~

There is some automatically generated text, and inside we can easily
find the command that was executed (under `"cmd"` keyword). The record
is stored using json formatting, and as such can be read not just by
us, but also by DataLad. This is very useful: now we will be able to
rerun the exact command if, for example, input data gets changed, the
script gets changed, or we decide to remove the outputs. We won't try
that now, but the command to do so is `datalad rerun`.

### Locking and unlocking

Let's try something else: editing an image which already exists. We
have done so with text files, so why should it be different?

Let's try doing something nonsensical: using the first input image
(chinstrap_01.jpg) and writing its greyscale version
onto the second output image (chinstrap_02_grey.jpg). Of
course the computer doesn't know what makes sense - the only thing
which might stop us is that we will be writing to a file which already
exists. This time we will skip `datalad run` to avoid creating a record
of our little mischief:

~~~
python code/greyscale.py inputs/images/chinstrap_01.jpg outputs/images_greyscale/chinstrap_02_grey.jpg
~~~
{: .language-bash}

~~~
Traceback (most recent call last):
  File "/home/bob/Documents/rdm-warmup/example-dataset/code/greyscale.py", line 20, in <module>
    grey.save(args.output_file)
  File "/home/bob/Documents/rdm-temporary/venv/lib/python3.9/site-packages/PIL/Image.py", line 2232, in save
    fp = builtins.open(filename, "w+b")
PermissionError: [Errno 13] Permission denied: 'outputs/images_greyscale/chinstrap_02_grey.jpg'
~~~
{: .output}

Something went wrong: `PermissionError:  [Errno 13] Permission denied` says the
message. What happened? Why don't we have the permission to change the
existing output file? Why didn't we run into the same problems when
editing text files? To answer that question we have to introduce the
concept of *annexed files* and go back to the moment when we created
our dataset.

DataLad uses two mechanisms to control files: `git` and
`git-annex`. This duality exists because it is not possible to store
large files in `git`. While `git` is especially good at tracking text
files (and can also handle files other than text) it would quickly run
into performance issues. We will refer to the files controlled by
`git-annex` as *annexed files*. There are no exact rules for what is a
*large* file, but a boundary between "regular" and annexed files has
to be drawn somewhere.

Let's look at the first two commit messages in `tig`. The second says:

~~~
o Instruct annex to add text files to Git
~~~
{: .output}

Remember how we created the dataset with `datalad create -c text2git
my-dataset`? The `-c text2git` option defined the distinction in a
particular way: text files are controlled with `git`, other (binary)
files are *annexed*. By default (without `text2git`) all files would be
annexed. There are also other predefined configuration options, and it's
easy to tweak the setting manually (however, we won't do this in this
tutorial). As a general rule you will probably want to hand some text
files to git (code, descriptions), and annex others (especially those
huge in size or number). In other words, while `text2git` works well
for our example, you should not treat it as the default approach.

One essential by-product of the above distinction is that annexed
files are write-protected to prevent accidental modifications:

![git vs git-annex]({{ page.root }}/fig/git_vs_gitannex.svg)

If we do want to edit the annexed file, we have to unlock it:

~~~
datalad unlock outputs/images_greyscale/chinstrap_02_grey.jpg
~~~
{: .language-bash}

Now, the operation should succeed:

~~~
python code/greyscale.py inputs/images/chinstrap_01.jpg outputs/images_greyscale/chinstrap_02_grey.jpg
~~~
{: .language-bash}

We can open the image to see that it changed, and check:

~~~
datalad status
~~~
{: .language-bash}

~~~
modified: outputs/images_greyscale/chinstrap_02-grey.jpg (file)
~~~
{: .output}

The file will be locked again after running `datalad save`:

~~~
datalad save -m "Make a mess by overwriting"
~~~

We could revert the changes we just saved, but let's overwrite the file
using correct inputs instead, to demonstrate another feature of
`datalad run`. The sequence of actions we just did (unlock - change -
save) is not uncommon, and `datalad run` has provisions to make all
three things happen at once, without the explicit `unlock` call. What
we need is the `--output` argument to tell datalad to prepare the
given file for writing (unlock it). Additionally, we will also use the
`--input` option (which tells datalad that this file is needed to run
the command). Although `--input` is not necessary in the current
example, we will introduce it for the future. Finally, to avoid
repetition, we will use `{inputs}` and `{outputs}` placeholder in the
run call.

~~~
datalad run \
    --input inputs/images/chinstrap_02.jpg \
    --output outputs/images_greyscale/chinstrap_02_grey.jpg \
    -m "Convert the second image again" \
    python code/greyscale.py {inputs} {outputs}
~~~
{: .language-bash}

~~~
[INFO   ] Making sure inputs are available (this may take some time)
unlock(ok): outputs/images_greyscale/chinstrap_02_grey.jpg (file)
[INFO   ] == Command start (output follows) ===== 
[INFO   ] == Command exit (modification check follows) ===== 
add(ok): outputs/images_greyscale/chinstrap_02_grey.jpg (file)
~~~
{: .output}

Success! Time to look at the images, and then check the dataset
history with `tig`. The commit message contains the following:

~~~
[DATALAD RUNCMD] Convert the second image again

=== Do not change lines below ===
{
 "chain": [],
 "cmd": "python code/greyscale.py '{inputs}' '{outputs}'",
 "dsid": "b4ee3e2b-e132-4957-9987-ca8aad2d8dfc",
 "exit": 0,
 "extra_inputs": [],
 "inputs": [
  "inputs/images/chinstrap_02.jpg"
 ],
 "outputs": [
  "outputs/images_greyscale/chinstrap_02_grey.jpg"
 ],
 "pwd": "."
}
^^^ Do not change lines above ^^^
~~~
{: .output}
	
### Making some more additions

Let's make a few more changes to the dataset. We will return to it in
the workshop module on remote collaboration. As an exercise, do the
following steps using DataLad commands:

- Download the king penguin image from this url:
  `https://unsplash.com/photos/8fmTByMm8wE/download?force=true`
  and save it as `inputs/images/king_01.jpg`
- Create a yaml file with the following content and save changes in the
  dataset:
  ~~~
  photographer: Ian Parker
  license: Unsplash License
  penguin_count: 5
  ~~~
  {: .language-yaml}
- Add the following acknowledgments at the end of the README:
  ~~~
  ## Credit
  
  Photos by [Derek Oyen](https://unsplash.com/@goosegrease)
  and [Ian Parker](https://unsplash.com/@evanescentlight)
  on [Unsplash](https://unsplash.com)
  ~~~
  {: .language-markdown}

> ## Solution
> 
> Download file using `download-url`:
> ```
> datalad download-url \
>   -m "Add third image" \
>   -O inputs/images/king01.jpg \
>   "https://unsplash.com/photos/8fmTByMm8wE/download?force=true"
> ```
> {: .language-bash}
> 
> Create the yaml file, e.g. using nano, and update the dataset:
> ```
> nano inputs/images/king_01.yaml
> # paste the contents and save
> datalad save -m "Add a description to the third picture"
> ```
> Edit the readme file, e.g. using nano, and update the dataset:
> ```
> nano README.md
> # paste the contents and save
> datalad save -m "Add credit to README"
> ```
{: .solution}
