#!/bin/sh -xe

if [ "$GITBUCKET_DB_URL" ]; then
  cat > /gitbucket/database.conf <<-EOCONF
db {
  url = "$GITBUCKET_DB_URL"
  user = "$GITBUCKET_DB_USER"
  password = "$GITBUCKET_DB_PASSWORD"
}
EOCONF
fi

exec java $JAVA_OPTS -jar /opt/gitbucket.war $GITBUCKET_OPTS
