FROM ubuntu:16.04
MAINTAINER Peter Lauri <peterlauri@gmail.com>

RUN rm -rf /var/lib/apt/lists/*
RUN apt-get update \
    && apt-get install -y locales \
    && rm -rf /var/lib/apt/lists/*
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
        openssh-client python-dev curl git \
        make build-essential libssl-dev zlib1g-dev libbz2-dev \
        libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
        xz-utils tk-dev \
    && rm -rf /var/lib/apt/lists/*

#RUN AUTO_ADDED_PACKAGES=`apt-mark showauto` && apt-get remove --purge -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
#    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
#    xz-utils tk-dev $AUTO_ADDED_PACKAGES

# installing pyenv: https://github.com/pyenv/pyenv
RUN git clone https://github.com/pyenv/pyenv.git /pyenv
ENV PYENV_ROOT "/pyenv"
ENV PATH "$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"

ARG PYENV_TARGET_VERSION

RUN echo "$PYENV_TARGET_VERSION"

# isntalling given version
RUN pyenv install $PYENV_TARGET_VERSION
RUN pyenv global $PYENV_TARGET_VERSION

# installing pip
RUN set -eEx \
    && curl -fSL 'https://bootstrap.pypa.io/get-pip.py' | python - --no-cache-dir --upgrade pip==$PYTHON_PIP_VERSION

# setting up the virtual environment
RUN pip install virtualenv
