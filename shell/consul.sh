#! /bin/bash

set -e

until sudo apt-get -y install zip
do
  echo "Try again"
  sleep 5
done

curl -o /tmp/consul.zip https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip

unzip -d /tmp /tmp/consul.zip

sudo mv /tmp/consul /usr/local/bin/consul

sudo useradd consul -m -s /usr/sbin/nologin -d /var/consul

sudo mkdir -p /etc/consul.d

sudo mv /tmp/systemd.service /etc/systemd/system/consul.service

sudo chown root:root /etc/systemd/system/consul.service