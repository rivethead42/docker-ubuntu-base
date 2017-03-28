# This Dockerfile is used to build a base image for binaryvoid.
FROM ubuntu:xenial

MAINTAINER Travis N. Thomsen <travis.n.thomsen@gmail.com>

# More notes bla
#bla
RUN  apt-get -yq update
RUN apt-get install -qqy wget git ssh vim

RUN wget https://apt.puppetlabs.com/puppetlabs-release-pc1-precise.deb
RUN dpkg -i puppetlabs-release-pc1-precise.deb
RUN apt-get -qqy update

RUN apt-get install -qqy puppet
RUN mkdir -p ~/.ssh
ADD .ssh/id_rsa /root/.ssh/
ADD .ssh/id_rsa.pub /root/.ssh/
ADD .ssh/known_hosts /root/.ssh/
RUN chmod 600 -R /root/.ssh/*

RUN mkdir -p /etc/puppet/hieradata

RUN gem install r10k
