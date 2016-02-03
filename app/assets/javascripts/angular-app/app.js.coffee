@app = angular.module('wpc', [
# additional dependencies here, such as restangular
  'templates',
  'rails',
  'ui.router',
  'templates',
  'ngVis',
  'angular-intro',
  'angular-jqcloud',
  'daterangepicker',
  'Devise'
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
])
