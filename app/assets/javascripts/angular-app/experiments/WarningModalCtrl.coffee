angular.module('wpc').controller("WarningModalCtrl", [
  '$scope', '$uibModalInstance',
  ($scope, $uibModalInstance)->
    $scope.ok = ->
      $uibModalInstance.close('ok')
])

