angular.module('wpc').controller("DashboardCtrl", [
  '$scope', 'Overview', 'VisDataSet',
  ($scope, Overview, VisDataSet)->
    Overview.query({period: 'day'}).then ((overview) ->
      overviewOptions = {
        "align": "center",
        "autoResize": true,
        "selectable": true,
        "orientation": "bottom",
        "showCurrentTime": true,
        "showMajorLabels": true,
        "showMinorLabels": true
        zoomMax: 86400000
        "stack": false
      }
#
      dsg = new VisDataSet()
      dsg.add (overview['groups'])

      dsi = new VisDataSet()
      dsi.add (overview['data'])

      $scope.overview = {items: dsi, groups: dsg}
      $scope.overviewOptions = overviewOptions
      $scope.overviewLoaded = true


#      container = document.getElementById('vis-timeline')

#      items = new vis.DataSet(overview['overview'])
#        [
#        {id: 1, content: 'item 1', start: '2013-04-20'},
#        {id: 2, content: 'item 2', start: '2013-04-14'},
#        {id: 3, content: 'item 3', start: '2013-04-18'},
#        {id: 4, content: 'item 4', start: '2013-04-16', end: '2013-04-19'},
#        {id: 5, content: 'item 5', start: '2013-04-25'},
#        {id: 6, content: 'item 6', start: '2013-04-27'}
#      ])

#      timeline = new vis.Timeline(container, items, overviewOptions);

    )
    $scope.exampleValue = "Hello angular and rails"
])