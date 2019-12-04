#! /bin/sh

set -ex

target=$1
sql_instance=$(echo $MYSQL_SOCKET | sed s/\\/cloudsql\\///)

mkdir /cloudsql

wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64
mv cloud_sql_proxy.linux.amd64 cloud_sql_proxy
chmod +x cloud_sql_proxy

sh -c "./cloud_sql_proxy -dir=/cloudsql -instances $sql_instance -credential_file /kms/credentials.$target.json" & 
bundle exec rails db:migrate
