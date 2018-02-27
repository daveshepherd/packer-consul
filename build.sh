#! /bin/bash

# Ensure we use the containing directory, irrelevant of where this script is called from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PACKER=$(which packer)
[[ -z ${PACKER} ]] &&  echo 'packer command not found in the search path. exiting...' && exit 1

source ${DIR}/../environments/config.env

${PACKER} build -var "london_vpc_id=${LONDON_VPC}" -var "london_subnet_id=${LONDON_SUBNET}" -var "ireland_vpc_id=${IRELAND_VPC}" -var "ireland_subnet_id=${IRELAND_SUBNET}" -var "consul_version=1.0.6" consul.json