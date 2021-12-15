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
