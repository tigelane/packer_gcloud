FROM docker.mirror.hashicorp.services/alpine:latest
LABEL maintainer="Tige Phillips tigelane@mac.com - Mostly Hashicorp code from the Packer team."

ENV PACKER_VERSION=1.7.8
ENV PACKER_SHA256SUM=8513c3679d51141c39da3d95c691fcfc4b2ccc20e96ac5244b58b98899d6fe54

RUN apk add --update git bash wget openssl

ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip ./
ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_SHA256SUMS ./

RUN sed -i '/.*linux_amd64.zip/!d' packer_${PACKER_VERSION}_SHA256SUMS
RUN sha256sum -cs packer_${PACKER_VERSION}_SHA256SUMS
RUN unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /bin
RUN rm -f packer_${PACKER_VERSION}_linux_amd64.zip

RUN apk add curl
RUN apk add python3
RUN curl -sSL https://sdk.cloud.google.com > /tmp/gcl && bash /tmp/gcl --install-dir=~/gcloud --disable-prompts
ENV PATH=$PATH:/root/gcloud/google-cloud-sdk/bin
