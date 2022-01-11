---
title: "Dataset management"
teaching: 45
exercises: 45
questions:
- How to manage data on a dataset level?
- How to link two datasets?
- When can multi-level datasets be useful?
objectives:
- Demonstrate dataset nesting (subdatasets)
- Investigate a nested dataset "in the wild"
- Create a simple model of a nested dataset
keypoints:
- A dataset can contain other datasets
- The super- and sub-datasets have separate histories.
- The superdataset only contains a reference to a specific commit in the subdataset's history
---

## Introduction

The simplest analysis takes some input data, and produces output data.
However, the same input dataset can be used in multiple analyses, and output (e.g. transformed or preprocessed) data produced by one analysis may serve as input for subsequent analysis.

To address these usecases, DataLad provides a mechanism for linking datasets (Image from DataLad Handbook):

![Subdataset linkage]({{ page.root }}/fig/linkage_subds.svg)
{: .image-with-shadow}

You may be interested in subdatasets if:
- there is a logical need to make your data modular (eg. raw data - preprocessing - analysis - paper)
- there is a technical need to do so (with data in the order of hundreds of thousands of files, splitting them into subdatasets will improve performance).

In this module, we will take a closer look at this mechanism.

## Real-life example: using nested datasets

We will work with the [Highspeed analysis](https://github.com/lnnrtwttkhn/highspeed-analysis) dataset containing data and code from:

> Wittkuhn, L., Schuck, N.W.
> Dynamics of fMRI patterns reflect sub-second activation sequences and reveal replay in human visual cortex. Nat Commun 12, 1795 (2021).
> https://doi.org/10.1038/s41467-021-21970-2

Let's start by inspecting the dataset's GitHub page.
Observe the following.
- The dataset is hosted on GitHub, a popular platform for git storage *without annexed content*.
  Publishing the dataset on GitHub and file content elsewhere is a common scenario for DataLad.
- The README provides an overview of the content, hinting that the `data` folder contains input datasets.
- If you navigate to `code`, you will see that most files with R code are there, hosted on GitHub.
- If you navigate to `data`, you will see links that take you to *other GitHub repositories* (technical detail - this is how GitHub displays submodules).
- Side note, if you go to one of the data directories, and navigate all the way to a single `.nii.gz` or `png` file, you will see GitHub showing that it is a symlink, not an actual data file.
- Try for example navigating to `highspeed-decoding/decoding/sub-01/plots/sub-01_run-01_tmap_masked.png`: it's a symbolic link pointing to `.git/annex/objects...`. Let's see if we have the ability to obtain this file through DataLad.

Both the README content and the existence of submodules told us that we are dealing with subdatasets.
But we could learn the same through DataLad after installing the dataset.
Let's install:

~~~
datalad clone https://github.com/lnnrtwttkhn/highspeed-analysis.git
~~~
{: .language-bash}

~~~
[INFO   ] scanning for annexed files (this may take some time)
[INFO   ] Remote origin not usable by git-annex; setting annex-ignore
[INFO   ] https://github.com/lnnrtwttkhn/highspeed-bids.git/config download failed: Not Found
[INFO   ] access to 1 dataset sibling keeper not auto-enabled, enable with:
| 		datalad siblings -d "/home/alice/Documents/rdm-course/highspeed-analysis" enable -s keeper
install(ok): /home/alice/Documents/rdm-course/highspeed-analysis (dataset)
~~~
{: .output}

Now, let's change directory into the dataset and ask about its subdatasets:

~~~
cd highspeed-bids
datalad subdatasets
~~~
{: .language-bash}

~~~
subdataset(ok): code/raincloud-plots (dataset)
subdataset(ok): data/bids (dataset)
subdataset(ok): data/decoding (dataset)
~~~
{: .output}

Our goal is to retrieve a file from the "decoding" (sub)dataset.

If we try to list its contents, we see... nothing:

~~~
ls data/decoding/
~~~
{: .language-bash}

~~~
~~~
{: .output}

Think of it this way: subdataset is a logically separate entity, and
you probably don't need its contents from the outset.

To work with a subdataset, we need to install it.
Subdatasets can be installed with the already familiar `datalad get` command.
In this case we want to use `--no-data` to only obtain placeholders for annexed files.
Without the option we would start downloading what could potentially be a ton of files.
Instead, we'll just get an overview, and `datalad get` the specific file afterwards.

~~~
datalad get --no-data data/decoding
~~~
{: .language-bash}

~~~
[INFO   ] scanning for annexed files (this may take some time)
[INFO   ] Remote origin not usable by git-annex; setting annex-ignore
[INFO   ] https://github.com/lnnrtwttkhn/highspeed-decoding.git/config download failed: Not Found
install(ok): /home/jupyter-mslw/highspeed-analysis/data/decoding (dataset) [Installed subdataset in order to get /home/alice/Documents/rdm-course/highspeed-analysis/data/decoding]
~~~
{: .output}

Now we can list the contents:

~~~
ls data/decoding
~~~
{: .language-bash}

~~~
CHANGELOG.md  LICENSE  README.md  bids  code  datacite.yml  decoding  fmriprep  glm  highspeed-decoding.Rproj  logs  masks
~~~
{: .output}

Let's get the file we wanted (first plot from the first subject):

~~~
datalad get data/decoding/decoding/sub-01/plots/sub-01_run-01_tvalue_distribution.png
~~~
{: .language-bash}

~~~
get(ok): data/decoding/decoding/sub-01/plots/sub-01_run-01_tmap_masked.png (file) [from gin...]
~~~
{: .output}

We successfully obtained the file from the subdataset and can view it.

Why it matters?
The file we opened was, seemingly, a diagnostic image for visual quality control.
In a high-level dataset (statistical analysis, paper...) we are probably not very interested in the raw data.
However, it's convenient to have an easy way to retrieve the low-level dataset when needed.

## Toy example: creating subdatasets

Let's try to build a nested dataset from scratch.
We will stick with the theme set in the previous episodes.
This time, our goal is to write a short report on penguins, based on the data made available by [Palmer Station Antarctica LTER](https://pal.lternet.edu/) and dr Kristen Gorman (see also: [palmerpenguins R dataset](https://allisonhorst.github.io/palmerpenguins/)).
Let's say we want to investigate the relationship between flipper length and body mass in three different penguin species.

We will:
- Create a main dataset for our report, and create a subdataset within to store inputs
- Populate the subdataset with data
- Run an analysis, producing a figure in the main dataset
- Write our "report"

This is the folder structure we're aiming for:

~~~
penguin-report/
├── figures
│   └── lmplot.png
├── inputs
│   ├── adelie.csv
│   ├── chinstrap.csv
│   └── gentoo.csv
├── process.py
├── report.html
└── report.md
~~~

### Create a dataset within a dataset

Let's start by creating our main dataset and changing our working directory.
We're using the text2git configuration again:

~~~
datalad create -c text2git penguin-report
cd penguin-report
~~~
{: .language-bash}

Then, let's create a subdataset, this time without `text2git`, and name it `inputs`.
The `-d`/`--dataset` option is very important: it tells DataLad to create a new subdataset and register it in the given parent dataset.

~~~
datalad create -d . inputs
~~~
{: .language-bash}

~~~
[INFO   ] Creating a new annex repo at /home/jupyter-mslw/penguin-report/inputs
add(ok): inputs (file)
add(ok): .gitmodules (file)
save(ok): . (dataset)
create(ok): inputs (dataset)
~~~
{: .output}

At this point it's worthwhile checking `tig` to see the nature of the last change.
The command created one commit, titled `[DATALAD] Recorded changes`.
If we view the details of the commit (hit Enter), we see that the parent dataset was affected in two places:
an entry was created in the hidden `.gitmodules` files, and for the `inputs` folder, a *subproject commit* was recorded.
This is all the information the parent dataset stores about the subdataset.

~~~
    [DATALAD] Recorded changes
---
 .gitmodules | 4 ++++
 inputs      | 1 +
 2 files changed, 5 insertions(+)

diff --git a/.gitmodules b/.gitmodules
new file mode 100644
index 0000000..d5cf43d
--- /dev/null
+++ b/.gitmodules
@@ -0,0 +1,4 @@
+[submodule "inputs"]
+       path = inputs
+       url = ./inputs
+       datalad-id = 16d66558-93d5-415b-b059-af680f2040fc

diff --git a/inputs b/inputs
new file mode 160000
index 0000000..b9c6cc5
--- /dev/null
+++ b/inputs
@@ -0,0 +1 @@
+Subproject commit b9c6cc5fd918a8aba3aa3e06c5e1c7fdae176ba8
~~~
{: .output}


For the following commands we will be explicit with the `-d`/`--dataset` argument, and always specify on which dataset we want to act.

### Populate the input dataset

#### Download contents

In our input dataset we want to include tabular data with size measurements of Adelie, Gentoo, and Chinstrap penguins.

~~~
datalad download-url -d inputs -m "Add Adelie data" -O inputs/adelie.csv https://pasta.lternet.edu/package/data/eml/knb-lter-pal/219/5/002f3893385f710df69eeebe893144ff
datalad download-url -d inputs -m "Add Gentoo data" -O inputs/gentoo.csv https://pasta.lternet.edu/package/data/eml/knb-lter-pal/220/7/e03b43c924f226486f2f0ab6709d2381
datalad download-url -d inputs -m "Add Chinstrap data" -O inputs/chinstrap.csv https://pasta.lternet.edu/package/data/eml/knb-lter-pal/221/8/fe853aa8f7a59aa84cdd3197619ef462
~~~
{: .language-bash}

Let's preview one csv file to see what content we're dealing with.
An easy way to do so without leaving the command line is with the `head` command, which will print the first n lines of a text file (default n=10):

~~~
head -n 2 inputs/adelie.csv
~~~
{: .language-bash}

~~~
studyName,"Sample Number",Species,Region,Island,Stage,"Individual ID","Clutch Completion","Date Egg","Culmen Length (mm)","Culmen Depth (mm)","Flipper Length (mm)","Body Mass (g)",Sex,"Delta 15 N (o/oo)","Delta 13 C (o/oo)",Comments
PAL0708,1,"Adelie Penguin (Pygoscelis adeliae)",Anvers,Torgersen,"Adult, 1 Egg Stage",N1A1,Yes,2007-11-11,39.1,18.7,181,3750,MALE,,,"Not enough blood for isotopes."
~~~
{: .output}

If you are working in JupyterLab, you can conveniently preview the file by double-clicking it in the file browser.

#### See where changes got recorded

Checking the history with `tig` shows us that there is no record of these commits ("Add ... data") in the parent dataset!

~~~
tig
~~~
{: .language-bash}

~~~
2022-01-11 10:40 Unknown o Unstaged changes
2022-01-11 10:19 Alice   o [master] [DATALAD] Recorded changes
2022-01-11 10:18 Alice   o Instruct annex to add text files to Git
2022-01-11 10:18 Alic    I [DATALAD] new dataset
~~~
{: .output}

Moreover, `datalad status` only reports that the subdataset has changed, without listing the individual files.

~~~
datalad status
~~~
{: .language-bash}

~~~
modified: inputs (dataset)
~~~
{: .output}

However, if we change into the subdataset, we can see its history (and none of the parent dataset).

~~~
cd inputs
tig
~~~
{: .language-bash}

~~~
2022-01-11 10:34 Alice o [master] Add Chinstrap data
2022-01-11 10:34 Alice o Add Gentoo data
2022-01-11 10:34 Alice o Add Adelie data
2022-01-11 10:19 Alice I [DATALAD] new dataset
~~~
{: .output}

Also, `datalad status` reports that the subdataset's working tree is clean, with nothing to save:

~~~
datalad status
~~~
{: .language-bash}

~~~
nothing to save, working tree clean
~~~
{: .output}

Let's get back to the parent dataset

~~~
cd ..
~~~
{: .language-bash}

#### Record the change in the parent dataset

In the parent dataset, `datalad status` shows that there was `some` change in the subdataset: `modified: inputs (dataset)`.
To check what this looks like, let's do `git diff`:

~~~
git diff
~~~
{: .language-bash}

~~~
diff --git a/inputs b/inputs
index b9c6cc5..a194b15 160000
--- a/inputs
+++ b/inputs
@@ -1 +1 @@
-Subproject commit b9c6cc5fd918a8aba3aa3e06c5e1c7fdae176ba8
+Subproject commit a194b15d6b26c515f970480f7f66e92e4fd9b4c2
~~~
{: .output}

From the parent dataset (superdataset) perspective, only the *subproject commit* has changed (if you went back into the subdataset and look at its history you could see that this is indeed the shasum of the latest commit).
This is important: a subdataset does not record individual changes within the subdataset, it only records the state of the subdataset.
In other words, it points to the subdataset location and a point in its life (indicated by a specific commit).

Let's acknowledge that we want our superdataset to point to the updated version of the subdataset (ie. that which has all three tabular files) by saving this change in the superdataset's history.
In other words, while the subdataset progressed by three comits, in the parent dataset we can record it as a single change (from empty to populated subdataset):

~~~
datalad save -d . -m "Progress the subdataset version"
~~~
{: .language-bash}

~~~
add(ok): inputs (file)
save(ok): . (dataset)
~~~
{: .output}

At this stage, our superdataset stores the reference to a populated inputs dataset.

> ## Separate history
>
> - The super- and sub-datasets have separate histories.
> - The superdataset only contains a reference to a specific commit in the subdataset's history
> - If the subdataset evolves, the reference in the superdataset can be updated (this has to be done explicitly)
> 
> ## Installing subdatasets
> 
> - Usually, you would install an already existing dataset as a subdataset with `datalad clone -d . ...` rather than create it from scratch like we just did.
> - The end effect would be the same, with the parent dataset pointing at the specific state of the subdataset.
> 
{: .callout}

### Add a processing script to the parent dataset

Let's proceed with our subdatasets use case.
Create a file `process.py` in the root of the parent dataset (we can do away with the code directory for simplicity) and paste the following:

~~~
import argparse
import pandas
import seaborn
from pathlib import Path

# Command line arguments
parser = argparse.ArgumentParser()
parser.add_argument('--data', nargs='+', help='csv data file(s) to analyse')
parser.add_argument('--figure', help='file to store resulting plot')
args = parser.parse_args()

# Create output directory if needed
fig_path = Path(args.figure)
if not fig_path.parent.exists():
    fig_path.parent.mkdir(parents=True)

# Load and concatenate input tables
tables = [pandas.read_csv(f) for f in args.data]
penguins = pandas.concat(tables)

# Plot data and regression model fits
g = seaborn.lmplot(
    x="Flipper Length (mm)",
    y="Body Mass (g)",
    hue="Species",
    height=7,
    data=penguins,
)

# Save the plot
g.savefig(fig_path)
~~~
{: .language-python}

The script is written in a way that:
- it takes one or more csv files as `--data` argument
- it produces a linear model (correlation) plot of body mass vs flipper length
- it saves the plot in the file specified as `--output` argument

Then commit the file to the superdataset history:

~~~
datalad save -d . -m "Add code" process.py
~~~
{: .language-bash}

### Run the analysis

We'll use `datalad run` to create a record of data processing in the superdataset.
Here, we are giving the `--input` command several times with different files, and referring to all of them with the `{inputs}` placeholder.
The caveat is that when we are doing so, we need to put the command in quotes (ie. as a string) so that the expanded inputs will not be surrounded by quotes (or vice versa; here we don't want that, but DataLad caters for different situations).
To see what the expanded command would look like, without actually executing the command, we'll use the `--dry-run basic` option (useful for more complex commands):

~~~
datalad run \
  --dry-run basic \
  -d . \
  -m "Create correlations plot" \
  -i inputs/adelie.csv \
  -i inputs/chinstrap.csv \
  -i inputs/gentoo.csv \
  -o figures/lmplot.png \
  "python process.py --data {inputs} --figure {outputs}"
~~~
{: .language-bash}

~~~
 location: /home/alice/penguin-report
 expanded inputs:
  ['inputs/adelie.csv', 'inputs/chinstrap.csv', 'inputs/gentoo.csv']
 expanded outputs:
  ['figures/lmplot.png']
 command:
  python process.py --data {inputs} --figure {outputs}
 expanded command:
  python process.py --data inputs/adelie.csv inputs/chinstrap.csv inputs/gentoo.csv --figure figures/lmplot.png
~~~
{: .output}

Everything looks good, so let's run for real:

~~~
datalad run \
  --dry-run basic \
  -d . \
  -m "Create correlations plot" \
  -i inputs/adelie.csv \
  -i inputs/chinstrap.csv \
  -i inputs/gentoo.csv \
  -o figures/lmplot.png \
  "python process.py --data {inputs} --figure {outputs}"
~~~
{: .language-bash}

~~~
[INFO   ] Making sure inputs are available (this may take some time)
[INFO   ] == Command start (output follows) =====
[INFO   ] == Command exit (modification check follows) =====
add(ok): figures/lmplot.png (file)
save(ok): . (dataset)
~~~
{: .output}

This should produce a figure in `figures/lmplot.png`.
Take a look.
As expected, there is a remarkable correlation between flipper length and body mass, with the slope slightly different depending on the species.

### Write the report

Once again we'll use Markdown to write text.
Create a `report.md` file and put the following (or similar) contents inside:

~~~
# Penguins

## Introduction
Penguins have fascinated researchers since antiquity.
Nowadays, access to data on penguin size and foraging is easier than ever.

## Method
We analysed the Palmer penguins dataset.

## Results
There is a strong correlation between flipper length and body mass.

![Correlation plot](figures/lmplot.png)

## Conclusion
This was not surprising.
~~~
{: .language-markdown}

Hint: if you are working in Jupyter Lab, you can right click the file and select Open With → Markdown Preview to see the rendered version.

Then, save our changes with:

~~~
datalad save -d . -m "Draft the report" report.md
~~~
{: .language-bash}

~~~
add(ok): report.md (file)
save(ok): . (dataset)
~~~
{: .output}

#### Convert from Markdown to html for easier reading

To complete our use case, let's convert the report to another format.
We'll use a program called pandoc, which can convert between multiple formats.
Let's select html as output (although PDF would be the most obvious choice, pandoc needs additional dependencies to make it).

~~~
datalad run -i report.md -o report.html "pandoc -s {inputs} -o {outputs}"
~~~
{: .language-bash}

~~~
[INFO   ] Making sure inputs are available (this may take some time)
[INFO   ] == Command start (output follows) =====
[WARNING] This document format requires a nonempty <title> element.
  Defaulting to 'report' as the title.
  To specify a title, use 'title' in metadata or --metadata title="...".
[INFO   ] == Command exit (modification check follows) =====
add(ok): report.html (file)
save(ok): . (dataset)
~~~
{: .output}

The end! We have produced a nested datset:
- the superdataset (penguin-report) directly contains our code, figures, and report (tracking their history), and includes inputs as a subdatset...
- the subdataset (inputs) tracks the history of the raw data files.
