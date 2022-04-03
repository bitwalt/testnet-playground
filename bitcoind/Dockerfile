# Based on https://raw.githubusercontent.com/freewil/bitcoin-testnet-box/master/Dockerfile
# bitcoin-testnet-box docker image

FROM ubuntu
LABEL maintainer="Walter Maffione <waltermaffy@gmail.com>"

# ENV BITCOIN_CORE_VERSION "22.0"
ARG BITCOIN_CORE_VERSION
# define CPU architecture
# x86: x86_64-linux-gnu, ARM 32bit: arm-linux-gnueabihf, ARM 64bit : aarch64-linux-gnu
# ENV ARCH "aarch64-linux-gnu"

ARG ARCH
# install make
RUN apt-get update && \
	apt-get install --yes make wget

# create a non-root user
RUN adduser --disabled-login --gecos "" tester

# run following commands from user's home directory
WORKDIR /home/tester

# download and install bitcoin binaries
RUN mkdir tmp \
	&& cd tmp \
	&& wget "https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_CORE_VERSION}/bitcoin-${BITCOIN_CORE_VERSION}-${ARCH}-linux-gnu.tar.gz" \
	&& tar xzf "bitcoin-${BITCOIN_CORE_VERSION}-${ARCH}-linux-gnu.tar.gz" \
	&& cd "bitcoin-${BITCOIN_CORE_VERSION}/bin" \
	&& install --mode 755 --target-directory /usr/local/bin *

# clean up
RUN rm -r tmp

# copy the testnet-box files into the image
ADD . /home/tester/bitcoin-testnet-box

# make tester user own the bitcoin-testnet-box
RUN chown -R tester:tester /home/tester/bitcoin-testnet-box

# color PS1
RUN mv /home/tester/bitcoin-testnet-box/.bashrc /home/tester/ && \
	cat /home/tester/.bashrc >> /etc/bash.bashrc

# use the tester user when running the image
USER tester

# run commands from inside the testnet-box directory
WORKDIR /home/tester/bitcoin-testnet-box

# expose rpc ports for the nodes to allow outside container access
EXPOSE 19001 19011 18333 18332 
# bitcoind P2P
EXPOSE 18444/tcp
# bitcoind regtest RPC
EXPOSE 18443/tcp
# zmqpubrawblock
EXPOSE 12005/tcp
# zmqpubrawtx
EXPOSE 12006/tcp

CMD ["/bin/bash"]
