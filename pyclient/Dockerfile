FROM ubuntu

ENV DEBCONF_NOWARNINGS yes
ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get update --fix-missing -y \
&&  apt-get upgrade -y

RUN apt-get install -y \
    python3.9  python3-pip   \
    git curl \ 
    &&  apt-get clean \
    &&  rm -rf /var/lib/apt/lists/*

RUN groupadd -r pyclient &&  useradd -r -s /sbin/nologin -g pyclient pyclient 
ENV PATH $PATH:/home/pyclient/.local/bin
WORKDIR /home/pyclient

RUN git clone https://github.com/googleapis/googleapis.git
COPY data/requirements.txt /home/pyclient
RUN pip3 install -r requirements.txt
COPY .bashrc /home/pyclient/

# Get lnd lightning.proto file 
RUN curl -o lightning.proto -s https://raw.githubusercontent.com/lightningnetwork/lnd/master/lnrpc/lightning.proto
# Compile proto file
RUN python3 -m grpc_tools.protoc --proto_path=googleapis:. --python_out=. --grpc_python_out=. lightning.proto

COPY data /home/pyclient

EXPOSE 8888

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root"]