ARG VERSION=v0.9.1

FROM rust:1.41.1-slim AS builder

ARG VERSION

WORKDIR /build

RUN apt-get update
RUN apt-get install -y git clang cmake libsnappy-dev wget

RUN git clone --branch $VERSION https://github.com/romanz/electrs .

RUN cargo install --locked --path .

FROM debian:buster-slim

RUN useradd -rG sudo electrs
USER electrs

WORKDIR /data
COPY --from=builder /usr/local/cargo/bin/electrs /bin/electrs

COPY config.toml /etc/electrs/config.toml
COPY entrypoint.sh entrypoint.sh
RUN chmod a+x entrypoint.sh

# Electrum port
EXPOSE 50001 

STOPSIGNAL SIGINT

ENTRYPOINT ["electrs"]