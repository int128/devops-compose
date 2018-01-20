psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    -- Crowd
    CREATE USER crowd PASSWORD 'crowd';
    CREATE DATABASE crowd;
    GRANT ALL PRIVILEGES ON DATABASE crowd TO crowd;

    -- JIRA
    -- https://confluence.atlassian.com/adminjiraserver072/connecting-jira-applications-to-postgresql-828787559.html
    CREATE USER jira PASSWORD 'jira';
    CREATE DATABASE jira WITH ENCODING 'UNICODE' LC_COLLATE 'C' LC_CTYPE 'C' TEMPLATE template0;
    GRANT ALL PRIVILEGES ON DATABASE jira TO jira;

    -- Confluence
    -- https://confluence.atlassian.com/doc/database-setup-for-postgresql-173244522.html
    CREATE USER confluence PASSWORD 'confluence';
    CREATE DATABASE confluence;
    GRANT ALL PRIVILEGES ON DATABASE confluence TO confluence;

    -- GitBucket
    CREATE USER gitbucket PASSWORD 'gitbucket';
    CREATE DATABASE gitbucket;
    GRANT ALL PRIVILEGES ON DATABASE gitbucket TO gitbucket;

    -- SonarQube
    CREATE USER sonarqube PASSWORD 'sonarqube';
    CREATE DATABASE sonarqube;
    GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonarqube;

    -- Mattermost
    -- https://github.com/mattermost/mattermost-docker
    CREATE USER mattermost PASSWORD 'mattermost';
    CREATE DATABASE mattermost;
    GRANT ALL PRIVILEGES ON DATABASE mattermost TO mattermost;

    -- ownCloud
    CREATE USER owncloud PASSWORD 'owncloud';
    CREATE DATABASE owncloud;
    GRANT ALL PRIVILEGES ON DATABASE owncloud TO owncloud;
EOSQL