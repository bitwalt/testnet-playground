FROM ubuntu

RUN apt-get update && \
	apt-get install --yes make wget

ARG BITCOIN_CORE_VERSION
ARG ARCH

# download and install bitcoin binaries
RUN wget "https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_CORE_VERSION}/bitcoin-${BITCOIN_CORE_VERSION}-${ARCH}-linux-gnu.tar.gz" \
	&& tar xzf "bitcoin-${BITCOIN_CORE_VERSION}-${ARCH}-linux-gnu.tar.gz" \
	&& rm -f "bitcoin-${BITCOIN_CORE_VERSION}-${ARCH}-linux-gnu.tar.gz" \
	&&  mv /bitcoin-${BITCOIN_CORE_VERSION} /usr/local/bin/bitcoin

# add user and group for bitcoin
RUN groupadd -r bitcoin &&  useradd -r -s /sbin/nologin -g bitcoin bitcoin 
# copy files into the image
ADD . /home/bitcoin

RUN chown -R bitcoin:bitcoin /home/bitcoin

# bash completion for bitcoind and bitcoin-cli
ENV GH_URL https://raw.githubusercontent.com/bitcoin/bitcoin/master/
ENV BC /usr/share/bash-completion/completions/
ADD $GH_URL/contrib/bitcoin-cli.bash-completion $BC/bitcoin-cli
ADD $GH_URL/contrib/bitcoind.bash-completion $BC/bitcoind
ADD $GH_URL/contrib/bitcoin-tx.bash-completion $BC/bitcoin-tx

ENV PATH $PATH:/usr/local/bin/bitcoin/bin
EXPOSE 18333 18332 28332 28333
# COPY create_bitcoin_conf.sh /create_bitcoin_conf.sh
# RUN chmod +x /create_bitcoin_conf.sh
# RUN bash create_bitcoin_conf.sh
# ENTRYPOINT [ "/create_bitcoin_conf.sh" ]	

# COPY entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh	
# ENTRYPOINT [ "/entrypoint.sh" ]	

USER bitcoin
WORKDIR /home/bitcoin

# CMD ["tail", "-f", "/dev/null"]
# CMD ["/usr/bin/bash/"]
