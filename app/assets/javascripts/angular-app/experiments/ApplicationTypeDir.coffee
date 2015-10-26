angular.module('wpc').directive 'experimentApplicationType', ->
  return {
  restrict: 'A',
  templateUrl: 'assets/angular-app/experiments/application_type.html'
  link: (scope, elm, attr)->
    makeit_dropable(elm, scope)
  }

makeit_dropable = (el, scope) ->
#  debugger
  interact(el.children().children()[0]).dropzone({
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
      bucket_id = parseInt($(dropzoneElement).attr('id'))
      bucket = _.findWhere(scope.application_types, {id: bucket_id})
      bucket.addApp(app)
      scope.$apply();

      draggableElement.classList.add('invisible')
    ,
    ondropdeactivate: (event) ->
# remove active dropzone feedback
      event.target.classList.remove('drop-active')
      event.target.classList.remove('drop-target')
  })

