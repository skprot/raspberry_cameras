#!/usr/bin/env python

import sys
sys.path.append('/usr/lib/python2.7/dist-packages')

import rospy
import argparse

from cv_bridge import CvBridge

from time import time
from picamerathread import PiVideoStream

from std_msgs.msg import String
from std_msgs.msg import Float32
from std_msgs.msg import Bool
from sensor_msgs.msg import Image


class DatasetCollector:
    def __init__(self, rpi_num):
        self.rpi_num = rpi_num
        self.node = rospy.init_node('camera_{}'.format(self.rpi_num), anonymous=True)
        self.start_status = None
        self.timer = None
        self.resolution = (432, 240)

        self.brige = CvBridge()
        self.time_publisher = rospy.Publisher('/cameras/time_{}'.format(self.rpi_num), Float32, queue_size=10)
        self.image_publisher = rospy.Publisher('/cameras/images_{}'.format(self.rpi_num), Image, queue_size=10)

        rospy.Subscriber('/cameras/start_status', Bool, self.start_status_callback, queue_size=1)
        rospy.Subscriber('/cameras/args', String, self.args_callback, queue_size=1)

        self.frame_grabber = PiVideoStream(self.resolution).start()
        self.timer_status = False
        self.current_time = None
        self.run()

    def start_status_callback(self, data):
        self.start_status = data.data

    def args_callback(self, data):
        self.resolution = data.data

    def run(self):
        self.start_status = False

        while not rospy.is_shutdown():
            frame, next_frame_index = self.frame_grabber.read()
            
            if self.start_status:

                if not self.timer_status:
                    self.start_timer()

                self.image_publisher.publish(self.bridge.cv2_to_imgmsg(frame, "bgr8"))
                self.time_publisher.publish(time() - self.current_time)

    def start_timer(self):
        self.current_time = time()
        self.timer_status = True


if __name__ == '__main__':
    try:
        DatasetCollector(1)
    except rospy.ROSInterruptException:
        pass

    rospy.spin()
