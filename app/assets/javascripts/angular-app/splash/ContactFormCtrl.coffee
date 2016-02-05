angular.module('wpc').controller("ContactFormCtrl", [
  '$scope', '$rootScope',
  ($scope, $rootScope)->
    user = {name: '', email: '', text: ''}
    $scope.user = user

    $scope.sendFeedback = () ->



])