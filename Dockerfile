FROM jenkins/jnlp-slave:alpine

ENV TERRAFORM_VERSION=0.12.0
ENV TERRAFORM_SHA256SUM=42ffd2db97853d5249621d071f4babeed8f5fdba40e3685e6c1013b9b7b25830

# Download and install Terraform
USER root
RUN apk add --update make git curl curl-dev openssh && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sha256sum -cs terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip
   
# Install latest nodejs  
RUN apk add --update nodejs nodejs-npm

# Install dependencies of canvas needed to build webpack
RUN apk add --update \
    && apk add --no-cache ffmpeg opus pixman cairo pango giflib ca-certificates \
    && apk add --no-cache --virtual .build-deps git curl build-base jpeg-dev pixman-dev \
    cairo-dev pango-dev pangomm-dev libjpeg-turbo-dev giflib-dev freetype-dev python g++ make nodejs npm chromium jq
#RUN apk --no-cache add --update python

# Install AWS CLI
RUN wget "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -O "awscli-bundle.zip"
RUN unzip awscli-bundle.zip && chmod +x ./awscli-bundle/install
RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
RUN rm awscli-bundle.zip && rm -rf awscli-bundle && rm /var/cache/apk/*

# Install ZIP
RUN apk --no-cache add --update zip
