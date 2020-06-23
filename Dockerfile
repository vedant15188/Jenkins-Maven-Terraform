FROM jenkins/jenkins:lts

USER root

# Get Packages
RUN apt-get update

# Install docker
RUN apt-get install -y --no-install-recommends \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg2 \
	software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/debian \
	$(lsb_release -cs) \
	stable"

RUN apt-get update
RUN apt-get install -y --no-install-recommends docker-ce \
	libltdl-dev

RUN usermod -aG docker jenkins

# Tweak for differnt GID
RUN groupadd -g 998 docker-debian
RUN usermod -aG  docker-debian jenkins

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# Install Terraform
RUN apt-get install wget unzip
RUN wget https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip
RUN unzip ./terraform_0.12.26_linux_amd64.zip -d /usr/local/bin/
RUN terraform -v

# APT Cleanup
RUN rm -rf /var/lib/apt/lists/* \
	&& rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
	&& apt-get clean

RUN update-rc.d docker enable

# Switch to Jenkins user
USER jenkins
#ENV PATH="${PATH}:/usr/local/rvm/bin"