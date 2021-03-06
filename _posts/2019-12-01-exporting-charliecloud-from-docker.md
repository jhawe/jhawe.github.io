---
title: "Exporting charliecloud tarballs from docker"
date: "Dec 1, 2019"
excerpt: "Explanation on how to create a charliecloud image from docker"
tags: "charliecloud HPC docker reproducibility"
toc: true
permalink: /exporting-charliecloud-from-docker/
---



# Introduction
This post is about how one can build and export [charliecloud](https://github.com/hpc/charliecloud) images from a docker daemon running on your local system.
For more details about charliecloud and how to get Rstudio running with it you can have a look at [my other blog post](/rstudio-server-and-charliecloud).

# Exporting tar-balls from Docker
This is in actuality rather straight forward.
You have to have docker installed on your system and the docker service/daemon needs to be running.

Here is an example on how you can build a container, simply call the `docker build` command from a terminal window and provide the path to the dockerfile via `-f <./path/to/file>` and a nice name via `-t <name>`):


{% highlight bash %}
docker build -f ./dockerfiles/my_dockerfile -t nice_name .
{% endhighlight %}

Don't forget the `.` at the end of the command, otherwise docker will complain.

> NOTE: Avoid putting large files in the directory from which you start the build. Docker will send **all files** in the working directory to the build context which can take a long while. Therefore, also export your images to a different directory outside of the current one.

Now, to package the built image as a charliecloud-readable image tar-ball, you need to first `docker create` your image and then `docker export` it to a `*.tar`-file. Finally, you can `gzip` it to save some space, like so:


{% highlight bash %}
# where to put the image file
mkdir ../images/

# create image and save its id
id=$(docker create nice_name)
docker export $id > ../images/nice_name.tar
gzip -c ../images/nice_name.tar > ../images/nice_name.tar.gz
{% endhighlight %}

The resulting `tar.gz` (in this example `nice_name.tar.gz`) file can then be transferred to e.g. a HPC server running charliecloud to make your very own software stack available there.

# Putting it together
Naturally, the above commands can also be combined to make it even more straight forward to use:


{% highlight bash %}
mkdir ../images/

# save the name in a variable
image_name='nice_name'

docker build -f ./dockerfiles/my_dockerfile -t ${image_name} . && \
  docker export $(docker create ${image_name}) | \
  gzip -c > ../images/${image_name}.tar.gz
{% endhighlight %}

Wrap the above commands in a nice script (e.g. `export_image.sh`) to make your export as easy as possible!

# Summary
That's all! A straight-forward way to bundle your favourite docker image into a charliecloud readable tar-ball. See you next time!

Until then, farewell!
