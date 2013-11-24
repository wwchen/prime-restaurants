'use strict';

angular.module('primeRestaurantsApp')
  .controller('DetailCtrl', function ($scope, $http, $routeParams, $filter) {
    $scope.coord = { latitude: 47.626117, longitude: -122.332817 };

    $http.get('data/restaurants.json').success(function (restaurants) {
      var id = $routeParams.id;
      $scope.restaurant = $filter('filter')(restaurants, {id : id}, true)[0];
      $scope.coord = $scope.restaurant.coordinates;
    });
    console.log($scope);
  });

