---
title: "Extras: The Basics of Branching"
teaching: 60
exercises: 0
questions:
- "What are branches, and why do you need them?"
objectives:
- "Get an understanding of Git's concept of a branch."
- "Create new branches in your dataset and switch between them."
- "Master the basics of a contribution workflow."
- "Understand what you need forks for TODO"
keypoints:
- "Your dataset contains branches. The default branch is usually called either `main` or `master`"
- "There's no limit to the number of branches one can have, and each branch can become an alternative timeline with developments independent from the developments in other branches"
- "Branches can be `merged` to integrate the changes from one branch into another."
- "Using branches is fundamental in collaborative workflows where many collaborators start from a clean default branch and propose new changes to a central dataset sibling."
- "Typically, central datasets are hosted on services like GitHub, GitLab, or Gin, and if collaborators push their branches with new changes, these services help to create pull requests."
---

> ## This is an extra lesson!
>
> Unlike the main Episodes of this course, this lesson focuses less on purely DataLad-centric workflows, but conveys concepts of Git's more advanced features.
>It aims to provide a more solid understanding of Git's _branches_, why and when they are useful, and how to work with them productively.
>Because DataLad datasets are Git repositories, mastering the concept of branches will translate directly into DataLad workflows, for example collaboration.
>This can be helpful for the [main episode on remote collaboration]({{ page.root }}{% link _episodes/03-remote-collaboration.md %})  ...TODO link overview GitHub
{: .callout}

> ##  Prerequisites
> This extra episode works best if you have worked through the episode [Content Tracking with DataLad]({{ page.root }}{% link _episodes/01-content-tracking-with-datalad.md %}) first, or if you already have created a DataLad dataset an made a few modifications.
{: .prereq}


## What is a branch?

You already know that a dataset keeps a revision history of all past changes.
Here is a short example with the development history of a dataset.
Albeit minimal, it is a fairly stereotypical example of a revision history for a data analysis: Over time, one adds a script for data processing, and changes and fixes the pipeline until it is ready to compute the data.
Then, the data are processed and saved, and once its published, one adds a DOI to the dataset README.

<a href="{{ page.root }}/fig/tig.png">
  <img height="100px" src="{{ page.root }}/fig/tig.png" alt="An example dataset history" />
</a>

You can envision these changes like consecutive points on a timeline.

<a href="{{ page.root }}/fig/branching/linear_time_1.svg">
  <img height="200px" src="{{ page.root }}/fig/branching/linear_time_1.svg" alt="A revision history is like a timeline" />
</a>

This timeline exists on a _branch_ - a lightweight history streak of your dataset.
In this example here, the timeline exists on only a single branch, the default branch.
This default branch is usually called either `main` or `master`.
Let's tag this timeline with its branch name:

<a href="{{ page.root }}/fig/branching/linear_time_2.svg">
  <img height="200px" src="{{ page.root }}/fig/branching/linear_time_2.svg" alt="A revision history is like a timeline" />
</a>

## A basic branching workflow

Git doesn't limit you to only a single timeline.
Instead, it gives you the power to create as many timelines (branches) as you want, and those can co-exist in parallel (just don't tell Physics).
This allows you to make changes in different timelines, i.e., you can create "alternative realities".
And what is more is that you have the power to travel across timelines, merge timelines or parts of them together, or add single events from one timeline to a different timeline.
(We secretely hope that this way of phrasing it sounds cool enough to interest you enough to endure a short demonstration of a workflow that uses branching, but may feel like uneccessary work at first.)

Lets go back in time and see how this dataset history could have reached its latest state (`added DOI to README`) in a workflow that used more than one branch.

**The big bang: Dataset creation**

At the start of time stands the first commit on the default branch.
A `datalad create` is the big bang at the start of your multiverse that creates both the default branch and the first commit on it:

<table>
<tr>
<td style="text-align:left; vertical-align:middle">
<code>$ datalad create mydataset</code>
</td>
<td>
<a href="{{ page.root }}/fig/branching/branching_1.svg">
  <img height="600px" src="{{ page.root }}/fig/branching/branching_1.svg" alt="A revision history is like a timeline" />
</a>
</td>
</tr>
</table>

The next major event in the young and yet single-verse is the addition of the processing script.
Its probably one a past graduate student left on the lab server - finders-keepers.

<table>
<tr>
<td style="text-align:left; vertical-align:middle">
<code>$ datalad save -m \ <br>
     "adding processing pipeline"</code>
</td>
<td>
<a href="{{ page.root }}/fig/branching/branching_2.svg">
  <img height="600px" src="{{ page.root }}/fig/branching/branching_2.svg" alt="A revision history is like a timeline" />
</a>
</td>
</tr>
</table>

**Escape to a safe sandbox**

The old script proves to be not as reusable as initially thought.
It parameterizes the analysis really weirdly, and we're not sure that we can actually run it on the data because it needs to much work.
Nevertheless, let's give it a try.
But because we're not sure if this endeavour works, we will teleport ourselves to a new timeline - a branch that is independent from the default branch, yet still contains the script, allowing us to do some experimental changes without cluttering the main history line, for example changing the parametrization.

<table>
<tr>
<td style="text-align:left; vertical-align:middle">
<code># create and enter a new branch<br>
$ git branch preproc <br>
$ git checkout preproc <br>
<br>
# alternatively, shorter: <br>
$ git checkout -b preproc" <br>
<br>
$ datalad save -m \ <br>
"Added parametrization A"</code>
</td>
<td>
<a href="{{ page.root }}/fig/branching/branching_3.svg">
  <img height="600px" src="{{ page.root }}/fig/branching/branching_3.svg" alt="A revision history is like a timeline" />
</a>
</td>
</tr>
</table>

In theory, we can now continue the development in the alternative timeline until it is time to compute the results.

<table>
<tr>
<td style="text-align:left; vertical-align:middle">
<code>$ datalad save -m \ <br>
"Tweak parameter, add comments"<br>
<br>
$ datalad save -m "Compute results"</code>
</td>
<td>
<a href="{{ page.root }}/fig/branching/branching_4.svg">
  <img height="600px" src="{{ page.root }}/fig/branching/branching_4.svg" alt="A revision history is like a timeline" />
</a>
</td>
</tr>
</table>

**Merging timelines - I**

And in theory, when the results look good, we can take a good look at the timeline we created and deem it worthy of "a merge" - getting integrated into the default branches' timeline.
How does it work? It involves jumps between branches:

<table>
<tr>
<td style="text-align:left; vertical-align:middle">
<code># switch back to the default branch <br>
$ git checkout main <br>
# merge the history of preproc into main<br>
$ git merge preproc</code>
</td>
<td>
<a href="{{ page.root }}/fig/branching/branching_5.svg">
  <img height="600px" src="{{ page.root }}/fig/branching/branching_5.svg" alt="A revision history is like a timeline" />
</a>
</td>
</tr>
</table>

This merge integrates all developments on the `preproc` branch into the `main` branch.

**Merging timelines II**

However, things could have gone slightly different.
Lets rewind and consider a slight complexity: After we started working on tuning the processing pipeline, the old graduate student called.
They apologized for the state of the script and urged us to change the absolute paths to relative paths - else it would never run for us.

How do we handle this? The change needs to go into the default branch because it is important, but it should not be a part of ``preproc``, as this branch shall be transparently dedicated only to tuning and performing the preprocessing.
We could add it straight to `main`, but we can also keep the branching workflow and perform the change on a new branch (`fix-paths`) that we then merge:


<table>
<tr>
<td style="text-align:left; vertical-align:middle">
<code>
# create and enter a new branch <br>
$ git branch fix-paths<br>
$ git checkout fix-paths <br>
$ datalad save -m "Fix: Change absolute to relative paths" <br>
<br>
# merge the fix into main <br>
$ git checkout main <br>
$ git merge fix-paths
</code>
</td>
<td>
<a href="{{ page.root }}/fig/branching/branching_6b.svg">
  <img height="600px" src="{{ page.root }}/fig/branching/branching_6b.svg" alt="A revision history is like a timeline" />
</a>
</td>
</tr>
</table>

**Merging timelines III**

Even though we didn't want to make the change to the paths on a branch dedicated to preprocessing, the fix is still crucial to run the script on the data.
So in order to get the fix (which is now a part of `main`) we can merge the changes from `main` into `preproc`.

<table>
<tr>
<td style="text-align:left; vertical-align:middle">
<code>
# enter preproc <br>
$ git checkout preproc <br>
# merge the fix from main into preproc <br>
$ git merge main
</code>
</td>
<td>
<a href="{{ page.root }}/fig/branching/branching_7b.svg">
  <img height="600px" src="{{ page.root }}/fig/branching/branching_7b.svg" alt="A revision history is like a timeline" />
</a>
</td>
</tr>
</table>

With fixes and tuning done, the data can be computed, ``preproc`` can be merged into `main`, and the development that does not need sandboxing (like adding a DOI badge to the README) can continue in the `main` branch.

<table>
<tr>
<td style="text-align:left; vertical-align:middle">
<code>
$ datalad save -m "Compute results" <br>
$ git checkout main <br>
# merge preproc into main <br>
$ git merge preproc
</code>
</td>
<td>
<a href="{{ page.root }}/fig/branching/branching_8.svg">
  <img height="600px" src="{{ page.root }}/fig/branching/branching_8.svg" alt="A revision history is like a timeline" />
</a>
</td>
</tr>
</table>


> ## Keypoints
>
> Branches are lightweight, independent history streaks of your dataset. Branches can contain less, more, or changed files compared to other branches, and one can merge the changes a branch contains into another branch. Branches can help with sandboxing and transparent development.
>While branching is a Git concept and is done with Git commands, it works in datasets (which are Git repositories under the hood) just as well.
{: .keypoints}
>

#### And... what now?

The end result of all this timeline travelling may be a bit underwhelming.
Because what this process ends in is the very same timeline as when working on the very same branch, just that its visualization is slightly more complex:

<table>
<tr>
<td>
<a href="{{ page.root }}/fig/branching/tig-branches.png">
  <img height="100px" src="{{ page.root }}/fig/branching/tig-branches.png" alt="A revision history is like a timeline" />
</a>
</td>
<td>
<iframe src="https://giphy.com/embed/xUPJPehFKgld5lttRK" width="30%" height="30%" frameBorder="0"></iframe></td>
</tr></table>

> ## Exercise
>
> To make up for this slight disappointment, enjoy one of the most well-made audio-visuals of the branching workflow. As an exercise, pay close attention to the git commands at the bottom of the video, and also the colorful branch and commit visualizations. Note how each instrument is limited to its branch until several branches are merged.
> Which concepts are new, which ones did you master already?
> <iframe width="760" class="yt-wrapper2" height="515" src="https://www.youtube-nocookie.com/embed/S9Do2p4PwtE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
{: .challenge}


## The true power in collaborative scenarios

The true power of this workflow is visible in collaborative scenarios.
Imagine we're not alone in this project - we teamed up with the grad student that wrote the script.

### Setup for collaboration

Collaboration requires more than one dataset, or rather many copies (so called _siblings_) of the same dataset.
In a common collaborative workflow every involved collaborator has their own sibling of the dataset on their own computer.
Often, these datasets are siblings of one central dataset, which is commonly called `upstream` (though nothing enforces this convention - you could chose arbitrary names).
`upstream` is also where every collaborator sends their changes to, and typically lives on a Git repository hosting services such as GitHub, GitLab, Gin, or Bitbucket, because those services are usually accessible to every collaborator and provide a number of convenient collaborative features.

Lets travel back in time and put the dataset to GitHub after the old processing script was added to it.

<table>
<tr>
<td style="text-align:left; vertical-align:middle">
<code># create a sibling repository named "mydataset" <br>
# on your user account on GitHub (github.com/username/mydataset) <br>
# (You need to create and supply a token the first time) <br>
$ datalad create-sibling-github mydataset --sibling-name upstream <br>
<br>
# Send the commit history to the sibling on GitHub. <br>
$ datalad push --to upstream
</code></td>
<td>
<a href="{{ page.root }}/fig/branching/collab_1.svg">
  <img height="600px" src="{{ page.root }}/fig/branching/collab_1.svg" alt="A revision history is like a timeline" />
</a>
</td>
</tr></table>

Lets now also invite the old graduate student to collaborate on the analysis with us.
What they do first is obtain a clone from GitHub to their own Laptop.

<table>
<tr>
<td style="text-align:left; vertical-align:middle">
<code># get a clone from GitHub <br>
$ datalad clone git@github.com:username/mydataset.git <br>
<br>
# also name this sibling "upstream" for consistency<br>
# (by default the location one clones from is registered as 'origin') <br>
$ git remote rename origin upstream
</code></td>
<td>
<a href="{{ page.root }}/fig/branching/collab_2.svg">
  <img height="600px" src="{{ page.root }}/fig/branching/collab_2.svg" alt="A revision history is like a timeline" />
</a>
</td>
</tr></table>

With every collaborator set up with a dataset to work on in parallel, we can work on preprocessing tuning, while the old grad student fixes the issue with the absolute paths.

<table>
<tr>
<td style="text-align:left; vertical-align:middle">
<code># Work on our sibling <br>
$ git branch preproc<br>
$ git checkout preproc<br>
$ datalad save -m "Added parametrization A"<br>
$ datalad save -m "Tweak parameter, add comments"<br>
...<br>
<br>
<br>
# Work on the other grad students sibling <br>
$ git branch fix-paths <br>
$ git checkout fix-paths <br>
$ datalad save -m "Fix: Change absolute to relative paths</code></td>
<td>
<a href="{{ page.root }}/fig/branching/collab_3.svg">
  <img height="600px" src="{{ page.root }}/fig/branching/collab_3.svg" alt="A revision history is like a timeline" />
</a>
</td>
</tr></table>

In order to propose the fix to the central dataset as an addition, the collaborator pushes their branch to the central sibling.
When the central sibling is on GitHub or a similar hosting service, the hosting service assists with merging `fix-paths` to `main` with a **pull request** - a browser-based description and overview of the changes a branch carries.
Collaborators can conviently take a look and decide whether they accept the pull request and thereby merge the `fix-paths` into `upstream`'s `main`.
You can see how opening and merging PRs look like in GitHub's interface in the expandable box below.

> ## Creating a PR on GitHub
>
>TODO: add images of PRs
>
{: .solution }



<table>
<tr>
<td style="text-align:left; vertical-align:middle">
<code>$ datalad push --to upstream <br>
# alternatively, with Git<br>
$ git push upstream fix-paths
</code></td>
<td>
<a href="{{ page.root }}/fig/branching/collab_4.svg">
  <img height="600px" src="{{ page.root }}/fig/branching/collab_4.svg" alt="A revision history is like a timeline" />
</a>
</td>
</tr></table>


Because those fixes are crucial to do the processing, we can now get them from the central sibling `upstream` - this time using `git pull upstream main` to `merge` the `main` branch of `upstream`.



<table>
<tr>
<td style="text-align:left; vertical-align:middle">
<code> # we merge upstream's changes into our preproc branch<br>
$ git pull upstream main
</code></td>
<td>
<a href="{{ page.root }}/fig/branching/collab_5.svg">
  <img height="600px" src="{{ page.root }}/fig/branching/collab_5.svg" alt="A revision history is like a timeline" />
</a>
</td>
</tr></table>

Now that we have the crucial fix thanks to the parallel work of our collaborator, we can finally run the processing, and push our changes as well to propose them as a pull request to `upstream`:

<table>
<tr>
<td style="text-align:left; vertical-align:middle">
<code>$ datalad save -m "Compute results"
$ datalad push --to upstream
</code></td>
<td>
<a href="{{ page.root }}/fig/branching/collab_6.svg">
  <img height="600px" src="{{ page.root }}/fig/branching/collab_6.svg" alt="A revision history is like a timeline" />
</a>
</td>
</tr></table>

`upstream`'s default branch `main` now has a transparent and clean history with contributions from different collaborators. You can continue to make unobstructive changes to `main`, such as adding the DOI badge after publication of your fantastic results, but having used branches in the collaborative workflow before ensured that both changes could be developed in parallel, and integrated without hassle into `main`.

<table>
<tr>
<td style="text-align:left; vertical-align:middle">
<code>$ datalad save -m "Compute results"
$ datalad push --to upstream
</code></td>
<td>
<a href="{{ page.root }}/fig/branching/collab_7.svg">
  <img height="600px" src="{{ page.root }}/fig/branching/collab_7.svg" alt="A revision history is like a timeline" />
</a>
</td>
</tr></table>


## Further reading

Understanding and mastering branching keeps many people awake at night.
It is a powerful concept, but it requires some time to generate the right mental model.
Luckily, you will find hundreds of useful resources on the internet.
Here, we'll recommend two:

* The first one is [The Git Parable](https://tom.preston-werner.com/2009/05/19/the-git-parable.html) (20 min reading time). It is a story-like journey that not only explains the complex fundamental workings of Git, it also motivates them in an accessible way.
As an added benefit, having read this text will make you friends with every open source software contributor at the next party - it works just like mentioning in passing that you have seen _\<insert-niche-Indie-band-here\>_ in person to someone who has been a life-long fan.

* The second one is the free, browser-based game [learngitbranching.js.org](https://learngitbranching.js.org). You will learn a lot of Git commands in passing, its at least as much fun and colors as Candy Crush, and the best use of time during boring Zoom seminars.
