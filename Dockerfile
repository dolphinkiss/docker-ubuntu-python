FROM ubuntu:16.04
MAINTAINER Peter Lauri <peterlauri@gmail.com>

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 \
    DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    PYTHON_PIP_VERSION=9.0.1 PYTHONHASHSEED=random

# Dependencies:
# - openssh-client:	ssh-keyscan etc.
# - python-dev:		python compiling
# - libpq-dev:		to be able to build/use psycopg2 python package
# - git:			for pip git installs
# - curl:			to download stuff for builds
RUN apt-get update \
    && apt-get install -y \
        ca-certificates libssl1.0.0 \
        openssh-client python-dev curl \
    && rm -rf /var/lib/apt/lists/*

# installing pip
RUN set -eEx \
    && curl -fSL 'https://bootstrap.pypa.io/get-pip.py' | python2.7 - --no-cache-dir --upgrade pip==$PYTHON_PIP_VERSION

# setting up the virtual environment
RUN pip install virtualenv
