# This Dockerfile is used to build a base image for linuxacademy.com.
FROM ubuntu:xenial

MAINTAINER Travis N. Thomsen <travis.@linuxacademy.com>

RUN apt-get -yq update
RUN apt-get install -qqy wget git ssh vim

RUN wget https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
RUN dpkg -i puppetlabs-release-pc1-xenial.deb
RUN apt-get -qqy update

RUN apt-get install -qqy puppet

RUN mkdir -p /etc/puppet/hieradata

RUN gem install r10k
