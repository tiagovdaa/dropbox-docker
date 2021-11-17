FROM debian:sid
MAINTAINER Tiago Almeida <tiagovdaa@gmail.com>
ENV DEBIAN_FRONTEND noninteractive

ARG UID=1000

### updating image and installing dependencies.
RUN apt-get update && apt-get -y dist-upgrade \
    && apt-get install -y wget gnupg2 ca-certificates curl python3-gpg 

### adding dropbox repo and installing.
RUN echo 'deb https://linux.dropbox.com/debian sid main' > /etc/apt/sources.list.d/dropbox.list 
RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E \
    && apt-get update \
    && apt-get install -y dropbox

### Creating service account
RUN groupadd dropbox \
	&& useradd -m -u ${UID} -d /dbox -c "Dropbox Daemon Account" -s /usr/sbin/nologin -g dropbox dropbox

### Dropbox needs to download it's proprietary daemon
USER dropbox
RUN mkdir -p /dbox/.dropbox /dbox/.dropbox-dist /dbox/Dropbox /dbox/base \
	&& echo y | dropbox start -i

### fix to avoid dropbox messing things around
USER root
RUN mkdir -p /opt/dropbox \
	# Prevent dropbox to overwrite its binary
	&& mv /dbox/.dropbox-dist/dropbox-lnx* /opt/dropbox/ \
	&& mv /dbox/.dropbox-dist/dropboxd /opt/dropbox/ \
	&& mv /dbox/.dropbox-dist/VERSION /opt/dropbox/ \
	&& rm -rf /dbox/.dropbox-dist \
	&& install -dm0 /dbox/.dropbox-dist \
	# Prevent dropbox to write update files
	&& chmod u-w /dbox \
	&& chmod o-w /tmp \
	&& chmod g-w /tmp \
	# Prepare for command line wrapper
	&& mv /usr/bin/dropbox /usr/bin/dropbox-cli

# Install init script and dropbox command line wrapper
COPY run /root/
COPY dropbox /usr/bin/dropbox

WORKDIR /dbox/Dropbox
EXPOSE 17500
VOLUME ["/dbox/.dropbox", "/dbox/Dropbox"]
ENTRYPOINT ["/root/run"]