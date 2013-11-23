'use strict';

angular.module('primeRestaurantsApp')
  .controller('MainCtrl', function ($scope, $http) {
    $http.get('data/restaurants.json').success(function (restaurants) {
      $scope.restaurants = restaurants;
      $scope.seattle = { lat: 47.626117, lng:-122.332817 };
    });
  });
