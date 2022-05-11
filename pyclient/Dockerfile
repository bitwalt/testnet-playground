FROM ubuntu

ENV DEBCONF_NOWARNINGS yes
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update --fix-missing -y \
&&  apt-get upgrade -y

RUN apt-get install -y \
    python3.9     \
    python3-pip   \
    git curl \ 
&&  apt-get clean \
&&  rm -rf /var/lib/apt/lists/*

RUN groupadd -r pyclient &&  useradd -r -s /sbin/nologin -g pyclient pyclient 
# USER pyclient
WORKDIR /home/pyclient
ENV PATH $PATH:/home/pyclient/.local/bin

COPY conf/requirements.txt /home/pyclient
RUN pip3 install -r requirements.txt

RUN git clone https://github.com/googleapis/googleapis.git

# Get lnd lightning.proto file 
RUN curl -o lightning.proto -s https://raw.githubusercontent.com/lightningnetwork/lnd/master/lnrpc/lightning.proto
# Compile proto file
# RUN mkdir  /home/pyclient/lnd-gprc && cd /home/pyclient/lnd-gprc 
RUN python3 -m grpc_tools.protoc --proto_path=googleapis:. --python_out=. --grpc_python_out=. lightning.proto

EXPOSE 8888

# WORKDIR /home/pyclient
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["tail", "-f", "/dev/null"]