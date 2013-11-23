var primeControllers = angular.module('primeControllers', []);

//primeControllers.controller('PrimeListCtrl', ['$scope', '$http', function($scope, $http) {
primeControllers.controller('PrimeListCtrl',
  function($scope, $http) {
    $http.get('js/restaurants.json').success(function(restaurants) {
      $scope.restaurants = restaurants;
      $scope.seattle = { lat: 47.626117, lng:-122.332817 };
    });

    $scope.moveToTop = function(anchor) {
      console.log("Moving list to " + anchor);
      $('#listPane').animate({
        scrollTop: $('#' + anchor).position().top
      }, 500);
    }
  });

primeControllers.controller('PrimeDetailCtrl',
  function($scope, $http, $routeParams, $filter) {
    $http.get('js/restaurants.json').success(function(restaurants) {
      var id = $routeParams.id;
      $scope.restaurant = $filter('filter')(restaurants, {id : id}, true)[0];
    });
  });
