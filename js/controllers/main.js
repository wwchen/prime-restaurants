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
      isPaneCollapsed: true,
      restaurantsByPromo: {},
      restaurants: {},
      promoSelect: null,
      mapObject: {}
    });


    $http.get('data/restaurants.json').success(function (restaurants) {
      angular.forEach(restaurants, function (r) {
        r.click = function () {
          moveToTop(r.id);
          changeDetailPane(r); // no worky, because of scope
        };

        // create a reverse object that maps promos to restaurant ids
        angular.forEach(r.promotions, function (p) {
          var array = $scope.restaurantsByPromo[p] || [];
          array.push(r.id);
          $scope.restaurantsByPromo[p] = array;
        });
      });
      $scope.restaurants = restaurants;
      $scope.switchModel = changeDetailPane;

      // filter and save the results when user types to query
      $scope.$watch('query', function (newValue, oldValue) {
        //var filtered = $filter('filter')($scope.restaurants, newValue);
        if(!newValue) { $scope.filteredRestaurants = $scope.restaurants; return; }
        $scope.filteredRestaurants = {};
        angular.forEach ($scope.restaurants, function (r) {
          if (r.name.toLowerCase().search (newValue.toLowerCase()) >= 0) {
            $scope.filteredRestaurants[r.id] = r;
          }
        });
        console.log('query: ' + newValue);
      });

      $scope.$watch('promoSelect', function (newValue, oldValue) {
        if (!newValue) { $scope.filteredRestaurants = $scope.restaurants; return; }
        $scope.filteredRestaurants = {};
        // newValue is an array of restaurant ids
        angular.forEach (newValue, function (id) {
          $scope.filteredRestaurants[id] = $scope.restaurants[id];
        });
      });

      $scope.$watch('mapObject', function (map) {
        console.log('map');
        console.log(map);
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
      
      // reset the main map to show only the restaurant
      // TODO creating another latlng object. can we reuse the one we created for markers?
      var latlng = new google.maps.LatLng(restaurant.lat, restaurant.lng);
      $scope.mapObject.setCenter(latlng);
      $scope.mapObject.setZoom(collapsePane ? 10 : 18);
    };
  });
