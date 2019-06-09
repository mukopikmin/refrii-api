#! /bin/sh 

set -ex

docker run \
  -v $PWD/credentials/credentials.staging.json:/config \
  -p 127.0.0.1:3306:3306 \
  gcr.io/cloudsql-docker/gce-proxy:1.12 \
  /cloud_sql_proxy \
    -instances refrii-169906:us-central1:refrii-api=tcp:0.0.0.0:3306 \
    -credential_file /config
    