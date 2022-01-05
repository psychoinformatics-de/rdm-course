---
layout: page
title: Setup
root: .
---

> ## TODO
>
> - Add link to Binder
{: .callout}


## Participate without installation: Jupyter Hub
If you are participating in an organised workshop, the organisers may
have provided you with an access to a Jupyter Hub. In this case you
will be working on a remote server, with all required software,
through a web browser interface. This interface, called Jupyter Lab,
gives you access to a command line, a basic file browser and a basic
text editor.

## Participate without installation: use Binder
If you don't have access to a premade environment (such as the Jupyter
Hub above) and can't or don't want to install anything on your own
machine, you can follow all exercises through
[Binder](https://mybinder.org/v2/gh/datalad-handbook/datalad-tutorial-binder/HEAD).
The link opens a Jupyter Lab interface in your browser (see
above). The binder environment has everything that's needed during the
workshop. However, it has two limitations: it is not persistent (all
content will be removed after you close it) and does not allow
outgoing ssh connections (meaning that during the lesson about
collaboration you won't be able to publish all example data).

## Participate with own computer: install software

If you want to follow the exaples on your own machine, you will need
to install DataLad and some additional software which we will use
during the walkthrough. Note that Linux or MacOS are strongly
recommended for this workshop; although DataLad works on all main
operating systems, on Windows there are some caveats which may
complicate the presented workflow.

### Datalad

For the installation of DataLad, follow the instructions from the
[DataLad
handbook](https://handbook.datalad.org/en/latest/intro/installation.html).

### Python & Pillow

During the workshop, Python will be used to run examples of data
processing. We will use photos to represent data, so in addition to
having python installed you will also need the pillow library. The
best way is to create a virtual environment and install it
there. Here's how to do it with virtualenv and pip:

~~~
virtualenv --system-site-packages --python=python3 ~/.venvs/rdm-workshop
source ~/.venvs/rdm-workshop/bin/activate
pip install pillow
~~~

### Tig

Tig (text mode interface for Git) is a small command line program
which we will use to view dataset history. On Linux you can istall it
with your package manager (e.g. `apt install tig` on Debian and
Ubuntu), and on MacOS it's best to install it through
[homebrew](https://brew.sh) (`brew install tig`), detailed
instructions for different systems are given
[here](https://jonas.github.io/tig/INSTALL.html).

## Register a GIN account

[Gin](https://gin.g-node.org/) is a data hosting / management platform
of the German Neuroinformatics Node. In the module on remote
collaboration we will be using Gin to demonstrate data publishing. If
you want to follow the entire walkthrough, you will need to register a
gin account [here](https://gin.g-node.org/user/sign_up). From the
registration page:

> For Registration we require only username, password, and a valid
> email address, but adding your name and affiliation is
> recommended. Please use an institutional email address for
> registration to benefit from the full set of features of GIN.

<!---
Here's some Software Carpentry code to display switchable panes
for Windows, Linux and MacOS.

{::options parse_block_html="true" /}
<div>
<ul class="nav nav-tabs nav-justified" role="tablist">
<li role="presentation" class="active"><a data-os="windows" href="#windows" aria-controls="Windows" role="tab" data-toggle="tab">Windows</a></li>
<li role="presentation"><a data-os="macos" href="#macos" aria-controls="macOS" role="tab" data-toggle="tab">macOS</a></li>
<li role="presentation"><a data-os="linux" href="#linux" aria-controls="Linux" role="tab" data-toggle="tab">Linux</a></li>
</ul>

<div class="tab-content">
<article role="tabpanel" class="tab-pane active" id="windows">
Computers with Windows operating systems do not automatically have a Unix Shell program
installed.
In this lesson, we encourage you to use an emulator included in [Git for Windows][install_shell],
which gives you access to both Bash shell commands and Git.

Once installed, you can open a terminal by running the program Git Bash from the Windows start
menu.

**For advanced users:**

As an alternative to Git for Windows you may wish to [Install the Windows Subsystem for Linux][wsl]
which gives access to a Bash shell command-line tool in Windows 10.

Please note that commands in the Windows Subsystem for Linux (WSL) may differ slightly
from those shown in the lesson or presented in the workshop.
</article>

<article role="tabpanel" class="tab-pane" id="macos">
For a Mac computer running macOS Mojave or earlier releases, the default Unix Shell is Bash.
For a Mac computer running macOS Catalina or later releases, the default Unix Shell is Zsh.
Your default shell is available via the Terminal program within your Utilities folder.

To open Terminal, try one or both of the following:
* In Finder, select the Go menu, then select Utilities.
  Locate Terminal in the Utilities folder and open it.
* Use the Mac 'Spotlight' computer search function.
  Search for: `Terminal` and press <kbd>Return</kbd>.

To check if your machine is set up to use something other than Bash,
type `echo $SHELL` in your terminal window.

If your machine is set up to use something other than Bash,
you can run it by opening a terminal and typing `bash`.

[How to Use Terminal on a Mac][mac-terminal]
</article>

<article role="tabpanel" class="tab-pane" id="linux">
The default Unix Shell for Linux operating systems is usually Bash.
On most versions of Linux, it is accessible by running the
[Gnome Terminal][gnome-terminal] or [KDE Konsole][kde-konsole] or [xterm][xterm],
which can be found via the applications menu or the search bar.
If your machine is set up to use something other than Bash,
you can run it by opening a terminal and typing `bash`.
</article>
</div>
</div>

[zip-file]: {{ page.root }}/data/shell-lesson-data.zip
[wsl]: https://docs.microsoft.com/en-us/windows/wsl/install-win10
[mac-terminal]: http://www.macworld.co.uk/feature/mac-software/how-use-terminal-on-mac-3608274/
[gnome-terminal]: https://help.gnome.org/users/gnome-terminal/stable/
[kde-konsole]: https://konsole.kde.org/
[xterm]: https://en.wikipedia.org/wiki/Xterm
[install_shell]: https://carpentries.github.io/workshop-template/#shell

-->
