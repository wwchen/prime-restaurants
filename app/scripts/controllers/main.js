'use strict';

angular.module('primeRestaurantsApp')
  .controller('MainCtrl', function ($scope, $http) {
    angular.extend($scope, {
      seattle: { latitude: 47.626117, longitude: -122.332817 }
    });

    $http.get('data/restaurants.json').success(function (restaurants) {
      $scope.restaurants = restaurants;
    });
  });
