FROM alpine:3.12.0

# MAINTAINER is deprecated: MAINTAINER PS <psellars@gmail.com>

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
      https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_${VERSION}_linux-64bit.tar.gz > hugo_${VERSION}_linux-64bit.tar.gz \
    && echo "99c4752bd46c72154ec45336befdf30c28e6a570c3ae7cc237375cf116cba1f8  hugo_${VERSION}_linux-64bit.tar.gz" >> hugo_checksum.txt \
    && sha256sum -c hugo_checksum.txt \
    && tar -xzvf hugo_${VERSION}_linux-64bit.tar.gz \
    && mv hugo /usr/local/bin/hugo \
    && addgroup -Sg 1000 hugo \
    && adduser -SG hugo -u 1000 -h /src hugo
    
WORKDIR /src

HEALTHCHECK CMD ls index.html

EXPOSE 1313

ENTRYPOINT ["hugo", "server", "-w", "--bind=0.0.0.0"]
