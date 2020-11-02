#! /bin/sh

set -ex

service=$1
image=$2

gcloud beta run deploy $service \
  --image $image \
  --allow-unauthenticated \
  --region asia-northeast1 \
  --platform managed \
  --memory 1Gi \
  --min-instances 1 \
  --max-instances 5 \
  --labels env=production \
  --update-env-vars RELEASE_HASH=$RELEASE_HASH
 
