# devops-compose [![CircleCI](https://circleci.com/gh/int128/devops-compose.svg?style=shield)](https://circleci.com/gh/int128/devops-compose)

A docker-compose to setup following tools in a few minutes.

* JIRA software
* Confluence
* GitBucket
* Jenkins
* Mattermost
* Reverse Proxy
* PostgreSQL
* LDAP


## How to Use

Install Docker Compose and run containers:

```sh
./install-docker-compose.sh
docker-compose build
docker-compose up -d
```

### Setup JIRA

Open port 80 of the instance on the browser.
The index page should show up.

Open JIRA and configure the database connection.

- Database server: `db`
- Type: PostgreSQL
- Database name: `jira`
- User: `jira`
- Password: `jira`

Configure LDAP authentication and create a user.

- LDAP server: `ldap`
- Admin DN: `cn=admin,dc=example,dc=com` with `admin`
- Base DN: `dc=example,dc=com`
- User attribute: `cn`
- Name attribute: `displayName`
- Mail attribute: `mail`

### Setup Confluence

Open Confluence and configure the database connection.

- Database server: `db`
- Type: PostgreSQL
- Database name: `confluence`
- User: `confluence`
- Password: `confluence`

Configure an application link to JIRA.

### Setup Jenkins

Get the initial admin password by following command:

```sh
docker exec devopscompose_jenkins_1 cat /var/jenkins_home/secrets/initialAdminPassword
```

Open Jenkins and configure LDAP authentication.

- LDAP server: `ldap`
- Admin DN: `cn=admin,dc=example,dc=com` with `admin`
- Root DN: `dc=example,dc=com`
- Base DN: (empty)
- User attribute: `cn={0}`
- Name attribute: `displayname` (default)
- Mail attribute: `mail` (default)

### Setup GitBucket

Open GitBucket and configure LDAP authentication.

- LDAP server: `ldap`
- Admin DN: `cn=admin,dc=example,dc=com` with `admin`
- Base DN: `dc=example,dc=com`
- User attribute: `cn`
- Name attribute: `displayname`
- Mail attribute: `mail`

### Setup Mattermost

Mattermost (Community Edition) does not support LDAP authentication.
Configure a mail service such as AWS SES and use the email sign up.

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
