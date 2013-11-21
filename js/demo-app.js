(function() {
  "use strict";

  var demoApp = angular.module('demoApp', [
    'googleMaps'
  ]);

  demoApp.controller('demoCtrl', function($scope) {
    $scope.canvas = {};
  });

})();
