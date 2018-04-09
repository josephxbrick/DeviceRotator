class DefaultDot extends Layer
	constructor: (options={}) ->
		_.defaults options,
			size: 13
			borderRadius: "50%"
			borderColor: "rgba(255,255,255,0.9)"
			backgroundColor:"rgba(0, 0, 0, 0.05)"
			borderWidth: 1.1
		super options

class exports.Paginator extends Layer
	constructor: (@options={}) ->
		_.defaults @options,
			pageComponent: undefined
			side: "bottom"
			sideOffset: 10
			dotSize: 13
			dotSpacing: 6
			dotDefaultProps: backgroundColor: "rgba(0, 0, 0, 0.15)", borderColor: "rgba(255,255,255,0.95)"
			dotSelectedProps: backgroundColor: "rgba(255,255,255,0.95)", borderColor: "rgba(0,0,0,0.35)"
			animationOptions: time: 0.3, curve: Bezier.ease
			backgroundColor: ""
			interactive: false
		super @options
		if not @pageComponent
			throw new Error "You must supply Paginator with a PageComponent"
		# for positioning to work properly, Paginator must be on same layer as is PageComponent
		@parent = @pageComponent.parent
		if @side not in ["top", "bottom", "left", "right"]
			throw new Error "What side are you on?"

		@pageComponent.on "change:currentPage", (currentPage, target) =>
			@_selectDot target.horizontalPageIndex(currentPage)
		@pageComponent.content.on "change:children", =>
			@_layout()
		@pageComponent.on "change:size", =>
			@_setPosition()
		@pageComponent.on "change:point", =>
			@_setPosition()

		@_layout()

	_createDots: ->
		numDots = @pageComponent.content.children.length
		for i in [0...Math.max(numDots, @children.length)]
			if i >= numDots
				# Too many dots from prevous execution of _createDots().
				# (A page has been removed from the page component.)
				destroyMe = @children[i]
				destroyMe.parent = null
				destroyMe.destroy()
			if i < @children.length and i < numDots
				# Reuse existing dot from previous execution _createDots()
				# due to @pageComponent event "change:children"
				dot = @children[i]
			else if i < numDots
				# make new dot
				dot = new DefaultDot
				dot.props = @dotDefaultProps
			if i < numDots
				dot.size = @dotSize
				dot.parent = @
				if @side in ["top", "bottom"]
					dot.x = i * (dot.width + @dotSpacing)
					dot.y = 0
				else
					dot.x = 0
					dot.y = i * (dot.height + @dotSpacing)
				dot.states =
					default: @dotDefaultProps
					selected: @dotSelectedProps
				if @interactive is true
					dot.onTap (event, target) =>
						@pageComponent.snapToPage @pageComponent.content.children[_.indexOf(@children, target)]
						@emit "dotTapped", target, _.indexOf(@children, target)
		if @side in ["top", "bottom"]
			@width = numDots * (dot.width + @dotSpacing) - @dotSpacing
			@height = dot.height
		else
			@width = dot.width
			@height = numDots * (dot.height + @dotSpacing) - @dotSpacing

	_selectDot: (dotIndex) ->
		for child, i in @children
			if i is dotIndex
				child.animate "selected",
					@animationOptions
			else
				child.animate "default",
					@animationOptions

	_setPosition: ->
		if @side is "bottom"
			@x = @pageComponent.x + @pageComponent.width/2 - @.width/2
			@y = @pageComponent.maxY - @height - @sideOffset
		else if @side is "top"
			@x = @pageComponent.x + @pageComponent.width/2 - @.width/2
			@y = @pageComponent.y + @sideOffset
		else if @side is "left"
			@x = @pageComponent.x + @sideOffset
			@y = @pageComponent.y + @pageComponent.height/2 - @.height/2
		else if @side is "right"
			@x = @pageComponent.maxX - @width - @sideOffset
			@y = @pageComponent.y + @pageComponent.height/2 - @.height/2

	_layout: ->
		@_createDots()
		@_selectDot _.indexOf @pageComponent.content.children, @pageComponent.currentPage
		@_setPosition()

	@define "pageComponent",
		get: -> @options.pageComponent
		
	@define "side",
		get: -> @options.side
		set: (value) ->
			@options.side = value
			# don't call @_layout() upon @side being set in constructor
			if @__framerInstanceInfo? # undefined until instance is created
				@_layout()
	@define "sideOffset",
		get: -> @options.sideOffset
		set: (value) ->
			@options.sideOffset = value
			if @__framerInstanceInfo? 
				@_layout()
	@define "dotSize",
		get: -> @options.dotSize
		set: (value) ->
			@options.dotSize = value
			if @__framerInstanceInfo? 
				@_layout()
	@define "dotSpacing",
		get: -> @options.dotSpacing
		set: (value) ->
			@options.dotSpacing = value
			if @__framerInstanceInfo? 
				@_layout()
	@define "dotDefaultProps",
		get: -> @options.dotDefaultProps
		set: (value) ->
			@options.dotDefaultProps = value
			if @__framerInstanceInfo? 
				@_layout()
	@define "dotSelectedProps",
		get: -> @options.dotSelectedProps
		set: (value) ->
			@options.dotSelectedProps = value
			if @__framerInstanceInfo? 
				@_layout()
	@define "interactive",
		get: -> @options.interactive
