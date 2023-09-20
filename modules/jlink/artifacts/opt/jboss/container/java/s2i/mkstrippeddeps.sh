#!/bin/bash
set -euo pipefail

test -f deps.txt

<deps.txt \
  grep 'java\|jdk\.'  | # mostly removes target/, but also jdk8internals
  sed -E "s/Warning: .*//" | #remove extraneous warnings
  sed -E "s/.*-> //"  | # remove src of src -> dep
  sed -E "s/.*\.jar//" | # remove extraneous dependencies
  sed "s#/.*##"       | # delete anything after a slash. in practice target/..
  sort | uniq |
tee stripped-deps.txt
