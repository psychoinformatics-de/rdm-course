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

> ## Prerequisites
>
> [GIN](https://gin.g-node.org/) (G-Node Infrastructure) platform will
> be used for dataset publication. In order to fully complete the
> exercises, you will need a GIN account. The sign-up requires only a
> username, password, and a valid e-mail address (institutional
> e-mails are recommended to benefit from the full set of features).
>
{: .prereq}

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
first module. As a platform of our choice we will use
[GIN](https://gin.g-node.org) (G-Node Infrastructure).

We chose GIN because it provides a convenient way of hosting DataLad
datasets. That being said, DataLad integrates with many providers and
supports different scenarios -- including those when hosting of
dataset information and actual data is separated into two locations.

## Prelude: file availability, getting and droping content

Before we proceed to data publishing let's first take a look at the
dataset we created during the first module. We used two ways of adding
image files: some were downloaded, placed in the dataset "manually",
while others were included using `datalad download-url`. We noted that
the latter records the file origin in a way that is not only
accessible to us, but also usable by DataLad. Let's use this
information now.

The `datalad drop` command is used to drop file content from
datasets. It does not remove the file entirely - the information about
its presence and all associated history are maintained - it removes
the file content to save space, and only does so if the file can be
reobtained. Let's use it on one of the files we got through
`download-url`. 

Change the working directory to the dataset root (the folder which we
called `my-dataset` when the dataset was created) and then do:

```
datalad drop inputs/images/derek-oyen-8PxCm4HsPX8-unsplash.jpg
```
{: .language-bash}

```
drop(ok): /home/alice/Documents/rdm-workshop/my-dataset/inputs/images/derek-oyen-8PxCm4HsPX8-unsplash.jpg
```
{: .output}

What are the results? The file is still visible (you can list files
with `ls inputs/images` or check the directory in your file browser),
but has no contents: you can try opening it (from your file browser or
with `xdg-open` if you're on linux) ends in an error. You can verify
that this has freed up disk space by typing:

```
datalad status --annex all
```
{: .language-bash}

```
5 annex'd files (5.4 MB/6.3 MB present/total size)
nothing to save, working tree clean
```
{: .output}

Let's try dropping the file which we put in the dataset manually
(i.e. using `wget` and not `datalad download-url`):

```
datalad drop inputs/images/derek-oyen-3Xd5j9-drDA-unsplash.jpg
```
{: .language-bash}

```
...
```
{: .output}

This time, DataLad refused to drop the file, because no information
about its availability elsewhere has been recorded.

The `datalad get` command is the reverse of `datalad drop` - it
obtains file contents from a known source. Let's use it to reobtain
the previously dropped file:

```
datalad get inputs/images/derek-oyen-8PxCm4HsPX8-unsplash.jpg
```
{: .language-bash}
```
...
```
{: .output}

The output shows that it was reobtained from the stored url. You can
now verify that the file has its contents and can be opened again.

The datalad `get` / `drop` mechanism is used a lot. Soon, we will
demonstrate it in action with datasets downloaded from external
sources. However, you can already imagine its potential use cases. If
you have a dataset with many large files and a backup location, you
can use it to keep only part of its contents on your local machine
(e.g. laptop) while being aware of the bigger whole. With that in
mind, let's move on to dataset publishing.

## GIN - configuration (SSH keys)

To participate in the following part you should have registered an
account on GIN. Before we are able to start sending data, we need to
configure our access. This will require a little bit of explanation.

The data transfer to and from GIN (and other git-based platforms, such
as GitHub or GitLab) can be done based on two *protocols*, https (the
same as used by web browsers to access websites) and ssh (typically
used for command line access to remote computers). The https access
uses a combination of user name and password for authentication. For
GIN, it cannot be used to transfer annexed file content. For this
reason, we will prefer the ssh protocol. The authentication is based
on SSH keys - pairs of text files with seemingly random content,
called a *private* and *public* key. The public key is shared with a
server, while the private one is kept on a local computer. They are
generated so that it is easy to verify ownership of one based on the
other, but virtually impossible to forge it.

> ## Note on Binder (no ssh)
> 
> If you are working from the datalad Binder, you will not be able to
> use the ssh protocol, as it is disabled. You can skip the key
> generation part, and replace all URLs below with their https
> counterparts (i.e. `https://gin.g-node.org/` instead of
> `git@gin.g-node.org:/`). This will not allow you to transfer the
> annexed files content, but at least you will be able to transfer
> file information and non-annexed text files.
{: .callout}

To generate the SSH keys, we will follow the GitHub guides on [checking for existing](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/checking-for-existing-ssh-keys) and [generating new keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).
