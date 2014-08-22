# DOCKER-VERSION 0.11.1
# VERSION 0.0.1

FROM centos:centos7

MAINTAINER aozora0000

# sysconfig network
RUN echo "NETWORKING=yes" > /etc/sysconfig/network

RUN rpm -Uvh http://ftp.riken.jp/Linux/fedora/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm
# yum
RUN yum update -y
RUN yum install -y passwd
RUN yum install -y sudo
RUN yum install -y gcc
RUN yum install -y gcc-c++
RUN yum install -y make
RUN yum install -y vim
RUN yum install -y git
RUN yum install --enablerepo=epel -y mosh
RUN yum install -y openssl-devel
RUN yum install -y zlib-devel
RUN yum install -y readline-devel
RUN yum install -y bzip2-devel
RUN yum install -y libevent-devel
RUN yum install -y openssh
RUN yum install -y openssh-server
RUN yum install -y openssh-clients
RUN yum install -y cmake
RUN yum install -y npm
RUN yum install -y redis

# ssh
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

# user
RUN useradd aozora
RUN echo '19841004' | passwd --stdin aozora

# sudo
RUN echo 'aozora ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/aozora

# timezone
RUN cp -p /usr/share/zoneinfo/Japan /etc/localtime

# sshd
RUN /sbin/service sshd start
RUN /sbin/service sshd stop

# redis
RUN /etc/init.d/redis start
RUN chkconfig redis on

# npm
## coffee-script
RUN npm install -g coffee-script
## hubot
RUN npm install -g hubot

USER aozora
WORKDIR /home/aozora
RUN hubot --create myhubot

USER root
WORKDIR /home/aozora/myhubot

## sushi-yuki
RUN npm install -g hubot-misawa
RUN npm install -g hubot-meshi
RUN npm install -g hubot-totsuzen
RUN cp external-scripts.json external-scripts.json.back
ADD external-scripts.json /home/aozora/myhubot/external-script.json
RUN ./bin/hubot

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
