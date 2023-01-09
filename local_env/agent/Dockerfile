FROM alpine:latest AS downloader

ARG docker_url=https://download.docker.com/linux/static/stable/x86_64/
ARG docker_version=18.06.3-ce

# download and untar docker cli
RUN wget -qO- ${docker_url}docker-${docker_version}.tgz | \
	tar zxvf - --strip 1 -C /usr/bin docker/docker

# build final image
FROM jenkins/ssh-agent 

# install git
RUN apt-get update && apt-get install -y \
	git curl \
	&& rm -rf /var/lib/apt/lists/*

# copy docker from "downloader" build stage
COPY --from=downloader /usr/bin/docker /usr/bin/docker
