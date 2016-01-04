angular.module('wpc').controller("DashboardCtrl", [
  '$scope', 'Overview', 'VisDataSet',
  ($scope, Overview, VisDataSet)->
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
      dsg = new VisDataSet()
      dsg.add (overview['groups'])

      dsi = new VisDataSet()
      dsi.add (overview['data'])

      $scope.overview = {items: dsi, groups: dsg}
      $scope.overviewOptions = overviewOptions
      $scope.overviewLoaded = true

    )
])