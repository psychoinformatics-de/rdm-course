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

## File types (text vs binary)

Any dataset will likely store different kinds of data, and use different file formats to do so. There is a myriad of formats; sometimes, the format choice for a given type of data will be obvious (dictated by universally accepted or field-specific standards), sometimes there will be several possibilities. Leaving the formats aside, one broad distinction can be made: text vs binary.

- Text file is a file structured as a sequence of lines containing text, composed of characters. 
- Binary file is anything other than a text file.

A text file can be viewed and edited using a text editor . The *lines* are delimited by a newline character, typically written as `\n`. Note that although some editors will *wrap* lines for display purposes, this is purely visual, as the line endings are stored in the file.

### Version control

One important feature of text files is that they can be version controlled on a line by line basis. So if you have a long file, but only change it in a few places, changes will be recorded for the specific lines. Moreover, it will be easy to display what the modification involved, by portraying it as lines being taken out and added (in programming slang, this is called a file *diff*).

Compare this to a binary file, which does not have a line structure. Version control systems, including datalad, will also track binary files, but they will do so on a per-file basis. TODO: Flesh out

Datalad introduces one additional distinction between text and binary files. In a typical dataset, binary files will be annexed (TODO: meaning that...) and text files will not (TODO: although...). To protect the data from accidental modifications, datalad will content-lock the annexed files, disabling your permission to edit them. The files can be unlocked manually with `datalad unlock`, but the `datalad run` command performs unlocking automatically.

### Different flavours of text files

Text files may be simple in their structure, but they can be very powerful in their ability to store content. All the example formats below are human- and machine-readable. They have all become widely accepted standards and you will likely find a library for reading these files in your favourite programming language.

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

Fairly standardised and very popular, Markdown is recognised by many programs and platforms. While it is readable as-is, many code-hosting websites, such as GitHub, will recognise markdown files (giving special attention to those named README) and render them as html in the web interface. Markdown files are a good choice for describing things in a free narrative - yor project, dataset, or analysis. This course materials have also been written in Markdown!

There are other markup languages for similar purposes, such as reStructuredText (popular choice in the world of python documentation), AsciiDoc, or Org Mode (popular among the users of Emacs text editor). Html is also a markup language, but in most cases it is easier to write in one of the lightweight languages and then convert the documents to html when they are .


#### Delimited files: csv, tsv

Moving on from narrative to data, comma-separated files (.csv) and tab-separated files (.tsv) are common ways to represent tabular data:

~~~
TODO: example of a few csv rows, possibly demonstrating quoting
~~~

#### Configuration and data serialisation: toml, yaml & json

Some formats were made for serialisation (or interchange) -- converting data objects into an easily transmittable form. They can be useful for storing configurations, or keeping (meta-)data which is best represented as key-value pairs.

Here's an example in [TOML](https://toml.io/en/), Tom's Obvious Minimal Language (taken from its official website):

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

This is what the same data looks like in [YAML](https://yaml.org/), Yaml Ain't Markup Language:

~~~
# This is a YAML document

title: Example
owner:
  dob: 1979-05-27 07:32:00-08:00
  name: Tom Preston-Werner
database:
  enabled: true
  ports:
  - 8000
  - 8001
  - 8002
  data:
  - - delta
    - phi
  - - 3.14
  temp_targets:
    case: 72.0
    cpu: 79.5
~~~
{: .language-yaml}

And here is the same data in [JSON](https://www.json.org/), JavaScript Object notation:

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

## Sidecar metadata strategy

Sometimes, it is desirable to combine binary and text files to represent the same data object. This could be useful if the binary format does not have the possibility to store some metadata, or simply because we want to make the metadata easily readable to anybody (i.e. without requiring potentially uncommon software which can open our binary format).

Let's assume our dataset contains photographs of penguins, collected for research purposes. Suppose that we want to keep (TODO: decide) in the file name to make it easily searchable, but there is additional metadata that may be needed for analysis. We can decide to store the image data in a jpeg file (binary) and the metadata in a yaml file (text). Thus, we will use two files with the same base name and different extensions:

~~~
photo_type-color.jpeg
photo_type-color.toml
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


As a side note, jpeg files do support quite a lot of metadata (Exif specification) but most likely they are neither sufficient nor convenient for our research.

## [TODO] File / directory structure

## [TODO] Other

- Unify headings
- Consider splitting into several "episodes"
