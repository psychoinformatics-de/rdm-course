---
theme: gaia
_class: lead
paginate: true
backgroundColor: #fff
backgroundImage: url('https://marp.app/assets/hero-background.svg')
---

# Research Data Management with DataLad

SFB1451 Workshop, day 1

- Content tracking with DataLad
- Good practicies in data management

---

## Introduction: life of digital objects

- Alice is a PhD student.
- She works on a fairly typical research project: data collection & and processing.
  - Exact kind of data not relevant for us
  - first sample → final result: cumulative process

--- 

- When working locally, Alice likes to have an automated record of:
  - when a given file was last changed
  - where it came from
  - what input files were used to generate a given output
  - why some things were done.
- Even without sharing, essential for her future self
- Project is exploratory: often large changes to her analysis scripts
- Enjoys comfort of being able to return to a previously recorded state

This is *local* version control.

---

- Alice's work not confined to a single computer
  - laptop / desktop / remote server
  - automatic and efficient way to synchronise
- Some data collected / analysed by colleagues from other team
  - all synchronize with centralized storage
  - preserving origin & authorship
  - combining simultaneous contributions

This is *distributed* version control.

---

- When working, needs a subset of all data at a given time
  - all files are kept on a server
  - few files are rotated into and out of the laptop
- When project is complete, Alice may need to publish
  - raw data / outputs / both
  - completely or selectively

... all these were typical data management issues which we will touch upon during this workshop, using DataLad as our primary tool.

---

## Workshop plan

- Day 1:
  - Content tracking with DataLad (local version control)
  - Good practices in data management
- Day 2:
  - Distributed version control (publish / consume)
  - Linked datasets

---

## Resources

- https://datalad-hub.inm7.de/
- https://psychoinformatics-de.github.io/rdm-course/

---
<!-- _class: lead -->
# 1 Content tracking with DataLad

---

- Gradually build up an example dataset
  - Discover version control and basic DataLad concepts in the process.
  - Introduce basic DataLad commands - a technical foundation for all above
- DataLad is agnostic about the kind of data it manages
  - Add photos and text as "data"
  - Convert photos to b/w as "data processing"
- Add files → record origin → make changes → track changes → undo things
