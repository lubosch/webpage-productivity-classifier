angular.module('wpc').service('ApplicationTypes', [
  'railsResourceFactory',
  (railsResourceFactory) ->
    return railsResourceFactory({
      url: '/api/experiments/application_types',
      name: 'applicationTypes'
    });

])
