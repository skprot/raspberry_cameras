#!/bin/bash

echo "RUNNING ROS CAMERA NODE!"
bash /ros_entrypoint.sh
rosrun /root/catkin_ws/src/raspi_camera/launch/raspi_camera.launch