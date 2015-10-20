angular.module('wpc').controller("ExperimentCtrl", [
  '$scope', 'ApplicationList', 'ApplicationType',
  ($scope, ApplicationList, ApplicationType)->
    ApplicationList.query().then ((application_list) ->
      $scope.application_list = application_list['applications']
    )

    $scope.$on '$viewContentLoaded', init_drags
    $scope.application_types = [
      ApplicationType.new('bucket-adult', 'Adult content'),
      ApplicationType.new('bucket-news', 'News'),
      ApplicationType.new('bucket-commercial', 'Commercial'),
      ApplicationType.new('bucket-educational', 'Educational, Research'),
      ApplicationType.new('bucket-discussion', 'Discussion'),
      ApplicationType.new('bucket-personal', 'Personal'),
      ApplicationType.new('bucket-leisure', 'Leisure'),
      ApplicationType.new('bucket-multimedia', 'Multimedia'),
      ApplicationType.new('bucket-other', 'Other'),

    ]


])

init_drags = ->
  interact('[id^=bucket]').dropzone({
    overlap: 0.25,
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
    ,
    ondropdeactivate: (event) ->
# remove active dropzone feedback
      event.target.classList.remove('drop-active')
      event.target.classList.remove('drop-target')
  })
