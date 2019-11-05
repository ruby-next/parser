ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}-slim

ARG BUNDLER_VERSION

# Install system dependencies
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    curl \
    less \
    git \
    ragel \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && truncate -s 0 /var/log/*log

RUN mkdir /app /bundle

# Configure bundler and PATH
ENV LANG=C.UTF-8 \
  BUNDLE_PATH=/bundle \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3
ENV BUNDLE_APP_CONFIG=${BUNDLE_PATH} \
  BUNDLE_BIN=${BUNDLE_PATH}/bin
ENV PATH /app/bin:${BUNDLE_BIN}:${PATH}

# Upgrade RubyGems and install required Bundler version 
RUN gem update --system && \
    gem install bundler:${BUNDLER_VERSION}

WORKDIR /app
