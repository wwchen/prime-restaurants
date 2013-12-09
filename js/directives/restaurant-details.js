// a custom direction <div restaurant-details></div>
// template is partials/detail.html

"use strict";

angular.module('restaurantDetails', ['dollarFilter', 'placePhotosDirective'])
.directive('restaurantDetails', function () {
  return {
    restrict: 'AC', // attribute or class
    replace: false,
    templateUrl: 'partials/detail.html',
    scope: {
      restaurant: '=model',
      mapModel: '='
    },
    link: function ($scope) {
      $scope.Math = window.Math;

      $scope.$watch('restaurant', function(res) {
        getPlaceDetails();
      });

      var getPlaceDetails = function() {
        var map = $scope.mapModel;
        var res = $scope.restaurant;
        $scope.details = null;
        if(map !== -1 && res && res.gplaces_ref) {
          var service = new google.maps.places.PlacesService(map);
          var request = { reference: res.gplaces_ref };
          service.getDetails(request, function(place, status) {
            if (status == google.maps.places.PlacesServiceStatus.OK) {
              // the meat of everything
              console.log('details gotten');
              $scope.details = place;
            }
          });

        }
      };
    }
  }
});
