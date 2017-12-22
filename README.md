# DevOps Compose [![CircleCI](https://circleci.com/gh/int128/devops-compose.svg?style=shield)](https://circleci.com/gh/int128/devops-compose)

A compose of following Docker containers:

* Crowd
* JIRA software
* Confluence
* GitBucket
* Jenkins
* Nexus
* SonarQube
* Mattermost
* ownCloud
* OpenLDAP


## Getting Started

Create the following stack.

Component | Note
----------|-----
RDS       | Stores databases. Recommeded for easy backup and migration.
EBS#1     | Stores `/var/lib/docker`.
EBS#2     | Stores persistent volumes. Recommeded for easy backup and migration.
EC2       | -
ACM       | Provides a SSL certificate.
ALB       | Provides a SSL termination.
Route53   | -

### RDS database

Create a PostgreSQL instance.
It is recommended to use managed services such as Amazon RDS or Google Cloud SQL for maintenancebility reason.
MySQL is available and works as well but [PostgreSQL is recommended for JIRA](https://confluence.atlassian.com/adminjiraserver074/supported-platforms-881683157.html).

Initialize databases and users by executing [`init-postgresql.sql`](/init-postgresql.sql).

### EC2 Instance

Create following EC2 instance and EBS volumes:

- EC2 instance
- EBS volume attached to the instance on `/var/lib/docker`
- EBS volume attached to the instance on `/persistent_volumes`

Connect to the instance and do followings:

```bash
# Configure fstab
echo '/dev/xvdb /var/lib/docker ext4 defaults,nofail 0 2' | sudo tee -a /etc/fstab
echo '/dev/xvdc /persistent_volumes ext4 defaults,nofail 0 2' | sudo tee -a /etc/fstab

# Create swap space
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile swap swap defaults 0 0' | sudo tee -a /etc/fstab

# Install Docker Compose
sudo yum install -y docker
sudo curl -L -o /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/1.12.0/docker-compose-Linux-x86_64
sudo chmod +x /usr/local/bin/docker-compose

# Make sure Docker service is running
sudo docker version
sudo docker-compose version
```

Run containers. This may take a few minutes.

```bash
cd /persistent_volumes
git clone https://github.com/int128/devops-compose.git
cd /persistent_volumes/devops-compose

# Environment specific values
echo 'DATABASE_HOST=xxxxx.xxxxx.rds.amazonaws.com' >> .env
echo 'REVERSE_PROXY_DOMAIN_NAME=example.com' >> .env
echo 'PERSISTENT_VOLUMES_ROOT=/persistent_volumes' >> .env

docker-compose build
docker-compose up -d
```

### ALB, Route53 and ACM

Request a certificate for a wildcard domain on ACM.

Create an ALB and target group for the instance.

Create a wildcard record on the hosted zone.

```
A *.example.com. <ELB endpoint>.
```

### Configure auto launch

```sh
sudo ln -s /persistent_volumes/devops-compose/init-lsb.sh /etc/init.d/devops-compose
sudo chkconfig --add devops-compose
```


## Setup DevOps tools

Open https://devops.example.com (concatenate `devops` and the domain).

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
- Root DN: `dc=example,dc=org`
- User search base: (empty)
- User search filter: `cn={0}`
- Group search base: (empty)
- Group search filter: `cn={0}`
- Group membership: Search for LDAP groups containing user, filter: `uniqueMember={0}`
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
- Group type: Dynamic
- Group member of attribute: `memberOf` (default)

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


## Contribution

This is an open source software licensed under Apache-2.0.
Feel free to open issues or pull requests.
