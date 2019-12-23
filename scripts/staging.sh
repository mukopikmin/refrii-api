#! /bin/bash

set -ex

if [ "$1" = "" ] ; then
  echo "Argment is required as service name."
  exit 1
fi

base=refrii-api-staging2
region=asia-northeast1
image=gcr.io/refrii-169906/refrii.api:$(git rev-parse --short HEAD)

envs=$(gcloud beta run services describe $base \
  --region $region \
  --format json |
  jq .spec.template.spec.containers[0].env)
size=$(echo $envs | jq length)
env_str="RELEASE_HASH=$(git rev-parse HEAD),RELEASE_TAG=staging-$(git symbolic-ref --short HEAD)"

for i in $(seq 0 $(($size - 1))); do
  key=$(echo $envs | jq -r .[$i].name)
  value=$(echo $envs | jq -r .[$i].value)

  # Remove line ending
  if [ "$key" = "GOOGLE_PRIVATE_KEY" ]; then
    value=$(echo $value | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g')
  fi

  env_str=$env_str,$key=$value
done

gcloud beta run deploy $1 \
  --image $image \
  --allow-unauthenticated \
  --memory 1Gi \
  --region $region \
  --set-env-vars $env_str
