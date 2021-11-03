---
title: "Remote collaboration"
teaching: 45
exercises: 45
questions:
- How to create a dataset collaboratively?
- How to publish a dataset?
- How to consume a dataset?
objectives:
- Exercise publishing and consuming data
- Demonstrate the dissociation between a dataset and its contents
keypoints:
- TBD
---

## Introduction

In the first module we covered the basics of local version control. We
learned how to record changes that were made, and how to interact with
the dataset history. We built a small dataset, with a record of
operations which led to its current state. All these operations were
done in a single location and by a single person.

However, research data rarely lives just on a single computer, and
research projects aren't single-person affairs. You may want to
synchronise your data to a remote location for backup or
archival. Having a remote storage, you may want to keep only a
selection of files on your computer to save space (but also frequently
rotate the files you have locally). You may want to use this storage
to send data to your colleagues, and rely on version control to ensure
that they are up to date. You may also want them to contribute to your
dataset by adding new data or making some changes, which will be
tracked. Finally, you may want to publish the dataset to some kind of
a repository.

DataLad has tools to facilitate all these operations. In this module
we will cover the basics of collaborative and remote work with
datasets. We will start by publishing the dataset created during the
first module. As a platform of our choice we will use GIN.
