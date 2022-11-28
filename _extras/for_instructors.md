---
layout: page
title: For Instructors
---

To save time during a workshop, organisors and instructors can consider setting
up a cloud-based server beforehand, with Jupyter Hub and all required software
packages pre-installed for all users. This ensures that all users have a working
setup that is accessible via the browser, and prevents user- and operating
system-specific issues from hindering workshop progress.

Below we provide instructions on how to set up
[The Littlest JupyterHub](https://tljh.jupyter.org/en/latest/index.html) for a
small number of users (0-100) on a single
[AWS cloud-computing server](https://aws.amazon.com/ec2/).


### Before you begin

1. Sign up for an [AWS account](https://aws.amazon.com/) and verify it.
2. Consider the costs involved in running a cloud-compute server. AWS provides resources
for checking [EC2 on-demand pricing](https://aws.amazon.com/ec2/pricing/on-demand/) and
also for [calculating cost estimates](https://calculator.aws/) for your usage.
*TODO: add ballpark figures for costs of running a workshop for X users for Y days.*
3. If you want to serve your workshop content via a custom domain (e.g.
[datalad-hub.inm7.de](http://datalad-hub.inm7.de/)), ensure that you have the required
level of access that will allow you to associate the EC2-provided IP address with your
chosen domain address.


> ## AWS account usage can incur costs
>
> While Amazon provides [Free Tier](https://aws.amazon.com/free/) access to its services, it can still potentially result in costs if usage exceeds [Free Tier Limits](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-limits.html). Be sure to take note of these limits, or set up [automatic tracking alerts](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/tracking-free-tier-usage.html) to be notified before incurring unnecessary costs.
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
        --admin <admin-user-name>
    ~~~

    **Be sure to replace `<admin-user-name>` with your username of choice. And the shebang is important, don't miss it!**

    > ## TLJH bootstrap script
    >
    > This bootstrap script is for convenience, so that the server is set up from the get-go. It ensures that you'll only have to work through JupyterHub and not connect to the server via SSH. If you don't paste this bit, you will have to SSH from your terminal and follow the steps described in [Installing on your own server](https://tljh.jupyter.org/en/latest/install/custom-server.html) as if you worked on any other remote server.
    {: .discussion}

8. Finally, select `Launch instance`. Give it about 10 minutes to complete the installation.





