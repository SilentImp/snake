jsDependencies = [
  'modernizr'
  'jquery'
  'PxLoader'
  'PxLoaderImage'
  'PxLoaderSound'
  'modernizr'
  'jgestures.min'
  'l20n'
  'mozHack'
  'jquery.hotkeys'
  'requestAnimationFramePolyfill'
  'TimerController'
  'FoodController'
  'BuildingsController'
  'ScoreController'
  'MenuController'
  'GameController'
  ]
dir = 'images/'
imgDependencies = [
  dir+'house.png'
  dir+'train.png'
  dir+'sky.png'
  ]

imgDependencies = []

require.config
  urlArgs: "bust=" +  (new Date()).getTime()
  shim:
    "jquery.hotkeys":
      deps: ['jquery']
    "jgestures.min":
      deps: ['jquery']
    "PxLoaderImage":
      deps: ['PxLoader']
    "PxLoaderSound":
      deps: ['PxLoader']

require jsDependencies, (modernizr, $, PxLoader)->
  loader = new PxLoader
  for img in imgDependencies
    loader.addImage img
  loading = $ '.loading-screen'
  loader.addProgressListener (event)->
    loading.find('.line').text(Math.floor((event.completedCount*100)/imgDependencies.length)+'%')
  loader.addCompletionListener ()->
    $(document).ready ()->
      $('.language-navigation a[data-lang="'+document.l10n.supportedLocales[0]+'"]').addClass 'selected'
      $('.page').show()
      loading.hide()
  loader.start()

require.onError = (err)->
  console.log err.requireType
  if err.requireType is 'timeout'
    console.log 'modules: ' + err.requireModules

  throw err;