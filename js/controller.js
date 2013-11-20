var primeControllers = angular.module('primeControllers', []);

//primeControllers.controller('PrimeListCtrl', ['$scope', '$http', function($scope, $http) {
primeControllers.controller('PrimeListCtrl',
  function($scope, $http) {
    $http.get('js/restaurants.json').success(function(data) {
      $scope.restaurants = data;
      var element = document.getElementById('map-canvas');
      var options = {
        zoom: 10,
        center: new google.maps.LatLng(47.626117, -122.332817)
      }
      $scope.map = new google.maps.Map(element, options);
    });
  });

primeControllers.controller('PrimeDetailCtrl',
  function($scope, $http, $routeParams, $filter) {
    $http.get('js/restaurants.json').success(function(data) {
      var id = $routeParams.id;
      var restaurants = data;
      $scope.restaurant = $filter('filter')(restaurants, {id : id}, true)[0];
    });
  });
