[![Build
Status](https://travis-ci.com/cliwrap/alpine-37.svg?branch=master)](https://travis-ci.com/cliwrap/alpine-37)
[![CircleCI](https://circleci.com/gh/cliwrap/alpine-37.svg?style=svg)](https://circleci.com/gh/cliwrap/ansible-37)
[![Docker
Stars](https://img.shields.io/docker/stars/cliwrap/alpine-37.svg)](https://hub.docker.com/r/cliwrap/alpine-37/)
[![Docker
Pulls](https://img.shields.io/docker/pulls/cliwrap/alpine-37.svg)](https://hub.docker.com/r/cliwrap/alpine-37/)
[![Docker Automated
build](https://img.shields.io/docker/cloud/automated/cliwrap/alpine-37.svg)](https://hub.docker.com/r/cliwrap/alpine-37/)
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/cliwrap/alpine-37)](https://hub.docker.com/r/cliwrap/alpine-37/)
[![Image](https://images.microbadger.com/badges/image/cliwrap/alpine-37.svg)](https://microbadger.com/images/cliwrap/alpine-37)
[![Version](https://images.microbadger.com/badges/version/cliwrap/alpine-37.svg)](https://microbadger.com/images/cliwrap/alpine-37)
[![CII Best
Practices](https://bestpractices.coreinfrastructure.org/projects/4118/badge)](https://bestpractices.coreinfrastructure.org/projects/4118)

The `Dockerfile` in this repository builds an `alpine:3.7` container
which lets you run commands inside the container using a UID and GID
which are passed in environment variables from outside the container,
so that any files created in a volume mount can be created as the user
and group who initiated `docker run`.

To download: [`docker pull cliwrap/alpine-37`](https://hub.docker.com/r/cliwrap/alpine-37/)

Examples
--------

Create a file called `myfile` in the current directory

```docker run --rm -e "HOSTUID=`id -u`" -v "`pwd`:/work" cliwrap/alpine-37 touch myfile```

Create a file with the correct uid and gid in the current directory

```docker run --rm -e "HOSTUID=`id -u`" -e "HOSTGID=`id -g`" -v "`pwd`:/work" cliwrap/alpine-37 touch myfile```
