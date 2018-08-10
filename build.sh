#! /bin/bash

PACKER=$(which packer)
[[ -z ${PACKER} ]] &&  echo 'packer command not found in the search path. exiting...' && exit 1

CONSUL_VERSION=1.2.2

${PACKER} build -var "region=${REGION}" -var "vpc_id=${VPC_ID}" -var "subnet_id=${SUBNET_ID}" -var "consul_version=${CONSUL_VERSION}" -var "destination_regions=${DESTINATION_REGIONS}" build.json