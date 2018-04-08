# This class's instance is a rotate button that is added to the current phone/tablet layer shown when a prototype is displayed in a desktop web browser or in Framer Studio itself (but not when viewed on a phone or tablet). The image is customizable and flips itself appropriately when the device rotates. 
#
# The default orientation of the provided bitmap should be designed for the portrait orientation. The default size of the instance designed to work well with any phone/tablet that Framer displays, but the coder can customize this size (or scale the button)
#
# @rotationImage: the image that is used in the button
# @deviceEdgeOffset: number of pixels between the right edge of the device and the button (coder is discouraged from specifying x)
# @y: number of pixels from the top of the device

class exports.DeviceRotator extends Layer
	constructor: (@options = {}) ->
		_.defaults @options,
			image: "https://i.imgur.com/jPtLs8E.png"
			deviceEdgeOffset: 0
			y: 0 # set to zero to see if coder specifies a non-zero y
			size: 0  # set to zero to see if coder specifies a size
			backgroundColor: ""
		super @options
		
		# get reference to the "phone" layer, become its child, and match its context
		@deviceLayer = Framer.Device.phone
		@parent = @deviceLayer
		@._context = @deviceLayer.context
		
		# Now that we're in the same context as @deviceLayer, it's safe to do some sizing/layout.
		
		size = @size # grab constructed size
		
		if size.width is 0 or size.height is 0 # the coder did not pass in any sizing info
			@size = @deviceLayer.width * 0.045 * @deviceLayer.height/@deviceLayer.width # our default size
		else
			@size = 0  # zero-out size to force registration of resize (in our new context) in line below
			@size = size # coder-specified size.
			
		@x = @deviceLayer.width + @deviceEdgeOffset
		
		if @options.y isnt 0 # coder provided a y value
			@y = 0 # zero-out y for same reason as above.
			@y = @options.y
			
		# flip self properly if instantiated while device's parent is in landscape (rotationZ is -90)
		@rotationY = @deviceLayer.parent.rotationZ * 2
		
		# show ourself only when appropriate
		@visible = Framer.Device._device.deviceType in ["phone","tablet"] and not Utils.isMobile()

		# flip ourself the other way as Device.hands layer (parent of @deviceLayer) rotates 90 degrees
		@deviceLayer.parent.on "change:rotationZ", (newRotation) =>
			@rotationY = newRotation * 2
		
		# rotate device appropriately when clicked
		@onClick ->
			if Framer.Device.orientation is 0
				Framer.Device.rotateLeft()
			else
				Framer.Device.rotateRight()

		# make sure any child added to instance gets proper context and has its size/point properties reset in the context
		@on "change:children", ->
			for child in @children
				size = child.size
				point = child.point
				child.size = 0
				child.point = 0
				child._context = @context
				child.size = size
				child.point = point

	@define "deviceEdgeOffset",
		get: -> @options.deviceEdgeOffset
		set: (offset) -> 
			# Check whether we're an instance yet; we don't want the constructor to trigger
			# this setter because the proper context isn't set yet.
			if @__framerInstanceInfo? 
				@options.deviceEdgeOffset = offset
				@x = @deviceLayer.width + @deviceEdgeOffset
