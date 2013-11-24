angular.module('primeRestaurantsApp', [
  'ngRoute',
  'primeControllers',
  'googleMaps'
])

.config(function($routeProvider) {
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
});
