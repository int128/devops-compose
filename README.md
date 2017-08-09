# DevOps Compose [![CircleCI](https://circleci.com/gh/int128/devops-compose.svg?style=shield)](https://circleci.com/gh/int128/devops-compose)

A compose of following Docker containers:

* JIRA software
* Confluence
* GitBucket
* Jenkins
* Artifactory
* SonarQube
* Mattermost
* ownCloud
* PostgreSQL
* LDAP


## Provisioning

Run containers on Docker Compose.
This may take a few minutes.

```sh
# Wildcard DNS
echo 'REVERSE_PROXY_DOMAIN_NAME=192.168.1.2.xip.io' > .env

# Custom domain
echo 'REVERSE_PROXY_DOMAIN_NAME=example.com' > .env

docker-compose build
docker-compose up -d
```


### CoreOS

Enough swap space and Docker Compose are required.

```sh
#!/bin/bash -xe
cat > /etc/systemd/system/swap.service <<EOF
[Service]
Type=oneshot
ExecStartPre=-/usr/bin/rm -f /swapfile
ExecStartPre=/usr/bin/touch /swapfile
ExecStartPre=/usr/bin/fallocate -l 4G /swapfile
ExecStartPre=/usr/bin/chmod 600 /swapfile
ExecStartPre=/usr/sbin/mkswap /swapfile
ExecStartPre=/usr/sbin/sysctl vm.swappiness=10
ExecStart=/sbin/swapon /swapfile
ExecStop=/sbin/swapoff /swapfile
ExecStopPost=-/usr/bin/rm -f /swapfile
RemainAfterExit=true
[Install]
WantedBy=multi-user.target
EOF
systemctl enable --now /etc/systemd/system/swap.service
mkdir -p /opt/bin
curl -L -o /opt/bin/docker-compose https://github.com/docker/compose/releases/download/1.12.0/docker-compose-Linux-x86_64
chmod +x /opt/bin/docker-compose
```


### Custom domain

Create a wildcard record on the DNS service.

```
A *.example.com. 192.168.1.2.
```


## Setup

Open http://devops.example.com (concatenate `devops` and domain name).


### Setup JIRA

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

- Server: `ldap`
- Root DN: (empty)
- User search base: `dc=example,dc=com`
- User search filter: `cn={0}`
- Group search base: `dc=example,dc=com`
- Group search filter: `cn={0}`
- Group membership: `memberOf` (default)
- Manager DN: `cn=admin,dc=example,dc=com`
- Manager Password: `admin`
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

### Setup Artifactory

Open Artifactory and configure LDAP authentication.

- LDAP server: `ldap://ldap/dc=example,dc=com`
- User DN: `cn={0}`
- Mail attribute: `mail`
- Search filter: `(*)`
- Search base: `dc=example,dc=com`
- Manage DN: `cn=admin,dc=example,dc=com` with `admin`

### Setup SonarQube

SonarQube does not support LDAP authentication.

### Setup Mattermost

Mattermost (Community Edition) does not support LDAP authentication.
Configure a mail service such as AWS SES and use the email sign up.

### ownCloud

Open ownCloud and configure LDAP authentication.

- LDAP server: `ldap:389`
- Admin DN: `cn=admin,dc=example,dc=com` with `admin`
- Base DN: `dc=example,dc=com`

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
