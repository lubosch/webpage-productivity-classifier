angular.module('wpc').service('WordsCloud', [
  'railsResourceFactory',
  (railsResourceFactory) ->
    return railsResourceFactory({
      url: '/api/dashboards/words_cloud',
      name: 'words_cloud'
    });

])
