'use strict';

angular.module('primeRestaurantsApp')
  .controller('MainCtrl', function ($scope, $http) {
    angular.extend($scope, {
      seattle: { latitude: 47.626117, longitude: -122.332817 },
      map: {
        center: $scope.seattle,
        zoom: 10,
        events: {
        }
      },
    });

    $http.get('data/restaurants.json').success(function (restaurants) {
      $scope.restaurants = restaurants;
      console.log($scope);
    });

    $scope.log = function() {
      console.log('hello');
    };

    $scope.moveToTop = function(anchor) {
      var container = $('#listContainer');
      var scroll = container.scrollTop() + $('#' + anchor).position().top;
      console.log('Moving list to ' + anchor + ' by ' + scroll);

      container.animate({
        scrollTop: scroll
      }, 500);
    };
  });
