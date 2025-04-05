FROM mcr.microsoft.com/devcontainers/base:alpine-3.20

ARG TERRAFORM_VERSION=1.11.3
ARG ANSIBLE_VERSION=11.4.0
ARG ARCH=amd64

RUN apk add --update --no-cache python3 unzip && \
    python3 -m venv /venv/ansible
    
RUN source /venv/ansible/bin/activate && \ 
    python3 -m ensurepip && \
    python3 -m pip install ansible==$ANSIBLE_VERSION

ADD https://hashicorp-releases.yandexcloud.net/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip /opt/terraform/

RUN cd /opt/terraform/ && \
    unzip terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip && \
    install /opt/terraform/terraform /usr/bin/terraform

ENV TF_CLI_CONFIG_FILE=/terraform.conf.d/terraform.tfrc
COPY terraform.conf.d/ /terraform.conf.d/
