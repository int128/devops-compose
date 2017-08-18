# DevOps Compose [![CircleCI](https://circleci.com/gh/int128/devops-compose.svg?style=shield)](https://circleci.com/gh/int128/devops-compose)

A compose of following Docker containers:

* Crowd
* JIRA software
* Confluence
* GitBucket
* Jenkins
* Artifactory
* SonarQube
* Mattermost
* ownCloud
* OpenLDAP


## How to provision

### DNS

Create a wildcard record on the DNS service.

```
A *.example.com. 192.168.1.2.
```

If you do not have a domain, instead use the wildcard DNS service such as xip.io.

### DBMS

Create a PostgreSQL instance. It is recommended to use managed services such as Amazon RDS or Google Cloud SQL for maintenancebility reason. If we are not on cloud, we can add [a PostgreSQL container](https://hub.docker.com/_/postgres/) to the `docker-compose.yml`.

MySQL is also available and works well but [PostgreSQL is recommended for JIRA](https://confluence.atlassian.com/adminjiraserver074/supported-platforms-881683157.html).

Initialize databases and users with [`init-postgresql.sql`](/init-postgresql.sql).

### Instance

Docker Compose and enough swap space are required.

```bash
yum install -y docker
mkdir -p /opt/bin
curl -L -o /opt/bin/docker-compose https://github.com/docker/compose/releases/download/1.12.0/docker-compose-Linux-x86_64
chmod +x /opt/bin/docker-compose
fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile swap swap defaults 0 0' >> /etc/fstab
```

Run containers. This may take a few minutes.

```bash
# Database host
echo 'DATABASE_HOST=xxxxx.xxxxx.rds.amazonaws.com' >> .env

# Domain name
echo 'REVERSE_PROXY_DOMAIN_NAME=example.com' >> .env           # using your DNS
echo 'REVERSE_PROXY_DOMAIN_NAME=192.168.1.2.xip.io' >> .env    # using xip.io

docker-compose build
docker-compose up -d
```


## How to setup

Open http://devops.example.com (concatenate `devops` and domain name).

### Setup Crowd

Open Crowd and configure the database connection.

- Database server: Hostname of the database instance
- Type: PostgreSQL
- Database name: `crowd`
- User: `crowd`
- Password: `crowd`

Add the LDAP directory.

- URL: `ldap://ldap:389/`
- Base DN: `dc=example,dc=org`
- Username: `cn=admin,dc=example,dc=org`
- Password: `admin`

### Setup JIRA

Open JIRA and configure the database connection.

- Database server: Hostname of the database instance
- Type: PostgreSQL
- Database name: `jira`
- User: `jira`
- Password: `jira`

Add the Crowd server.

### Setup Confluence

Open Confluence and configure the database connection.

- Database server: Hostname of the database instance
- Type: PostgreSQL
- Database name: `confluence`
- User: `confluence`
- Password: `confluence`

Add the Crowd server.

### Setup Jenkins

Get the initial admin password by following command:

```sh
docker exec devopscompose_jenkins_1 cat /var/jenkins_home/secrets/initialAdminPassword
```

Open Jenkins and configure LDAP authentication.

- Server: `ldap`
- Root DN: (empty)
- User search base: `dc=example,dc=org`
- User search filter: `cn={0}`
- Group search base: `dc=example,dc=org`
- Group search filter: `cn={0}`
- Group membership: `memberOf` (default)
- Manager DN: `cn=admin,dc=example,dc=org`
- Manager Password: `admin`
- Name attribute: `displayname` (default)
- Mail attribute: `mail` (default)

### Setup GitBucket

Open GitBucket and configure LDAP authentication.

- LDAP server: `ldap`
- Admin DN: `cn=admin,dc=example,dc=org` with `admin`
- Base DN: `dc=example,dc=org`
- User attribute: `cn`
- Name attribute: `displayname`
- Mail attribute: `mail`

### Setup Nexus

Open Nexus and configure LDAP authentication.

- LDAP server: `ldap://ldap:389`
- Search base: `dc=example,dc=org`
- Username: `cn=admin,dc=example,dc=org`
- Password: `admin`
- Configuration template: Generic Ldap Server
- Object class: `inetOrgPerson` (default)
- User ID attribute: `cn`
- Name attribute: `displayname`
- Mail attribute: `mail`
- Group type: Static
- Group object class: `posixGroup` (default)
- Group ID attribute: `cn`
- Group member attribute: `uniqueMember`
- Group member format: `cn=${username},dc=example,dc=org`

### Setup SonarQube

SonarQube does not support LDAP authentication.

### Setup Mattermost

Mattermost (Community Edition) does not support LDAP authentication.
Configure a mail service such as AWS SES and use the email sign up.

### ownCloud

Open ownCloud and configure LDAP authentication.

- LDAP server: `ldap:389`
- Admin DN: `cn=admin,dc=example,dc=org` with `admin`
- Base DN: `dc=example,dc=org`

### Register init script

We provide the init script for LSB.
Register as follows:

```sh
sudo ln -s /opt/devops-compose/init-lsb.sh /etc/init.d/devops-compose
sudo chkconfig --add devops-compose
```

## Backup and Restore

It may be best to backup and restore volumes under `/var/lib/docker/volumes`.

## Contribution

This is an open source software licensed under Apache-2.0.
Feel free to open issues or pull requests.
