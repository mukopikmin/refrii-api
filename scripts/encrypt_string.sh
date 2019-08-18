#! /bin/sh

env=$1
val=$2
keyring=refrii-api

encrypted=$(echo $val | gcloud kms encrypt \
  --plaintext-file=- \
  --ciphertext-file=- \
  --location=global \
  --keyring=$keyring \
  --key=${env} | base64)

echo $encrypted