#!/bin/bash

set -e
set -u

function create_user_and_database() {
	local database
	database=$(echo $1 | tr ',' ' ' | awk  '{print $1}')
	local owner
	owner=$(echo $1 | tr ',' ' ' | awk  '{print $2}')
	echo "Creating database '$database' and grant access to '$owner'"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	    CREATE DATABASE $database;
	    GRANT ALL PRIVILEGES ON DATABASE $database TO $owner;
EOSQL
}

function create_user() {
	local user
	user=$(echo $1 | tr ',' ' ' | awk  '{print $1}')
	local password
	password=$(echo $1 | tr ',' ' ' | awk  '{print $2}')
	echo "Creating user '$user' with password '$password'"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	    CREATE USER $user WITH PASSWORD '$password';
EOSQL
}

if [ -n "$POSTGRES_USERS" ]; then
	echo "Postgres users creation requested"
	for user in $(echo "$POSTGRES_USERS" | tr ':' ' '); do
		create_user $user
	done
	echo "Users created"
fi

if [ -n "$POSTGRES_DATABASES" ]; then
	echo "Multiple database creation requested"
	for db in $(echo "$POSTGRES_DATABASES" | tr ':' ' '); do
		create_user_and_database $db
	done
	echo "Multiple databases created"
fi
