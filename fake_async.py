import os
import time
import cv2
import numpy as np
# import requests
import asyncio
from aiohttp import ClientSession

raw_frame = None
frame = None
mask = None
inv_mask = None

def post_process_mask(tmp_mask):
    global mask, inv_mask
    tmp_mask = cv2.dilate(tmp_mask, np.ones((10,10), np.uint8) , iterations=1)
    mask = cv2.blur(tmp_mask.astype(float), (30,30))
    inv_mask = 1-mask

async def get_mask(bodypix_url='http://localhost:9000'):
    global raw_frame
    async with ClientSession() as session:
        while True:
            if raw_frame is None:
                print("in get_mask: no frame, yawn!")
                await asyncio.sleep(1)
            else:
                print("in get_mask: frame, happy!")
                _, data = cv2.imencode(".jpg", raw_frame)
                async with session.post(
                    bodypix_url,
                    data=data.tobytes(),
                    headers={'Content-Type': 'application/octet-stream'}) as r:
                    content_bytes = await r.read()
                    if content_bytes is None:
                        print("in get_mask: empty response")
                    else:
                        print("in get_mask: have response, happy!")
                        tmp_mask = np.frombuffer(content_bytes, dtype=np.uint8)
                        tmp_mask = tmp_mask.reshape((raw_frame.shape[0], raw_frame.shape[1]))
                        post_process_mask(tmp_mask)

def shift_image(img, dx, dy):
    img = np.roll(img, dy, axis=0)
    img = np.roll(img, dx, axis=1)
    if dy>0:
        img[:dy, :] = 0
    elif dy<0:
        img[dy:, :] = 0
    if dx>0:
        img[:, :dx] = 0
    elif dx<0:
        img[:, dx:] = 0
    return img

def hologram_effect(img):
    # add a blue tint
    holo = cv2.applyColorMap(img, cv2.COLORMAP_WINTER)
    # add a halftone effect
    bandLength, bandGap = 2, 3
    for y in range(holo.shape[0]):
        if y % (bandLength+bandGap) < bandLength:
            holo[y,:,:] = holo[y,:,:] * np.random.uniform(0.1, 0.3)
    # add some ghosting
    holo_blur = cv2.addWeighted(holo, 0.2, shift_image(holo.copy(), 5, 5), 0.8, 0)
    holo_blur = cv2.addWeighted(holo_blur, 0.4, shift_image(holo.copy(), -5, -5), 0.6, 0)
    # combine with the original color, oversaturated
    out = cv2.addWeighted(img, 0.5, holo_blur, 0.6, 0)
    return out

async def get_frames(cap, background_scaled):
    global raw_frame, frame, mask, inv_mask
    while True:
        print("in get_frames")
        _, raw_frame = cap.read()
        if mask is None:
            print("in get_frames: no mask, moving on")
            await asyncio.sleep(1)
        else:
            print("in get_frames: have mask, happy!")
            tmp_frame = hologram_effect(raw_frame)
            # composite the foreground and background
            frame = tmp_frame
            for c in range(tmp_frame.shape[2]):
                frame[:,:,c] = tmp_frame[:,:,c]*mask + background_scaled[:,:,c]*inv_mask
            await asyncio.sleep(0) # yield

async def output_images():
    global frame
    while True:
        print("in output_images")
        if frame is not None:
            print("have frame")
            cv2.imshow("Virtual Webcam Image", frame)
            cv2.waitKey(1) # waits until a key is pressed, or max 1 msec
            await asyncio.sleep(0) # yield
        else:
            print("no frame, yawn!")
            await asyncio.sleep(1) 



async def main():
    # setup access to the *real* webcam
    cap = cv2.VideoCapture(0)
    height, width = 720, 1280
    aspect_ratio = height / width
    cap.set(cv2.CAP_PROP_FRAME_WIDTH, width)
    cap.set(cv2.CAP_PROP_FRAME_HEIGHT, height)
    cap.set(cv2.CAP_PROP_FPS, 60)

    # load the virtual background
    # background = cv2.imread("star-wars-feature-vf-2019-summer-embed-07.jpg")
    background = cv2.imread("anakin-and-the-jedi-council.jpg")
    # resize without distortion
    bk_height, bk_width, _ = background.shape
    bk_aspect_ratio = bk_height / bk_width
    if bk_aspect_ratio > aspect_ratio:
        height_new = (bk_height * width) // bk_width
        height_offset = (height_new - height) // 2
        background_scaled_raw = cv2.resize(background, (width, height_new))
        background_scaled = background_scaled_raw[height_offset:(height_offset+height), 0:width]
    else:
        width_new = (bk_width * height) // bk_height
        width_offset = (width_new - width) // 2
        background_scaled_raw = cv2.resize(background, (width_new, height))
        background_scaled = background_scaled_raw[0:height, width_offset:(width_offset+width)]

    await asyncio.gather(
            get_mask(),
            get_frames(cap, background_scaled),
            output_images())

if __name__ == "__main__":
    asyncio.run(main())
