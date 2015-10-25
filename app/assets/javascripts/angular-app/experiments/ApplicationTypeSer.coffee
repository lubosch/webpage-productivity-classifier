angular.module('wpc').factory('ApplicationType',
  () ->
    ApplicationType = (id, text) ->
      @id = id
      @text = text
      @application_pages = []
      return

    ApplicationType.prototype = {
      addApp: (app) ->
        @application_pages.push(app)
      ,
      removeApp: (app) ->
        @application_pages = _.reject(@application_pages, (item)->
          item.id == app.id
        )
        $('#experiment-draggable-' + app.id).show()
        $('#experiment-draggable-' + app.id).removeAttr('style')
        return

    }
    return ApplicationType
)
