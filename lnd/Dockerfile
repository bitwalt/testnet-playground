FROM golang:1.18-alpine as builder

# Force Go to use the cgo based DNS resolver. This is required to ensure DNS
# queries required to connect to linked containers succeed.
ENV GODEBUG netdns=cgo

# Pass a tag, branch or a commit using build-arg.  This allows a docker
# image to be built from a specified Git state.  The default image
# will use the Git tip of master by default.
ARG checkout="master"
ARG git_url="https://github.com/lightningnetwork/lnd"

# Install dependencies and build the binaries.
RUN apk add --no-cache --update alpine-sdk \
    git \
    make \
    gcc \
&&  git clone $git_url /go/src/github.com/lightningnetwork/lnd \
&&  cd /go/src/github.com/lightningnetwork/lnd \
&&  git checkout $checkout \
&&  make release-install

# Start a new, final image.
FROM ubuntu as final

# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -qq && apt-get install -yqq \
		curl unzip jq bash-completion \
    	ca-certificates gnupg make
    
# Copy the binaries from the builder image.
COPY --from=builder /go/bin/lncli /bin/
COPY --from=builder /go/bin/lnd /bin/
COPY --from=builder /go/src/github.com/lightningnetwork/lnd/scripts/verify-install.sh /
COPY --from=builder /go/src/github.com/lightningnetwork/lnd/scripts/keys/* /keys/

# Store the SHA256 hash of the binaries that were just produced for later
# verification.
RUN sha256sum /bin/lnd /bin/lncli > /shasums.txt \
  && cat /shasums.txt

#- - - - - - -

# Create group and user for LND
RUN groupadd -r lnd \
&&  useradd -r -g lnd lnd \
&&  mkdir -p /home/lnd/.lnd \
&&  chown -R lnd:lnd /home/lnd

# Copy scripts and configuration files
COPY lnd.conf /home/lnd/.lnd/
COPY bashrc /home/lnd/.bashrc
RUN . /home/lnd/.bashrc
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh	


USER lnd
WORKDIR /home/lnd


# Expose lnd ports (p2p, rpc).
EXPOSE 9735 10009

# ENTRYPOINT [ "/entrypoint.sh" ]	

CMD ["tail", "-f", "/dev/null"]
