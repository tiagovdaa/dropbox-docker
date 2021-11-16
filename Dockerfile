FROM debian:sid
MAINTAINER Tiago Almeida <tiagovdaa@gmail.com>
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt-get -y dist-upgrade \
    && apt-get install -y gnupg2 ca-certificates curl python-gpgme \
    && apt-key adv --keyserver pgp.mit.edu --recv-keys FC918B335044912E \
    && apt-get install -y dropbox
RUN mkdir -p /dbox/Dropbox /dbox/.dropbox
WORKDIR /dbox/Dropbox
EXPOSE 17500
VOLUME ["/dbox/.dropbox", "/dbox/Dropbox"]
ENTRYPOINT ["/bin/bash"]