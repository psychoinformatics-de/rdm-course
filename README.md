RDM with DataLad
================

This workshop teaches best practices for Research Data Management with DataLad.
Content for this workshop was developed by the DataLad team,
while the workshop infrastructure is based on materials developed by The Carpentries (distributed under a CC-BY license).

Contributors
============

For extensive information on how the Carpentries Lesson styles template
is set up and how to customize it, see: https://carpentries.github.io/lesson-example/index.html.

## Editing the config

The `_config.yml` file in the repo root allows several options for customization.
The `carpentry` variable is set to `swc` (line 10), meaning that for any updates where
we want DataLad-specific content to display we will have to ensure these are edited wherever `swc`-specific logic occurs.

## Editing the main page

Edit the `index.md` file in the repo root.

## Adding "episodes"

Add a Markdown file per new episode in the `_episodes` directory.
The `_episodes/01-formatting.md` file can be used as a template for new
episodes, as it already contains examples of most formatting options / 
components that will likely be needed.

Prepend sequential numerical values to the filename in order to specify
episode order.

Episodes will automatically appear in order as part of the schedule on
the main page.

## Setup for local rendering of lessons

To preview the changes locally, follow the instructions from
[Carpentries lesson example](https://carpentries.github.io/lesson-example/setup.html).

Short version:

```bash
# Install:
sudo apt-get install ruby ruby-dev build-essential libxml2-dev
gem install bundler --user-install

# Add ~/.local/share/gem/ruby/2.7.0/bin to path, as per printed message

# In the root of the repository (once) to install dependencies
bundle update

# Start the server
make serve
```

## Slides

Slides, rendered using [marp](https://marp.app/), are placed in `data/slides-html`.
Markdown source for the slides is in `data/slides-md`.


Credit
======

This repo's design was adapted from
[The Carpentries lesson styles template](https://github.com/carpentries/styles/)
(licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).)

The RDM training material itself was created by the DataLad team,
either in full, or adapted from existing openly available material.

Sources include:
- [DataLad Handbook](https://handbook.datalad.org)
- [Naming Things](http://www2.stat.duke.edu/~rcs46/lectures_2015/01-markdown-git/slides/naming-slides/naming-slides.pdf)" (CC0) by Jenny Bryan
- [Project structure](https://slides.djnavarro.net/project-structure) by Danielle Navarro
- [The Turing Way](https://the-turing-way.netlify.app/) (CC-BY 4.0) 

