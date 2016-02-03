angular.module('wpc').controller("NavCtrl", [
  '$scope', '$state',
  ($scope, $state)->
    $scope.$state = $state
    $scope.splash = true


])