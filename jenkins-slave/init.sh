#!/bin/sh -e

# Add jenkins user into docker group
[ -S /var/run/docker.sock ]
docker_group="`stat -c '%g' /var/run/docker.sock`"
[ "$docker_group" -gt 0 ]
groupadd -g "$docker_group" docker
usermod -a -G docker jenkins
id jenkins

# Generate random password if not given
[ -z "$ssh_passwd" ] && ssh_passwd="`tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 16`"

# Set password of jenkins user
echo "jenkins:${ssh_passwd}" | chpasswd
echo "Connect via SSH as jenkins user with password: ${ssh_passwd}"
unset ssh_passwd

# Run SSHD
exec /usr/sbin/sshd -D -e
