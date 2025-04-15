FROM mcr.microsoft.com/devcontainers/base:bookworm

ARG USER=vscode
ARG TERRAFORM_VERSION=1.11.3
ARG ANSIBLE_VERSION=11.4.0
ARG ANSIBLE_LINT_VERSIOn=25.2.1
ARG ARCH=amd64

SHELL [ "bash", "-c" ]

RUN apt update -y && \
    apt install -y python3 python3-venv unzip && \
    apt autoremove -y && rm -rf /var/lib/apt/lists/*

ADD https://hashicorp-releases.yandexcloud.net/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip /opt/terraform/

RUN cd /opt/terraform/ && \
    unzip terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip && \
    install /opt/terraform/terraform /usr/bin/terraform

USER  $USER
ENV   HOME=/home/$USER
   
RUN python3 -m venv $HOME/venv/ansible && \
    ACTIVATE_PATH=$HOME/venv/ansible/bin/activate && \
    source $ACTIVATE_PATH && \ 
    python3 -m ensurepip && \
    python3 -m pip install ansible==$ANSIBLE_VERSION ansible-lint==$ANSIBLE_LINT_VERSIOn && \
    echo source $ACTIVATE_PATH >> $HOME/.profile

ENV   TF_CLI_CONFIG_FILE=$HOME/terraform.d/terraform.tfrc
COPY  terraform.d/ $HOME/terraform.d/
COPY  .ssh $HOME/.ssh
