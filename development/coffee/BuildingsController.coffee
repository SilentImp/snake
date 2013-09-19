define ["jquery", 'domReady'], ($, domReady)->
  class BuildingsController
    constructor: (options)->
      @debug = options.debug
      @cellSize = options.cellSize || 40
      @type = 'building'
      @map = options.map
      @snake = options.snake
      @wrapper = options.wrapper || $ '#field'
      @xSize = @map.length
      @ySize = @map[0].length
      @x = null
      @y = null
      @node = $ $('#house-template').html()
      @addRandomly()

    addRandomly: =>
      x = Math.max(Math.min(Math.round(Math.random()*@xSize),@xSize-3),1)
      y = Math.max(Math.min(Math.round(Math.random()*@ySize),@ySize-3),1)
      @add x, y

    add: (@x, @y)=>
      for i in [Math.max(@x-1,0)..Math.min(@x+2,@xSize-1)]
        for k in [Math.max(@y-1,0)..Math.min(@y+2,@ySize-1)]
          if typeof @map[i][k] != 'undefined'
            @addRandomly()
            return false

      @node.css
        '-webkit-transform':'translateX('+@x*@cellSize+'px) translateY('+@y*@cellSize+'px)'
        '-moz-transform':'translateX('+@x*@cellSize+'px) translateY('+@y*@cellSize+'px)'
        'transform':'translateX('+@x*@cellSize+'px) translateY('+@y*@cellSize+'px)'
      @wrapper.append @node
      @map[@x][@y] = @
      @map[@x+1][@y] = @
      @map[@x+1][@y+1] = @
      @map[@x][@y+1] = @

      if @debug
        $('#'+@x+'-'+@y)[0].className = 'holder building'
        $('#'+(@x+1)+'-'+@y)[0].className = 'holder building'
        $('#'+(@x+1)+'-'+(@y+1))[0].className = 'holder building'
        $('#'+@x+'-'+(@y+1))[0].className = 'holder building'

      return true

    remove: =>
      @node.remove()
      @map[@x][@y] = undefined
      @map[@x+1][@y] = undefined
      @map[@x+1][@y+1] = undefined
      @map[@x][@y+1] = undefined
      if @debug
        $('#'+@x+'-'+@y)[0].className = 'holder'
        $('#'+(@x+1)+'-'+@y)[0].className = 'holder'
        $('#'+(@x+1)+'-'+(@y+1))[0].className = 'holder'
        $('#'+@x+'-'+(@y+1))[0].className = 'holder'
        

  domReady ->
    window.BuildingsController = BuildingsController