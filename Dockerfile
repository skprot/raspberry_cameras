#FROM sixsq/opencv-python:master-arm
FROM arm64v8/ros:melodic-ros-base-stretch

ENV CATKIN_WS=/root/catkin_ws
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN source /opt/ros/melodic/setup.bash && mkdir -p $CATKIN_WS/src && cd $CATKIN_WS/src && catkin_init_workspace && cd $CATKIN_WS && catkin_make && source $CATKIN_WS/devel/setup.bash
RUN mkdir $CATKIN_WS/src/raspi_camera
RUN mkdir $CATKIN_WS/src/raspi_camera/launch

#WORKDIR /tmp
COPY requirements.txt .

RUN apt-get -q update && apt-get -y install libraspberrypi-bin && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --upgrade pip
RUN pip install -r ./requirements.txt

RUN apt-get install ros-melodic-multimaster-fkie


COPY ros_package_files/ $CATKIN_WS/src/raspi_camera
COPY launch_file/ $CATKIN_WS/src/raspi_camera/launch
COPY scripts/ $CATKIN_WS/src/raspi_camera

RUN cd $CATKIN_WS/
CMD ["roslaunch", "raspi_camera.launch"]

#CMD ["python3", "./test.py"]
##USE --add-host ex: host2.test.com:192.168.0.2. It will add new hosts to /etc/hosts