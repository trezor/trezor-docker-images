FROM debian:bullseye-slim as builder

WORKDIR /root
RUN apt-get update \
    &&  apt-get install -y clang cmake build-essential git cargo
    
RUN git clone https://github.com/romanz/electrs \ 
    && cd electrs \ 
    && cargo build --locked --release

FROM ghcr.io/vdovhanych/bitcoind-regtest:latest

COPY --from=builder /root/.cargo/bin/electrs /root

RUN chmod a+rx /root
RUN chmod a+rx /root/electrs

EXPOSE 18021 60401

ADD config.toml /etc/electrs/config.toml
ADD entrypoint.sh /root/entrypoint.sh
RUN chmod a+x /root/entrypoint.sh

CMD ["/root/entrypoint.sh"]