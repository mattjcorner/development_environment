FROM debian:jessie

# Debian release name
ENV DEBIAN_RELEASE=jessie

# Docker Version
ENV DOCKER_VERSION=1.13

# Python Version
ENV PYTHON_VERSION=3.4

# Update apt repositories
RUN apt-get update

# Install build tools
RUN apt-get -y install build-essential

# Install python, python-dev, lsb_release (which depends on python), curl
RUN apt-get -y install python$PYTHON_VERSION python$PYTHON_VERSION-dev lsb-release curl

# Install Docker dependencies
RUN apt-get -y install apt-transport-https ca-certificates python-software-properties software-properties-common

# Add Docker apt repository
RUN add-apt-repository "deb https://apt.dockerproject.org/repo/ debian-$DEBIAN_RELEASE main"

# Add Docker GPG key
RUN curl -fsSL https://yum.dockerproject.org/gpg | apt-key add -

# Update apt repositories... again
RUN apt-get update

# Install docker
RUN apt-get -y install docker-engine

# Install python setup tools (for pip)
RUN apt-get -y install python$(echo $PYTHON_VERSION | cut -c -1)-setuptools

# Install pip
RUN easy_install$(echo $PYTHON_VERSION | cut -c -1) pip

# Install vim
RUN apt-get -y install vim

# Install debscan for security updates
RUN apt-get -y install debsecan

# Copy apt package list
COPY ./extra_packages /tmp/extra_packages

# Install extra packages
RUN cat /tmp/extra_packages | xargs apt-get -y install

# Copy pip package list
COPY ./pip_packages /tmp/pip_packages

# Install pip packages
RUN pip install --upgrade -r /tmp/pip_packages

# Create Projects directory (to be mounted)
RUN mkdir ~/Projects

# Install vundle
RUN mkdir -p ~/.vim/bundle && git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Run InstallPlugin so vim is set up
RUN vim -c 'PluginInstall' -c 'qa!'

# Inject vimrc 
COPY ./vimrc.inject /tmp/vimrc.inject
RUN cat /tmp/vimrc.inject >> ~/.vimrc

# Inject bashrc
COPY ./bashrc.inject /tmp/bashrc.inject
RUN cat /tmp/bashrc.inject >> ~/.bashrc

# Apply security updates
RUN apt-get install $(debsecan --suite ${DEBIAN_RELEASE} --format packages --only-fixed)
