var primeControllers = angular.module('primeControllers', []);

//primeControllers.controller('PrimeListCtrl', ['$scope', '$http', function($scope, $http) {
primeControllers.controller('PrimeListCtrl', function($scope, $http) {
  $http.get('js/restaurants.json').success(function(data) {
    $scope.restaurants = data;
  });
});

primeControllers.controller('PrimeDetailCtrl', function($scope, $http, $routeParams, $filter) {
  $http.get('js/restaurants.json').success(function(data) {
    var id = parseInt($routeParams.id);
    var restaurants = data;
    $scope.restaurant = $filter('filter')(restaurants, {id : id}, true);
  });

});
