# virtual-background

Port to Windows the Virtual Background solution by Ben Elder: https://elder.dev/posts/open-source-virtual-background/

Current version draws the computed video image into a window, where it can be captured by OBS and made available via OBS's Virtual Webcam plugin.

Requires node.js and Python 3.

Because I don't have an nVidia GPU, I am falling back to the CPU version of Tensorflow. This gives me a somewhat unsatisfying frame rate. Maybe get the mask asynchronously and apply one mask to several frames?

Usage:

  1. Install necessary node.js packages using `npm i`
  2. Run the Tensorflow model `node app.js`
  3. Run the Python script `python fake.py`
  4. Set up window capture in OBS
  
