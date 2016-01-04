angular.module('wpc').controller("DashboardCtrl", [
  '$scope', 'Overview', 'WordsCloud', 'VisDataSet',
  ($scope, Overview, WordsCloud, VisDataSet)->
    Overview.query({period: 'day'}).then ((overview) ->
      overviewOptions = {
        align: "center",
        autoResize: true
        selectable: true
        orientation: "bottom"
        showCurrentTime: true
        showMajorLabels: true
        showMinorLabels: true
        zoomMax: 3600000
        stack: false
        start: Date.now() - 3600000
        end: Date.now()
      }
      #
      overview['data'].forEach (item)->
        item.start = vis.moment.utc(item.start).local()
        item.end = vis.moment.utc(item.end).local()

      dsg = new VisDataSet()
      dsg.add (overview['groups'])

      dsi = new VisDataSet()
      dsi.add (overview['data'])

      $scope.overview = {items: dsi, groups: dsg}
      $scope.overviewOptions = overviewOptions
      $scope.overviewLoaded = true

    )

    WordsCloud.query({period: 'day'}).then (data) ->
      $scope.words = data
#      $.each(data, (id, obj) ->
#        $scope.words.push({text: obj.text, weight: obj.weight})
#      )
      return
])