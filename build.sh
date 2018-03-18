#! /bin/bash

PACKER=$(which packer)
[[ -z ${PACKER} ]] &&  echo 'packer command not found in the search path. exiting...' && exit 1

CONSUL_VERSION=1.0.6

${PACKER} build -var "london_vpc_id=${LONDON_VPC}" -var "london_subnet_id=${LONDON_SUBNET}" -var "ireland_vpc_id=${IRELAND_VPC}" -var "ireland_subnet_id=${IRELAND_SUBNET}" -var "consul_version=${CONSUL_VERSION}" consul.json