#! /bin/sh 

set -ex

project=refrii-169906
region=asia-northeast1
instance=refrii-api-mysql

# docker run \
#   -v $PWD/credentials/credentials.staging.json:/config \
#   -p 127.0.0.1:3306:3306 \
#   gcr.io/cloudsql-docker/gce-proxy:1.12 \
#   /cloud_sql_proxy \
#     -instances ${project}:${region}:${instance}=tcp:0.0.0.0:3306 \
#     -credential_file /config

./cloud_sql_proxy \
  -dir /cloudsql \
  -instances ${project}:${region}:${instance} \
  -credential_file credentials/credentials.staging.json
  