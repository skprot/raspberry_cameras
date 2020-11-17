from imutils.video.pivideostream import PiVideoStream
from imutils.video import FPS


class PiCameraThread:
    def __init__(self, resolution=(640, 480), framerate=90, show_fps=True):
        self.stop_status = False
        self.show_fps = show_fps
        self.resolution = resolution
        self.grabber = PiVideoStream(self.resolution).start()
        self.fps = FPS().start()


    def get_frame(self):
        self.frame = self.grabber.read()

        if self.show_fps == True:
            self.fps.update()

        return self.frame

    def stop(self):

        self.stop_status = True
        self.grabber.stop()
        self.fps.stop()

    def print_fps(self):

        print(self.fps.fps())