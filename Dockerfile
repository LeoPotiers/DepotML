
FROM tensorflow/tensorflow:latest-gpu
WORKDIR /code

RUN pip install Cython contextlib2 pillow lxml jupyter matplotlib tf_slim --no-cache-dir

ADD https://github.com/tensorflow/models/archive/master.zip /
RUN unzip /master.zip

WORKDIR /tensorflow/models/research/

ADD https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip /
RUN unzip /protoc-3.0.0-linux-x86_64.zip \
&& ./bin/protoc /code/models/research/object_detection/protos/*.proto --python_out=.


ADD . .

CMD python3 CodeML.py

