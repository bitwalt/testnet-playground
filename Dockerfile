# bitcoin-testnet-box docker image

FROM ubuntu
LABEL maintainer="Sean Lavine <lavis88@gmail.com>"

# install make
RUN apt-get update && \
	apt-get install --yes make wget

# create a non-root user
RUN adduser --disabled-login --gecos "" tester

# run following commands from user's home directory
WORKDIR /home/tester

# ENV BITCOIN_CORE_VERSION "0.21.0"
ENV BITCOIN_CORE_VERSION "22.0"
# Define chip architecture x86: x86_64-linux-gnu, ARM 32bit: arm-linux-gnueabihf, ARM 64bit : aarch64-linux-gnu
ENV ARCH "aarch64-linux-gnu"


# download and install bitcoin binaries
RUN mkdir tmp \
	&& cd tmp \
	&& wget "https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_CORE_VERSION}/bitcoin-${BITCOIN_CORE_VERSION}-${ARCH}.tar.gz" \
	&& tar xzf "bitcoin-${BITCOIN_CORE_VERSION}-${ARCH}.tar.gz" \
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

# expose two rpc ports for the nodes to allow outside container access
EXPOSE 19001 19011 18333 18332

CMD ["/bin/bash"]
