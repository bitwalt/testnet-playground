FROM python:3.10-bullseye

ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install --no-install-recommends -y \
git make curl wget nano \
&& apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home pyclient

# install requirements
COPY conf/requirements.txt .
RUN python -m pip install --upgrade pip
RUN pip install -r requirements.txt

RUN mkdir /home/pyclient/code
WORKDIR /home/pyclient/code
ENV PATH="/home/pyclient/.local/bin:$PATH"

# Get lnd lightning.proto file 
RUN wget https://raw.githubusercontent.com/lightningnetwork/lnd/master/lnrpc/lightning.proto

RUN git clone https://github.com/googleapis/googleapis.git
# Compile proto file
RUN python3 -m grpc_tools.protoc --proto_path=googleapis:. --python_out=. --grpc_python_out=. lightning.proto

# COPY code .
COPY .bashrc /home/pyclient/.bashrc

# COPY entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh	

EXPOSE 8888 8889

# ENTRYPOINT [ "/entrypoint.sh",  "--jupyter_port", "$JUPYTER_PORT"]
CMD ["jupyter", "notebook", "--no-browser", "--ip=0.0.0.0", "--port=8889", "--allow-root"]
# CMD ["tail", "-f", "/dev/null"]