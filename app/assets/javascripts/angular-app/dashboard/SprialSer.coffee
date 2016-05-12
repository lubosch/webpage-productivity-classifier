angular.module('wpc').service('Spiral', [
  'railsResourceFactory',
  (railsResourceFactory) ->
    return railsResourceFactory({
      url: '/api/dashboards/spiral',
      name: 'dashboards'
    });

])
