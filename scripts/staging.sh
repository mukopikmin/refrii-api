#! /bin/bash

set -ex

if [ "$BRANCH_NAME" = "master" ] ; then
  echo "Not creating staging release from master branch."
  exit 0
fi

if [[ ! $(cat /git/message) =~ "[staging]" ]] ; then
  echo "Skip creating staging environment."
  exit 0
fi

base=refrii-api-staging2
service=staging-${BRANCH_NAME}
region=asia-northeast1
image=gcr.io/refrii-169906/refrii-api:$SHORT_SHA

envs=$(gcloud run services describe $base \
  --platform managed \
  --region asia-northeast1 \
  --format \
    "csv[no-heading, separator='=', terminator=','](spec.template.spec.containers[0].env.name, spec.template.spec.containers[0].env.value)" \
  --flatten "spec.template.spec.containers[0].env" \
  | sed "s/\"//g")

gcloud run deploy $service \
  --image $image \
  --allow-unauthenticated \
  --memory 1Gi \
  --platform managed \
  --region $region \
  --update-env-vars "$envs" \
  --update-labels env=staging
