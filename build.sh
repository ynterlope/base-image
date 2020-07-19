#!/usr/bin/env bash
# set +x

if [ -f .env ]
then
  export $(cat .env | xargs)
fi

packer build templates/base-centos7.json