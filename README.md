# postgres-container
Contains a basic example for running Postgres in docker container, with the possibility of custom configuration.

Has the ability to create multiple databases and users.
To do this, you need to define the `POSTGRES_DATABASES` and `POSTGRES_USERS` environment variables.

`POSTGRES_DATABASES` format: `{db_name_1},{user_name_1}:{db_name_2},{user_name_2}`. Thus, it define few pairs - the database and its owner. Database and owner are separated by `,` symbol, pairs are separated by `:`.

`POSTGRES_USERS` format: `{user_name_1},{user_password_1}:{user_name_2},{user_password_2}`. Similarly, but as a pair is a username and password.

Ensure that all users listed as database owners are also listed in `POSTGRES_USERS` to be created.
By default, the owner is assigned at the `ALL PRIVILEGES` level.
The script that is responsible for initializing users and databases is located in [database/initdb/create-multiple-postgresql-databases.sh](https://github.com/roman-baldaev/postgres-container/blob/main/database/initdb/create-multiple-postgresql-databases.sh).

Folder `/database/initdb` is binded to docker directory `/docker-entrypoint-initdb.d`, which is used as place for initialization scripts (see [official postgres docker image](https://registry.hub.docker.com/_/postgres/).

The postgres config is in [database/postgresql.conf](https://github.com/roman-baldaev/postgres-container/blob/main/database/postgresql.conf).

The `PG_DATA` directory is binded to the host directory `database/data`.
