---
layout: page
title: For Instructors
---

To save time during a workshop, organizers and instructors can consider setting
up a cloud-based server beforehand, with JupyterHub and all required software
packages pre-installed for all users. This ensures that all users have a working
setup that is accessible via the browser, and prevents user- and operating
system-specific issues from hindering workshop progress.

Below we provide instructions on how to set up
[The Littlest JupyterHub](https://tljh.jupyter.org/en/latest/index.html) (for short: TLJH) 
for a small number of users (0-100) on a single
[AWS cloud-computing server](https://aws.amazon.com/ec2/). This includes:

1. [Creating an EC2 instance on AWS](#1-creating-an-ec2-instance-on-aws)
2. [Create a constant IP address and domain](#2-create-a-constant-ip-address-and-domain)
3. [JupyterHub configuration](#3-jupyterhub-configuration)
4. [Some notes and further options](#4-some-notes-and-further-options)


### Before you begin

1. Sign up for an [AWS account](https://aws.amazon.com/) and verify it.
2. Consider the costs involved in running a cloud-compute server. AWS provides resources
for checking [EC2 on-demand pricing](https://aws.amazon.com/ec2/pricing/on-demand/) and
also for [calculating cost estimates](https://calculator.aws/) for your usage.
3. If you want to serve your workshop content via a custom domain (e.g.
[datalad-hub.inm7.de](http://datalad-hub.inm7.de/)), ensure that you have the required
level of access that will allow you to associate the EC2-provided IP address with your
chosen domain address.


## AWS account usage can incur costs

> While Amazon provides [Free Tier](https://aws.amazon.com/free/) access to its services, it can still potentially result in costs if usage exceeds [Free Tier Limits](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html). Be sure to take note of these limits, or set up [automatic tracking alerts](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/tracking-free-tier-usage.html) to be notified before incurring unnecessary costs.
>
> In 2022, our costs for a two half-day workshop were about 15 € (we used a small AWS instance for setup, and manually started & stopped a large instance for the workshop sessions only, i.e. about 8 hours).
{: .discussion}


## 1. Creating an EC2 instance on AWS

*Note: The content of this section has been adapted from [The Littlest JupyterHub](https://tljh.jupyter.org/en/latest/install/amazon.html) documentation.*

JupyterHub can be installed on AWS's Elastic Compute Cloud (EC2), resulting in a
setup with admin users and a user environment with conda / pip packages. Please follow
these instructions:

1. In `Services`, find `EC2`, and click `Launch Instances`.
2. `Name and tags`: enter the name that will show in your EC2 management console - something that will identify it for you, like `datalad-workshop`.
3. `Application and OS Images`: choose `Ubuntu` and pick `Ubuntu Server 22.04 LTS`.
4. `Instance type`: while The Littlest JupyterHub documentation recommends `t3.small`, we suggest `t3a.medium`.
The type can easily be up- or downscaled at a later stage. See notes below.
5. `Key pair (login)`: create new one or use one that you have created previously. Creating a new one will download it to your machine, and you should keep this safe. This key can be used for ssh access from your terminal, which will likely only be needed if things go wrong, since you should be able to do everything you need to via the JupyterHub browser interface.
6. `Network settings`: click `Edit` and at `Firewall (security groups)` click `Create security group`, or otherwise `Select existing security group` if you have previously created one. When creating a new security group: 
   - Edit the `Security group name` and `Description`
   - Use `Add security group rule` to ensure that HTTP (TCP port 80), HTTPS (TCP port 443) and SSH (TCP port 22) are all allowed.
   - If a new rule requires the `Source` to be set, use `0.0.0.0/0`
7. `Configure storage`: enter the amount of storage you require. This will vary depending on your workshop content and installed packages.
According to AWS, "free tier eligible customers can get up to 30 GB of EBS General Purpose (SSD) or Magnetic storage".
8. `Advanced details`: expand this section, and at the very end in the text-field `User data`
paste the following code (provided in [The Littlest JupyterHub documentation](https://tljh.jupyter.org/en/latest/topic/customizing-installer.html#topic-customizing-installer)):

   ~~~
   #!/bin/bash
   curl -L https://tljh.jupyter.org/bootstrap.py \
   | sudo python3 - \
       --admin <admin-username>
   ~~~

    **Be sure to replace `<admin-username>` with your username of choice. And the shebang is important, don't miss it!**

    > ## TLJH bootstrap script
    >
    > This bootstrap script is for convenience, so that the server is set up from the get-go. It ensures that you'll only have to work through JupyterHub and not connect to the server via SSH. If you don't paste this bit, you will have to SSH from your terminal and follow the steps described in [Installing on your own server](https://tljh.jupyter.org/en/latest/install/custom-server.html) as if you worked on any other remote server.
    {: .discussion}

8. Finally, select `Launch instance`. Give it about 10 minutes to complete the installation.


## 2. Create a constant IP address and domain

Once launched and running, the instance with JupyterHub environment will be accessible via a
public IP address. You can verify this by navigating to `Instances` in the left-hand sidebar of the EC2 console, then selecting your newly launched instance, and clicking on `open address` next to the IP address in the information block. This should open a browser tab/window with a login interface for JupyterHub.
At this moment, we only have http available (not https).

Technically, this IP address can suffice as a point of entry for users, but there are certain caveats:
- we ideally want the IP address to stay constant even if we stop and restart our instance,
- we want to assign a domain to our hub that makes it easily identifiable (e.g. `datalad-hub.inm7.de`),
- we want the information transfer to and from the server to be securely encrypted via HTTPS,
- HTTPS access in TLJH can only be configured when we have a domain (i.e. not when using a plain IP address).

For these reasons, we need an "Elastic IP":

1. Go to `Elastic IPs` under `Network & Security` in the left-hand sidebar in EC2 console.
2. Click the orange `Allocate Elastic IP address` button.
3. Keep `Amazon's pool of IPv4 addresse` selected, and click `Allocate` at the bottom
4. Next, select the IP address that was allocated, click `Actions` (next to the orange button), and select `Associate Elastic IP address`.
5. Now, associate the elastic IP address with the instance that you've created. If you want to be able to reassociate the elastic IP address in future, check that box. Once done, the newly associated IP address will show up on the instance, and the instance will be accessible via this address.
6. Lastly, ask your friendly system admin to associate this with a custom address likely within your institutional domain (such as `datalad-hub.inm7.de`). Once this is completed, your instance will be accessible via its own custom domain address.

## 3. JupyterHub configuration

Once your instance is set up with JupyterHub installed and accessible via a custom domain,
several steps remain in order to create an environment that is ready to use and intuitive for users.
These include configuring HTTPS, installing required software tools, setting up the default shell, and user management.

### 3.1. Log in and explore the hub

Before doing anything else, navigate to your Elastic IP address or custom domain
and login to JupyterHub. You should type the username that you entered in the place
of `<admin-username>` in the bootstrap script above. You can enter any password you
prefer. This first login will save that as your admin account password. Once logged in,
you will likely see the hub Home View at `<your-hub-address>/hub/home`. From here, you can:

- Start and stop your user server
- Navigate to your server at `<your-hub-address>/user/<admin-username>`. This address can
be appended with `/lab` or `/tree` depending on which interface you'd like to see.
- Navigate to the admin page at `<your-hub-address>/hub/admin`. There you can manually add,
edit, and remove users, and start/stop their servers.
- Change your password by navigating to `<your-hub-address>/hub/auth/change-password`

### 3.2. TLJH configuration

You can configure The Littlest JupyterHub using `tljh-config` via a terminal window once logged in.
For all configuration options, see [the documentation](https://tljh.jupyter.org/en/latest/topic/tljh-config.html). For now, we will only configure our hub to use JupyterLab as the default interface.

Navigate to your server, open up a `Terminal` and type and run the following command:

~~~
sudo tljh-config set user_environment.default_app jupyterlab
~~~

After modification, the configuration should be reloaded in order to take effect:

~~~
sudo tljh-config reload
~~~

In order to view the configuration, you can use:

~~~
sudo tljh-config show
~~~

### 3.3. Set up HTTPS

This can be done with [Let's Encrypt](https://letsencrypt.org/) by following instructions from
[TLJH documentation](https://tljh.jupyter.org/en/latest/howto/admin/https.html#):

1. Enable HTTPS:
   ~~~
   sudo tljh-config set https.enabled true
   ~~~
2. Set your email addres for Let's Encrypt:
   ~~~
   sudo tljh-config set https.letsencrypt.email <you@example.com>
   ~~~
   where `<you@example.com>` should be replaced by your email address.
3. Add your domain:
   ~~~
   sudo tljh-config add-item https.letsencrypt.domains <your-hub-address>
   ~~~
   where `<your-hub-address>` should just be the custom part of the address
   excluding `http...`, e.g.: `datalad-hub.inm7.de`
4. Check the updated configuration to make sure all details are correct.
   ~~~
   sudo tljh-config show
   ~~~
   You should see something like this:

   ~~~
   users:
      admin:
      - admin-username
   user_environment:
      default_app: jupyterlab
   https:
      enabled: true
      letsencrypt:
         email: you@example.com
         domains:
         - datalad-hub.inm7.de
   ~~~
   {: .output}
5. Finally, reload the proxy to load the new configuration:
   ~~~
   sudo tljh-config reload proxy
   ~~~
   This could also require you to to refresh the page (with the address now containing `https`
   instead of `http`) and log in again.

### 3.4. Increase cull timeout

JupyterHub will [shut down inactive notebook servers](https://tljh.jupyter.org/en/latest/topic/idle-culler.html) to save resources.
Although state is restored, having to click "restart my server" if there is a pause during the workshop may be irritating.
To increase cull timeout, do:
~~~
sudo tljh-config set services.cull.timeout <time in seconds>
~~~
If you plan to leave a low-resource instance running for users to explore, you may wish to adjust culling only before the workshop.

### 3.5. Install required tools into the base environment

This ensures that you have the required tools for the rest of the configuration procedure
as well as those required for the workshop.

Run the following lines one by one, typing `y` for "Yes" whenever you are prompted to continue:
~~~
sudo apt update
sudo apt upgrade
sudo apt install zsh tig tree
~~~

For the workshop itself, we want to install datalad and its dependencies.
Run the following lines one by one:
~~~
sudo -E apt install git-annex
sudo -E -H pip3 install datalad
~~~

Depending on the content of your workshop, you might also want to install DataLad extensions or
other packages. This would be a sensible time to do so. Remember to add `sudo -E` in front of the
install command in order to make the installation apply to all users.

### 3.6. Set up the default shell

We will set up [`zsh`](https://en.wikipedia.org/wiki/Z_shell) as the default shell for the terminal.
Currently, when you open a terminal and run `echo $0`, it should print `/usr/bin/bash`, indicating that
the current default is bash.

In order to change the default, we need to import some `dotfiles` (we will use
[Pure](https://github.com/sindresorhus/pure)) and tell the terminal and hub how
to access them in order to set the default shell to `zsh`:

1. Run the following lines one by one in order to import the dotfiles:
   ~~~
   sudo mkdir -p "$HOME/.zsh"
   git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
   ~~~
2. Create a `.zshrc` file in your HOME directory with a basic configuration taken, e.g., from [this source](https://gist.github.com/mslw/926f1191e61ef2d705fadab66d19b8ba):
   ~~~
   wget https://gist.githubusercontent.com/mslw/926f1191e61ef2d705fadab66d19b8ba/raw/.zshrc
   ~~~
3. Lastly, we also need to make the hub aware of which shell it should use when launching a terminal.
   We do this with a configuration script. Run the following lines one by one:
   ~~~
   touch "$HOME/.jupyter/jupyter_notebook_config.py
   echo 'c.NotebookApp.terminado_settings = {"shell_command": ["/usr/bin/zsh"]}' > "$HOME/.jupyter/jupyter_notebook_config.py
   ~~~
4. This finalizes the shell setup. You can now navigate to the hub's admin panel and restart your server
   in order for the changes to take effect.


### 3.7. Create a global `gitignore`

When we work with `git` repositories and add content or code, we often want certain files
or directories not to form part of the `git` history. We can achieve this by telling `git`
to ignore certain files or directories, via the `.gitignore` configuration. JupyterHub stores its own
metadata files under `.ipynb_checkpoints` and will create this directory whenever the hub's text
editor is used, or a notebook is opened. To prevent these directories for getting into user's way
when working with DataLad, we will create a global (user-level) `gitignore` configuration following
[this method](https://docs.github.com/en/get-started/getting-started-with-git/ignoring-files#configuring-ignored-files-for-all-repositories-on-your-computer):

~~~
echo ".ipynb_checkpoints" > ~/.gitignore_global
git config --global core.excludesfile "~/.gitignore_global"
~~~

### 3.8. Set up default user settings and data

What we have done up until now is to set up the base environment that a user will encounter
when they log into the JupyterHub. Some tools and packages, such as `datalad`,
 have been installed for all users (as a result of using `pip` with `sudo -E`). However,
some settings were done only for the admin account, and  will not yet be the default for 
other, newly created users. This includes the default
shell setup as well as any data content. We can ensure that any configuration files or data content
are available to individual users by copying the required content to the `/etc/skel` directory, the
contents of which will be placed in the `$HOME` directories of newly created users.

Run the following code to copy the `zsh` configuration files, the `.gitignore_global` file, and the `jupyter_notebook_config.py` file:
~~~
sudo mkdir -p /etc/skel/.zsh
sudo cp -r "$HOME/.zsh/pure" /etc/skel/.zsh/
sudo cp "$HOME/.zshrc" /etc/skel/
 
sudo cp "$HOME/.gitconfig" /etc/skel/
sudo cp "$HOME/.gitignore_global" /etc/skel/ 

sudo mkdir -p /etc/skel/.jupyter
sudo cp "$HOME/.jupyter/jupyter_notebook_config.py" /etc/skel/.jupyter/
~~~

Now, at long last, you can create a new user from the JupyterHub admin panel.
Using this user, login from another device or using the browser's incognito mode,
and then check to see that everything functions as expected.

### 3.9. Finally, add users!

Depending on group size and logistics, we suggest creating users beforehand via the admin control panel (e.g. using their email addresses, or the username part of these), and letting users create their own passwords once they navigate to the hub URL for the first time. This is the default configuration.

Different authentication options are possible (e.g. admin can also authenticate users individually after they sign up, or authentication can happen via Google, GitHub or AWS). Refer to the documentation for further options.


## 4. Some notes and further options

### EC2 instance notes

- The letter `a` in type name (eg. `t3a.medium`) means that they are running on AMD, and are slightly cheaper than their Intel counterparts (without the `a`).
- There are different [instance types](https://aws.amazon.com/ec2/instance-types/). We're interested in T3 and M5, both of which are multipurpose. T3 instances are burstable (meaning they accumulate credits when idling and use them when active, so don't offer full performance all the time, which suits us well). M5 are fixed-performance multipurpose (you get the full capacity all the time).
- TLJH recommends `t3.small` to start with: 2 vCPU and 2 GB RAM should be enough to install everything (though some conda installs may be pushing the 2GB RAM limit for some reason).
- We went with `t3a.medium` from the get-go: 2 vCPU and 4GB RAM are very comfortable for all setup steps, and it should be fine for a few concurrent users if you want to leave the hub running between workshop days - the price around $1 a day seems fine for that.
- For the workshop sessions, consider upscaling to `M5a.4xlarge` (for the live sessions only, meaning downscaling back to `t3a.medium` overnight in a 2-day format). The "quadruple extra large" offers 16 vCPU and 64 GB RAM. Judging by looking at htop, this is serious overprovisioning even for ca 16 people, but at $1 an hour it seems a reasonable price for comfort.
- To scale (up or down), go to EC2 management console, select your instance, right click (or click on Actions), and stop it. Then again right-click (or Actions), instance settings, change instance type. Then bring it back up.
- Elastic IP incurs cost when not associated with a running instance, but it is marginal.
- After the workshop, you will want to pull everything down, including storage (if left sitting, storage may generate a couple dollars per month).

### Troubleshooting

- When checking if your hub was initialized successfully, apart from trying to access the server's ip address, you may want to view the AWS's system log.
- In EC2 Management Console, Instances page, right click your instance, and select "Monitor and troubleshoot", "Get system log".
- If system setup was finished, there will be a lot of text, most likely ending with something like:
~~~
2022/12/01 12:40:30Z: OsProductName: Ubuntu
2022/12/01 12:40:30Z: OsVersion: 22.04
~~~
- If the JupyterHub bootsrap script succeeded, within the last 30 lines you will find:
~~~
[  210.143720] cloud-init[1233]: Waiting for JupyterHub to come up (1/20 tries)
[  210.147437] cloud-init[1233]: Done!
~~~
- If the "user data" was not given, or pasted incorrectly (e.g. without admin name), within the last 30 lines you will probably see:
~~~
cloud-init[1246]: 2022-12-01 12:40:29,790 - util.py[WARNING]: Running module scripts-user (<module 'cloudinit.config.cc_scripts_user' from '/usr/lib/python3/dist-packages/cloudinit/config/cc_scripts_user.py'>) failed
~~~
- In case of problems, you can log in through `ssh` and try running the TLJH bootstrap script manually, or terminate the instance and start over.
