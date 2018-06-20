FROM ubuntu:trusty
MAINTAINER Andrés Diaz <andres.diaz@yuxiglobal.com>

ENV DEBIAN_FRONTEND noninteractive
SHELL ["/bin/bash", "-l", "-c"]

# Setup environment language
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Update system and install dependencies
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y \
  curl \
  libpq-dev \
  git
RUN apt-get autoremove -y

# Install Javascript Runtime
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && apt-get install -y nodejs

ENV RUBY_VERSIONS "2.5.1 2.2.2"

# Install RVM
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN \curl -sSL https://get.rvm.io | bash -s stable
RUN source /etc/profile.d/rvm.sh

# Install RUBY_VERSIONS
RUN for version in $RUBY_VERSIONS; do echo "Now installing Ruby $version"; rvm install $version; rvm cleanup all; rvm use $version; gem update --system; gem install bundler; done
