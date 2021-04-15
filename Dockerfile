#!/usr/bin/env bash

FROM arm32v7/ros:melodic-ros-base-bionic

ENV CATKIN_WS=/root/catkin_ws

COPY requirements.txt .
RUN apt-get --yes update && \
 	sudo apt --yes dist-upgrade && \
	sudo apt --yes install curl && \
	sudo apt --yes install software-properties-common && \
	sudo apt-get --yes install ros-melodic-multimaster-fkie && \
	sudo apt-get --yes install ros-melodic-cv-bridge && \
	sudo apt-get --yes install python-pip && \
	pip install --upgrade pip

RUN sudo bash -c "echo 'start_x=1' >> /boot/config.txt" && \
	sudo bash -c "echo 'gpu_mem=128' >> /boot/config.txt" && \
	#curl -L --output /usr/bin/rpi-update https://raw.githubusercontent.com/Hexxeh/rpi-update/master/rpi-update && \
 	#chmod +x /usr/bin/rpi-update && \
	#sudo apt-get --yes install kmod && \
	#sudo SKIP_WARNING=1 SKIP_SDK=1 rpi-update && \
	#sudo add-apt-repository ppa:ubuntu-raspi2/ppa && \
	#sudo apt-get --yes install libraspberrypi-bin libraspberrypi-dev && \
	git clone https://github.com/raspberrypi/userland && \
    cd userland && \
    ./buildme && \
    cd .. && \
    rm -rf /root/userland && \
    export path ${PATH}:/opt/vc/bin && \
	pip install git+https://github.com/waveform80/picamera && \
	pip install git+https://github.com/waveform80/colorzero && \
	pip install -r requirements.txt

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
