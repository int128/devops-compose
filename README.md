# devops-compose

A docker-compose to setup following tools in a few minutes.

* JIRA software
* Confluence
* GitBucket
* Jenkins
* Jenkins slave for Docker operation
* Mattermost
* Reverse Proxy
* PostgreSQL
* LDAP


## How to Use

### Setup the instance

Install Docker and Docker Compose into the instance by `init.sh`.

### Run containers

Put environment specific settings into `docker-compose.override.yml`:

```yaml
services:
  jira:
    environment:
      X_PROXY_NAME: ec2-x-x-x-x.x.compute.amazonaws.com
```

Run containers:

```sh
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
- Admin DN: `cn=admin,dc=example,dc=org` with `admin`
- Base DN: `dc=example,dc=org`
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

### Setup Jenkins

Get the initial admin password by following command:

```sh
docker exec devopscompose_jenkins_1 cat /var/jenkins_home/secrets/initialAdminPassword
```

Open Jenkins and configure LDAP authentication.

### Setup GitBucket

Open GitBucket and configure LDAP authentication.
Database connection is automatically configured.

### Setup Mattermost

Mattermost (Community Edition) does not support LDAP authentication.
Configure a mail service such as AWS SES and use the email sign up.

### Register init script

We provide the init script for LSB.
Register as follows:

```sh
sudo ln -s /opt/devops-compose/init.sh /etc/init.d/devops-compose
sudo chkconfig --add devops-compose
```

## TODO

* Backup script


## Contribution

This is an open source software licensed under Apache-2.0.
Feel free to open issues or pull requests.

