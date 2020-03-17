#! /bin/sh

set -ex

service=$1
image=$2

gcloud run deploy $service \
  --image $image \
  --allow-unauthenticated \
  --region asia-northeast1 \
  --platform managed \
  --memory 1Gi \
  --labels env=production \
  --update-env-vars RELEASE_HASH=$RELEASE_HASH
