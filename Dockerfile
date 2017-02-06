FROM debian:jessie

#Debian release name
ENV DEBIAN_RELEASE=jessie

#Docker Version
ENV DOCKER_VERSION=1.13

#Python Version
ENV PYTHON_VERSION=3.4

# Update apt repositories
RUN apt-get update

# Install python, lsb_release (which depends on python), curl
RUN apt-get -y install python$PYTHON_VERSION lsb-release curl

# Install Docker dependencies
RUN apt-get -y install apt-transport-https ca-certificates python-software-properties software-properties-common

# Add Docker repository
RUN add-apt-repository "deb https://apt.dockerproject.org/repo/ debian-$DEBIAN_RELEASE main"

# Add Docker GPG key
RUN curl -fsSL https://yum.dockerproject.org/gpg | apt-key add -

# Update apt repositories... again
RUN apt-get update

# Install docker
RUN apt-get -y install docker-engine

# Install extra packages
RUN apt-get -y install vim

# Create Projects directory (to be mounted)
RUN mkdir ~/Projects

# Aliases!
RUN echo "alias vi=vim" >> ~/.bashrc
RUN echo "alias cdd='cd ~/Projects'" >> ~/.bashrc

# Prompt!
RUN echo "export PS1='\e[33;1m\u@\h: \e[31m\W\e[0m\$ '" >> ~/.bashrc

# Colours!
RUN echo "export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33'" >> ~/.bashrc
RUN echo "export TERM=xterm-color" >> ~/.bashrc

# Install vundle
RUN mkdir -p ~/.vim/bundle && git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Run InstallPlugin so vim is set up
RUN vim -c 'PluginInstall' -c 'qa!'

# Add vimrc 
COPY ./vimrc /root/.vimrc
