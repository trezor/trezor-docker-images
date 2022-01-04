FROM debian:buster-slim as builder

WORKDIR /root
RUN apt-get update \
    &&  apt-get install -y git clang cmake build-essential libtool autotools-dev \ 
    automake pkg-config bsdmainutils python3 \
    && apt-get install -y wget software-properties-common cargo 
    
RUN cargo install --locked --release --git https://github.com/romanz/electrs --tag v0.9.4 --bin electrs

FROM ghcr.io/vdovhanych/bitcoind-regtest:latest

COPY --from=builder /root/.cargo/bin/electrs /root

RUN chmod a+rx /root
RUN chmod a+rx /root/electrs

EXPOSE 18021 60401

ADD config.toml /etc/electrs/config.toml
ADD entrypoint.sh /root/entrypoint.sh
RUN chmod a+x /root/entrypoint.sh

CMD ["/root/entrypoint.sh"]