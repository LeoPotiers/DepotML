FROM tensorflow/tensorflow:latest-gpu
WORKDIR /tensorflow

RUN pip install protobuf-compiler Cython contextlib2 pillow lxml jupyter matplotlib tf_sl$

ADD https://github.com/tensorflow/models/archive/master.zip /
RUN unzip /master.zip

ADD https://github.com/LeoPotiers/DepotML/zipball/master /

WORKDIR /tensorflow/models-master/research/

ADD https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64$
RUN unzip /protoc-3.0.0-linux-x86_64.zip
RUN ./bin/protoc object_detection/protos/*.proto --python_out=.


ADD . .
#CMD export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim
#CMD python3 import sys \
#&& sys.path.append('/tensorflow/models-master/research/slim')
ENV PYTHONPATH "${PYTHONPATH}:/tensorflow/models-master/research/slim"

WORKDIR /tensorflow/models-master/research/

RUN python3 setup.py build
RUN python3 setup.py install

CMD python3 CodeML2.py






