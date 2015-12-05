#!/usr/bin/env bash

apt-get update
apt-get install -yqqq git curl wget g++ make cmake python
apt-get install -yqqq graphviz
source /build/build_ruby.sh
gem install json
