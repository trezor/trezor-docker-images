FROM debian:buster-slim as builder

WORKDIR /root

# install electrs

RUN apt-get update && \
    apt-get install git build-essential libtool autotools-dev automake pkg-config \
    bsdmainutils python3 -y && \
    apt-get install -y wget software-properties-common apt-transport-https \
    libllvm10 clang-10 libclang-common-10-dev curl cargo
    

RUN cargo install --git https://github.com/romanz/electrs --tag v0.9.4 --bin electrs

FROM ghcr.io/vdovhanych/bitcoind-regtest:latest

COPY --from=builder /root/.cargo/bin/electrs /root

RUN chmod a+rx /root
RUN chmod a+rx /root/electrs

EXPOSE 18021 60401

ADD config.toml /etc/electrs/config.toml
ADD entrypoint.sh /root/entrypoint.sh
RUN chmod a+x /root/entrypoint.sh

CMD ["/root/entrypoint.sh"]