FROM debian:buster-slim

RUN useradd -rG sudo bitcoin \
  && apt-get update -y \
  && apt-get install -y curl wget gnupg gosu logrotate libsnappy-dev libgflags2.2 libzmq3-dev procps\
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Fetching the binaries from foked blockbook repo unti we introduce building of packages directly in blockbook repo
# https://github.com/satoshilabs/devops/issues/45

RUN wget https://github.com/vdovhanych/blockbook/releases/download/v0.3.5/backend-bitcoin-regtest_22.0-satoshilabs-1_amd64.deb \
  && dpkg -i backend-bitcoin-regtest_22.0-satoshilabs-1_amd64.deb \
  && rm backend-bitcoin-regtest_22.0-satoshilabs-1_amd64.deb

COPY entrypoint.sh entrypoint.sh
RUN chmod +x ./entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]
