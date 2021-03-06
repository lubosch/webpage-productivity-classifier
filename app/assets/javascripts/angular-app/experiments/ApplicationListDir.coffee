angular.module('wpc').directive 'experimentApplicationList', ->
  return {
  restrict: 'A',
  templateUrl: 'assets/angular-app/experiments/application_list.html'
  link: (scope, elm, attr)->
    makeit_draggable(elm)
#    elm.draggable()
#    init_drags()
  }


makeit_draggable = (el) ->
#  debugger
  interact(el.children()[0]).draggable({
#  enable inertial throwing
    inertia: true,
#  keep the element within the area of it's parent
#    restrict: {
#      restriction: "parent",
#      endOnly: true,
#      elementRect: {top: 0, left: 0, bottom: 1, right: 1}
#    },
    autoScroll: false,

    onmove: dragMoveListener,
# call this function on every dragend event
});

dragMoveListener = (event) ->
  target = event.target
  # keep the dragged position in the data-x/data-y attributes
  x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx
  y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy

  # translate the element
  target.style.webkitTransform = target.style.transform = 'translate(' + x + 'px, ' + y + 'px)'

  # update the posiion attributes
  target.setAttribute('data-x', x)
  target.setAttribute('data-y', y)
