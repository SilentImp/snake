dependency = [
  'domReady'
  'jquery'
  'jquery.hotkeys'
  'TimerController'
  'SnakeController'
  'FoodController'
  'BuildingsController'
]

define dependency, (domReady)->

  class GameController
    constructor: ->
      @touch = $('html').hasClass 'touch'
      @controller = $ '.controller'
      @debug = false
      @screen = $ '.screen.game'
      @backCount = @screen.find '.back-count'
      @fieldWith = 10
      @fieldHeight = 10
      @placeSize = 40
      @houseCount = 2
      @backCountNum = 3
      @speed = 750
      @wrapper = $ '#field'
      @snake = null
      @score = 0
      @scoreElement = @screen.find '.stats .count'

      @quit = @screen.find '.quit'
      @quit.on 'click', @quitGame

    init: =>
      if @touch
        @controller.show()

      @speed = 800
      @score = 0
      @updateScore()

      @wrapper.find('>*:not(.position):not(.side)').remove()

      @field = new Array(@fieldWith)
      for i in [0...@fieldWith]
        @field[i] = new Array(@fieldHeight)

      pos = @wrapper.find '.position'
      if @debug
        for i in [0...@fieldWith]
          for k in [0...@fieldHeight]
            pos.append('<div id="'+i+'-'+k+'" class="holder">'+i+':'+k+'</div>')
            $('#'+i+'-'+k).css
              '-webkit-transform':'translateX('+i*40+'px) translateY('+k*40+'px)'
              '-moz-transform':'translateX('+i*40+'px) translateY('+k*40+'px)'
              'transform':'translateX('+i*40+'px) translateY('+k*40+'px)'

      @snake = new window.SnakeController
        map: @field
        debug: @debug

      $(document).on 'die', @endGame
      $(document).on 'food', @foodEaten

      @addBuildings()

      food = new window.FoodController
        map: @field
        snake: @snake
        debug: @debug

      @cdCount = @backCountNum;
      @timer = new window.RAFTimer
        duration: 1000,
        callback: @cdStep
      @timer.run()

    quitGame: (event)=>
      event.preventDefault?()
      if @touch
        @controller.hide()
      if @touch
        @controller.find('.left').off('tapone',@left)
        @controller.find('.up').off('tapone',@up)
        @controller.find('.right').off('tapone',@right)
        @controller.find('.down').off('tapone',@down)
      else
        $(document).unbind('keydown', @left)
        $(document).unbind('keydown', @up)
        $(document).unbind('keydown', @right)
        $(document).unbind('keydown', @down)

      $(document).off 'die', @endGame
      $(document).off 'food', @foodEaten

      @timer.stop()
      window.MenuController.showMenu(event)

    endGame: =>
      if @touch
        @controller.hide()
      if @touch
        @controller.find('.left').off('tapone',@left)
        @controller.find('.up').off('tapone',@up)
        @controller.find('.right').off('tapone',@right)
        @controller.find('.down').off('tapone',@down)
      else
        $(document).unbind('keydown', @left)
        $(document).unbind('keydown', @up)
        $(document).unbind('keydown', @right)
        $(document).unbind('keydown', @down)

      $(document).off 'die', @endGame
      $(document).off 'food', @foodEaten

      @timer.stop()
      $('.screen.game-over .count').text @score
      window.ScoreController.scoreSave(window.MenuController.playerName, @score)

      window.setTimeout(
        ()->
          window.MenuController.showGameOver()
        ,2000)

    foodEaten: =>
      food = new window.FoodController
        map: @field
        snake: @snake
        debug: @debug

      if @speed > 150
        @speed = Math.round(@speed - @speed*0.075)
      @timer.duration = @speed
      @score += 10

      @updateScore()

    updateScore: =>
      @scoreElement.text @score

    gameStep: (timer)=>
      @snake.move()

    addBuildings: =>
      for i in [0...@houseCount]
        building = new window.BuildingsController
          map: @field
          snake: @snake
          debug: @debug

    cdStep: (timer)=>
      diff = @cdCount - timer.total_ticks
      @backCount.removeClass('count')
      if diff == 0
        timer.stop()
        if @touch
          @controller.find('.left').on('tapone',@left)
          @controller.find('.up').on('tapone',@up)
          @controller.find('.right').on('tapone',@right)
          @controller.find('.down').on('tapone',@down)
        else
          $(document).on('keydown', null, 'left', @left);
          $(document).on('keydown', null, 'up', @up);
          $(document).on('keydown', null, 'right', @right);
          $(document).on('keydown', null, 'down', @down);

        timer.duration = @speed
        timer.callback = @gameStep
        timer.run()
        return
      @backCount.text(diff)
      @backCount.addClass('count')

    left: (event)=>
      event.preventDefault?()
      @snake.turn 'left'
    up: (event)=>
      event.preventDefault?()
      @snake.turn 'up'
    right: (event)=>
      event.preventDefault?()
      @snake.turn 'right'
    down: (event)=>
      event.preventDefault?()
      @snake.turn 'down'



  domReady ->
    window.GameController = new GameController