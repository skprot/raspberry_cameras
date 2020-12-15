#!/usr/bin/env bash

#FROM sixsq/opencv-python:master-arm
FROM arm32v7/ros:melodic-ros-base-bionic

ENV CATKIN_WS=/root/catkin_ws
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN source /opt/ros/melodic/setup.bash && mkdir -p $CATKIN_WS/src && cd $CATKIN_WS/src && catkin_init_workspace && cd $CATKIN_WS && catkin_make && source $CATKIN_WS/devel/setup.bash
RUN mkdir $CATKIN_WS/src/raspi_camera
RUN mkdir $CATKIN_WS/src/raspi_camera/launch

#WORKDIR /tmp
COPY requirements.txt .

#RUN apt-get -q update && apt-get -y install libraspberrypi-bin && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN apt-get -q update
RUN apt-get --yes install python-pip
RUN pip install --upgrade pip

RUN sudo bash -c "echo 'start_x=1' >> /boot/config.txt"
RUN sudo bash -c "echo 'gpu_mem=128' >> /boot/config.txt"
RUN curl -L --output /usr/bin/rpi-update https://raw.githubusercontent.com/Hexxeh/rpi-update/master/rpi-update && chmod +x /usr/bin/rpi-update
RUN sudo rpi-update
RUN sudo add-apt-repository ppa:ubuntu-raspi2/ppa
RUN sudo apt-get install libraspberrypi-bin libraspberrypi-dev
RUN echo 'SUBSYSTEM==\"vchiq\",GROUP=\"video\",MODE=\"0660\"' > /etc/udev/rules.d/10-vchiq-permissions.rules && usermod -a -G video ubuntu

RUN pip install -r requirements.txt
RUN apt-get install ros-melodic-multimaster-fkie

COPY ros_package_files/ $CATKIN_WS/src/raspi_camera
COPY launch_file/ $CATKIN_WS/src/raspi_camera/launch
COPY scripts/ $CATKIN_WS/src/raspi_camera

RUN cd $CATKIN_WS/
CMD ["roslaunch", "raspi_camera.launch"]

#CMD ["python3", "./test.py"]
##USE --add-host ex: host2.test.com:192.168.0.2. It will add new hosts to /etc/hosts

#TODO: EXEC FORMAT ERROR