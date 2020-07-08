FROM alpine:3.12.0

ARG created

LABEL maintainer="matt@msvtechnology.com"
LABEL org.opencontainers.image.created=$created
LABEL org.opencontainers.image.revision="1.0.0"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/msvtech/manning-live-project-containers"
LABEL org.opencontainers.image.title="Manning Live Project"

# hadolint ignore=DL3018
RUN apk add --no-cache \
    curl \
    git \
    openssh-client \
    rsync

ENV VERSION 0.64.0

WORKDIR /usr/local/src

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN mkdir -p /usr/local/src \
    && curl -L \
      https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_${VERSION}_Linux-64bit.tar.gz > hugo_${VERSION}_Linux-64bit.tar.gz \
    \
    && curl -L \
      https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_${VERSION}_checksums.txt > hugo_${VERSION}_checksums.txt \
    \
    && grep "hugo_${VERSION}_Linux-64bit.tar.gz" hugo_${VERSION}_checksums.txt > hugo_checksum.txt \
    && sha256sum -cs hugo_checksum.txt \
    \
    && tar -xzvf hugo_${VERSION}_Linux-64bit.tar.gz \
    && mv hugo /usr/local/bin/hugo \
    \
    && addgroup -Sg 1000 hugo \
    && adduser -SG hugo -u 1000 -h /src hugo
    
USER hugo

WORKDIR /src

EXPOSE 1313

HEALTHCHECK CMD wget http://localhost:1313
