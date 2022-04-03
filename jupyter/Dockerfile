FROM jupyter/minimal-notebook:latest

# RUN groupadd jupyter &&  useradd -g jupyter jupyter -m -s /bin/bash 
# USER jupyter
# WORKDIR /home/jupyter

COPY conf/requirements.txt .
RUN pip3 install -r requirements.txt

EXPOSE 8888

CMD ["tail", "-f", "/dev/null"]
