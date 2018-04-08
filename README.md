# DeviceRotator
A Framer module that adds a rotation button to a phone/tablet when said is displayed in a desktop browser or in Framer Studio (but not on device)

Framer sample: [sample.framer](https://framer.cloud/CQOqv)

<img src="/readme_images/rotate_device.gif" width="600">

## Getting Started

If you have Modules installed, or want to use Modules to add this module to you project, click the badge below.

<a href='https://open.framermodules.com/DeviceRotator'>
    <img alt='Install with Framer Modules'
    src='https://www.framermodules.com/assets/badge@2x.png' width='160' height='40' />
</a>

Otherwise, download devicerotator.coffee an place it in the `/modules` folder of your project.

In your coffeescript file, include the following (again, if not using Modules to install).

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

Instead of using an image (the stock one or your own), you can add a layer (or a targeted frame from Design mode) as a child of the instance.

```
# create instance, which is automatically added to the current device
deviceRotator = new DeviceRotator
	image: "" # get rid of default image

# add iconDesign (here a frame from Design mode) to instance
deviceRotator.addChild iconDesign
# note: it's important that any sizing/positioning of iconDesign occurs AFTER
# it's added as a child (for context reasons)
iconDesign.point = 0
iconDesign.size = deviceRotator.size
```

## Sample Framer.js Project
* [sample.framer](https://framer.cloud/CQOqv)
