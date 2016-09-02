#!/bin/sh -e

# Initialize JIRA database
# https://confluence.atlassian.com/adminjiraserver072/connecting-jira-applications-to-postgresql-828787559.html

test "$JIRA_DB_NAME"
test "$JIRA_DB_USER"
test "$JIRA_DB_PASSWORD"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
CREATE USER $JIRA_DB_USER PASSWORD '$JIRA_DB_PASSWORD';
CREATE DATABASE $JIRA_DB_NAME WITH ENCODING 'UNICODE' LC_COLLATE 'C' LC_CTYPE 'C' TEMPLATE template0;
GRANT ALL PRIVILEGES ON DATABASE $JIRA_DB_NAME TO $JIRA_DB_USER;
EOSQL
