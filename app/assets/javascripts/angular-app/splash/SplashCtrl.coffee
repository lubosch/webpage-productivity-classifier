angular.module('wpc').controller("SplashCtrl", [
  '$scope', '$rootScope',
  ($scope, $rootScope)->
    $rootScope.hiddenLeftMenu = true
    creative(jQuery)
])