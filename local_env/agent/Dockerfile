FROM jenkins/ssh-agent

ARG docker_url=https://download.docker.com/linux/static/stable/x86_64/
ARG docker_version=18.06.3-ce

# install docker cli
RUN curl -fsSL ${docker_url}docker-${docker_version}.tgz | \
tar zxvf - --strip 1 -C /usr/bin docker/docker

