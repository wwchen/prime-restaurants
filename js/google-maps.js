(function() {
  "use strict";

  var module = angular.module('googleMaps', []);

  module.directive('googleMaps', function() {
    return {
      restrict: 'E', // only match element name
      replace: true,
      template: '<div style="width: 100%; height: 100%"></div>',
      scope: {
        center: '=',
        zoom: '@'
      },
      link: link
    };

    function link(scope, element, attrs) {
      scope.$parent.maps = scope.$parent.maps || {};

      var map = new google.maps.Map(element[0], {
        zoom: parseInt(scope.zoom),
        //center: new google.maps.LatLng(scope.center.lat, scope.center.lng)
        center: new google.maps.LatLng(47.626117, -122.332817)
      });
      scope.$parent.maps[attrs.canvasId] = map;

      element.on('$destroy', function() {
        map = null;
      });
      console.log(map);
    };
  });

  module.directive('marker', function() {
    return {
      restrict: 'E',
      scope: {
        coord: '=coordinates'
      },
      link: link
    }

    function link(scope, element, attrs) {
      var map = scope.$parent.maps[attrs.canvas];
      //var coord = scope.coord;
      var coord = scope.$parent.restaurant.coordinates; 
      console.log(scope.$parent.restaurant.name);
      console.log(coord);
      var marker = new google.maps.Marker({
        position: new google.maps.LatLng(coord.lat, coord.lng),
        map: map
      });
      element.on('$destroy', function() {
        console.log('destroyed');
        marker.setMap(null);
      });
    };
  });

})();
