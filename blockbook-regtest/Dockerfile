FROM debian:bullseye-slim

RUN useradd -rG sudo bitcoin \
  && apt-get update -y \
  && apt-get install -y curl wget gnupg gosu logrotate libsnappy-dev libgflags2.2 libzmq3-dev procps libgcc-s1\
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# https://github.com/satoshilabs/devops/issues/45
ARG TARGETPLATFORM
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then ARCHITECTURE=amd64; elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then ARCHITECTURE=arm64; else ARCHITECTURE=amd64; fi \
  && wget https://data.trezor.io/dev/blockbook/builds/backend-bitcoin-regtest_23.0-satoshilabs-1_${ARCHITECTURE}.deb \
  && wget https://data.trezor.io/dev/blockbook/builds/blockbook-bitcoin-regtest_0.3.6_${ARCHITECTURE}.deb \
  && dpkg -i backend-bitcoin-regtest_23.0-satoshilabs-1_${ARCHITECTURE}.deb \
  && dpkg -i blockbook-bitcoin-regtest_0.3.6_${ARCHITECTURE}.deb \
  && rm blockbook-bitcoin-regtest_0.3.6_${ARCHITECTURE}.deb \
  && rm backend-bitcoin-regtest_23.0-satoshilabs-1_${ARCHITECTURE}.deb

# replace default blockbook config with custom config with changed coin_shortcut to "REGTEST", to be compatibile with trezor-common shorcut.
COPY ./blockchaincfg.json /opt/coins/blockbook/bitcoin_regtest/config/blockchaincfg.json
COPY ./entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]
