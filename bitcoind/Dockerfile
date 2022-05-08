FROM ubuntu

# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -qq && apt-get install -yqq \
		curl unzip jq bash-completion make wget

ARG BITCOIN_CORE_VERSION
ARG ARCH

# download and install bitcoin binaries
RUN wget "https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_CORE_VERSION}/bitcoin-${BITCOIN_CORE_VERSION}-${ARCH}-linux-gnu.tar.gz" \
	&& tar xzf "bitcoin-${BITCOIN_CORE_VERSION}-${ARCH}-linux-gnu.tar.gz" \
	&& rm -f "bitcoin-${BITCOIN_CORE_VERSION}-${ARCH}-linux-gnu.tar.gz" \
	&&  mv /bitcoin-${BITCOIN_CORE_VERSION} /usr/local/bin/bitcoin

# add user and group for bitcoin
RUN groupadd -r bitcoin &&  useradd -r -s /sbin/nologin -g bitcoin bitcoin 
# RUN chown -R bitcoin:bitcoin /home/bitcoin


# bash completion for bitcoind and bitcoin-cli
ENV GH_URL https://raw.githubusercontent.com/bitcoin/bitcoin/master/
ENV BC /usr/share/bash-completion/completions/
ADD $GH_URL/contrib/bitcoin-cli.bash-completion $BC/bitcoin-cli
ADD $GH_URL/contrib/bitcoind.bash-completion $BC/bitcoind
ADD $GH_URL/contrib/bitcoin-tx.bash-completion $BC/bitcoin-tx

ENV PATH $PATH:/usr/local/bin/bitcoin/bin
EXPOSE 18333 18332 28332 28333

# Copy bitcoind configuration directory
COPY bitcoin.conf /home/bitcoin/testnet/bitcoin.conf
# Copy support scripts
COPY .bashrc /root/.bashrc
COPY entrypoint.sh /entrypoint.sh
COPY scripts/mine.sh /mine.sh

RUN chmod +x /entrypoint.sh	
RUN chmod +x /mine.sh	

USER bitcoin
WORKDIR /home/bitcoin

ENTRYPOINT [ "/entrypoint.sh",  "--network", "$BITCOIN_NETWORK" ]	
CMD ["tail", "-f", "/dev/null"]
