az postgres flexible-server stop -n psql-fs-ec-ec-001 -g psql-fs-ec &;
az postgres flexible-server stop -n psql-fs-ec-fs-001 -g psql-fs-ec &;
az vm stop -n vm01 -g psql-fs-ec &;
