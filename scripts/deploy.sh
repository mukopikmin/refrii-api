#! /bin/sh

set -ex

service=$1
image=$2

gcloud beta run deploy $service \
  --image $image \
  --add-cloudsql-instances refrii-api \
  --allow-unauthenticated \
  --region us-central1 \
  --memory 512Mi \
  --set-env-vars " \
    RAILS_ENV=$RAILS_ENV, \
    RACK_ENV=$RACK_ENV, \
    GOOGLE_CLIENT_EMAIL=$GOOGLE_CLIENT_EMAIL, \
    GOOGLE_CLIENT_ID=$GOOGLE_CLIENT_ID, \
    GOOGLE_CLOUD_STORAGE_BUCKET=$GOOGLE_CLOUD_STORAGE_BUCKET, \
    GOOGLE_PRIVATE_KEY=$GOOGLE_PRIVATE_KEY, \
    GOOGLE_PRIVATE_KEY_ID=$GOOGLE_PRIVATE_KEY_ID, \
    GOOGLE_X509_CERT_URL=$GOOGLE_X509_CERT_URL, \
    MYSQL_SOCKET=$MYSQL_SOCKET, \
    MYSQL_DATABASE=$MYSQL_DATABASE, \
    MYSQL_USERNAME=$MYSQL_USERNAME, \
    MYSQL_PASSWORD=$MYSQL_PASSWORD, \
    FIREBASE_PROJECT_ID=$FIREBASE_PROJECT_ID, \
    SECRET_KEY_BASE=$SECRET_KEY_BASE \
  "