#!/bin/bash

## Exit immediately if a command exits with a non-zero status.
set -e

cd /opt/docker
apt update
apt install -y lsb-release gnupg2 build-essential curl libglew-dev cmake libgoogle-glog-dev libgflags-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev wget git python3-dev python3-setuptools python3-pytest python3-scipy python3-h5py libceres-dev
echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list

curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

apt update

### https://answers.ros.org/question/248637/fatal-error-anglesanglesh-no-such-file-or-directory-include-anglesanglesh/
apt install -y ros-melodic-pcl-ros ros-melodic-velodyne-msgs ros-melodic-nav-msgs ros-melodic-angles python-wstool

cd /opt/docker

# version=2.1.0
version=1.14.0
wget http://ceres-solver.org/ceres-solver-$version.tar.gz

tar -xf ceres-solver-$version.tar.gz
mkdir ceres-bin
cd ceres-bin
cmake ../ceres-solver-$version
make -j4
# make test
make install

cd /opt/docker

git clone https://github.com/strasdat/Sophus
cd Sophus
git checkout 00f3fd91c153ef04


mkdir build && cd build

cmake ../

make -j4
make install

cd /opt/docker

git clone --recursive -j8 https://github.com/hovren/kontiki
cd kontiki/python/
python3 setup.py install

cd /opt/docker

source /opt/ros/melodic/setup.bash

git clone --recursive https://github.com/APRIL-ZJU/ndt_omp

cd ndt_omp

mkdir build ; cd build

cmake ..
make -j4

make install

cd /opt/docker

mkdir -p catkin_li_calib/src

cd catkin_li_calib/src

catkin_init_workspace

git clone https://github.com/APRIL-ZJU/lidar_IMU_calib


wstool init
wstool merge lidar_IMU_calib/depend_pack.rosinstall
wstool update

cd /opt/docker/catkin_li_calib/src/lidar_IMU_calib

./build_submodules.sh

cd ../../

### https://github.com/ethz-asl/lidar_align/issues/16
sudo mv /usr/include/flann/ext/lz4.h /usr/include/flann/ext/lz4.h.bak
sudo mv /usr/include/flann/ext/lz4hc.h /usr/include/flann/ext/lz4.h.bak
sudo ln -s /usr/include/lz4.h /usr/include/flann/ext/lz4.h
sudo ln -s /usr/include/lz4hc.h /usr/include/flann/ext/lz4hc.h
catkin_make

source ./devel/setup.bash

rm /opt/docker/install_deps.sh
