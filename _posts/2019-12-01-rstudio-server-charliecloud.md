---
title: "Using Rstudio server with charliecloud"
date: "Dec 1, 2019"
excerpt: "Explanation on how to run Rstudio server from within a charliecloud container"
tags: "charliecloud rstudio server HPC SLURM R reproducibility"
toc: true
permalink: /rstudio-server-and-charliecloud/
---



# TLDR;
We can run Rstudio server within charliecloud by performing 'fake authentication'
of the Rstudio user using a custom authentication script and by running the `rserver`
binary instead of the usual Rstudio service. I put together the needed scripts and an example dockerfile
in [this repository](https://github.com/jhawe/rstudio-charliecloud).

# Introduction
This post is about how one can use [charliecloud](https://github.com/hpc/charliecloud) on a high-performance computing (HPC) environment running the [SLURM workload manager](https://slurm.schedmd.com/) to run an [Rstudio server](https://rstudio.com/products/rstudio/#rstudio-server).

**Charliecloud** is a lightweight containerization solution (such as [docker](https://www.docker.com) or [singularity](https://singularity.lbl.gov/) which you might have heard of) and as such can be used to run your own user-defined software stack (UDSS, checkout also this [technical paper](http://permalink.lanl.gov/object/tr?what=info:lanl-repo/lareport/LA-UR-16-22370) about charliecloud).
This essentially means that you can define your very own software environment (including any programs/tools/libraries of your choosing), which you can distribute to any system running charliecloud, making it thus possible to have a fully **reproducible** and **isolated** system available anywhere (i.e. you will always have identical software versions wherever you run your container).

**Rstudio** and [**R**](https://www.r-project.org/) is one such software which you might want to make fully reproducible, including any [CRAN](https://cran.r-project.org/) or [bioconductor](https://www.bioconductor.org/) packages, etc.
With Rstudio server, it is possible to create R sessions on a remote computer and access these sessions via your browser through a web interface. R itself, as your probably know, is a script language mainly used for statistical analysis and which makes it easy to for example handle datasets (i.e. cleaning, summarizing and visualizing data).

**SLURM** is a widely used workload manager on **HPC** systems which enables users to send *jobs* (e.g. specific analysis tasks) to a central computing cluster which will then be queued and subsequently executed, thereby leveraging large compute resources.

So, given the information above, one might want to combine the three concepts: Run **R** sessions accessible via a browser (hence **Rstudio** server) on a **HPC** system to leverage resources, while having specific and well-defined R and package versions available which can easily be transferred to any system running **charliecloud** for **reproducibility**.

# The problem
Charliecloud runs **unprivileged** images, that means that software such as Rstudio server which usually need privileged access to a system can not be run without problems.
In this post I'll describe a way to circumvent this issue mainly by

1. not executing the Rstudio-daemon but the `rserver` binary and
2. providing a custom *light* authentication script

The main issue is really that Rstudio tries to perform PAM authentication, which is not possible due to it being run in unprivileged mode. Hence, we generate a custom authentication procedure.

# The solution
We will not handle container creation for an Rstudio server in detail at this point, you just need to have **docker** installed and [create and export](/exporting-charliecloud-from-docker) a charliecloud image using e.g. the [rocker/verse](https://hub.docker.com/r/rocker/verse) definitions from [Docker Hub](https://hub.docker.com/).

The most crucial point is to fake authentication for the Rstudio server (which would usually need privileged access) for your R session. The solution is to create a random password which is shown to the executing user at server start, but will still use the user's system user name.

First, put this into a script (e.g. `r-auth.sh`) and copy the script to the image, e.g. under `/bin/r-auth.sh`. This will handle the authentication step, checking the username and the password set in the `RSTUDIO_PASSWORD` environment variable (set in the next script):


{% highlight bash %}
#!/usr/bin/env bash

# Confirm username is supplied
if [[ $# -ne 1 ]]; then
  echo "Usage: auth USERNAME"
  exit 1
fi
USERNAME="${1}"

# Confirm password environment variable exists
if [[ -z ${RSTUDIO_PASSWORD} ]]; then
  echo "The environment variable RSTUDIO_PASSWORD is not set"
  exit 1
fi

# Read in the password from user
read -s -p "Password: " PASSWORD
echo ""

if [[ ${USERNAME} == ${USER} && ${PASSWORD} == ${RSTUDIO_PASSWORD} ]]; then
  echo "Successful authentication"
  exit 0
else
  echo "Invalid authentication"
  exit 1
fi
{% endhighlight %}

Once this is done, it is relatively simple to start the server.
You can use the following script to do so (you might want to put it also into the charliecloud image for convenience, e.g. under `/bin/start-rstudio.sh`).
Essentially, we just execute the `rserver` binary, specifying the 'fake authentication' script as an authentication helper and preparing the password beforehand:


{% highlight bash %}
#!/bin/bash

# generate a new password to be used for the current user
# Variable 'RSTUDIO_PASSWORD' must be set and is expected by authentication script
password=$(openssl rand -base64 20)
export RSTUDIO_PASSWORD=${password}

echo "Password for this session is:"
echo ${password}

# this path has to match the path to the r-auth.sh script copied to the image!
RSTUDIO_AUTH="/bin/r-auth.sh"

# define port to be used
port=8818

echo ""
echo "Running RStudio server at port ${port}"

# run rstudio
/usr/lib/rstudio-server/bin/rserver \
  --www-port=${port} \
  --auth-none=0 \
  --auth-pam-helper-path=${RSTUDIO_AUTH} \
  --auth-encrypt-password=0
{% endhighlight %}

The lines above will run the server and show the randomly generated password to the user.
If you now access the server via a web browser (type the IP-address or name of the machine you run the server followed by the port specification in the address field, e.g. `http://server-name:8188` if you specified port-number `8188`) you see the Rstudio server login page. Type your usual user-name and provide the generated password shown in the terminal to login to your very own and secured R session!

> NOTE: You might want to pass the port number as a parameter to your script

> NOTE 2: You also might want to consider to create your own secure-cookie-key file if you run it on a multi-user system (which is likely the case!). You can use the `--secure-cookie-key-file` parameter of the `rserver` bin to provide your own file.

# Summary
That's all! Please let me know if I missed some details you'd like to know.
However, the main steps should be straight forward and can be adjusted to your needs as required.
I hope the post helped you along with getting your Rstudio server to run within charliecloud.

Until then, farewell!
