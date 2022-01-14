FROM debian:bullseye-slim as builder

WORKDIR /root
RUN apt-get update \
    &&  apt-get install -y clang cmake build-essential git cargo

RUN git clone --depth 1 --branch v0.9.4 https://github.com/romanz/electrs \
    && cd electrs \
    && cargo install --path /root/electrs

RUN ls -la && ls -la electrs/ && ls -la electrs/.cargo/
FROM ghcr.io/vdovhanych/bitcoind-regtest:latest

COPY --from=builder /root/.cargo/bin/electrs /root

RUN chmod a+rx /root
RUN chmod a+rx /root/electrs

EXPOSE 18021 60401

ADD entrypoint.sh /root/entrypoint.sh
RUN chmod a+x /root/entrypoint.sh

CMD ["/root/entrypoint.sh"]
