'use strict';

angular.module('primeRestaurantsApp')
  .controller('DetailCtrl', function ($scope, $http, $routeParams, $filter) {
    $http.get('data/restaurants.json').success(function (restaurants) {
      var id = $routeParams.id;
      $scope.restaurant = $filter('filter')(restaurants, {id : id}, true)[0];
    });
  });

