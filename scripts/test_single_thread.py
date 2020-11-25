from picamera.array import PiRGBArray
from picamera import PiCamera
from time import time
from time import sleep
import cv2

num_frames = 0
current_time = time()
camera = PiCamera()
rawCapture = PiRGBArray(camera, size=(640, 480))

sleep(0.1)
while time() - current_time < 60:
    camera.capture(rawCapture, format="bgr")
    image = rawCapture.array

    cv2.imshow("Image", image)
    key = cv2.waitKey(0) & 0xFF

    num_frames += 1

print(num_frames / (time() - current_time))