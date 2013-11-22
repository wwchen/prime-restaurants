var primeControllers = angular.module('primeControllers', []);

//primeControllers.controller('PrimeListCtrl', ['$scope', '$http', function($scope, $http) {
primeControllers.controller('PrimeListCtrl',
  function($scope, $http) {
    $http.get('js/restaurants.json').success(function(data) {
      $scope.restaurants = data;
      $scope.seattle = {lat: 47.626117, lng:-122.332817};
    });
  });

primeControllers.controller('PrimeDetailCtrl',
  function($scope, $http, $routeParams, $filter) {
    $http.get('js/restaurants.json').success(function(data) {
      var id = $routeParams.id;
      var restaurants = data;
      $scope.restaurant = $filter('filter')(restaurants, {id : id}, true)[0];
      $scope.seattle = {lat: 47.626117, lng:-122.332817};
    });
  });
