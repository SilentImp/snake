dependency = [
  'jquery'
  'domReady'
]

define dependency, ($, domReady)->
  class SnakeController
    constructor: (options)->
      @debug = options.debug
      @type = 'snake'
      @reason = 'fuck off'
      @directions = ['up','down','left','right','up','down','left','right']
      @cellSize = options.cellSize || 40
      @wrapper = options.wrapper || $ '#field'
      @map = options.map
      @xSize = @map.length
      @ySize = @map[0].length
      @wrapper = $ '#field'
      @head = null
      @x = null
      @y = null
      @direction = null
      @addRandomly()


    turn: (direction)=>
      switch direction
        when "up"
          if @oldDirection == 'down'
            return
          @direction = 'up'
        when "down"
          if @oldDirection == 'up'
            return
          @direction = 'down'
        when "left"
          if @oldDirection == 'right'
            return
          @direction = 'left'
        when "right"
          if @oldDirection == 'left'
            return
          @direction = 'right'
      @head[0].className = 'train-pos head ' + @direction

    addRandomly: ()=>
      x = Math.max(Math.min(Math.round(Math.random()*@xSize),@xSize-3),1)
      y = Math.max(Math.min(Math.round(Math.random()*@ySize),@ySize-3),1)
      direction = @directions[Math.round(Math.random()*7)]
      @add x, y, direction

    add: (@x, @y, @direction)=>
      for i in [Math.max(@x-1,0)..Math.min(@x+2,@xSize-1)]
        for k in [Math.max(@y-1,0)..Math.min(@y+2,@ySize-1)]
          if typeof @map[i][k] != 'undefined'
            @addRandomly()
            return
      if @head != null 
        @head.removeClass 'head'
      @head = $ $('#train-template').html()
      @head[0].className = 'train-pos head ' + @direction
      @moveTo @head, @x, @y
      @wrapper.append @head
      @nodeCollection = [@head]
      @oldDirection = @direction
      @xCollection = [@x]
      @yCollection = [@y]
      @oCollection = [@direction]
      @map[@x][@y] = @
      if @debug
        $('#'+@x+'-'+@y)[0].className = 'holder snake'

    moveTo: (element, x, y)=>
      element.css
        '-webkit-transform':'translateX('+x*@cellSize+'px) translateY('+y*@cellSize+'px)'
        '-moz-transform':'translateX('+x*@cellSize+'px) translateY('+y*@cellSize+'px)'
        'transform':'translateX('+x*@cellSize+'px) translateY('+y*@cellSize+'px)'

    move: ()=>

      switch @direction
        when "up"
          dx = 0
          dy = -1
        when "down"
          dx = 0
          dy = 1
        when "left"
          dx = -1
          dy = 0
        when "right"
          dx = 1
          dy = 0

      die = false
      pop = true
      @x += dx
      @y += dy

      if ((@x >= @xSize)||(@x<0)||(@y >= @ySize)||(@y<0))
        @reason = 'fall'
        die = true
        @head.find('.train').wrapAll("<div class='fall'></div>");

      if (die == false)&&(typeof @map[@x][@y] != 'undefined')
        
        switch @map[@x][@y].type
          when "food"            

            @head = @map[@x][@y].node
            delete @map[@x][@y]

            @moveTo @head, @x, @y
            @wrapper.append @head
            @nodeCollection.unshift @head

            pop = false
            $(document).trigger 'food'

          when "snake"
            if (@x!=@xCollection[@xCollection.length-1])||(@y!=@yCollection[@yCollection.length-1])
              @reason = 'snake'
              die = true

          when "building"
            @map[@x][@y].node.addClass 'onfire'
            @reason = 'building'
            die = true

      @xCollection.unshift @x
      @yCollection.unshift @y
      @oCollection.unshift @direction
      if !die
        @map[@x][@y] = @

      if @debug&&!die
        $('#'+@x+'-'+@y)[0].className = 'holder snake   '

      if pop == true
        if @debug
          $('#'+@xCollection[@xCollection.length-1]+'-'+@yCollection[@yCollection.length-1])[0].className = 'holder'
        delete @map[@xCollection[@xCollection.length-1]][@yCollection[@yCollection.length-1]]
        @xCollection.pop()
        @yCollection.pop()
        @oCollection.pop()
      head = 'head '
      for i in [0...@nodeCollection.length]
        @nodeCollection[i][0].className = 'train-pos '+head + @oCollection[i]
        @moveTo @nodeCollection[i], @xCollection[i], @yCollection[i]
        head = ''
      @oldDirection = @direction

      if die == true
        $(document).trigger 'die'

  domReady ->
    window.SnakeController = SnakeController