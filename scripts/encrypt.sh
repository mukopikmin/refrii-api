#! /bin/sh

env=$@
source .env.${env}

keyring=refrii-api
keys=( \
  GOOGLE_CLIENT_EMAIL \
  GOOGLE_CLIENT_ID \
  GOOGLE_CLOUD_STORAGE_BUCKET \
  GOOGLE_PRIVATE_KEY \
  GOOGLE_PRIVATE_KEY_ID \
  GOOGLE_X509_CERT_URL \
  MYSQL_SOCKET \
  MYSQL_DATABASE \
  MYSQL_USERNAME \
  MYSQL_PASSWORD \
  FIREBASE_PROJECT_ID SECRET_KEY_BASE \
)

for key in ${keys[@]}
do
  val=$(eval echo '$'$key)
  encrypted=$(echo $val | gcloud kms encrypt \
    --plaintext-file=- \
    --ciphertext-file=- \
    --location=global \
    --keyring=$keyring \
    --key=${env} | base64)
  
  echo "${key}: ${encrypted}"
done

gcloud kms encrypt \
  --plaintext-file=credentials.${env}.json \
  --ciphertext-file=credentials.${env}.json.enc \
  --location=global \
  --keyring=$keyring \
  --key=$env
