'use strict';

angular.module('primeRestaurantsApp')
  .controller('MainCtrl', function ($scope, $http, $filter) {
    angular.extend($scope, {
      filteredRestaurants: [],
      map: {
        center: { latitude: 47.626117, longitude: -122.332817 },
        zoom: 10,
        events: {
        },
        markers: []
      },
    });

    $http.get('data/restaurants.json').success(function (restaurants) {
      $scope.restaurants = restaurants;
      console.log($scope);

      // filter and save the results when user types to query
      $scope.$watch('query', function (newValue, oldValue) {
        var filtered = $filter('filter')($scope.restaurants, newValue);
        $scope.filteredRestaurants = filtered;
        console.log('query: ' + newValue);
      });
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
