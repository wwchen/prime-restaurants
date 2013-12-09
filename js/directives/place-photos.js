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
      fitContainer: '@fitContainerClass',
      maxHeight: '@',
      maxWidth: '@'
    },
    link: function ($scope) {
      $scope.$watch('model', function(m) {
        if(m) {
          var width = $scope.maxWidth;
          var height = $scope.maxHeight;
          var param = {};
          if (width)  { param.maxWidth = width; }
          if (height) { param.maxHeight = height; }

          if($scope.fitContainer) {
            var element = $($scope.fitContainer);
            param.maxWidth = element.width();
            param.maxHeight = element.height();
          }
          $scope.src = m.getUrl(param);
        }
      });
    }
  }
});
