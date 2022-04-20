---
title: "Extras: Removing datasets and files"
teaching: 15
exercises: 0
questions:
- "How can I remove files or datasets?"
objectives:
- "Learn how to remove dataset content"
- "Remove unwanted datasets"
keypoints:
- "Your dataset keeps annexed data safe and will refuse to perform operations that could cause data loss"
- "Removing files or datasets with known copies is easy, removing files or datasets without known copies requires by-passing security checks"
- "There are two 'destructive' commands: ``drop`` and ``remove``"
- "``drop`` is the antagonist command to ``get``, and ``remove`` is the antagonist command to ``clone``"
- "Both commands have a ``--reckless [MODE]`` parameter to override safety checks"
---

> ## This is an extra lesson!
>
>Unlike the main Episodes of this course, this lesson focuses on only a specific set of commands independent of a larger storyline.
>It aims to provide a practical hands-on walk-through of removing annexed files or datasets and the different safety checks that can be in place to prevent data loss.
>A complete overview of file system operations, including renaming or moving files, is in [handbook.datalad.org/basics/101-136-filesystem.html](http://handbook.datalad.org/en/latest/basics/101-136-filesystem.html).
{: .callout}

> ##  Prerequisites
> This episode requires DataLad version ``0.16`` or higher due to minor API changes in ``drop`` and ``remove`` that were introduced with ``0.16``.
{: .prereq}

## Drop and remove

Because we're dealing with version control tools whose job it is to keep your data safe, normal file system operations to get rid of files will not yield the intended results with DataLad datasets.
If you were to run "``rm``" on a file or ``<right-click> - <delete>`` it, the file would still be in your dataset's history. If you were to run ``rm -rf`` on a dataset or ``<right-click> - <delete>`` it, your screen would likely be swamped with ``permission denied`` errors.
This section specifically highlights how you can and can't remove annexed contents or complete datasets using the commands ``datalad drop`` and ``datalad remove``. 

``drop`` removes file contents from your local dataset annex, and ``remove`` wipes complete datasets from your system and does not leave a trace of them.
Even though these commands are potentially destructive, they can be useful in many use cases - ``drop`` is most useful to save disk space by removing file contents of currently or permanently unneeded files, and ``remove`` is most useful to get rid of a dataset that you do not need anymore.


### ``drop`` the easy way: file content with verified remote availability 

By default, both commands make sure that you wouldn't loose any data when they are run.
To demonstrate dropping file content, let's start by cloning a public dataset with a few small-ish (less than 80MB in total) files.
[This dataset](https://github.com/datalad-datasets/machinelearning-books) is a collection of machine-learning books and available from GitHub with the following ``clone`` command:

~~~
# make sure to run this command outside of any existing dataset
datalad clone https://github.com/datalad-datasets/machinelearning-books.git
~~~
{: .language-bash}

The PDFs in this dataset are all annexed contents, and can be retrieved using ``datalad get``:

~~~
cd machinelearning-books
datalad get A.Shashua-Introduction_to_Machine_Learning.pdf
~~~
{: .language-bash}

Once you have obtained one file's contents, they are known to exist in their remote registered location and locally on your system:

~~~
git annex whereis A.Shashua-Introduction_to_Machine_Learning.pdf
~~~
{: .language-bash}

~~~
whereis A.Shashua-Introduction_to_Machine_Learning.pdf (2 copies) 
  	00000000-0000-0000-0000-000000000001 -- web
   	0d757ca9-ea20-4646-96cb-19dccd732f8c -- adina@muninn:/tmp/machinelearning-books [here]

  web: https://arxiv.org/pdf/0904.3664v1.pdf
ok
~~~
{: .output}

This output shows that the file contents of this book exist locally and "on the web", more precisely under the URL [arxiv.org/pdf/0904.3664v1.pdf](https://arxiv.org/pdf/0904.3664v1.pdf).

A ``datalad drop <file>`` performs an internal check if the to-be-dropped file content could be re-obtained before dropping it.
When the file content exists in more than your local system, _and_ at least one of those other location is successfully probed to have this content, dropping its file content succeeds.
Here is a successful ``drop``:

~~~
datalad drop A.Shashua-Introduction_to_Machine_Learning.pdf
~~~
{: .language-bash}

~~~
drop(ok): A.Shashua-Introduction_to_Machine_Learning.pdf (file)
~~~
{: .output}

### ``remove`` the easy way: datasets with remote availability

To demonstrate removing datasets, let's remove the `machinelearning-books` dataset.

Because this dataset was cloned from a GitHub repository, it has a registered _sibling_:

~~~
datalad siblings
~~~
{: .language-bash}

~~~
.: here(+) [git]
.: origin(-) [https://github.com/datalad-datasets/machinelearning-books.git (git)]
~~~
{: .output}


``remove`` performs an internal check whether all changes in the local dataset would also be available from a known sibling.
If the dataset has a sibling and this sibling has all commits that the local dataset has, too, ``remove`` succeeds.

Note that ``remove`` needs to be called from _outside_ of the to-be-removed dataset, it can not "pull the rug from underneath its own feet".
Make sure to use ``-d/--dataset`` to point to the correct dataset:

~~~
cd ../
datalad remove -d machinelearning-books
~~~
{: .language-bash}

~~~
uninstall(ok): . (dataset)
~~~
{: .output}


### ``drop`` with disabled availability checks

When ``drop``'s check for continued file content availability from other locations fails, the ``drop`` command will fail, too.
To demonstrate this, let's create a new dataset, add a file into it, and save it.

~~~
datalad create local-dataset
cd local-dataset
echo "This file content will only exist locally" > local-file.txt
datalad save -m "Added a file without remote content availability"
~~~
{: .language-bash}

Verify that its content only has 1 copy, and that it is only available from the local dataset:

~~~
git annex whereis local-file.txt
~~~
{: .language-bash}

~~~
whereis local-file.txt (1 copy) 
  	0d757ca9-ea20-4646-96cb-19dccd732f8c -- adina@muninn:/tmp/local-dataset [here]
ok
~~~
{: .output}

Running ``datalad drop`` will fail now:

~~~
datalad drop local-file.txt
~~~
{: .language-bash}

~~~
drop(error): local-file.txt (file) [unsafe; Could only verify the existence of 0 out of 1 necessary copy; (Note that these git remotes have annex-ignore set: origin upstream); (Use --reckless availability to override this check, or adjust numcopies.)]
~~~
{: .output}


> ## Impeded file availability despite multiple registered sources
> The check for continued file content availability from other locations could fail when there is no other location registered, but also if the registered location is currently unavailable - for example because you disabled your internet connection, because the webserver hosting your contents is offline for maintenance, or because the registered location belongs to an external hard drive that is currently not plugged in.
>
{: .callout}

The error message ``drop`` displays hints at two ways to drop the file content even though no other available copy could be verified: Via a [git-annex configuration](https://git-annex.branchable.com/git-annex-numcopies) ("``adjust numcopies``", which is by default set to ensure at least 1 other copy) or via DataLad's ``--reckless`` parameter.

The ``--reckless`` parameter has multiple modes. Each mode is one type of safety check. Because it is the "availability" check fails, ``--reckless availability`` will disable it:

~~~
datalad drop local-file.txt --reckless availability
~~~
{: .language-bash}

The file content of ``local-file.txt`` is irretrievably gone now.

> ## Dropping multiple versions of a file
> If a file has been updated and saved multiple times, the revision history of the dataset will have each version in the annex, and only the most recent versions' content would be dropped.
>Consider the following example:
> {% raw %}
>       datalad run -m "Make a first version" --output local-file-multiple-revision.txt "echo 'This is the first revision' > {outputs}"
>       # overwrite the contents of the file 
>       datalad run -m "Make a second version" --output local-file-multiple-revision.txt "echo 'This is the second revision' > {outputs}"
> {% endraw %}
>
>``datalad drop --reckless availability local-file-multiple-revision.txt`` would drop the _current_ revision of the file, but the first version (with the content "``This is the first revision``") would still exist in the dataset's history.
>To verify this, ``git checkout`` the first run commit and check the contents of the file.
> {% raw %}
>       git checkout HEAD~1
>       cat local-file-multiple-revision.txt 
>       # outputs "This is the first revision"
>       git checkout main     # or master, depending on your default branch
> {% endraw %}
>
>In order to remove all past versions of this file, too, you can run ``git annex unused`` to find unused data, and `git annex dropunused` (potentially with a ``--force`` flag) to drop it:
>
> {% raw %}
>       git annex unused
>       unused . (checking for unused data...) (checking origin/HEAD...) (checking update-book-2...) (checking 
>       update-book...) (checking main...) 
>       Some annexed data is no longer used by any files:
>           NUMBER  KEY
>           1       MD5E-s27--f90c649b1fe585564eb5cdfdd16ec345.txt
>       (To see where this data was previously used, run: git annex whereused --historical --unused
>  
>       To remove unwanted data: git-annex dropunused NUMBER
>  
>       ok
> {% endraw %}
{: .solution }

### ``remove`` with disabled availability checks

When ``remove``'s check to ensure the availability of the dataset and all its revisions in a known sibling fails - either because there is no known sibling, or because the local dataset has branches or commits that are not available at that sibling, ``remove`` will fail.
This is the case for the ``local-dataset``:

~~~
cd ../
datalad remove -d local-dataset
~~~
{: .language-bash}

~~~
uninstall(error): . (dataset) [to-be-dropped dataset has revisions that are not available at any known sibling. Use `datalad push --to ...` to push these before dropping the local dataset, or ignore via `--reckless availability`. Unique revisions: ['main']]
~~~

``remove`` advises to either ``push`` the "unique revisions" to a different place (i.e., creating a sibling to host your pristine, version-controlled changes), or, similarily to how it was done for ``drop``, to disable the availability check with ``--reckless availability``.

~~~
datalad remove -d local-dataset --reckless availability
~~~
{: .language-bash}

~~~
uninstall(ok): . (dataset)
~~~
{: .output}

### remove gone wrong - how to fix an accidental ``rm -rf``

Removing datasets without ``datalad remove`` is a bad idea - for one, because it skips safety checks that aim to prevent data loss, and secondly, because it doesn't work so well.
If you were to remove a dataset using common Unix commands such as ``rm -rf`` or your operating systems' file browser, you would see the residue of write-protected annexed files refusing to be deleted.
On the command line, it would look something like this:

~~~
cannot remove 'machinelearning-books/.git/annex/objects/zw/WF/URL-s1787416--http&c%%www1.maths.leeds.ac.uk%,126charles%statlog%whole.pdf/URL-s1787416--http&c%%www1.maths.leeds.ac.uk%,126charles%statlog%whole.pdf': Permission denied
rm: cannot remove 'machinelearning-books/.git/annex/objects/jQ/GM/MD5E-s21322662--8689c3c26c3a1ceb60c1ba995d638677.pdf/MD5E-s21322662--8689c3c26c3a1ceb60c1ba995d638677.pdf': Permission denied
[...]
~~~
{: .output}

Afterwards, a few left-over but unusable dataset ruins remain.
To remove those from your system, you need to make the remaining files writable:

~~~
# add write permissions to the directory
chmod -R +w <dataset>
# remove everything that is left
rm -rf <dataset>
~~~
{: .language-bash}
## Further reading

This overview only covers the surface of all possible file system operations, and not even all ways in which files or datasets can be removed. For a more complete overview, checkout [handbook.datalad.org/basics/101-136-filesystem.html](http://handbook.datalad.org/en/latest/basics/101-136-filesystem.html) - the navigation bar on the left of the page lists a number of useful file system operations.
