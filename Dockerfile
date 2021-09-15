#####
# build-hugo
FROM golang:1.17.1-alpine as build-hugo

# Prep for build.
ENV CGO_ENABLED=1
ENV GOOS=linux
ENV GOARCH=amd64

# The Hugo version to compile.  Set here and below.
ENV HUGO_VERSION=0.88.1

WORKDIR /root/hugo

# Basic packages to perform the build.
RUN apk --no-cache add \
    wget git gcc g++ \
    musl-dev

# Download the source and compile it.
RUN cd /root/hugo && \
    wget https://github.com/gohugoio/hugo/archive/v${HUGO_VERSION}.tar.gz -O /root/hugo.tar.gz && \
    tar -zxf ../hugo.tar.gz && cd hugo-${HUGO_VERSION} && \
    go build -ldflags '-extldflags "-fno-PIC -static"' -buildmode pie -tags 'extended osusergo netgo static_build'

#####
# build-pandoc
FROM pandoc/ubuntu-crossref:latest AS build-pandoc

#####
# hugo-integrator
# FROM alpine:latest
FROM debian:bullseye-slim

# The Hugo version to compile.  Set here and below.
ENV HUGO_VERSION=0.88.1

# Copy Hugo from build.
COPY --from=build-hugo /root/hugo/hugo-${HUGO_VERSION}/hugo /usr/local/bin/hugo
COPY --from=build-pandoc /usr/local/bin/pandoc /usr/local/bin/pandoc-crossref /usr/local/bin/

# Install supporting packages as well as Graphviz.
# RUN apk update && \
#     apk add --no-cache \
#     bzip2 \
#     ca-certificates \
#     curl \
#     file \
#     gmp \
#     graphviz \
#     gzip \
#     libffi \
#     lua5.3 \
#     lua5.3-lpeg \
#     nodejs \
#     npm \
#     python3 \
#     python3-dev \
#     py3-pip \
#     tar \
#     wget \
#     zip \
#     unzip
RUN apt-get update && \
    apt-get --yes install \
    bzip2 \
    ca-certificates \
    curl \
    file \
    graphviz \
    libatomic1 \
    libayatana-appindicator3-1 \
    libffi7 \
    libgmp10 \
    liblua5.3-0 \
    libnotify4 \
    libnss3 \
    libopentk1.1-cil \
    libpcre3 \
    libsecret-1-0 \
    libxss1 \
    libyaml-0-2 \
    lua-lpeg \
    nodejs \
    npm \
    python3.9 \
    python3.9-dev \
    python3-pip \
    unzip \
    xdg-utils \
    xvfb \
    zip \
    zlib1g && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Mermaid CLI.
RUN npm install -g @mermaid-js/mermaid-cli

# Install Draw.io.
RUN curl --location --remote-name https://github.com/jgraph/drawio-desktop/releases/download/v15.2.7/drawio-amd64-15.2.7.deb && \
    dpkg -i --force-depends drawio-amd64-15.2.7.deb && \
    rm -f drawio-amd64-15.2.7.deb

# Install aws-cli.
RUN pip install awscli
