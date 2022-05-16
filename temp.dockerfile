FROM ubuntu:18.04
ENV PYTHONUNBUFFERED 1
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /opt/docker

RUN apt update && apt-get install -y lsb-release &&\
    echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
RUN apt install -y gnupg2 build-essential && apt install -y curl && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

RUN apt update && apt install -y ros-melodic-pcl-ros ros-melodic-velodyne-msgs

RUN apt-get install -y cmake libgoogle-glog-dev libgflags-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev
ENV CERES_VERSION 1.14.0
RUN apt install -y wget && wget -q http://ceres-solver.org/ceres-solver-$CERES_VERSION.tar.gz
RUN tar -xf ceres-solver-$CERES_VERSION.tar.gz
RUN mkdir ceres-bin && cd ceres-bin && cmake ../ceres-solver-$CERES_VERSION && make -j4 && make install

WORKDIR /opt/docker
RUN apt-get install -y git build-essential cmake python3-dev python3-setuptools python3-pytest python3-scipy python3-h5py libceres-dev && git clone https://github.com/strasdat/Sophus && cd Sophus && git checkout 00f3fd91c153ef04

WORKDIR /opt/docker/Sophus
RUN mkdir build && cd build && cmake ../ && make -j4 && make install
# RUN apt-get install ros-melodic-sophus
