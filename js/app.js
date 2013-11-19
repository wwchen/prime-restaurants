var primeApp = angular.module('primeApp', [
  'ngRoute',
  'primeControllers',
]);

primeApp.config(['$routeProvider', function($routeProvider) {
  $routeProvider.
    when('/map', {
      templateUrl: 'partials/map.html',
      controller: 'PrimeListCtrl'
    }).
    when('/restaurant/:id', {
      templateUrl: 'partials/detail.html',
      controller: 'PrimeDetailCtrl'
    }).
    otherwise({
      redirectTo: '/map'
    });
}]);
