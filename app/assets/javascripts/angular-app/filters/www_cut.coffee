angular.module('wpc').filter('wwwCut', ->
  return (input) ->
    re = /^www /i
    return input.replace(re, '')
)