// a custom direction <div restaurant-details></div>
// template is partials/detail.html

"use strict";

angular.module('restaurantDetails', [])
.directive('restaurantDetails', function () {
  return {
    restrict: 'AC', // attribute or class
    replace: false,
    templateUrl: 'partials/detail.html',
    scope: {
      restaurant: '=model'
    },
    link: function ($scope, $element, $attrs) {
      $scope.$watch('restaurant', function() {
            console.log('loaded');
      });
    }
  }
});
