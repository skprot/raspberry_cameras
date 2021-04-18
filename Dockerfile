#!/usr/bin/env bash

FROM skprot/picamera_ros_kinetic:master

ENV READTHEDOCS True
ENV CATKIN_WS=/root/catkin_ws

RUN mkdir -p $CATKIN_WS/src && \
	mkdir $CATKIN_WS/src/raspi_camera && \
	mkdir $CATKIN_WS/src/raspi_camera/launch

COPY ros_package_files/ $CATKIN_WS/src/raspi_camera
COPY launch_file/ $CATKIN_WS/src/raspi_camera/launch
COPY scripts/ $CATKIN_WS/src/raspi_camera
COPY rosrun.sh .


RUN rm /bin/sh && \
	ln -s /bin/bash /bin/sh
RUN source /opt/ros/kinetic/setup.bash && \
	cd $CATKIN_WS/src && \
	catkin_init_workspace && \
	cd $CATKIN_WS && \
	catkin_make && \
	source $CATKIN_WS/devel/setup.bash && \
	echo "source $CATKIN_WS/devel/setup.bash" >> ~/.bashrc && \
	chmod +x $CATKIN_WS/src/raspi_camera/main.py

CMD ["/bin/bash", "/rosrun.sh"]