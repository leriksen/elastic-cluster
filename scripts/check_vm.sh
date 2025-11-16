#!/usr/bin/env bash

export HOST=$(az network public-ip show -n ip01 -g psql-fs-ec | jq -r '.ipAddress')

ssh -i ~/.ssh/id_rsa adminuser@${HOST} "az --version"
ssh -i ~/.ssh/id_rsa adminuser@${HOST} "psql --version"

