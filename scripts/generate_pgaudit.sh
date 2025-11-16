#!/usr/bin/env bash

export PGHOST=""psql-fs-ec-ec-psql001.postgres.database.azure.com""
export PGUSER="psqladmin"
export PGPORT=5432
export PGDATABASE=postgres
export PGPASSWORD='WkIzatV4d(+1sC_'

psql -f sql/insert_data.sql
psql -f sql/select_data.sql
