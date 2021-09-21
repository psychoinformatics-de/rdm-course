---
title: "Structuring data"
teaching: 90
exercises: 0
questions:
- "What is a good filename?"
- "How to keep data nicely structured?"
objectives:
- "Explain good practices in naming files"
- "Encourage structured thinking about datasets: files/directories, text vs binary data, tabular files, sidecar metadata strategy"
- "Explain data modularity"
keypoints:
- "TBD"
---

## How to name a file?

This section is based on the presentation 
"[Naming Things](http://www2.stat.duke.edu/~rcs46/lectures_2015/01-markdown-git/slides/naming-slides/naming-slides.pdf)"
(CC0) by Jenny Bryan.

Let's start with some examples. These filenames are not uncommon, but
could be improved to avoid problems in the future:

~~~
myabstract.docx
Joe’s Filenames Use Spaces and Punctuation.xlsx
figure 1.png
fig 2.png
JW7d^(2sl@deletethisandyourcareerisoverWx2*.txt
~~~

These filenames are better:

~~~
2014-06-08_abstract-for-sla.docx
joes-filenames-are-getting-better.xlsx
fig01_scatterplot-talk-length-vs-interest.png
fig02_histogram-talk-attendance.png
1986-01-28_raw-data-from-challenger-o-rings.txt
~~~

Here is an awesome example of data file names:

~~~
2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_A01.csv
2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_A02.csv
2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_platefile.csv
2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_B01.csv
2014-02-26_BRAFWTNEGASSAY_FFPEDNA-CRC-1-41_A01.csv
2014-02-26_BRAFWTNEGASSAY_FFPEDNA-CRC-1-41_A02.csv
2014-02-26_BRAFWTNEGASSAY_FFPEDNA-CRC-1-41_B01.csv
~~~

Let's identify and explain three principles for (file) names:

- machine readable
- human readable
- plays well with default ordering

### Machine readable

With the last example, we can use **globbing** to narrow file listing

~~~
ls *Plasmid*
~~~
{: .language-bash}

~~~
2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_A01.csv
2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_A02.csv
2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_platefile.csv
2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_B01.csv
~~~
{: .output}

~~~
glob.glob('*Plasmid*')
~~~
{: .language-python}

~~~
['2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_A01.csv',
 '2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_A02.csv',
 '2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_platefile.csv',
 '2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_B01.csv']
~~~
{: .output}

~~~
list.files(pattern = "Plasmid")
~~~
{: .language-r}

~~~
[1] "2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_A01.csv"
[2] "2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_A02.csv"
[3] "2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_platefile.csv"
[4] "2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_B01.csv"
~~~

Deliberate use of "_" and "-" allows us to recover meta-data from the
filenames.  For example, the names we are using contain the following
information: date, assay, sample set, and well. Underscores delimit
units of meta-data which can be useful later, and hyphens delimit
words (so they are easier to read).

~~~
list.files(pattern = "Plasmid") %>%
	stringr::str_split_fixed(flist, "[_\\.]", 5)
~~~
{: .language-r}

~~~
     [,1]         [,2]             [,3]                                   [,4]  [,5]
[1,] "2013-06-26" "BRAFWTNEGASSAY" "Plasmid-Cellline-100-1MutantFraction" "A01" "csv"
[2,] "2013-06-26" "BRAFWTNEGASSAY" "Plasmid-Cellline-100-1MutantFraction" "A02" "csv"
[3,] "2013-06-26" "BRAFWTNEGASSAY" "Plasmid-Cellline-100-1MutantFraction" "A03" "csv"
[4,] "2013-06-26" "BRAFWTNEGASSAY" "Plasmid-Cellline-100-1MutantFraction" "B01" "csv"
[5,] "2013-06-26" "BRAFWTNEGASSAY" "Plasmid-Cellline-100-1MutantFraction" "B02" "csv"
[6,] "2013-06-26" "BRAFWTNEGASSAY" "Plasmid-Cellline-100-1MutantFraction" "B03" "csv"
~~~
{: .output}

New to regular expressions and globbing? Be kind to yourself and avoid

- spaces in file names
- punctuation
- accented characters
- different files named “foo” and “Foo”

> ## In practice, "machine readable" means that:
> 
> - it's easy to search for files later
> - it's easy to narrow file lists based on names
> - it's easy to extract info from file names, e.g. by splitting
{:.callout}

## Human readable

A human readable name contains information on **content**. It connects
to a concept of a *slug* from [semantic
URLs](https://en.wikipedia.org/wiki/Clean_URL). The slug may look like
`pre-dea-filtering` or `explore-dea-results`.

The practice boils down to a question: "which set of files do you want
at 3 a.m. before a deadline?"

| Slug                          | No slug    |
| ------------------------------|------------|
| 01_marshal-data.md            | 01.md      | 
| 01_marshal-data.r             | 01.r       |
| 02_pre-dea-filtering.md       | 02.md      |
| 02_pre-dea-filtering.r        | 02.r       |
| 03_dea-with-limma-voom.md     | 03.md      |
| 03_dea-with-limma-voom.r      | 03.r       |
| 04_explore-dea-results.md     | 04.md      |
| 04_explore-dea-results.r      | 04.r       |
| 90_limma-model-term-name-fiasco.md | 90.md |
| 90_limma-model-term-name-fiasco.r  | 90.r  |
| Makefile                      | Makefile   |
| figure                        | figure     |
| helper01_load-counts.r        | helper01.r |
| helper02_load-exp-des.r       | helper02.r |
| helper03_load-focus-statinf.r | helper03.r |
| helper04_extract-and-tidy.r   | helper04.r |
| tmp.txt                       | tmp.txt    |

> ## In practice, "human readable" means that:
> it's easy to figure out what the heck something is, based on its name.
{: .callout}

## Plays well with default ordering

| Chronological order                                                    | Logical order          |
| -----------------------------------------------------------------------|------------------------|
| 2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_A01.csv | 01_marshal-data.r      |
| 2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_A02.csv | 02_pre-dea-filtering.r |
| 2013-06-26_BRAFWTNEGASSAY_Plasmid-Cellline-100-1MutantFraction_platefile.csv | 90_limma-model-term-name-fiasco.r |
| 2014-02-26_BRAFWTNEGASSAY_FFPEDNA-CRC-1-41_A01.csv | helper01_load-counts.r  |
| 2014-02-26_BRAFWTNEGASSAY_FFPEDNA-CRC-1-41_A02.csv | helper02_load-exp-des.r |


> ## To play well with default ordering, it can be useful to:
> 
> - put something numeric first
> - use the ISO 8601 standard for dates: **YYYY-MM-DD** ([relevant xkcd](https://xkcd.com/1179))
> - left pad numbers with zeros (if you don't pad, `10_something` comes before `1_something`)

## Avoid leaking undesired information

When dealing with personal data, pseudonymisation is a common
practice. While, for example, a name composed of birth date and
initials may be sufficient to distinguish subjects within a study, a
file with such a name can hardly be considered deidentified.

If a dataset is being version controlled (which means that its history of changes is being recorded), this poses an additional challenge: file name changes are also tracked, and the record of the change is preserved:

~~~
git log --pretty=format:"%h  %ar  %s" 
~~~
{: .language-bash}

~~~
2d265d2  28 minutes ago  Recode names
f94c030  29 minutes ago  Add data
~~~
{: .output}


~~~
git diff f94c030 2d265d2
~~~
{: .language-bash}

~~~
diff --git a/name-with-identifying-information.dat b/name-recoded.dat
similarity index 100%
rename from name-with-identifying-information.dat
rename to name-recoded.dat
~~~
{: .output}

Therefore, a naming pattern needs to be chosen carefully!

## [TODO] Further topics

Also part of this module, either within the current "episode" or as a
separate one.

- Data organisation
  - files / directories
  - tabular data
  - binary data
  - sidecar metadata strategy
