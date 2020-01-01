#! /bin/sh

set -ex

curl \
  -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 \
  > ./cc-test-reporter
chmod +x ./cc-test-reporter

GIT_COMMITTED_AT=$(cat /git/timestamp) ./cc-test-reporter $@
