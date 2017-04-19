#!/usr/bin/env bash
for v in "$@"; do
    docker build . --build-arg "PYENV_TARGET_VERSION=$v" -t "dolphinkiss/ubuntu-python:$v"
    docker push "dolphinkiss/ubuntu-python:$v"
done
