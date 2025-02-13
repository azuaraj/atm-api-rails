#!/bin/sh
set -e

# Wait until PostgreSQL is ready
until pg_isready -h db -p 5432 -U postgres
do
  echo "Waiting for PostgreSQL to start..."
  sleep 2
done

exec "$@"
