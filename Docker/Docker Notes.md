# Docker

- [Docker](#docker)
  - [What is Docker](#what-is-docker)
  - [How it works](#how-it-works)
  - [Installing Docker](#installing-docker)
  - [Docker Privilege](#docker-privilege)
  - [Testing Docker installation](#testing-docker-installation)
  - [The Dockerfile](#the-dockerfile)
  - [docker images - View currently installed images](#docker-images---view-currently-installed-images)
  - [--help - Get help on any docker subcommand](#help---get-help-on-any-docker-subcommand)
  - [docker pull - Download an image or a repository from a registry](#docker-pull---download-an-image-or-a-repository-from-a-registry)
  - [docker run - Run an installed docker image](#docker-run---run-an-installed-docker-image)
  - [docker ps - List containers](#docker-ps---list-containers)
  - [docker rm - Remove a container](#docker-rm---remove-a-container)
  - [docker start - Startup a container](#docker-start---startup-a-container)
  - [docker stop - Stop container from running](#docker-stop---stop-container-from-running)
  - [docker restart - Restart a container](#docker-restart---restart-a-container)
  - [docker attach - View container command line](#docker-attach---view-container-command-line)
  - [Docker networking](#docker-networking)
  - [Docker Storage](#docker-storage)
  - [Docker Lab Example](#docker-lab-example)
  - [Vagrant or Docker](#vagrant-or-docker)
  - [Lab Exercise](#lab-exercise)

## What is Docker

It is a way of running multiple software applications on the same machine.

Each of which is run is an isolated environment called a "container".

It eliminates the annoying problem of "works on my machine".
Software is packaged in the container and,
hence, can be run on any machine that has the Docker engine installed.

A container is a closed environment for the software.
It bundles all the files and libraries that the
application needs to function correctly.
Multiple containers can be deployed on the same machine and share resources.

But isn't that what virtual machines and Vagrant do?

No, virtualization is the process of abstracting the operating
system hardware so that complete machines can be run simultaneously on
the same host.

Containers on the other hand use the same physical hardware
of the host machine to run just the application in an isolated
environment

Containers, by definition, use less resources than virtual machines.
However, they have the drawback of using Linux kernels only.
You cannot containerize a Windows or a MAC application.

## How it works

Vagrant uses boxes to distribute virtual machines. A box can be used to spawn multiple machines.

Docker works in the same manner. It uses images to spawn containers.
Multiple containers can be created using an image.

Images are index and saved in an online repository managed by Docker. It can be found on:
[https://hub.docker.com/explore](https://hub.docker.com/explore)

Of course you can also create and maintain your own images.

Example of dockers power:

- You have a web application running on Ubuntu 15.
- You need to upgrade your OS to the latest Ubuntu 17. but then the software will not run as it depends on libraries that are only available in Ubuntu 15.
- Using a Docker image to run this software, you can upgrade Ubuntu to the latest version and ensure that the application will continue to run in complete isolation of the OS current libraries.
  
## Installing Docker

We will install the Community Edition (CE) which is free as compared to the Enterprise Edition.

```bash
sudo apt-get update

# Install prerequisites
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io
```

## Docker Privilege

You must use `sudo` whenever using docker

## Testing Docker installation

```bash
sudo docker run hello-world
# Unable to find image 'hello-world:latest' locally
# latest: Pulling from library/hello-world
# 1b930d010525: Pull complete
# Digest: sha256:b8ba256769a0ac28dd126d584e0a2011cd2877f3f76e093a7ae560f2a5301c00
# Status: Downloaded newer image for hello-world:latest
#
# Hello from Docker!
# This message shows that your installation appears to be working correctly.
#
# To generate this message, Docker took the following steps:
#  1. The Docker client contacted the Docker daemon.
#  2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
#     (amd64)
#  3. The Docker daemon created a new container from that image which runs the
#     executable that produces the output you are currently reading.
#  4. The Docker daemon streamed that output to the Docker client, which sent it
#     to your terminal.
#
# To try something more ambitious, you can run an Ubuntu container with:
#  $ docker run -it ubuntu bash
#
# Share images, automate workflows, and more with a free Docker ID:
#  https://hub.docker.com/
#
# For more examples and ideas, visit:
#  https://docs.docker.com/get-started/
```

## The Dockerfile

Like the Vagrantfile for Vagrant machines, the `Dockerfile` is an
instructions file used for building containers.

However, Vagrant must have a Vagrantfile for the machine to work.
Docker needs the Dockerfile only if you are building new images.

Building an image is an incremental process.
For example, you may download the apache web server image (httpd),
and use a Dockerfile to install components on top of it like a specific
version of PHP.

You can add new packages, change configuration files, create new users and groups,
and even copy files and directories to the image.

An example of a Dockerfile can be examined through this URL:
[https://github.com/docker-library/httpd/blob/master/2.4/Dockerfile](https://github.com/docker-library/httpd/blob/master/2.4/Dockerfile)

Dockerfile cheat sheet: [https://kapeli.com/cheat_sheets/Dockerfile.docset/Contents/Resources/Documents/index](https://kapeli.com/cheat_sheets/Dockerfile.docset/Contents/Resources/Documents/index)

Simple Dockerfile Example:

```docker
# Base it on an existing Dockerfile
FROM httpd:2.4

# Copy directory on host machine into directory in container
COPY ./public-html/ /usr/local/apache2/htdocs
```

To use this Dockerfile:

```bash
# Build the Dockerfile into an image called my-apache2
sudo docker build -t my-apache2

# Run a container based on that image
sudo docker run -dit --name my-running-app my-apache2
```

## docker images - View currently installed images

```bash
sudo docker images
# REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
# hello-world         latest              fce289e99eb9        8 months ago        1.84kB
```

## --help - Get help on any docker subcommand

```bash
sudo docker images --help
#
# Usage:  docker images [OPTIONS] [REPOSITORY[:TAG]]
#
# List images
#
# Options:
#   -a, --all             Show all images (default hides intermediate images)
#       --digests         Show digests
#   -f, --filter filter   Filter output based on conditions provided
#       --format string   Pretty-print images using a Go template
#       --no-trunc        Don't truncate output
#   -q, --quiet           Only show numeric IDs
#
```

## docker pull - Download an image or a repository from a registry

```bash
sudo docker pull [IMAGE_NAME]

# Ex
sudo docker pull busybox
# Using default tag: latest
# latest: Pulling from library/busybox
# 7c9d20b9b6cd: Pull complete
# Digest: sha256:fe301db49df08c384001ed752dff6d52b4305a73a7f608f21528048e8a08b51e
# Status: Downloaded newer image for busybox:latest
# docker.io/library/busybox:latest
```

## docker run - Run an installed docker image

Will install the image automatically if it is not already present.

`--attach LIST or -a LIST` Attach to STDIN, STDOUT or STDERR

`--detach or -d` Run in background without viewing command line.

`--name` Assign a name to the container.

`--env LIST or -e LIST` Set environment variables

`--hostname STRING or -h STRING` Set containers hostname

`--interactive or -i` Keep STDIN open even if not attached

`--tty or -t` Allocate a pseudo-TTY (Allows container to act as process)

`--rm` Deletes container once it exits

`--net MODEL` Which model of networking to use (none, bridge and host are the possible options)

`-p PORT [FORWARDED_PORT]` Publish containers ports to the host

If the docker container is not running anything internally, it will exit usually.
That is why you may see it's status as `Exited` after using the `docker run` command.

```bash
# Run container in background
sudo docker run --detach --name CONTAINER_NAME IMAGE_NAME

# Ex
sudo docker run --detach --name server busybox
# e235d8488ebfe95927488da880cc0f2e5d1977d66ffb00dbadc4146e8e432078

# Infinite loop to show that a container will show as still running if its doing something
sudo docker run -d --name server busybox sh -c "while true; do sleep 5; done"

# Keeps container running
sudo docker run -itd --name server busybox
```

## docker ps - List containers

`-a` Show all containers, even those which are not running.

`-s` Show the size of a container

```bash
# Displays nothing because no containers are running
sudo docker ps
# CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

# Use -a to show non running containers
sudo docker ps -a
# CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                   PORTS               NAMES
# edcee8a2db5f        busybox             "sh -c 'while true; …"   6 seconds ago       Up 5 seconds                                 server
# aecf68e72bd7        hello-world         "/hello"                 2 hours ago         Exited (0) 2 hours ago                       # priceless_tereshkova
```

## docker rm - Remove a container

```bash
sudo docker rm CONTAINER

# Ex:
sudo docker rm server
# server
```

## docker start - Startup a container

`--attach or -a` Attach STDOUT/STDERR and forward signals
`--interactive or -i`  Attach container's STDIN

```bash
sudo docker start CONTAINER

# Ex:
sudo docker start server
```

## docker stop - Stop container from running

```bash
sudo docker stop CONTAINER

# Ex:
sudo docker stop server
#server
```

## docker restart - Restart a container

```bash
sudo docker restart CONTAINER

# Ex:
sudo docker restart server
```

## docker attach - View container command line

Attach local standard input, output and error streams to a container

Note: when you exit from the attached shell, the shell exits and the container is stopped as well.

```bash
sudo docker attach CONTAINER

# Ex:
sudo docker attach server
```

## Docker networking

A docker container is not a virtual  machine.
This means that it uses the existing interface of the host.

Once a container is created, a private loopback interface is available for the container
for internal communication.
It is totally isolated from the outside traffic.

Docker also creates a bridge interface called `docker0` that is responsible for carrying
traffic from and to the container.

The docker 0 interface acts as a router for the container.
It can be used for internal communications between different containers
and the host.
It can also be used for routing traffic from and to the outside network.

Docker provides three modes of networking:

- Closed: Container is totally isolated from any outside networks. Cannot communicate, even with the host.

```bash
sudo docker run -it --rm --net none busybox ifconfig -a
# lo        Link encap:Local Loopback  
#           inet addr:127.0.0.1  Mask:255.0.0.0
#           UP LOOPBACK RUNNING  MTU:65536  Metric:1
#           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000
#           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
#
```

- Bridged: 2 device interfaces created for container. (This is the DEFAULT mode)

```bash
sudo docker run -it --rm --net bridge busybox ifconfig -a
# eth0      Link encap:Ethernet  HWaddr 02:42:AC:11:00:02  
#           inet addr:172.17.0.2  Bcast:172.17.255.255  Mask:255.255.0.0
#           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
#           RX packets:3 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:0
#           RX bytes:286 (286.0 B)  TX bytes:0 (0.0 B)
#
# lo        Link encap:Local Loopback  
#           inet addr:127.0.0.1  Mask:255.0.0.0
#           UP LOOPBACK RUNNING  MTU:65536  Metric:1
#           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
#           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
#           collisions:0 txqueuelen:1000
#           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
#
```

Port forwarding:

```bash
# Let docker choose port to forward to port 80 on container
sudo docker run -d -p 80 --name webserver httpd
sudo docker ps
# CONTAINER ID        IMAGE               COMMAND              CREATED              STATUS              PORTS                   NAMES
# ed9a28a4a91c        httpd               "httpd-foreground"   About a minute ago   Up About a minute   0.0.0.0:32768->80/tcp   webserver

# You can connect to the containers web server by using the port that was automatically allocated
curl 0.0.0.0:32768
# <html><body><h1>It works!</h1></body></html>

sudo docker stop webserver
# webserver

sudo docker rm webserver
# webserver

# Now try specifying a port explicitly, all traffic sent to port 8080 on host is forwarded to port 80 on container
sudo docker run -d -p 8080:80 --name webserver httpd

sudo docker ps
# CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                  NAMES
# 2402abad12d4        httpd               "httpd-foreground"   50 seconds ago      Up 49 seconds       0.0.0.0:8080->80/tcp   webserver

curl 0.0.0.0:8080
# <html><body><h1>It works!</h1></body></html>

# You will also be able to access this webserver from other devices on your local network (Phone for example)

sudo docker stop webserver
# webserver

sudo docker rm webserver
# webserver

# Bind a port to a specific ip address on the host (127.0.0.1 makes it only accessible on your machine, no external devices)
sudo docker run -d -p 127.0.0.1:8080:80 --name webserver httpd

sudo docker ps
# CONTAINER ID        IMAGE               COMMAND              CREATED              STATUS              PORTS                    NAMES
# d242d775c50a        httpd               "httpd-foreground"   About a minute ago   Up About a minute   127.0.0.1:8080->80/tcp   webserver

curl 127.0.0.1:8080
# <html><body><h1>It works!</h1></body></html>


```

- Open: Doesn't forward any ports, just makes the container accessible from the host or outside network on the port it has used

```bash
sudo docker run -d --name webserver --net host httpd

# Notice how you no longer see the PORTS?
sudo docker ps
# CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
# 4607b87e22ee        httpd               "httpd-foreground"   19 seconds ago      Up 18 seconds                           webserver

# No port needed, port 80 on host is used directly
curl 0.0.0.0
# <html><body><h1>It works!</h1></body></html>
```

## Docker Storage

Docker uses UFS (Union File system) to work.
This. basically means that an image may be a combination of a number of images,
each of which has its own file systems.
Those file systems are layered together so that common files and libraries can be reused.

This filesystem is not suitable for all scenarios.
When you want to share files with a docker container,
you'd use `volumes` for this.

A `volume` is just a mount point to a directory inside the container where files can be shared with the host.
It works just like `/vagrant` but of course in a technically different manner.

Actually, Docker supports three methods of storage:

`1. Bind Mounts`: Store files directly on the Host filesystem (Not managed by Docker).

`-v HOST_PATH:CONTAINER_PATH` Option in docker run command to specify a bind mount (2 Paths)

```bash
sudo docker run -d --name CONTAINER -p 8080:80 -v HOST_PATH:CONTAINER_PATH IMAGE

# Ex:
sudo docker run -d --name webserver -p 8080:80 -v "$(pwd)":/usr/local/apache2/htdocs httpd

echo '<html><body><h1>Hello World!</h1></body></html>' >> test.html
cat test.html
# <html><body><h1>Hello World!</h1></body></html>
curl localhost:8080/test.html
# <html><body><h1>Hello World!</h1></body></html>
```

`2. Docker Volumes`: Store files in a Docker managed area on the Host filesystem.

A Docker volume is a little more complex in setup than bind mounts.
However, it is more robust and recommended to be used to save persistent data.

To use a Docker volume with a container you can create one first:

```bash
# Create volume
sudo docker volume create VOLUME_NAME

# Ex:
sudo docker volume create web-data-vol
# web-data-vol

# Inspect volume (Shows where volume was mounted)
sudo docker inspect VOLUME_NAME

# Ex:
sudo docker inspect web-data-vol
# [
#     {
#         "CreatedAt": "2019-09-27T10:48:34-04:00",
#         "Driver": "local",
#         "Labels": {},
#         "Mountpoint": "/var/lib/docker/volumes/web-data-vol/_data",
#         "Name": "web-data-vol",
#         "Options": {},
#         "Scope": "local"
#     }
# ]

# To use this volume with a container
sudo docker run -d --name CONTAINER_NAME -p 8080:80 -v VOLUME_NAME:CONTAINER_PATH IMAGE

# Ex:
sudo docker run -d --name webserver -p 8080:80 -v web-data-vol:/usr/local/apache2/htdocs httpd

# Notice how the file `index.html` from the container path appears in the volume?
sudo ls -la /var/lib/docker/volumes/web-data-vol/_data
# total 12
# drwxr-xr-x 2 root root 4096 Sep 27 10:52 .
# drwxr-xr-x 3 root root 4096 Sep 27 10:48 ..
# -rw-r--r-- 1 root src    45 Jun 11  2007 index.html
```

The reason why volumes are better than bind-mounts are numerous.
The most important of which is that
a name volume makes the container portable as it is not dependent on the host OS.
In other words, you cannot refer to a bind mount in a Dockerfile,
you can, however, refer to a named volume.

`3. tmpfs Mounts`: Stores files temporarily directly on the RAM.

Only works on Linux and MacOS machines (Not Windows).

The tmpfs type of mount is used in scenarios where data does not need to
be persisted on the host machine.

An example of this scenario is when you need to generate a password or a hash
that will be used in the current session only and does not (and should not) be
available once the session is over

If you used a tmpfs mount point with a container, any data written to this location
is going to be stored in the host's memory (RAM) rather than the file system.
Once the container is stopped, this data is gone.

Notice that this feature does not work on windows machines.

For example, let's create a busybox container that will write a one-tme hash to
/tmp directory on the host machine:

```bash
sudo docker run -itd --name CONTAINER_NAME --tmpfs TMP_PATH IMAGE

# Ex:
sudo docker run -itd --name secureserver --tmpfs /tmp busybox

# Login to the container and try to write some text to a file in /tmp
# Once the container is restarted, this file is gone.
# Try to run the container without --tmpfs
sudo docker attach secureserver
/ \# cd /tmp
/tmp \# echo "MyPassword" >> PasswordFile
/tmp \# ls
# PasswordFile
/tmp \# cat PasswordFile
# MyPassword
/tmp \# exit

sudo docker start secureserver
# secureserver
sudo docker attach secureserver
/ \# cd /tmp

# Notice now how the file "PasswordFile" is gone?
/tmp \# ls
/tmp \#
```

## Docker Lab Example

It's a good idea to read up on the documentation on docker images you
wish to use to see what options are available.

MariaDB: [https://hub.docker.com/_/mariadb](https://hub.docker.com/_/mariadb)

WordPress: [https://hub.docker.com/_/wordpress](https://hub.docker.com/_/wordpress)

```bash
# Set Environment variables with -e
# Set Volume with -v
# Use mariadb image
sudo docker run \
-e MYSQL_ROOT_PASSWORD=admin \
-e MYSQL_USER=wordpress \
-e MYSQL_PASSWORD=wordpress \
-e MYSQL_DATABASE=wp_database \
-v wp_database:/var/lib/mysql \
--name wordpressdb \
--detach \
mariadb

# You can use a mysql client to try and connect to the db and test it
sudo apt-get install mysql-client
# You can use sudo docker inspect wordpressdb | grep IPAddress to find IP
mysql -u wordpress -pwordpress -h 172.17.0.3

sudo docker run \
-e WORDPRESS_DB_USER=wordpress \
-e WORDPRESS_DB_PASSWORD=wordpress \
-e WORDPRESS_DB_HOST=172.17.0.3 \
-e WORDPRESS_DB_NAME=wp_database \
-p 8080:80 \
-v wp_data:/var/www/html \
--name wordpressapp \
--detach \
wordpress

sudo docker ps
#CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                  NAMES
#27b8bcbfb62c        wordpress           "docker-entrypoint.s…"   About a minute ago   Up 39 seconds       0.0.0.0:8080->80/tcp   wordpressapp
#099bf712f278        mariadb             "docker-entrypoint.s…"   18 minutes ago       Up 18 minutes       3306/tcp               wordpressdb

sudo docker volume inspect wp_data
# [
#     {
#         "CreatedAt": "2019-09-27T11:54:03-04:00",
#         "Driver": "local",
#         "Labels": null,
#         "Mountpoint": "/var/lib/docker/volumes/wp_data/_data",
#         "Name": "wp_data",
#         "Options": null,
#         "Scope": "local"
#     }
# ]

sudo ls /var/lib/docker/volumes/wp_data/_data -l
# total 204
# -rw-r--r--  1 www-data www-data   420 Nov 30  2017 index.php
# -rw-r--r--  1 www-data www-data 19935 Jan  1  2019 license.txt
# -rw-r--r--  1 www-data www-data  7447 Apr  8 18:59 readme.html
# -rw-r--r--  1 www-data www-data  6919 Jan 12  2019 wp-activate.php
# drwxr-xr-x  9 www-data www-data  4096 Sep  4 21:08 wp-admin
# -rw-r--r--  1 www-data www-data   369 Nov 30  2017 wp-blog-header.php
# -rw-r--r--  1 www-data www-data  2283 Jan 20  2019 wp-comments-post.php
# -rw-r--r--  1 www-data www-data  3189 Sep 27 11:54 wp-config.php
# -rw-r--r--  1 www-data www-data  2808 Sep 27 11:54 wp-config-sample.php
# drwxr-xr-x  4 www-data www-data  4096 Sep  4 21:08 wp-content
# -rw-r--r--  1 www-data www-data  3847 Jan  9  2019 wp-cron.php
# drwxr-xr-x 20 www-data www-data 12288 Sep  4 21:08 wp-includes
# -rw-r--r--  1 www-data www-data  2502 Jan 16  2019 wp-links-opml.php
# -rw-r--r--  1 www-data www-data  3306 Nov 30  2017 wp-load.php
# -rw-r--r--  1 www-data www-data 39551 Jun 10 09:34 wp-login.php
# -rw-r--r--  1 www-data www-data  8403 Nov 30  2017 wp-mail.php
# -rw-r--r--  1 www-data www-data 18962 Mar 28  2019 wp-settings.php
# -rw-r--r--  1 www-data www-data 31085 Jan 16  2019 wp-signup.php
# -rw-r--r--  1 www-data www-data  4764 Nov 30  2017 wp-trackback.php
# -rw-r--r--  1 www-data www-data  3068 Aug 16  2018 xmlrpc.php

# Browse to localhost:8080 to do the installation page of wordpress

# curl website or view in web browser to ensure it works
curl localhost:8080
```

## Vagrant or Docker

Highly depends on your use case and scenario.

Vagrant is a virtualization software that works on top of a platform
like VirtualBox or VMWare.
Using Vagrant, you have a complete virtual machine with it's own
CPU, memory, and network stack.

Virtualization tends to consume a lot of resources since everything needs to
be abstracted.
However, it can be used in cloud platforms, for example, for instant provisioning.

Docker uses containerization, which means that the image will create containers that
share the same Linux kernel (the host), with the appropriate level of isolation.
This means a lot less resource overhead.
But at the end, it is just a Linux process running an application not a complete machine.

To answer the question, actually they both complement each other
with Vagrant abstracting machine and docker abstracting the application.
For that reason, Vagrant uses Docker as one of its provisioners.
This means that you can deploy a Vagrant machine that will automatically
deploy a Docker container once it boots.

## Lab Exercise

Deploy Nginx server using host port 8081 and assign it a docker volume

NGINX: [https://hub.docker.com/_/nginx](https://hub.docker.com/_/nginx)

```bash
sudo docker run --name nginx-server -d -p 8081:80 -e NGINX_PORT=80 -v nginx_data:/usr/share/nginx/html nginx
# Unable to find image 'nginx:latest' locally
# latest: Pulling from library/nginx
# b8f262c62ec6: Already exists
# e9218e8f93b1: Pull complete
# 7acba7289aa3: Pull complete
# Digest: sha256:aeded0f2a861747f43a01cf1018cf9efe2bdd02afd57d2b11fcc7fcadc16ccd1
# Status: Downloaded newer image for nginx:latest
# 395d87f8588340944c58ebad361f371fa944ef7644345186d2eb77d985d0ce23
# jonathan@jonathan-ThinkPad-X230:~/Documents/DevOps/Docker$ sudo docker volume inspect nginx_data
# [
#     {
#         "CreatedAt": "2019-09-27T12:14:09-04:00",
#         "Driver": "local",
#         "Labels": null,
#         "Mountpoint": "/var/lib/docker/volumes/nginx_data/_data",
#         "Name": "nginx_data",
#         "Options": null,
#         "Scope": "local"
#     }
# ]
# Create test html
sudo nano /var/lib/docker/volumes/nginx_data/_data/test.html
curl localhost:8081/test.html
# <html>
# <body>
# <h1>Hello World!</h1>
# </body>
# </html>
```
