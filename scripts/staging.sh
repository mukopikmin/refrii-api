#! /bin/bash

set -ex

if [[ ! $(cat /git/message) =~ "[staging]" ]] ; then
  echo "Skip creating staging environment."
  exit 0
fi

base=refrii-api-staging2
service=${BRANCH_NAME}-${SHORT_SHA}
region=asia-northeast1
image=gcr.io/refrii-169906/refrii-api:$SHORT_SHA

envs=$(gcloud beta run services describe refrii-api-staging2 \
  --platform managed \
  --region asia-northeast1 \
  --format \
    "csv[no-heading, separator='=', terminator=','](spec.template.spec.containers[0].env.name, spec.template.spec.containers[0].env.value)" \
  --flatten "spec.template.spec.containers[0].env" \
  | sed "s/\"//g")

gcloud beta run deploy $service \
  --image $image \
  --allow-unauthenticated \
  --memory 1Gi \
  --platform managed \
  --region $region \
  --update-env-vars "$envs" \
  --update-labels env=staging
