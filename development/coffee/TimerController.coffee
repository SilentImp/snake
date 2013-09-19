define ()->
  class TimerController
    constructor: (options)->
      @total_ticks = 0
      @last = null
      @state = false
      if typeof options.duration is 'undefined'
        options.duration = 1000
      if typeof options.callback is 'undefined'
        return false
      @callback = options.callback
      @duration = options.duration

    run: ()=>
      @callback(@)
      @state = true
      @frame = window.requestAnimationFrame @timelog

    timelog: (time)=>
      time == Math.floor(time)

      if @last is null
        @last = time

      @passed = time - @last
      # console.log time - @last
      
      if @passed >= @duration
        @total_ticks++
        @last = time
        @callback(@)
      
      if @state == true
        @frame = window.requestAnimationFrame(@timelog)

    stop: ()=>
      @total_ticks = 0
      @last = null
      @state = false
      window.cancelAnimationFrame(@frame)
      return @


  window.RAFTimer = TimerController