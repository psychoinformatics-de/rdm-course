---
theme: gaia
_class: lead
paginate: true
backgroundColor: #fff
backgroundImage: url('https://marp.app/assets/hero-background.svg')
---

# Structuring data


---

## Good practices in data organisation

- "What is a good filename?"
- May seem prosaic, but can go a long way in making your life easier
  - file names
  - file types
  - project structure

---

## How to name a file?

Based on the presentations "[Naming Things](http://www2.stat.duke.edu/~rcs46/lectures_2015/01-markdown-git/slides/naming-slides/naming-slides.pdf)" (CC0) by Jenny Bryan and "[Project structure](https://slides.djnavarro.net/project-structure/)" by Danielle Navarro.

- A file name exists to identify its content.
- Opinions as to what *exactly* is a good file name differ.
- Disclaimer:
  - Probably no gold standard exists, and
  - we do not claim to possess one, but
  - we will focus on identifying patterns in file naming which can make working with data easier.

---

### Three principles:

  - be machine readable (automatically extract information without tripping)
  - be human readable (easy to know what's what)
  - make sorting and searching easy (easy to find things)

---

### Why some ways are preferred?

- The obvious
  - Need to know what's in a file / find what we need
- Less obvious
  - Different uses (point & click vs command line vs automation)
  - Must survive transfer (also between different OS)

---

### Example: english literature class (?)

```
✅ reading01_shakespeare_romeo-and-juliet_act01.docx
✅ reading01_shakespeare_romeo-and-juliet_act02.docx
✅ reading01_shakespeare_romeo-and-juliet_act03.docx
✅ reading02_shakespeare_othello.docx
✅ reading19_plath_the-bell-jar.docx
```
*versus*
```
❌ Romeo and Juliet Act 1.docx
❌ Romeo and juliet act 2.docx
❌ Shakespeare RJ act3.docx
❌ shakespeare othello I think?.docx
❌ belljar plath (1).docx
```

---

### What's to like?

```
✅ reading01_shakespeare_romeo-and-juliet_act03.docx
✅ reading02_shakespeare_othello.docx
✅ reading19_plath_the-bell-jar.docx
```

- uses consistent patterns
- avoids "risky" characters
- remains:
  - human readable
  - machine readable
  - easy to sort and search

---

### Avoid white spaces

- Command line: space separates arguments
  - `edit my file.txt` seen as `edit` command & `my`, `file.txt` args
- Solve by:
  - Quoting: `edit "my file.txt"`
  - Escaping: `edit my\ file.txt`
- Not ideal:
  - more typing / harder autocompletion
  - problems when passing around: `my\ file.txt` → `my\\ file.txt`

---

### Use only letters, numbers, hyphens, and underscores

- Encoding: e.g. even within Unicode, é in *Adélie* can be:
  - `U+00E9` (latin small letter e with acute)
  - `U+0065` `U+0301` (the letter "e" plus a combining acute symbol)
- Special meaning in command line (`'^.*?$+|`)
  - e.g. `?` *may* mean "match any character"
- Outright forbidden by some OS
  - illegal on Unix: `/` (directory separator)
  - illegal on Windows: `<>:"/\|?*`

---

### Don't rely on letter case

- Are `apple` and `Apple` are the same file?
  - depends on file system
  - eg. HFS+ preserves case on creation but not retrieval
- Be consistent
- Don't rely on just letter case to distinguish files

---

### Use separators in meaningful way

- Use `-` to join words into one entity.
- Use `_` to separate entities.
- Example pattern: `[category] [class] [author] [title] [section(optional)]`
- Basic variant:
  `reading_01_shakespeare_romeo-and-juliet_act01.docx`
- Key-value variant:
  `cat-reading_class-01_author-shakespeare_title-romeoandjuliet_act-01.docx`

---

The tool of your choice will likely have:

Globbing:
```
>>> import glob
>>> glob.glob('reading_01*')
['reading_01_shakespeare_romeo-and-juliet_act02.docx', 'reading_01_shakespeare_romeo-and-juliet_act01.docx']
```

(similar to search in GUI file browsers)

...

---

Splitting:
```
>>> file = 'reading_01_shakespeare_romeo-and-juliet_act01.docx'
>>> file.split('_')
['reading', '01', 'shakespeare', 'romeo-and-juliet', 'act01.docx']
```

Key-value representation (dictionary):
```
>>> file = 'cat-reading_class-01_author-shakespeare_title-romeoandjuliet_act-01.docx'
>>> dict(part.split('-') for part in file.split('_'))
{'cat': 'reading', 'class': '01', 'author': 'shakespeare', 'title': 'romeoandjuliet', 'act': '01.docx'}
```

---

### Follow ISO 8601 if using dates

- `YYYY-MM-DD` format maintains chronology in alphabetical ordering
- Dates aren't always preserved on transfer
- Valid usecases:
  - Date is crucial (e.g. daily weather data)
  - Sorting by name is crucial (e.g. meeting notes)
- Version control covers most other usecases:
  - Don't use date as `_v1`, `_v2`, `_v3_final`
  - `git log` will show file history
  - so will `git blame` (line-by-line for text files)

---

```
git log inputs/images/king_01.jpg
commit ff73ce9acb8ee4b99106fa7ae080cfcb08138d48
Author: John Doe <j.doe@example.com>
Date:   Mon Oct 18 16:09:27 2021 +0200

    Add third image
```

```
git blame --date human README.md
487b1267 (John Doe Oct 12 2021       1) # Example dataset
487b1267 (John Doe Oct 12 2021       2) 
487b1267 (John Doe Oct 12 2021       3) This is an example datalad dataset.
487b1267 (John Doe Oct 12 2021       4) 
7fef4b96 (John Doe Oct 12 2021       5) Raw data is kept in `inputs` folder:
7fef4b96 (John Doe Oct 12 2021       6) - penguin photos are in `inputs/images`
dbf4ad7e (John Doe Oct 13 2021       7) 
dbf4ad7e (John Doe Oct 13 2021       8) ## Credit
dbf4ad7e (John Doe Oct 13 2021       9) 
6e759623 (John Doe Oct 18 2021      10) Photos by [Derek Oyen](https://unsplash.com/@goosegrease) and ...
```

---

### Avoid leaking undesired information

```
touch name-with-identifying-information.dat
datalad save

git mv name-with-identifying-information.dat a-new-name.dat
datalad save

git diff HEAD~1 HEAD
```

```
diff --git a/name-with-identifying-information.dat b/a-new-name.dat
similarity index 100%
rename from name-with-identifying-information.dat
rename to a-new-name.dat
```

"Rewriting history" possible, but: not easy, potentially destructive.

---

### Use sidecar metadata if needed

```
adelie_087.jpeg
adelie_087.yaml
```

Content of `adelie_087.yaml`:

```
species: Adelie
island: Torgersen
date: 2021-09-12
penguin_count: 1
sex: MALE
photographer: John
```

---

```
penguins.csv
penguins.yaml
```

Meticulous column description in `penguins.yaml`:

```
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
```

---

## Side note: full vs relative file paths

```
/home/alice/Documents/project/figures/setup.png
/Users/bob/Documents/project/figures/setup.png
C:\\Users\eve\Documents\project\figures\setup.py
```

Relative path (within project folder): `figures/setup.png`

Avoid hardcoding full paths - easier to move around.

---

## Side note: text vs binary files

- Text file is a file structured as a sequence of lines containing text, composed of characters. 
- Binary file is anything other than a text file.
- Choice will affect
  - DataLad behaviour (esp. with text2git - often suboptimal)
  - Simplicity of reading data

---

| Text                                            | Binary                                             |
|-------------------------------------------------|----------------------------------------------------|
| .txt                                            | images: .jpg, .png, .tiff                          |
| markup: .md, .rst, .html                        | documents: docx, .xlsx, .pdf                       |
| source code: .py, .R, .m                        | compiled files: .pyc, .o, .exe                     |
| text-serialised formats: .toml, yaml, json, xml | binary-serialised formats: .pickle, .feather, .hdf |
| delimited files: .tsv, .csv                     | domain-specific: .nii, .edf                        |
| vector graphics: .svg                           | compressed: .zip .gz, .7z                          |
| ...                                             | ...

---

## Folder structure

- Aim for clarity
- Follow extablished patterns (examples follow)

---

### Keep inputs and outputs separately

Consider the following:

```
/dataset
├── sample1
│   └── a001.dat
├── sample2
│   └── a001.dat
...
```

---

After applying a transform (preprocessing, analysis, ...) this becomes:

```
/dataset
├── sample1
│   ├── ps34t.dat
│   └── a001.dat
├── sample2
│   ├── ps34t.dat
│   └── a001.dat
...
```

Without expert / domain knowledge, no distinction between original and derived data is possible anymore.

---

Compare it to a case with a clearer separation of semantics:

```
/derived_dataset
├── sample1
│   └── ps34t.dat
├── sample2
│   └── ps34t.dat
├── ...
└── inputs
    └── raw
        ├── sample1
        │   └── a001.dat
        ├── sample2
        │   └── a001.dat
        ...
```

---

### Example structure: research compendium

```
compendium/
├── data
│   ├── my_data.csv
├── analysis
│   └── my_script.R
├── DESCRIPTION
└── README.md
```

- Data and methods separated into folders
- Computational environment described in a designated file
- A README document provides a landing page

[research-compendium.science](https://research-compendium.science/)

---

```
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
(Example from The Turing Way)
```

---

### Example structure: YODA principles

*Structure study elements in modular components to facilitate reuse within or outside the context of the original study*

`datalad create -c yoda "my_analysis"` creates initial files, sets only `code`, `changelog` and `README` to be tracked by git (all else annexed)

```
.
├── CHANGELOG.md
├── code
│   └── README.md
└── README.md
```

[github.com/myyoda/myyoda](https://github.com/myyoda/myyoda)

---

```
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
(Example from Datalad Handbook)
```

---

### Example structure: Brain Imaging Data Structure

[bids.neuroimaging.io](https://bids.neuroimaging.io/) (file naming, directory structure, metadata)

```
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
```

---

```
sub-01_task-rhymejudgment_bold.nii.gz
sub-01_task-rhymejudgment_events.tsv
```

- Key-value naming, with underscores and dashes
- Sidecar metadata strategy:
  - .nii.gz (compressed binary file with neuroimaging data)
  - .tsv (text file with event timings)
- Text files where possible:
  - tsv files are used to store participant tables and event timings.
  - json files are used for metadata

