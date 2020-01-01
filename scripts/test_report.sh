#! /bin/sh

set -ex

curl \
  -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 \
  > ./cc-test-reporter
chmod +x ./cc-test-reporter

GIT_COMMITTED_AT="2020-01-01 23:29:37 +0900" ./cc-test-reporter $@
