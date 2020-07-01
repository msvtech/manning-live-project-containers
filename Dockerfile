FROM alpine:3.12.0

LABEL maintainer="matt@msvtechnology.com"

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

# ENTRYPOINT ["hugo", "server", "-w", "--bind=0.0.0.0"]
#    && echo "99c4752bd46c72154ec45336befdf30c28e6a570c3ae7cc237375cf116cba1f8  hugo_${VERSION}_linux-64bit.tar.gz" >> hugo_checksum.txt \

