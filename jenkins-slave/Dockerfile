FROM java:8
RUN apt-get update && apt-get install -y openssh-server

# Configure SSHD
RUN mkdir /var/run/sshd && \
    sed 's/session\s*required\s*pam_loginuid.so/session optional pam_loginuid.so/g' -i /etc/pam.d/sshd && \
    useradd -m jenkins

# Install docker and docker-compose
RUN curl -o /usr/local/bin/docker -L https://get.docker.com/builds/Linux/x86_64/docker-latest && \
    curl -o /usr/local/bin/docker-compose -L https://github.com/docker/compose/releases/download/1.3.2/docker-compose-Linux-x86_64 && \
    chmod +x /usr/local/bin/docker && \
    chmod +x /usr/local/bin/docker-compose

# Run SSHD
EXPOSE 22
ADD init.sh /init.sh
CMD ["/init.sh"]
