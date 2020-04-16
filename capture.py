#!/usr/bin/python

import cv2

def get_mask(frame, bodypix_url='http://localhost:9000'):
    _, data = cv2.imencode(".jpg", frame)
    r = requests.post(
        url=bodypix_url,
        data=data.tobytes(),
        headers={'Content-Type': 'application/octet-stream'})
    # convert raw bytes to a numpy array
    # raw data is uint8[width * height] with value 0 or 1
    mask = np.frombuffer(r.content, dtype=np.uint8)
    mask = mask.reshape((frame.shape[0], frame.shape[1]))
    return mask

if __name__ == "__main__":

    cap = cv2.VideoCapture(0)

    # configure camera for 720p @ 60 FPS

    height, width = 720, 1280
    cap.set(cv2.CAP_PROP_FRAME_WIDTH ,width)
    cap.set(cv2.CAP_PROP_FRAME_HEIGHT,height)
    cap.set(cv2.CAP_PROP_FPS, 60)

    success, frame = cap.read()
