angular.module('wpc').service('ApplicationType', [
  () ->
    id = ''
    name = ''

    return {
    new: (id, text)->
      return {
      id: id,
      text: text
      application_pages: []
      }
    }
])
