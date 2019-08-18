#! /bin/sh

env=$@
source .env.${env}
keyring=refrii-api

gcloud kms encrypt \
  --plaintext-file=credentials.${env}.json \
  --ciphertext-file=credentials.${env}.json.enc \
  --location=global \
  --keyring=$keyring \
  --key=$env
