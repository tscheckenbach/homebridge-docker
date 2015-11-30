##################################################################
# Set basics
##################################################################

FROM nodesource/jessie:0.12.7
MAINTAINER Thorsten Scheckenbach <t.scheckenbach@creativation.de>
RUN apt-get update

##################################################################
# Set environment
##################################################################

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

# Set timezone
RUN echo Europe/Berlin > /etc/timezone && dpkg-reconfigure tzdata

##################################################################
# Install packages
##################################################################

RUN apt-get -y --force-yes install curl wget git vim net-tools make gcc g++ apt-transport-https python build-essential libavahi-compat-libdnssd-dev libkrb5-dev
RUN apt-get -y --force-yes install libalgorithm-merge-perl libclass-isa-perl libcommon-sense-perl libdpkg-perl liberror-perl libfile-copy-recursive-perl libfile-fcntllock-perl libio-socket-ip-perl libjson-perl libjson-xs-perl libmail-sendmail-perl libsocket-perl libswitch-perl libsys-hostname-long-perl libterm-readkey-perl libterm-readline-perl-perl

##################################################################
# Install homebridge and plugins
##################################################################
USER root

RUN cd /root
RUN export USER=root; npm install --unsafe-perm -g homebridge

# Install netatmo plugin (don't forget to add an entry to config.json)
#RUN export USER=root; npm install --unsafe-perm -g homebridge-netatmo
# Install fhem plugin (don't forget to add an entry to config.json)
#RUN export USER=root; npm install --unsafe-perm -g git+https://github.com/justme-1968/homebridge-fhem.git
# Install harmony plugin (don't forget to add an entry to config.json)
#RUN export USER=root; npm install --unsafe-perm -g homebridge-harmonyhub
# Install ifttt plugin (don't forget to add an entry to config.json)
#RUN export USER=root; npm install --unsafe-perm -g homebridge-ifttt

##################################################################
# Start
##################################################################

USER root
RUN mkdir -p /var/run/dbus
VOLUME /var/run/dbus

EXPOSE 51826

RUN mkdir /root/.homebridge
COPY config.json /root/.homebridge/config.json

COPY run.sh ./
RUN chmod +x ./run.sh
CMD ["./run.sh"]
