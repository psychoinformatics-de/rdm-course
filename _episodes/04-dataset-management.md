---
title: "Dataset management"
teaching: 45
exercises: 45
questions:
- How to manage data on a dataset level?
- ...
objectives:
- Demonstrate dataset nesting (subdatasets)
- ...
keypoints:
- ...
---

## Introduction

A typical analysis relies on input data, and produces output data.
However, the same input dataset can be used in multiple analyses, and output (e.g. transformed or preprocessed) data produced by one analysis may serve as input for subsequent analysis.

To address these usecases, DataLad provides a mechanism for linking datasets:

![Subdataset linkage]({{ page.root }}/fig/linkage_subds.svg)
{: .image-with-shadow}

(Image from DataLad Handbook)

Subdatasets can also be useful if your data is in the order of hundreds of thousands of files, and splitting them into subdatasets will improve performance.

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
- Side note, if you go to one of the data directories, and navigate all the way to a single `.nii.gz` file, you will see GitHub showing that it is a symlink, not an actual data file.

Both the README content and the existence of submodules tell us that we are dealing with subdatasets.
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
| 		datalad siblings -d "/home/mszczepanik/Documents/rdm-course/highspeed-bids" enable -s keeper
install(ok): /home/mszczepanik/Documents/rdm-course/highspeed-bids (dataset)
~~~
{: .output}

Now, let's change directory into the dataset and ask about its subdatasets:

~~~
datalad subdatasets
~~~
{: .language-bash}

~~~
subdataset(ok): code/raincloud-plots (dataset)
subdataset(ok): data/bids (dataset)
subdataset(ok): data/decoding (dataset)
~~~
{: .output}

TODO: consider also showing siblings.

## Toy example: creating subdatasets

Let's try to build a nested dataset from scratch.
We will stick with the theme set in the previous episodes.
This time, our goal is to write a short report on penguins, based on the data made available by [Palmer Station Antarctica LTER](https://pal.lternet.edu/) and dr Kristen Gorman (see also: [palmerpenguins R dataset](https://allisonhorst.github.io/palmerpenguins/)).

We will:
- Create a main dataset for our report, and create a subdataset within to store inputs
- Populate the subdataset with data
- Run an analysis, producing a figure in the main dataset
- Write our "report"

This is the folder structure we're aiming for:

~~~
...
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

At this point it's worthwhile checking `tig` to see the nature of the last change.

For the following commands we will be explicit with the `-d`/`--dataset` argument, and always specify on which dataset we want to act.

### Populate the input dataset.

In our input dataset we want to include tabular data with size measurements of Adelie, Gentoo, and Chinstrap penguins.
We will also add a nice picture (why not).

~~~
datalad download-url -d inputs -m "Add Adelie data" -O inputs/adelie.csv https://pasta.lternet.edu/package/data/eml/knb-lter-pal/219/5/002f3893385f710df69eeebe893144ff
datalad download-url -d inputs -m "Add Gentoo data" -O inputs/gentoo.csv https://pasta.lternet.edu/package/data/eml/knb-lter-pal/220/7/e03b43c924f226486f2f0ab6709d2381
datalad download-url -d inputs -m "Add Chinstrap data" -O inputs/chinstrap.csv https://pasta.lternet.edu/package/data/eml/knb-lter-pal/221/8/fe853aa8f7a59aa84cdd3197619ef462
datalad download-url -d inputs -m "Add a photograph" -O inputs/penguin.jpg ...
~~~
{: .language-bash}

TODO: Preview the csv file with `head` OR by looking in Jupyter Lab.

#### See where changes got recorded

Checking with `tig` shows us that there is no record of changes in the parent dataset!
Moreover, `datalad status` reports only that the subdataset has changed.

~~~
tig
datalad status
~~~

However, if we change into the subdataset, we can see its history (and none of the parent dataset).

~~~
cd inputs
tig
~~~

Let's get back to the parent dataset
~~~
cd ..
~~~

#### Record the change in the parent dataset

~~~
...
~~~

Note: usually, you would install the subdataset with `datalad clone -d . ...` rather than create it from scratch.
The end effect would be the same, with the parent dataset pointing at the specific state of the subdataset.

### Add a processing script to the parent dataset

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

### Run the analysis

~~~
datalad run \
  --dry-run basic \
  -d . \
  -m "Create correlations plot" \
  -i inputs/adelie.csv \
  -i inputs/chinstrap.csv \
  -i inputs/gentoo.csv \
  -o figures/lmplot.png \
  python process.py --data {inputs} --figure {outputs}
~~~
{: .language-bash}

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
Wow!
~~~
{: .language-markdown}

Then, save our changes with ...

#### Convert from Markdown to html for easier reading

~~~
datalad run pandoc ...
~~~
