ARG OS=ubuntu
ARG OS_VER=focal
ARG GO_VER=1.13
# Define base images with ARG versions
FROM ${OS}:${OS_VER} as os
FROM golang:${GO_VER} as go

# OS image with command-line utilities
FROM os AS os-base

# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -qq && apt-get install -yqq \
		curl unzip jq bash-completion

# Go image for building LND
FROM go as lnd-build

ENV GO_VER=${GO_VER}
ENV GOPATH=/go

# Build LND
ARG LND_VER=v0.13.1-beta
ENV LND_VER=${LND_VER}
RUN	mkdir -p ${GOPATH}/src && \
	cd ${GOPATH}/src && \
	go get -v -d github.com/lightningnetwork/lnd && \
	cd ${GOPATH}/src/github.com/lightningnetwork/lnd && \
	git checkout tags/${LND_VER} && \
	make clean && make && make install

# Runtime image for running LND
FROM os-base as lnd-run

# Copy only the executables
COPY --from=lnd-build /go/bin /go/bin

ADD https://raw.githubusercontent.com/lightningnetwork/lnd/master/contrib/lncli.bash-completion \
	   /usr/share/bash-completion/completions/lncli


RUN apt-get update  -y \
&&  apt-get install -y expect xxd jq


#- - - - - - -
# Copy scripts and configuration files

RUN mkdir -p /home/lnd/.lnd
RUN mkdir -p /home/lnd/share

COPY lnd/lnd.conf /home/lnd/.lnd/.
COPY bashrc /root/.bashrc
RUN . /root/.bashrc
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh	

# Create group and user for LND
RUN groupadd -r lnd \
&&  useradd -r -g lnd lnd \
&&  mkdir -p /home/lnd/.lnd \
&&  chown -R lnd:lnd /home/lnd

USER lnd
WORKDIR /home/lnd

# Expose lnd ports (p2p, rpc).
EXPOSE 9735 10009

# ENTRYPOINT [ "/entrypoint.sh" ]	

CMD ["tail", "-f", "/dev/null"]
