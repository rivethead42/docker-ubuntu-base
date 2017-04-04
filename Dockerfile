# This Dockerfile is used to build a base image for linuxacademy.com.
FROM ubuntu:xenial

MAINTAINER Travis N. Thomsen <travis.@linuxacademy.com>

RUN apt-get -yq update
RUN apt-get install -qqy wget git ssh vim

RUN wget https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
RUN dpkg -i puppetlabs-release-pc1-xenial.deb
RUN apt-get -qqy update

RUN apt-get install -qqy puppet-agent

RUN mkdir -p /etc/puppetlabs/code/hieradata

RUN /opt/puppetlabs/bin/puppet module install puppet-r10k --version 5.0.0
RUN /opt/puppetlabs/bin/puppet apply -e "class { 'r10k': }"

# Configure manifests and modules
COPY puppet/site.pp /etc/puppetlabs/puppet/manifests/

# Add Puppetfile
COPY puppet/Puppetfile /etc/puppetlabs/puppet/

# Configure hiera
COPY puppet/hiera/hiera.yaml /etc/puppetlabs/puppet/

COPY puppet/hiera/common.json /etc/puppetlabs/code/hieradata/

# Run r10k
RUN PUPPETFILE=/etc/puppetlabs/puppet/Puppetfile PUPPETFILE_DIR=/etc/puppetlabs/code/modules/ r10k puppetfile install --verbose debug2 --color

# Run Puppet apply
RUN /opt/puppetlabs/bin/puppet apply /etc/puppetlabs/puppet/manifests/site.pp --modulepath=/etc/puppetlabs/code/modules/ --hiera_config /etc/puppetlabs/puppet/hiera.yaml --verbose


RUN rm -rf /etc/puppetlabs/code/modules/*
RUN rm -rf /etc/puppetlabs/puppet/Puppetfile
