var dependency,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

dependency = ['jquery', 'domReady'];

define(dependency, function($, domReady) {
  var ScoreController;
  ScoreController = (function() {
    function ScoreController() {
      this.scoreLoaded = __bind(this.scoreLoaded, this);
      this.scoreSave = __bind(this.scoreSave, this);
      $.ajax('getScore.php', {
        complete: this.scoreLoaded
      });
    }

    ScoreController.prototype.scoreSave = function(name, score) {
      return $.ajax('setScore.php', {
        method: 'post',
        data: {
          name: name,
          score: score
        },
        complete: this.scoreLoaded
      });
    };

    ScoreController.prototype.scoreLoaded = function(result) {
      var i, list, score, score_template, score_tmp, _i, _ref;
      if (typeof result === 'undefined' && typeof result.responseJSON === 'undefined') {
        return;
      }
      score = result.responseJSON;
      score_template = $($('#person').html());
      list = '';
      for (i = _i = 0, _ref = score.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        score_tmp = score_template.clone();
        score_tmp.find('.name').text(score[i][1]);
        score_tmp.find('.count').text(score[i][0]);
        list += score_tmp.html();
      }
      return $('.screen.score ol').html(list);
    };

    return ScoreController;

  })();
  return domReady(function() {
    return window.ScoreController = new ScoreController;
  });
});
