FROM python:3.10-bullseye

ENV PYTHONUNBUFFERED=1
# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
git make curl wget nano \
&& apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home pyclient

# Install python requirements
COPY requirements.txt .
RUN python -m pip install --upgrade pip
RUN pip install -r requirements.txt
ENV PATH="/home/pyclient/.local/bin:$PATH"

# Install gRPC lnd
RUN mkdir -p /home/pyclient/code/grpc_lnd
WORKDIR /home/pyclient/code/
# Get lnd lightning.proto file 
RUN wget https://raw.githubusercontent.com/lightningnetwork/lnd/master/lnrpc/lightning.proto
RUN mv lightning.proto grpc_lnd
# Compile proto file
RUN python3 -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. grpc_lnd/lightning.proto
RUN mv grpc_lnd ..

COPY .bashrc /home/pyclient/.bashrc

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh	

EXPOSE 8888 8889
ENTRYPOINT [ "/entrypoint.sh",  "--jupyter_port", "$JUPYTER_PORT"]

USER pyclient

CMD ["tail", "-f", "/dev/null"]