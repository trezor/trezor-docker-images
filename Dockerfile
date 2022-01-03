ARG VERSION=v0.9.1

FROM rust:1.41.1-slim AS builder

ARG VERSION

WORKDIR /build

RUN apt-get update
RUN apt-get install -y git clang cmake libsnappy-dev wget

RUN git clone --branch $VERSION https://github.com/romanz/electrs .

RUN cargo install --locked --path .

FROM debian:buster-slim

RUN useradd -rG sudo bitcoin \
  && apt-get update -y \
  && apt-get install -y curl wget gnupg gosu logrotate libsnappy-dev libgflags2.2 libzmq3-dev procps\
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget https://github.com/vdovhanych/blockbook/releases/download/v0.3.5/backend-bitcoin-regtest_22.0-satoshilabs-1_amd64.deb \
    && dpkg -i backend-bitcoin-regtest_22.0-satoshilabs-1_amd64.deb \
    && rm backend-bitcoin-regtest_22.0-satoshilabs-1_amd64.deb

RUN adduser --disabled-password --uid 1000 --home /data --gecos "" electrs
USER electrs

WORKDIR /data
COPY --from=builder /usr/local/cargo/bin/electrs /bin/electrs

ADD config.toml /etc/electrs/config.toml
ADD entrypoint.sh entrypoint.sh
RUN chmod a+x entrypoint.sh

# Electrum and bitcoind RPC
EXPOSE 50001 18021 19021 19121

STOPSIGNAL SIGINT

ENTRYPOINT ["electrs"]