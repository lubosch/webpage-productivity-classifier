angular.module('wpc').controller("ExperimentCtrl", [
  '$scope', '$rootScope', 'ApplicationList', 'ApplicationType', 'ApplicationTypes', '$http',
  ($scope, $rootScope, ApplicationList, ApplicationType, ApplicationTypes, $http)->
    $rootScope.hiddenLeftMenu = true

    ApplicationList.query().then ((application_list) ->
      $scope.application_list = application_list['applications']
    )

    $scope.application_types = [new ApplicationType(1, 'name')]
    ApplicationTypes.query().then (application_types) ->
      $scope.application_types = []
      _.each(application_types, (app_type) ->
        $scope.application_types.push(new ApplicationType(app_type.id, app_type.name))
      )
      $scope.$on '$viewContentLoaded', ->
        init_drags($scope)

    $scope.submit = ->
      $http.post('/api/experiments/app_categorization.json', {result: $scope.application_types}).then ->
        $scope.exp_success = true

    $scope.set_working_app = (id) ->
      app = _.findWhere($scope.application_list, {id: id})
      app['is_work'] = true

    $scope.unset_working_app = (id) ->
      app = _.findWhere($scope.application_list, {id: id})
      app['is_work'] = null

    $scope.set_non_working_app = (id) ->
      app = _.findWhere($scope.application_list, {id: id})
      app['is_work'] = false


    $scope.intro_options = {
      steps: [
        {
          element: '[data-app-id]',
          intro: "Drag and Drop the application to one of the green buckets based on type of the application"
        },
        {
          element: '.thumbs-space',
          intro: "Select thumb up if the the application is related to work. Select thumb down if the application is not related to work. You can click on the thumbs also in the green buckets"
        },
        {
          element: '[data-app-type-id]',
          intro: "Drag and Drop the applications to one of these green buckets"
        }
      ],
      showStepNumbers: false,
      exitOnOverlayClick: true,
      exitOnEsc: true,
      nextLabel: '<strong>Next</strong>',
      prevLabel: '<span style="color:green">Previous</span>',
      showProgress: true,
      skipLabel: 'Exit',
      doneLabel: 'Thanks'
    }

])

