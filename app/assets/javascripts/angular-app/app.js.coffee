@app = angular.module('wpc', [
# additional dependencies here, such as restangular
  'templates',
  'rails',
  'ui.router',
  'templates',
  'ngVis'

])

# for compatibility with Rails CSRF protection

@app.config([
  '$httpProvider', ($httpProvider)->
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')

])
