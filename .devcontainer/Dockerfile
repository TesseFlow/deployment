FROM mcr.microsoft.com/devcontainers/base:bookworm

ARG USER=vscode
ARG TERRAFORM_VERSION=1.11.3
ARG ANSIBLE_VERSION=11.4.0
ARG ARCH=amd64

SHELL [ "bash", "-c" ]

RUN apt update -y && \
    apt install -y python3 python3-venv unzip && \
    python3 -m venv /venv/ansible && \
    apt autoremove -y && rm -rf /var/lib/apt/lists/*
    
RUN source /venv/ansible/bin/activate && \ 
    python3 -m ensurepip && \
    python3 -m pip install ansible==$ANSIBLE_VERSION

ADD https://hashicorp-releases.yandexcloud.net/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip /opt/terraform/

RUN cd /opt/terraform/ && \
    unzip terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip && \
    install /opt/terraform/terraform /usr/bin/terraform

USER  $USER
ENV   HOME=/home/$USER

ENV   TF_CLI_CONFIG_FILE=$HOME/terraform.d/terraform.tfrc
COPY  terraform.d/ $HOME/terraform.d/
COPY  .ssh $HOME/.ssh
