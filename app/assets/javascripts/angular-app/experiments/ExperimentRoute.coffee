angular.module('wpc').config ($locationProvider, $stateProvider, $urlRouterProvider)->
  $stateProvider.state 'experiments', {
    url: '/experiments',
    controller: 'ExperimentCtrl',
    templateUrl: '/assets/angular-app/experiments/index.html'
  }

