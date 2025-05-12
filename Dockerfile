FROM debian:bookworm
LABEL maintainer="tiagovdaa@gmail.com"
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Europe/Lisbon
ENV LC_ALL pt_BR.UTF-8
ENV LANG pt_BR.UTF-8
ENV LANGUAGE pt_BR.UTF-8

ARG UID=1000

### updating image and installing dependencies.
RUN apt-get update && apt-get -y dist-upgrade \
    && apt-get install -y wget gnupg2 ca-certificates curl python3-gpg tzdata locales locales-all

### adding dropbox repo and installing.
COPY dropbox.asc /usr/share/keyrings/
RUN echo 'deb [arch=i386,amd64 signed-by=/usr/share/keyrings/dropbox.asc] http://linux.dropbox.com/debian bookworm main' > /etc/apt/sources.list.d/dropbox.list
RUN apt-get update \
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
#	# Prevent dropbox to write update files
#	&& chmod u-w /dbox \
#	&& chmod o-w /tmp \
#	&& chmod g-w /tmp \
	# Prepare for command line wrapper
	&& mv /usr/bin/dropbox /usr/bin/dropbox-cli

# Install init script and dropbox command line wrapper
COPY run /root/
COPY dropbox /usr/bin/dropbox

# Perform cleanup
RUN apt-get clean all

WORKDIR /dbox/Dropbox
EXPOSE 17500
VOLUME ["/dbox/"]
ENTRYPOINT ["/root/run"]