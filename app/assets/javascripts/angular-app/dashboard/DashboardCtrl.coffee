angular.module('wpc').controller("DashboardCtrl", [
  '$scope', 'Overview', 'WordsCloud', 'VisDataSet', '$compile',
  ($scope, Overview, WordsCloud, VisDataSet, compile)->
    morning_date = new Date()
    if morning_date.getHours >= 5
      morning_date.setHours(5)
    else
      morning_date.setHours(5)
      morning_date.setDate(morning_date.getDate() - 1)

    $scope.datePicker = {startDate: morning_date, endDate: new Date(), maxDate: new Date()};

    $scope.$watch('datePicker', ()->
      date_changed()
    )

    date_changed = ->
      WordsCloud.query({start_day: $scope.datePicker.startDate, end_day: $scope.datePicker.endDate}).then (data) ->
        time_words = gather_time_words(data)
        timeline_data = gathet_timeline_data(time_words, compile, $scope)


        if (timeline_data.length > 0)
          $scope.words = time_words
          $scope.wordCloudTimeline = {items: (new VisDataSet(timeline_data))}
        else
          $scope.wordCloudTimeline = {
            items: new VisDataSet([{
              start: $scope.datePicker.startDate,
              end: $scope.datePicker.endDate,
              content: 'No data'
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
          orientation: "bottom"
          showCurrentTime: true
          showMajorLabels: true
          showMinorLabels: true
#          zoomMax: 3600000
          stack: false
#          start: Date.now() - 3600000
#          end: Date.now()
        }

        overview['data'].forEach (item)->
          item.start = vis.moment.utc(item.start).local()
          item.end = vis.moment.utc(item.end).local()

        dsg = new VisDataSet()
        dsg.add (overview['groups'])

        dsi = new VisDataSet()
        dsi.add (overview['data'])

        if(dsi.length > 0)
          $scope.overview = {items: dsi, groups: dsg}
          $scope.overviewLoaded = true
        else
          $scope.overview = {
            items: new VisDataSet([{
              start: $scope.datePicker.startDate,
              end: $scope.datePicker.endDate,
              content: 'No data'
            }])
          }
        $scope.overviewOptions = overviewOptions
        return

      )

])

term_weight = (term_type) ->
  switch(term_type)
    when 'title'
      1.0
    when 'header'
      0.5
    when 'text'
      0.1
    when 'description'
      0.8
    else
      0.0


gather_time_words = (data) ->
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
        weight: act_term.weight + term_weight(uap.termType) * uap.length / 100.0,
        text: uap.termText
      }
    else
      words[sk][uap.termId] = {count: 1, weight: term_weight(uap.termType) * uap.length / 100.0, text: uap.termText}
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
      jqcloud = compile('<jqcloud words="words[\'' + keys[i] + '\']" steps=5 width=500 height=300 autoResize="true" shape="rectangular" />')(scope)
      timeline_data.push({id: i, content: jqcloud[0], start: start_date, end: end_date})
    i += 1
  timeline_data


