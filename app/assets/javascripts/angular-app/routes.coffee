angular.module('wpc').config ($locationProvider, $stateProvider, $urlRouterProvider)->
  $locationProvider.html5Mode(enabled: true, requireBase: false);

  $urlRouterProvider.otherwise ->
    return '/'

  $stateProvider.state 'index', {
    url: '/'
    controller: 'HomeCtrl',
    template: 'HomeCtrl'
  }

  $stateProvider.state 'dashboards', {
    url: '/dashboards',
    controller: 'DashboardCtrl',
    templateUrl: '/assets/angular-app/templates/dashboards/index.html'
  }

