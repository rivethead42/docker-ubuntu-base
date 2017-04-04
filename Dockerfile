# This Dockerfile is used to build a base image for linuxacademy.com.
FROM ubuntu:xenial

MAINTAINER Travis N. Thomsen <travis.@linuxacademy.com>

RUN apt-get -yq update
RUN apt-get install -qqy wget git ssh vim

RUN wget https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
RUN dpkg -i puppetlabs-release-pc1-xenial.deb
RUN apt-get -qqy update

RUN apt-get install -qqy puppet-agent

RUN mkdir -p /etc/puppet/modules
RUN mkdir -p /etc/puppet/manifests
RUN mkdir -p /etc/puppet/manifests
RUN mkdir -p /etc/puppet/hieradata

RUN gem install r10k

# Configure manifests and modules
COPY puppet/site.pp /etc/puppet/manifests/

# Add Puppetfile
COPY puppet/Puppetfile /etc/puppet/

# Configure hiera
COPY puppet/hiera/hiera.yaml /etc/puppet/

COPY puppet/hiera/common.json /etc/puppet/hieradata/

# Run r10k
RUN PUPPETFILE=/etc/puppet/Puppetfile PUPPETFILE_DIR=/etc/puppet/modules/ r10k puppetfile install --verbose debug2 --color

# Run Puppet apply
#RUN puppet apply --modulepath=/etc/puppet/modules/ --hiera_config /etc/puppet/hiera.yaml --verbose
