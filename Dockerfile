#!/usr/bin/env bash

FROM duckietown/rpi-duckiebot-base:master18

ENV READTHEDOCS True
ENV CATKIN_WS=/root/catkin_ws

COPY requirements.txt .
RUN apt-get --yes update && \
 	sudo apt --yes dist-upgrade && \
	sudo apt-get --yes install ros-kinetic-multimaster-fkie && \
	sudo apt-get --yes install ros-kinetic-cv-bridge && \
	pip install --upgrade picamera==1.13

RUN mkdir -p $CATKIN_WS/src && \
	mkdir $CATKIN_WS/src/raspi_camera && \
	mkdir $CATKIN_WS/src/raspi_camera/launch

COPY ros_package_files/ $CATKIN_WS/src/raspi_camera
COPY launch_file/ $CATKIN_WS/src/raspi_camera/launch
COPY scripts/ $CATKIN_WS/src/raspi_camera

RUN rm /bin/sh && \
	ln -s /bin/bash /bin/sh
RUN source /opt/ros/melodic/setup.bash && \
	cd $CATKIN_WS/src && \
	catkin_init_workspace && \
	cd $CATKIN_WS && \
	catkin_make && \
	source $CATKIN_WS/devel/setup.bash && \
	echo "source $CATKIN_WS/devel/setup.bash" >> ~/.bashrc && \
	chmod +x $CATKIN_WS/src/raspi_camera/main.py
