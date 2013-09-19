dependency = [
  'jquery'
  'domReady'
  'GameController'
]

define dependency, ($, domReady)->

  class MenuController
    constructor: ->
      @touch = $('html').hasClass 'touch'
      @page = $ '.page'
      @screenGame = $ '.screen.game'
      @screenScore = $ '.screen.score'
      @screenName = $ '.screen.name'
      @screenMenu = $ '.screen.menu'
      @screenGameOver = $ '.screen.game-over'
      @globalNav = @screenMenu.find '.global-navigation'
      @langNav = @screenMenu.find '.language-navigation'
      @input = @screenName.find 'input'
      @change = @globalNav.find '.change'
      @screenMenu.show()

      if @touch==false

        @globalNav.find('.score').on 'click', @showScore
        @globalNav.find('.play').on 'click', @showGame
        @change.on 'click', @changeName
        @langNav.find('a').on 'click', @changeLanguage
        @screenScore.find('.menu').on 'click', @showMenu
        @screenName.find('.menu').on 'click', @showMenu
        @screenGame.find('.menu').on 'click', @showMenu
        @screenGameOver.find('.again').on 'click', @showGame
        @screenGameOver.find('.menu').on 'click', @showMenu

      else
        @globalNav.find('.score').on 'tapone', @showScore
        @globalNav.find('.play').on 'tapone', @showGame
        @change.on 'tapone', @changeName
        @langNav.find('a').on 'tapone', @changeLanguage
        @screenScore.find('.menu').on 'tapone', @showMenu
        @screenName.find('.menu').on 'tapone', @showMenu
        @screenGame.find('.menu').on 'tapone', @showMenu
        @screenGameOver.find('.again').on 'tapone', @showGame
        @screenGameOver.find('.menu').on 'tapone', @showMenu

      

      @input.on 'focus', @focusForm
      @input.on 'blur', @blurForm
      @screenName.on 'submit', @showGame

      
      # предопределение имени
      @playerName = @input.val()
      @change.show()

      @playerName = null;

    changeLanguage: (event)=>
      event.preventDefault?()
      link = $ event.currentTarget
      lang = link.attr 'data-lang'
      @langNav.find('.selected').removeClass 'selected'
      link.addClass 'selected'
      document.l10n.requestLocales(lang)

    blurForm: (event)=>
      input = event.currentTarget
      window.setTimeout ()->
        $('.answer-1').removeClass 'focused'
        input.blur()
      , 350

    focusForm: (event)=>
      $('.answer-1').addClass 'focused'

    showScore: (event)=>
      event.preventDefault?()
      @page[0].className = 'page state-score'

    showMenu: (event)=>
      event.preventDefault?()
      @page[0].className = 'page state-menu'

    changeName: (event)=>
      event.preventDefault?()
      @page[0].className = 'page state-name'

    showName: (event)=>
      event.preventDefault?()
      if @playerName == null
        @page[0].className = 'page state-name'
      else
        @showGame event
    
    showGame: (event)=>
      event.preventDefault?()
      @input.blur()
      @playerName = @input.val()
      @change.show()
      @page[0].className = 'page state-game'
      window.GameController.init()

    showGameOver: =>
      @page[0].className = 'page state-game-over'
      

  domReady ->
    window.MenuController = new MenuController