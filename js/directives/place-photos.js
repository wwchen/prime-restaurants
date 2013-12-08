"use strict";

// https://developers.google.com/maps/documentation/javascript/reference#PlaceResult
// https://developers.google.com/maps/documentation/javascript/examples/place-details
angular.module('placePhotosDirective', [])
.directive('placePhotos', function () {
  return {
    restrict: 'E', // element only
    replace: true,
    template: '<img ng-src="{{src}}" />',
    scope: {
      model: '=',
      maxSize: '@'
    },
    link: function ($scope) {
      $scope.$watch('model', function(m) {
        if(m) {
          var size = $scope.maxSize || 300;
          $scope.src = m.getUrl({maxWidth: size, maxHeight: size});
        }
      });
    }
  }
});
