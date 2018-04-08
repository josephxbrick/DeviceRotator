# DeviceRotator
A Framer module that adds a rotation button to the Framer phone/tablet display when the prototype is displayed in a desktop browser or in Framer Studio (but not when displayed on an actual device). This allows your audience to see how the prototype behaves when rotated without viewing it on an actual tablet/phone. Note that the DeviceRotator won't be visible for watches, PCs, or TVs.

Framer sample: [sample.framer](https://framer.cloud/CQOqv)

<img src="/readme_images/rotate_device.gif" width="400">

## Getting Started

If you have Modules installed, or want to install Modules to add this module to you project, click the badge below.

<a href='https://open.framermodules.com/DeviceRotator'>
    <img alt='Install with Framer Modules'
    src='https://www.framermodules.com/assets/badge@2x.png' width='160' height='40' />
</a>

Note that you can hit Ctrl+C in Modules (when DeviceRotator is the active module) to copy a code example that you can then paste into your file. 

If you are not using Modules, download `devicerotator.coffee`, place it in the `/modules` folder of your project, and in your coffeescript file, include the following:

`{DeviceRotator} = require "devicerotator"`

## Creating the rotation button instance
The following creates the instance and adds it to the device selected in Framer.
```
deviceRotator = new DeviceRotator
  image: "path to image"
  deviceEdgeOffset: 10
```
* **image**: (optional) path to the image you want to be displayed in the instance. If not specified, a default image is provided.
* **deviceEdgeOffset**: (optional) the number of pixels between the right edge of the (portrait mode) device and the instance. Default is 0

## Customizing the instance

### Changing the image's offset from the top of the device
Some of Framer Studio's devices (notably, iPhone X and the iPads) have their device images offset from the top by several pixels. To move the rotate-button instance downwards a number of pixels, simply specify a `y` value for the instance.

```
# offset the top edge of the rotator instance from the top of the device by 20 pixels
deviceRotator = new DeviceRotator
  y: 20
 ```
### Forgoing the image

Instead of using an image (the stock one, or your own) in the instance, you can add a layer or a targeted frame from Design mode as a child of the instance. Be aware, however, that vector paths (that aren't part of a stock icon) cannot be resized as of this writing, so they won't work for your image.

```
# create instance, which is automatically added to the current device
deviceRotator = new DeviceRotator
	image: "" # get rid of default image
	size: 110

# add iconDesign (here a frame from Design mode) to instance
deviceRotator.addChild iconDesign
# note: it's important that any sizing/positioning of iconDesign occurs AFTER
# it's added as a child (for context reasons)
iconDesign.point = 0
iconDesign.size = deviceRotator.size
```

## Sample Framer.js Project
* [sample.framer](https://framer.cloud/CQOqv)
