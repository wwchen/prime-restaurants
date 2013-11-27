'use strict';

angular.module('primeRestaurantsApp')
.controller('MainCtrl',
  function ($scope, $http, $filter) {
    angular.extend($scope, {
      filteredRestaurants: [],
      map: {
        center: { lat: 47.626117, lng: -122.332817 },
        zoom: 10,
      },
      isPaneOpen: true
    });

    $http.get('data/restaurants.json').success(function (restaurants) {
      angular.forEach(restaurants, function (r) {
        r.click = function() { moveToTop(r.id) };
      });
      $scope.restaurants = restaurants;

      // filter and save the results when user types to query
      $scope.$watch('query', function (newValue, oldValue) {
        var filtered = $filter('filter')($scope.restaurants, newValue);
        $scope.filteredRestaurants = filtered;
        console.log('query: ' + newValue);
      });
    });

    var moveToTop = function(anchor) {
      console.log("move to top clicked");
      var container = $('#listContainer');
      var scroll = container.scrollTop() + $('#' + anchor).position().top;
      console.log('Moving list to ' + anchor + ' by ' + scroll);

      container.animate({
        scrollTop: scroll
      }, 500);
    };

    $scope.switchModel = function(restaurant) {
      if($scope.r == null || $scope.r == restaurant) {
        $scope.isPaneOpen = !$scope.isPaneOpen;
      }
      $scope.r = restaurant;
    };
  });
