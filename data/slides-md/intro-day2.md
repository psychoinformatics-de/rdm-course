---
theme: gaia
_class: lead
paginate: true
backgroundColor: #fff
backgroundImage: url('https://marp.app/assets/hero-background.svg')
---

# Research Data Management with DataLad

SFB1451 workshop, day 2

- Remote collaboration
- Dataset management

---

<!-- _class: lead -->
# 3 Remote collaboration

---

## Introduction

- Covered so far: basics of local version control
  - recording changes, interacting with dataset history
	- built a small dataset
	- have a record of what led to its current state
	- single location, single person

---

- Research data rarely lives just on a single computer.
- Research projects aren't single-person affairs.
- Want to:
  - synchronise with a remote location (backup/archival)
  - keep only a subset on your PC, rotating files (save space)
  - send data to colleagues, ensure up to date with version control
  - have them contribute to your dataset (add files, make changes)
  - publish to a repository

DataLad has tools to facilitate all that.

---

## Plan

- Publish our dataset from yesterday
- Use GIN (G-Node Infrastructure): gin.g-node.org
  - Convenient integration with DataLad (all files, annexed or not)
  - DataLad supports many different scenarios (incl. separation)
  - Some quirks, but steps for GIN will be similar elswhere
- Make changes to each other's datasets through GIN

---

<!-- _class: lead -->
# 4 Dataset management

---

## Introduction

- Analysis, simplified: collect inputs, produce outputs
  - same input can be used for multiple analyses
  - output (transform / preprocess) may become input for next one

---

![width:1200px](https://handbook.datalad.org/en/latest/_images/dataset_modules.svg)

---

## Subdatasets are useful if there is:

- a logical need to make your data modular
  - eg. raw data - preprocessing - analysis - paper
- a technical need to divide your data
  - hundreds of thousands of files start hurting performance

---

## Plan

- Inspect a published nested DataLad dataset
- Create a toy example from scratch

---

## Data we will use

- "Highspeed Analysis" DataLad dataset
  - Wittkuhn L, Schuck NW, *Nat. Commun.* 12, 1795 (2021)
  - [github.com/lnnrtwttkhn/highspeed-analysis](https://github.com/lnnrtwttkhn/highspeed-analysis)
- Tabular data from Palmer Station Antarctica LTER
  - Gorman KB, Williams TD, Fraser WR, *PLoS ONE* 9(3):e90081 (2014)
  - see also: palmerpenguins R dataset - alternative to Iris

---

## Published DataLad dataset: the plan

- Obtain the dataset
- Inspect its nested structure
- Obtain a specific file

---

## Toy example: the plan

- Investigate the relationship between flipper length and body mass in 3 penguin species.
  - Create a "penguin-report" dataset, with "inputs" subdataset
  - Populate the subdataset with data
  - Run an analysis, → figure in the main dataset
  - Write our "report" → document in the main dataset

---

## Folder structure we're aiming for

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

---

<!-- _class: lead -->
# Wrap-up

---

## Where to next

- Materials aren't going anywhere (but hub shuts down)
- INF project website: [rdm.sfb1451.de](https://rdm.sfb1451.de/)
  - contact information, practical info
- DataLad Office Hours
  - virtual, Thu 16:00
  - announced in a matrix chat room (link ☝)
- DataLad website: [datalad.org](https://datalad.org)
- DataLad handbook: [handbook.datalad.org](https://handbook.datalad.org/en/latest/)

---

## How was it?

- tell us what you liked
- tell us which parts weren't interesting
