#! /bin/sh

set -ex

service=$1
image=$2

gcloud beta run deploy $service \
  --image $image \
  --allow-unauthenticated \
  --region us-central1 \
  --platform managed \
  --memory 512Mi