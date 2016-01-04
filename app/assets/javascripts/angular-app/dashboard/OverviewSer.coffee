angular.module('wpc').service('Overview', [
  'railsResourceFactory',
  (railsResourceFactory) ->
    return railsResourceFactory({
      url: '/api/dashboards/overview',
      name: 'dashboards'
    });

])
