from threading import Thread
from picamera.array import PiRGBArray
from picamera import PiCamera


class PiCameraThread:
    def __init__(self, resolution=(640, 480), framerate=90):
        self.cam = PiCamera(resolution=resolution, framerate=framerate)
        self.rawCapture = PiRGBArray(self.cam, size=resolution)
        self.stream = self.cam.capture_continuous(self.rawCapture, format="bgr", use_video_port=True)
        self.stop_status = False
        self.frame = None

    def capture(self):
        Thread(target=self.update).start()

        return self

    def update(self):

        for f in self.stream:
            self.frame = f.array
            self.rawCapture.truncate(0)

            if self.stop_status:
                self.stream.close()
                self.rawCapture.close()
                self.cam.close()

                return

    def get_frame(self):

        return self.frame

    def stop(self):

        self.stop_status = True
