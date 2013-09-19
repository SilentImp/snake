dependency = [
  'jquery'
  'domReady'
]


define dependency, ($, domReady)->
  class ScoreController
    constructor: ->
      $.ajax('getScore.php'
        complete: @scoreLoaded
      )

    scoreSave: (name, score)=>
      $.ajax('setScore.php'
        method: 'post'
        data:
          name: name
          score: score
        complete: @scoreLoaded
      )

    scoreLoaded: (result)=>
      if typeof result == 'undefined' && typeof result.responseJSON == 'undefined'
        return

      score = result.responseJSON
      score_template = $($('#person').html())
      list = ''

      for i in [0...score.length]
        score_tmp = score_template.clone()
        score_tmp.find('.name').text(score[i][1])
        score_tmp.find('.count').text(score[i][0])
        list+= score_tmp.html()

      $('.screen.score ol').html(list)

  domReady ->
    window.ScoreController = new ScoreController