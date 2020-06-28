# virtual-background

Port to Windows the Virtual Background solution by Ben Elder: https://elder.dev/posts/open-source-virtual-background/

Current version draws the computed video image into a window, where it can be captured by OBS and made available via OBS's Virtual Webcam plugin.

Requires node.js and Python 3.

Because I don't have an nVidia GPU, I am falling back to the CPU version of Tensorflow. This gives me a somewhat unsatisfying frame rate. Maybe get the mask asynchronously and apply one mask to several frames?

Usage:

  1. Install necessary node.js packages using `npm i`
  2. Run the Tensorflow model `node app.js`
  3. Run the Python script `python fake.py` or `python fake_async.py`
  4. Set up window capture in OBS
  
The asynchronous version continues to render new frames while it waits for the mask to be generated. Thus you get smooth movements of the live image, but the mask always lags behind.

## Next steps to improve this

- Better integration with OBS
- Try it out on the Mac
- Is there a faster way to generate the mask, that does not require nVidia graphics? Downsample for mask generation?
