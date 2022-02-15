FROM debian:bullseye-slim as builder

WORKDIR /root
RUN apt-get update \
    &&  apt-get install -y clang cmake build-essential git cargo librocksdb-dev=6.11.4-3

ENV ROCKSDB_INCLUDE_DIR=/usr/include
ENV ROCKSDB_LIB_DIR=/usr/lib
RUN git clone --depth 1 --branch v0.9.5 https://github.com/romanz/electrs \
    && cd electrs \
    && cargo install --verbose --locked --path /root/electrs

FROM ghcr.io/vdovhanych/bitcoind-regtest:latest

COPY --from=builder /root/.cargo/bin/electrs /root
COPY --from=builder /root/.cargo/bin/electrs /usr/bin/electrs

RUN chmod a+rx /root
RUN chmod a+rx /root/electrs

EXPOSE 18021 60401 50001

ADD entrypoint.sh /root/entrypoint.sh
RUN chmod a+x /root/entrypoint.sh

CMD ["/root/entrypoint.sh"]
