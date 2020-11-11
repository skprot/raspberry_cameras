from threading import Thread
from picamera.array import PiRGBArray
from picamera import PiCamera
from time import time


class PiCameraThread:
    def __init__(self, resolution=(640, 480), framerate=90, show_fps=True):
        self.cam = PiCamera(resolution=resolution, framerate=framerate)
        self.rawCapture = PiRGBArray(self.cam, size=resolution)
        self.stream = self.cam.capture_continuous(self.rawCapture, format="bgr", use_video_port=True)
        self.stop_status = False
        self.frame = None
        self.show_fps = show_fps

    def capture(self):
        Thread(target=self.update).start()

        return self

    def update(self):

        for f in self.stream:
            fps_time = time()
            self.frame = f.array
            self.rawCapture.truncate(0)

            if self.show_fps:
                print("fps:  ", 1 / (time() - fps_time))

            if self.stop_status:
                self.stream.close()
                self.rawCapture.close()
                self.cam.close()

                return

    def get_frame(self):

        return self.frame

    def stop(self):

        self.stop_status = True
