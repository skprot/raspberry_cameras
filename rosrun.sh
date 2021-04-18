#!/bin/bash

echo "RUNNING ROS CAMERA NODE!"
bash /ros_entrypoint.sh
source /root/catkin_ws/devel/setup.bash
roslaunch /root/catkin_ws/src/raspi_camera/launch/raspi_camera.launch
