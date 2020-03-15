#! /bin/sh

environment=$1
keyring=$2

gcloud kms decrypt \
  --ciphertext-file=credentials/credentials.$environment.json.enc \
  --plaintext-file=/kms/credentials.$environment.json \
  --location=global \
  --keyring=$keyring \
  --key=$environment  