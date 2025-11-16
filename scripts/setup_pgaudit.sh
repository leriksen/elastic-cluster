#!/usr/bin/env bash

export PGHOST=""psql-fs-ec-ec-psql001.postgres.database.azure.com""
export PGUSER="psqladmin"
export PGPORT=5432
export PGDATABASE=postgres
export PGPASSWORD='WkIzatV4d(+1sC_'

psql -f sql/pgaudit.sql
psql -f sql/create_table.sql
