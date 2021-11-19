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

To generate the SSH keys, we will follow the GitHub guides on [checking for existing](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/checking-for-existing-ssh-keys) and [generating new keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent). The summary below applies to linux.

You may already have an SSH key and may want to use it. To check for
existing keys, enter `ls -al ~/.ssh` to check the contents of the
folder where they are typically stored. By default, a public key file
would be named `id_rsa.pub`, `id_ecdsa.pub` or `id_ed25519.pub` (the
names refer to the algorithms used to generate key pairs). If you
don't see such files, or the `~/.ssh` folder does not exist, you will
need to generate a new pair.

To generate, use the following command (replacing the placeholder with
the e-mail used to register on GIN):
```
ssh-keygen -t ed25519 -C "your_email@example.com"
```
{: .language-bash}

When prompted, accept the default location and choose a password to
protect the key. You may use no password by accepting an empty
one. However, especially on a shared machine, setting a password is
recommended, because it guarantees that a person who gets hold of the
key cannot use it without knowing the password.

Then, you can add the key to the ssh-agent, a helper program running
in the background. First, start the agent if necessary with `eval
"$(ssh-agent -s)"` and add the key with `ssh-add ~/.ssh/id_ed25519`
(if you chose a different name or location, use it instead).

Finally, you can add the public key to GIN. Log in to the web
interface, go to settings (click on your avatar in upper right and
choose "Your Settings"), then select SSH keys in the menu on the left,
and click "Add Key". This will open a form with two fields. In "Key
Name", enter something that you will recognise (eg. "Work laptop" or
"RDM workshop hub"). In "Content", paste the content of the public key
file. To get it, you can display the file and copy its content, or do
it with a single command: `pbcopy < ~/.ssh/id_ed25519.pub`. After
pasting the key, click the "Add key" button.

![Screenshot: adding SSH keys to GIN]({{ page.root }}/fig/GIN_SSH_1.png)
{: .image-with-shadow }

(Image from DataLad Handbook)

## Publishing to GIN (datalad push)

### Create an empty repository on GIN

We have our dataset, we configured our access, and we are ready to
publish. To do so, we first need to create a *repository* - a place on
GIN where things will be stored. To do this, we will go to GIN web
interface (note: DataLad version 0.16, which at the moment of writing
is upcoming, introduces a `create-sibling-gin` command which autoates
this process, but we will use this as an opportunity to take a look at
the GIN web interface anyway).

![Screenshot: creating a new repository on GIN]({{ page.root }}/fig/GIN_newrepo.png)
{: .image-with-shadow }

(Image from DataLad Handbook)

Click the plus button on the upper right and select "New
Repository". Then, enter a repository name (one word, no spaces, but
dashes and underscores are allowed). You can, optionally, add a short
description in "Title". In the "Initial files" section, uncheck the
"Initialize this repository with selected files and template"
checkbox - we want the repository to be empty. Finally, click the
button "Create Repository".

### Publish your dataset

To publish your dataset, you need to add the GIN repository as a
*sibling* of your dataset. To do so, use `datalad siblings add`,
substituting your user name and dataset name below (note that the url
is displayed for you on the GIN website after creating the
repository). Note that since this is the first time you will be
connecting to the GIN server via SSH, you will likely be asked to
confirm to connect. This is a safety measure, and you can type “yes”
to continue.

```
datalad siblings add \
    --dataset . \
    --name gin \
    --url git@gin.g-node.org:/username/dataset-name.git
```
{: .language-bash}

```
(...)
```
{: .output}

The command took three arguments, `dataset` (which dataset is being
configured, `.` means "here"), `name` is the name by which we will
later refer to the sibling, and `url` is the address for transferring
the data.

Afterwards, you can publish your dataset with `datalad push`, using
the name which we set in the command above:

```
datalad push --to gin
```
{: .language-bash}

```
(...)
```
{: .output}

If you now refresh the GIN website, you will find all of your dataset
there (note: if the file names look cryptic and you see "Branch:
git-annex" above the files, pick another branch, likely called "main";
to make this choice permanent, you can go to repository "Settings",
pick "Branches", and select a default branch -- this is dependent on
your git configuration). Observe, that:
- the README is displayed under the list of files
- you can click on files to view their content

TODO:
- add a screenshot
- `datalad siblings`

## Data consumption: datalad clone

With the dataset published, we can now switch our perspective to that
of a data consumer. Obtaining a copy of a dataset is called
*cloning*. To try it out, let's change our working directory outside
the dataset. Assuming we've been at the dataset root, we can change to
the upper directory:

```
cd ..
```

Then, we can clone the dataset using the SSH URL (the same which we
used to publish the data). For your convenience, the URL is displayed
above the file list on GIN.

```
datalad clone git@gin.g-node.org:/username/dataset-name.git
```
{: .language-bash}

```
(...)
```
{: .output}

Note. By default, repositories on GIN are created as private, meaning
that they are accessible only to their owner and, potentially, other
users who were explicitly granted that access. A repository can also
be made public, meaning that it's accessible (for download) to
anybody. Here, we are cloning our own repository, so we can access it
freely regardless of settings.

TODO:
- explain get in a clone
- new header: make changes in a clone (or maybe in a source) and push them
- fetch changes
- explain how it can be useful even if you're working alone on different computers
- move on to an exercise in collaboration?
