(function() {
  "use strict";

  var module = angular.module('googleMaps', []);

  module.directive('googleMaps', function() {
    return {
      restrict: 'E', // only match element name
      link: link
    };

    function link(scope, element, attrs) {
      scope.maps = scope.maps || {};

      var map = new google.maps.Map(element[0], {
        zoom: 10,
        center: new google.maps.LatLng(47.626117, -122.332817)
      });
      scope.maps[attrs.canvasId] = map;

      element.css({
        display: 'block',
        width: '100%',
        height: '100%'
      })
      element.on('$destroy', function() {
        map = null;
      });
    };
  });

  module.directive('marker', function() {
    return {
      restrict: 'E',
      link: link
    }

    function link(scope, element, attrs) {
      var map = scope.maps[attrs.canvas];
      var marker = new google.maps.Marker({
        position: new google.maps.LatLng(attrs.lat, attrs.lng),
        map: map
      });
      element.on('$destroy', function() {
        console.log('destroyed');
        marker.setMap(null);
      });
    };
  });

})();
