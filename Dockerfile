FROM ubuntu:18.04
ENV PYTHONUNBUFFERED 1
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /opt/docker
ADD install_deps.sh /opt/docker

RUN bash install_deps.sh

CMD /bin/bash
