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

Subdatasets can also be useful if your data is in the order of (...) of files, and splitting them into subdatasets will improve performance.

## Real-life example: using nested datasets

We will work with the [Highspeed analysis](https://github.com/lnnrtwttkhn/highspeed-analysis) dataset containing data and code from:

> Wittkuhn, L., Schuck, N.W.
> Dynamics of fMRI patterns reflect sub-second activation sequences and reveal replay in human visual cortex. Nat Commun 12, 1795 (2021).
> https://doi.org/10.1038/s41467-021-21970-2

## Toy example: creating subdatasets
