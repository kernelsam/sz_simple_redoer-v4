# docker build -t brian/sz_simple_redoer .
# docker run --user $UID -it -v $PWD:/data -e SENZING_ENGINE_CONFIGURATION_JSON brian/sz_simple_redoer

ARG BASE_IMAGE="senzing/senzingsdk-runtime:latest"
FROM ${BASE_IMAGE}
ARG BASE_IMAGE
RUN echo $BASE_IMAGE

LABEL Name="brain/sz_simple_redoer" \
      Maintainer="brianmacy@gmail.com" \
      Version="DEV"

USER root

RUN apt-get update \
 && apt-get -y install curl python3 python3-pip python3-psycopg2 \
 && python3 -mpip install --break-system-packages orjson \
 && apt-get -y remove build-essential python3-pip \
 && apt-get -y autoremove \
 && apt-get -y clean

COPY sz_simple_redoer.py /app/

ENV PYTHONPATH=/opt/senzing/er/sdk/python:/app

USER 1001

WORKDIR /app
ENTRYPOINT ["/app/sz_simple_redoer.py"]

