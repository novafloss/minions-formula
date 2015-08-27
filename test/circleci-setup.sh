#!/bin/bash

add-apt-repository -y ppa:saltstack/salt2014-7
apt-get update -y
apt-get install -y salt-common msgpack-python

# Allow tests to use git commit
git config --global user.name "CircleCI"
git config --global user.email root@circleci
