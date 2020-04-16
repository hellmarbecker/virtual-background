const tf = require('@tensorflow/tfjs-node');
const bodyPix = require('@tensorflow-models/body-pix');
const http = require('http');
const fs = require('fs'); // need filesystem to load jpeg
const path = require('path');

async function loadAndPredict() {
    return await bodyPix.load({
        architecture: 'MobileNetV1',
        outputStride: 16,
        multiplier: 0.5,
        quantBytes: 2,
    });
}

var net = loadAndPredict();

const bytes = fs.readFileSync(path.join(__dirname, '/test.jpg'));
const image = tf.node.decodeImage(bytes);

function segment() {
    return new Promise(async (resolve, reject) => {
        resolve(await net.segmentPerson(image, {
            flipHorizontal: false,
            internalResolution: 'medium',
            segmentationThreshold: 0.7,
        }));
    })
}

var segmentation = segment();    
tf.dispose(image);
