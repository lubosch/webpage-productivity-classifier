angular.module('wpc').controller("DashboardCtrl", [
  '$scope', 'Overview', 'Spiral', 'WordsCloud', 'VisDataSet', '$compile', '$filter', 'wwwCutFilter', '$sce',
  ($scope, Overview, Spiral, WordsCloud, VisDataSet, compile, $filter, wwwCutFilter, $sce)->
    morning_date = new Date()
    if morning_date.getHours() >= 5
      morning_date.setHours(5)
    else
      morning_date.setHours(5)
      morning_date.setDate(morning_date.getDate() - 1)

    $scope.datePicker = {startDate: morning_date, endDate: new Date(), maxDate: new Date()};

    $scope.$watch('datePicker', ()->
      date_changed()
    )

    $scope.weights = {text: 0.1, description: 0.8, header: 0.5, title: 1.0, duration: 60}

    date_changed = ->
      WordsCloud.query({start_day: $scope.datePicker.startDate, end_day: $scope.datePicker.endDate}).then (data) ->
        time_words = gather_time_words(data, $scope)
        timeline_data = gathet_timeline_data(time_words, compile, $scope)

        if (timeline_data.length > 0)
          $scope.words = time_words
          $scope.wordCloudTimeline = {items: (new VisDataSet(timeline_data))}
        else
          $scope.wordCloudTimeline = {
            items: new VisDataSet([{
              start: $scope.datePicker.startDate,
              end: $scope.datePicker.endDate,
              content: 'No activity logged at that time'
              className: 'unclassified'
            }])
          }

        $scope.wcTimelineOptions = {
          align: "center",
          autoResize: true
          selectable: true
          orientation: "bottom"
          showCurrentTime: true
          showMajorLabels: true
          showMinorLabels: true
          zoomMax: 3600000 * 6
          stack: false
        }
        return

      Overview.query({start_day: $scope.datePicker.startDate, end_day: $scope.datePicker.endDate}).then ((overview) ->
        overviewOptions = {
          align: "center",
          autoResize: true
          selectable: true
          orientation: "both"
          showCurrentTime: true
          showMajorLabels: true
          showMinorLabels: true
#          zoomMax: 3600000
          stack: false
#          start: Date.now() - 3600000
#          end: Date.now()
        }

        if overview['data'].length == 0
          overview['data'] = [{
            startAt: $scope.datePicker.startDate
            endAt: $scope.datePicker.endDate
            name: 'No activity logged at that time'
            applicationId: 999
          }]
          overview['groups'] = [{index: 0, id: 999, duration: 0, name: 'Nothing'}]

        overview['data'].forEach (item)->
          item.start = vis.moment.utc(item.startAt).local()
          item.end = vis.moment.utc(item.endAt).local()
          item.content = $sce.trustAsHtml(item.name)
          item.title = $sce.trustAsHtml(item.name)
          item.className = 'unclassified'
          item.group = item.applicationId

        overview['data'] = _.filter(overview['data'], (item) ->
          item.start < item.end
        )

        overview['groups'].forEach (item)->
          item.duration_nice = moment.duration(item.duration, 'seconds')
          item.content = $sce.trustAsHtml($filter('capitalize')(wwwCutFilter(item.name), 'all')) + ' (' + item.duration_nice.format() + ' )'
          item.order = item.index
          item.id = item.id

        dsg = new VisDataSet()
        dsg.add (overview['groups'])

        dsi = new VisDataSet()
        dsi.add (overview['data'])

        $scope.overview = {items: dsi, groups: dsg}
        $scope.overviewLoaded = true
        $scope.overviewOptions = overviewOptions
        return

      )

    $scope.spiraldata = {}

    Spiral.query(start_date: (new Date()).setDate((new Date()).getDate() - 30), end_date: new Date()).then (data) ->
      $scope.spiraldata = _.reduce(data, (memo, value, key) ->
        memo[new Date(key)] = value
        memo
      )

    $scope.spiral = {
      min_date: (new Date()).setDate((new Date()).getDate() - 30),
      max_date: new Date(),
      start_selected_date: (new Date()).setDate((new Date()).getDate() - 12)
      end_selected_date: new Date(),
    }
])

term_weight = (term_type, $scope) ->
  switch(term_type)
    when 'title'
      $scope.weights.title
    when 'header'
      $scope.weights.header
    when 'text'
      $scope.weights.text
    when 'description'
      $scope.weights.description
    else
      0.0


gather_time_words = (data, $scope) ->
  words = {}
  i = 0
  len = data.length
  while i < len
    uap = data[i]
    sk = moment(new Date(uap.createdAt)).format('YYYY-MM-DD HH:00')
    if(!words[sk])
      words[sk] = {}
    if(words[sk][uap.termId])
      act_term = words[sk][uap.termId]
      words[sk][uap.termId] = {
        count: act_term.count + 1,
        weight: act_term.weight + term_weight(uap.termType, $scope) * uap.length / $scope.weights.duration,
        text: uap.termText
      }
    else
      words[sk][uap.termId] = {
        count: 1,
        weight: term_weight(uap.termType, $scope) * uap.length / $scope.weights.duration,
        text: uap.termText
      }
    i += 1

  i = 0
  keys = Object.keys(words)
  len = keys.length
  while i < len
    time_keys = Object.keys(words[keys[i]])
    words[keys[i]] = time_keys.map (v)->
      return words[keys[i]][v]
    i += 1
  words

gathet_timeline_data = (time_words, compile, scope)->
  timeline_data = []
  keys = Object.keys(time_words)
  i = 0
  len = keys.length
  while i < len
    start_date = moment(keys[i], 'YYYY-MM-DD HH:mm')
    end_date = moment(start_date).hours(start_date.hours() + 1)
    if (start_date.isValid() && end_date.isValid())
      jqcloud = compile('<jqcloud words="words[\'' + keys[i] + '\']" steps=10 width=800 height=500 autoResize="true" shape="rectangular" />')(scope)
      timeline_data.push({id: i, content: jqcloud[0], start: start_date, end: end_date, className: 'unclassified'})
    i += 1
  timeline_data


