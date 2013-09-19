define ["jquery", 'domReady'], ($, domReady)->
  class FoodController
    constructor: (options)->
      @debug = options.debug
      @cellSize = options.cellSize || 40
      @type = 'food'
      @map = options.map
      @snake = options.snake
      @wrapper = options.wrapper || $ '#field'
      @xSize = @map.length
      @ySize = @map[0].length
      @x = null
      @y = null
      @node = $ $('#food-template').html()
      @xPoint = @wrapper.find '.x-cord' 
      @yPoint = @wrapper.find '.y-cord' 

      if Math.round(Math.random()*1) is 0
        @node.addClass 'up'
      @addRandomly()

    addRandomly: =>
      @add Math.round(Math.random()*(@xSize-1)), Math.round(Math.random()*(@ySize-1))

    add: (@x, @y)=>
      if @map[@x][@y] != undefined
        @addRandomly()
      else if (Math.abs(@snake.x-@x)<2)||(Math.abs(@snake.y-@y)<2)
        @addRandomly()
      else
        @node.css
          '-webkit-transform':'translateX('+@x*@cellSize+'px) translateY('+@y*@cellSize+'px)'
          '-moz-transform':'translateX('+@x*@cellSize+'px) translateY('+@y*@cellSize+'px)'
          'transform':'translateX('+@x*@cellSize+'px) translateY('+@y*@cellSize+'px)'
        @wrapper.append @node
        @map[@x][@y] = @
        @xPoint.css
          '-webkit-transform':'translateX('+@x*@cellSize+'px)'
          '-moz-transform':'translateX('+@x*@cellSize+'px)'
          'transform':'translateX('+@x*@cellSize+'px'
        @yPoint.css
          '-webkit-transform':'translateY('+@y*@cellSize+'px)'
          '-moz-transform':'translateY('+@y*@cellSize+'px)'
          'transform':'translateY('+@y*@cellSize+'px'


      if @debug
        $('#'+@x+'-'+@y)[0].className = 'holder food'

    remove: =>
      @node.remove()
      @map[@x][@y] = undefined
      if @debug
        $('#'+@x+'-'+@y)[0].className = 'holder'

        

  domReady ->
    window.FoodController = FoodController