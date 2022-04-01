---
layout: reference
---

## Summary of basic DataLad commands

| Action        | Description                                                                                |
|---------------|--------------------------------------------------------------------------------------------|
| create        | Create a new dataset from scratch                                                          |
| save          | Save the current state of a dataset                                                        |
| status        | Report on the state of a dataset and / or its subdatasets                                  |
| get           | Get dataset content (files / directories / subdatasets)                                    |
| clone         | Install an existing dataset from path / url / open data collection                         |
| update        | Update a dataset from a sibling                                                            |
| remove        | Remove datasets + contents, unregister from potential top-level datasets                   |
| unlock        | Unlock file(s) of a dataset to enable editing their content                                |
| drop          | Drop file content from dataset (remove data, retain symlink)                               |
| siblings      | Manage sibling configurations                                                              |
| publish       | Publish a dataset to a known sibling                                                       |
| run           | Run arbitrary shell command and record its impact                                          |
| rerun         | Re-execute a previous run command identified by its hash, and save resulting modifications |
| run-procedure | Run prepared procedures (execudables) on a dataset                                         |
| download-url  | Download, save, and record origin of content from websources.                              |


See the [DataLad cheat sheet](https://handbook.datalad.org/en/latest/basics/101-136-cheatsheet.html) in the DataLad Handbook.

## Glossary

{:auto_ids}
absolute path
:   A [path](#path) that refers to a particular location in a file system.
    Absolute paths are usually written with respect to the file system's
    [root directory](#root-directory),
    and begin with either "/" (on Unix) or "\\" (on Microsoft Windows).
    See also: [relative path](#relative-path).

current working directory
:   The directory that [relative paths](#relative-path) are calculated from;
    equivalently,
    the place where files referenced by name only are searched for.
    Every process has a current working directory.
    The current working directory is usually referred to using the shorthand notation `.` (pronounced "dot").

file system
:   A set of files, directories, and I/O devices (such as keyboards and screens).
    A file system may be spread across many physical devices,
    or many file systems may be stored on a single physical device;
    the operating system manages access.

path
:   A description that specifies the location of a file or directory within a [file system](#file-system).
    See also: [absolute path](#absolute-path), [relative path](#relative-path).

relative path
:   A [path](#path) that specifies the location of a file or directory
    with respect to the [current working directory](#current-working-directory).
    Any path that does not begin with a separator character ("/" or "\\") is a relative path.
    See also: [absolute path](#absolute-path).

root directory
:   The top-most directory in a [file system](#file-system).
    Its name is "/" on Unix (including Linux and macOS) and "\\" on Microsoft Windows.


## External references

### DataLad

* [DataLad website](https://www.datalad.org/)
* [DataLad Handbook](https://handbook.datalad.org)

### Other sources

* [The Unix Shell](https://swcarpentry.github.io/shell-novice/) Software Carpentry lesson (incl. [reference](https://swcarpentry.github.io/shell-novice/reference.html))
* [How to name files nicely](https://speakerdeck.com/jennybc/how-to-name-files), by Jenny Bryan
* [Project structure](https://slides.djnavarro.net/project-structure/), by Danielle Navarro
* [The Turing Way](https://the-turing-way.netlify.app/)

### Miscellaneous

* [Palmer Penguins R dataset](https://allisonhorst.github.io/palmerpenguins/)
