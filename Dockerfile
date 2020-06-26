FROM tensorflow/tensorflow:latest-gpu
WORKDIR /code

RUN pip install Cython contextlib2 pillow lxml jupyter matplotlib tf_slim --no-cache-dir

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/tensorflow/models.git

WORKDIR /tensorflow/models/research/

RUN apt-get install -y wget \
&& wget -O protobuf.zip https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip \
&& unzip protobuf.zip \
&& ./bin/protoc object_detection/protos/*.proto --python_out=.


ADD . /CodeML.py/

CMD python3 CodeML.py

