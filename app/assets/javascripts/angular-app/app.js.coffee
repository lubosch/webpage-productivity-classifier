@app = angular.module('wpc', [
# additional dependencies here, such as restangular
  'templates',
  'rails',
  'ui.router',
  'ui.bootstrap'
  'templates',
  'ngVis',
  'angular-intro',
  'angular-jqcloud',
  'daterangepicker',
  'Devise',
  '720kb.tooltips',
  'ngSanitize',
  'puigcerber.capitalize'
])

# for compatibility with Rails CSRF protection

@app.config([
  '$httpProvider', ($httpProvider)->
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
    $httpProvider.defaults.withCredentials = true;


])

@app.run(['Auth', '$rootScope', (Auth, $rootScope) ->
  Auth.currentUser().then((user) ->
    $rootScope.logged_in = true
  )
]).run(($rootScope, $location, Auth)  ->
  $rootScope.$on("$stateChangeStart", (event, toState, toParams, fromState, fromParams, options)->
    if ( !$rootScope.logged_in)
      Auth.currentUser().then((user) ->
        $rootScope.logged_in = true
      , (error) ->
        if ( toState != "index" )
          $location.path("/")
      )
  )
)
