angular.module('wpc').controller("ExperimentCtrl", [
  '$scope', '$rootScope', 'ApplicationList', 'ApplicationType',
  ($scope, $rootScope, ApplicationList, ApplicationType)->
    $rootScope.hiddenLeftMenu = true

    ApplicationList.query().then ((application_list) ->
      $scope.application_list = application_list['applications']
    )

    $scope.$on '$viewContentLoaded', ->
      init_drags($scope)
    $scope.application_types = [
      new ApplicationType('bucket-adult', 'Adult content'),
      new ApplicationType('bucket-news', 'News'),
      new ApplicationType('bucket-commercial', 'Commercial'),
      new ApplicationType('bucket-educational', 'Educational, Research'),
      new ApplicationType('bucket-discussion', 'Discussion'),
      new ApplicationType('bucket-personal', 'Personal'),
      new ApplicationType('bucket-leisure', 'Leisure'),
      new ApplicationType('bucket-multimedia', 'Multimedia'),
      new ApplicationType('bucket-other', 'Other'),

    ]


])

init_drags = (scope)->
  interact('[id^=bucket]').dropzone({
    overlap: 'pointer',
    ondropactivate: (event) ->
# add active dropzone feedback
      event.target.classList.add('drop-active')
    ,
    ondragenter: (event) ->
      draggableElement = event.relatedTarget
      dropzoneElement = event.target;

      #    feedback the possibility of a drop
      dropzoneElement.classList.add('drop-target')
      draggableElement.classList.add('can-drop')
    ,
    ondragleave: (event) ->
# remove the drop feedback style
      event.target.classList.remove('drop-target')
      event.relatedTarget.classList.remove('can-drop')
    ,
    ondrop: (event) ->
      draggableElement = event.relatedTarget
      dropzoneElement = event.target

      app_id = parseInt($(draggableElement).attr('data-app-id'))
      app = _.findWhere(scope.application_list, {id: app_id})
      bucket_id = $(dropzoneElement).attr('id')
      bucket = _.findWhere(scope.application_types, {id: bucket_id})
      bucket.addApp(app)
      scope.$apply();

      $(draggableElement).hide()
    ,
    ondropdeactivate: (event) ->
# remove active dropzone feedback
      event.target.classList.remove('drop-active')
      event.target.classList.remove('drop-target')
  })
