angular.module('wpc').service('ApplicationList', [
  'railsResourceFactory',
  (railsResourceFactory) ->
    return railsResourceFactory({
      url: '/api/experiments/application_list',
      name: 'applicationList'
    });

])
