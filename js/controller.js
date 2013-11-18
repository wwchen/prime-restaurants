var primeApp = angular.module('primeApp', []);

primeApp.controller('PrimeListCtrl', function($scope, $http) {
  $http.get('restaurants.json').success(function(data) {
    $scope.restaurants = data;
  });
});
