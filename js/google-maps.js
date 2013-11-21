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
      console.log("googleMaps scope, element, attrs");
      console.log(scope); console.log(element); console.log(attrs);

      var canvas = attrs.canvasId;
      // check for mandatory parameters
      if(!canvas) {
        console.error("Mandatory attributes not configured for initializing a Google Maps canvas");
        return;
      }

      var maps = scope.$parent.maps || {};
      scope.$watch('center', function(center) {
        if(center) {
          var map = new google.maps.Map(element[0], {
            zoom: parseInt(scope.zoom),
            center: new google.maps.LatLng(center.lat, center.lng)
            //center: new google.maps.LatLng(47.626117, -122.332817)
          });
          maps[canvas] = map;
        }
        scope.$parent.maps = maps;
      });

      element.on('$destroy', function() {
        scope.$parent.maps[canvas] = null;
      });
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
      //console.log("marker scope, element, attrs");
      //console.log(scope); console.log(element); console.log(attrs);

      var canvas = attrs.canvas;
      if(!canvas) {
        console.error("Mandatory attributes not configured for initializing a Google Maps canvas");
        return;
      }

      var map = scope.$parent.maps[canvas];
      // the map canvas hasn't been initialized yet.. watch the pot until it boils
      if(!map) {
        var watch = scope.$parent.$watch('maps', function(maps) {
          map = maps[canvas];
          if(map) {
            watch();
            createMarker();
          }
        });
      }
      else {
        createMarker();
      }

      function createMarker() {
        //var coord = scope.coord;
        var coord = scope.$parent.restaurant.coordinates; 
        var marker = new google.maps.Marker({
          position: new google.maps.LatLng(coord.lat, coord.lng),
          map: map
        });
        element.on('$destroy', function() {
          console.log('marker destroyed');
          marker.setMap(null);
        });
      }
    };
  });

})();
