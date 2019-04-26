FROM debian:buster

# Debian release name
ENV DEBIAN_RELEASE=buster

# Python Version
ENV PYTHON_VERSION=3.6

# Node Setup Version
ENV NODE_SETUP_VERSION=8.x

# Update apt repositories
RUN apt-get update

# Install build tools
RUN apt-get -y install build-essential

# Install python, python-dev, lsb_release (which depends on python), curl
RUN apt-get -y install python python${PYTHON_VERSION}-dev lsb-release curl

# Install Docker dependencies
RUN apt-get -y install apt-transport-https ca-certificates python3-software-properties software-properties-common

# Add Docker apt repository
# TODO: Update when buster has an official docker release 
RUN add-apt-repository "deb https://apt.dockerproject.org/repo/ debian-stretch main"

# Add Docker GPG key
RUN curl -fsSL https://yum.dockerproject.org/gpg | apt-key add -

# Update & Install docker
RUN apt-get update && apt-get -y install docker-engine

# Update & Install python setup tools (for pip)
RUN apt-get update && apt-get -y install python$(echo $PYTHON_VERSION | cut -c -1)-setuptools


# Add node repositories to apt-get and install nodejs
RUN curl -sL https://deb.nodesource.com/setup_$NODE_SETUP_VERSION | bash - && apt-get install -y nodejs

# Add GCP SDK repositories
RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk-$DEBIAN_RELEASE main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && cat /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Install GCP tools
RUN apt-get update && apt-get install -y google-cloud-sdk google-cloud-sdk-app-engine-python kubectl 

# Install vim
RUN apt-get -y install vim

# Install debscan for security updates
RUN apt-get -y install debsecan

# Copy apt package list
COPY ./extra_packages /tmp/extra_packages

# Install extra packages
RUN apt-get update && cat /tmp/extra_packages | xargs apt-get -y install

# Set alternatives to desired python version
RUN alias python=python
RUN update-alternatives --install /usr/bin/python python /usr/bin/python$PYTHON_VERSION 1
RUN update-alternatives --install /usr/bin/python python /usr/bin/python2 2
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 3

# Install the proper version of pip 
RUN python -m easy_install pip

# Copy pip package list
COPY ./pip_packages /tmp/pip_packages

# Install pip packages
RUN pip install --upgrade -r /tmp/pip_packages

# Copy npm packages list
COPY ./npm_packages /tmp/npm_packages

# Update npm and install packages
RUN npm update -g npm@latest && cat /tmp/npm_packages | xargs npm install -g

# Add Azure repo
# Have to use jessie for now...
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ jessie main" | tee /etc/apt/sources.list.d/azure-cli.list

# Get MS Signing Key
RUN apt-key --keyring /etc/apt/trusted.gpg.d/Microsoft.gpg adv \
     --keyserver packages.microsoft.com \
     --recv-keys BC528686B50D79E339D3721CEB3E94ADBE1229CF

# Install Azure CLI
RUN apt-get update && apt-get install azure-cli

# Copy usrlocal.inject files
COPY ./usrlocal.inject /tmp/usrlocal

# Copy usrlocal.inject files to /usr/local
RUN cp -r /tmp/usrlocal/* /usr/local 

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

