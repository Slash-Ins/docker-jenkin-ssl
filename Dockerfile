# pull base image Ubuntu 16.04 LTS (Xenial)
FROM ubuntu:xenial

MAINTAINER Stephen L. Reed (stephenreed@yahoo.com)

# this is a non-interactive automated build - avoid some warning messages
ENV DEBIAN_FRONTEND noninteractive

# install the OpenJDK 8 java runtime environment and curl
RUN apt update; \
  apt upgrade -y; \
  apt install -y default-jre curl wget git nano; \
  apt-get clean

ENV JAVA_HOME /usr
ENV PATH $JAVA_HOME/bin:$PATH

# copy jenkins war file to the container
ENV JENKINS_HOME /var/jenkins_home/.ssl
ADD http://mirrors.jenkins.io/war-stable/latest/jenkins.war /opt/jenkins.war
RUN chmod 644 /opt/jenkins.war
ENV JENKINS_HOME /jenkins

# configure the container to run jenkins, mapping container port 8080 to that host port
ENTRYPOINT ["java", "-jar", "/opt/jenkins.war", "--httpsPort=8443", "--httpPort=-1", "--httpsCertificate=fullchain.pem", "--httpsPrivateKey-rsa.pem"]
EXPOSE 8443