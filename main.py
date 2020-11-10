from time import time
from picamerathread import PiCameraThread
import argparse
import cv2


if __name__ == '__main__':
    parser = argparse.ArgumentParser(prog='main.py', description='Arguments for work with raspi camera')
    parser.add_argument('-t', '--time', type=float, default=None, help='Working time in seconds (default: 60)')
    parser.add_argument('-o', '--output', type=str, default=None, help='Output images folder (default: None)')
    parser.add_argument('-so', '--screen_output', type=bool, default=False, help='Output images on screen (default: False)')
    parser.add_argument('--silent', type=bool, default=False, help='Without output fps (default=False)')
    parser.add_argument('--resolution', type=int, default=640, help='Output resolution. Write 1080, 720 or 640 (default=640)')
    args = parser.parse_args()

    if args.resolution == 640:
        resolution = (640, 480)
    elif args.resolution == 720:
        resolution = (1280, 720)
    elif args.resolution == 1080:
        resolution = (1920, 1080)
    else:
        resolution = (640, 480)

    frame_grabber = PiCameraThread(resolution=resolution)
    frame_grabber.capture()

    if args.time:
        print('Run camera for {} seconds'.format(args.time))
        num_frames = 0
        current_time = time()

        while time() - current_time < args.time:
            fps_time = time()
            frame = frame_grabber.get_frame()

            if args.screen_output:
                cv2.imshow('Pi Cam', frame)

            if args.output:
                cv2.imwrite('{0}/{1}.jpg'.format(args.output, num_frames), frame)

            if not args.silent:
                print('Frame fps:       ', time() - fps_time)

            num_frames += 1

    cv2.destroyAllWindows()
    frame_grabber.stop()



