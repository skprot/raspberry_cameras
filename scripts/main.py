from time import time
from picamerathread import PiCameraThread
import argparse
import cv2


if __name__ == '__main__':
    parser = argparse.ArgumentParser(prog='main.py', description='Arguments for work with raspi camera')
    parser.add_argument('-t', '--time', type=float, default=None, help='Working time in seconds (default: 60)')
    parser.add_argument('-o', '--output', type=str, default=None, help='Output images folder (default: None)')
    parser.add_argument('--screen_output', default=False, action='store_true', help='Output images on screen (default: False)')
    parser.add_argument('--silent', default=False, action='store_true', help='Without output fps (default=False)')
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

    if args.time:
        print('XYU')
        frame_grabber = PiCameraThread(resolution=resolution)
        print('Run camera for {} seconds'.format(args.time))
        num_frames = 0
        current_time = time()

        while time() - current_time < args.time:
            #print(time() - current_time)
            frame = frame_grabber.get_frame()

            if args.screen_output:
                try:
                    cv2.imshow('Pi Cam', frame)
                except:
                    pass

            if args.output:
                cv2.imwrite('{0}/{1}.jpg'.format(args.output, num_frames), frame)

            num_frames += 1
            
        frame_grabber.stop()
        frame_grabber.print_fps()
    cv2.destroyAllWindows()


