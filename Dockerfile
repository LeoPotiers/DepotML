FROM tensorflow/tensorflow:latest-gpu
WORKDIR /tensorflow

RUN pip install protobuf-compiler Cython contextlib2 pillow lxml jupyter matplotlib tf_slim --no-cache-dir

ADD https://github.com/tensorflow/models/archive/master.zip /
RUN unzip /master.zip

WORKDIR /tensorflow/models-master/research/

ADD https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip /
RUN unzip /protoc-3.0.0-linux-x86_64.zip
RUN ./bin/protoc object_detection/protos/*.proto --python_out=.


ADD . .
CMD export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim


CMD python3 setup.py build
CMD python3 setup.py install

WORKDIR /tensorflow/models-master/research/


CMD python3 CodeML.py




