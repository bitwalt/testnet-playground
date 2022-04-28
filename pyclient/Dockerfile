FROM python:3.9

WORKDIR /home/pyclient

COPY conf/requirements.txt .
RUN pip3 install -r requirements.txt

RUN git clone https://github.com/googleapis/googleapis.git

# Get lnd lightning.proto file 
RUN curl -o lightning.proto -s https://raw.githubusercontent.com/lightningnetwork/lnd/master/lnrpc/lightning.proto
# Compile proto file
RUN python -m grpc_tools.protoc --proto_path=googleapis:. --python_out=. --grpc_python_out=. lightning.proto

EXPOSE 8888

CMD ["tail", "-f", "/dev/null"]