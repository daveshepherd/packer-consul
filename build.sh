#! /bin/bash

# Ensure we use the containing directory, irrelevant of where this script is called from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PACKER=$(which packer)
[[ -z ${PACKER} ]] &&  echo 'packer command not found in the search path. exiting...' && exit 1

source ${DIR}/../environments/config.env

echo "building ireland ami"
${PACKER} build -var "region=${IRELAND_REGION}" -var "vpc_id=${IRELAND_VPC}" -var "subnet_id=${IRELAND_SUBNET}" -var "consul_version=0.9.3" consul.json