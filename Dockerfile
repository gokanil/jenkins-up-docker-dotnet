#https://newbedev.com/adding-net-core-to-docker-container-with-jenkins/
#https://docs.docker.com/compose/install/
#https://www.jenkins.io/doc/book/installing/docker/
FROM jenkins/jenkins:lts
USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl libunwind8 gettext apt-transport-https && \
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
    mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg && \
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/dotnetdev.list' && \
    apt-get update
RUN apt-get install -y dotnet-sdk-5.0 && \
    export PATH=$PATH:$HOME/dotnet && \
    dotnet --version

RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean:1.24.8 docker-workflow:1.26"