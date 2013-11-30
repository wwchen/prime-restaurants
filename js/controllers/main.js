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
      isPaneCollapsed: true
    });


    $http.get('data/restaurants.json').success(function (restaurants) {
      angular.forEach(restaurants, function (r) {
        r.click = function () {
          moveToTop(r.id);
          changeDetailPane(r); // no worky, because of scope
        };
      });
      $scope.restaurants = restaurants;
      $scope.switchModel = changeDetailPane;

      // filter and save the results when user types to query
      $scope.$watch('query', function (newValue, oldValue) {
        //var filtered = $filter('filter')($scope.restaurants, newValue);
        var filtered = $scope.filteredRestaurants = JSON.parse(JSON.stringify($scope.restaurants));
        if(!newValue) { return; }
        for (var id in filtered) {
          if (filtered[id].name.toLowerCase().search (newValue.toLowerCase()) < 0) {
            delete filtered[id];
          }
        }
        console.log('query: ' + newValue);
      });
    });

    var moveToTop = function(anchor) {
      var container = $('#listContainer');
      var scroll = container.scrollTop() + $('#' + anchor).position().top;
      console.log('Moving list to ' + anchor + ' by ' + scroll);

      container.animate({
        scrollTop: scroll
      }, 500);
    };

    var changeDetailPane = function(restaurant) {
      var collapsePane = false;
      console.log('Changing detail pane to ' + restaurant.name);
      if($scope.r == restaurant) {
        collapsePane = !$scope.isPaneCollapsed;
      }
      $scope.isPaneCollapsed = collapsePane;
      $scope.r = restaurant;
    };
  });
