FROM debian:bullseye-slim as builder

WORKDIR /root

ENV BITCOIN_REPO=https://github.com/bitcoin/bitcoin.git
ENV BITCOIN_BRANCH=master
ENV BITCOIN_TAG=v22.0

RUN apt-get update && \
    apt-get install git build-essential libtool autotools-dev automake pkg-config \
    bsdmainutils python3 -y && \
    apt-get install libevent-dev libboost-system-dev libboost-filesystem-dev libboost-test-dev \
    libboost-thread-dev libdb-dev libdb++-dev -y && \
    apt-get install libsqlite3-dev && \
    git clone $BITCOIN_REPO --branch $BITCOIN_BRANCH --single-branch

RUN (cd bitcoin && git fetch --all --tags --prune && git checkout tags/$BITCOIN_TAG && \
      ./autogen.sh && \
      ./configure --disable-tests \
      --disable-bench --disable-static  \
      --without-gui --disable-zmq \
      --with-incompatible-bdb \
      CFLAGS='-w' CXXFLAGS='-w' && \
      make -j 4 && \
      strip src/bitcoind && \
      strip src/bitcoin-cli && \
      strip src/bitcoin-tx )

FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y libevent-dev libboost-system-dev libboost-filesystem-dev \
    libboost-thread-dev libdb-dev libdb++-dev curl build-essential librocksdb-dev=6.11.4-3

ENV ROCKSDB_INCLUDE_DIR=/usr/include
ENV ROCKSDB_LIB_DIR=/usr/lib

COPY --from=builder /root/bitcoin/src/bitcoind /usr/bin/
COPY --from=builder /root/bitcoin/src/bitcoin-cli /usr/bin/
COPY --from=builder /root/bitcoin/src/bitcoin-tx /usr/bin/

EXPOSE 18021

ADD entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

CMD ["/root/entrypoint.sh"]
