angular.module('wpc').controller("ExperimentCtrl", [
  '$scope', '$rootScope', 'ApplicationList', 'ApplicationType', 'ApplicationTypes', '$http',
  ($scope, $rootScope, ApplicationList, ApplicationType, ApplicationTypes ,$http)->
    $rootScope.hiddenLeftMenu = true

    ApplicationList.query().then ((application_list) ->
      $scope.application_list = application_list['applications']
    )

    $scope.application_types = []
    ApplicationTypes.query().then (application_types) ->
      _.each(application_types, (app_type) ->
        $scope.application_types.push(new ApplicationType(app_type.id, app_type.name))
      )
      $scope.$on '$viewContentLoaded', ->
        init_drags($scope)

    $scope.submit = ->
      $http.post('/api/experiments/app_categorization.json', {result: $scope.application_types})
])

