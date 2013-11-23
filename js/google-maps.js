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
      //console.log("googleMaps scope, element, attrs");
      //console.log(scope); console.log(element); console.log(attrs);

      var canvas = attrs.canvasId;
      var zoom = parseInt(attrs.zoom);
      // check for mandatory parameters
      if(!canvas || !zoom) {
        console.error("Mandatory attributes not configured for initializing a Google Maps canvas");
        return;
      }

      var maps = scope.$parent.maps || {};
      scope.$watch('center', function(center) {
        if(center) {
          var map = new google.maps.Map(element[0], {
            zoom: zoom,
            center: new google.maps.LatLng(center.lat, center.lng)
            //center: new google.maps.LatLng(47.626117, -122.332817)
          });
          maps[canvas] = map;
        }
        scope.$parent.maps = maps;
      });

      console.log("canvas created");
      element.on('$destroy', function() {
        scope.$parent.maps[canvas] = null;
        console.log("canvas destroyed");
      });
    };
  });

  module.directive('marker', function() {
    return {
      restrict: 'E',
      scope: {
        coord: '=coordinates',
        click: '&',
        hover: '&'
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

      // the map canvas hasn't been initialized yet.. watch the pot until it boils
      var watch = scope.$parent.$watch(
        // NOTE hackish. background info: maps is an object, but it starts off as undefined.
        // The watcher gets invoked when it changes from undefined to object, but not after a new
        // key is inserted to the object -- the watcher is invoked by reference. There is a boolean
        // to check equality by value, however it runs into an infinite loop with this maps
        // object... This leaves me with one option -- making my own watch expression. I return the
        // size of the object, -1 for undefined
        function() {
          var maps = scope.$parent.maps;
          return maps ? Object.keys(maps).length : -1;
        },
        function(length) {
          var maps = scope.$parent.maps;
          if(length > 0 && maps[canvas]) { createMarker(); watch(); }
      });


      function createMarker() {
        var map = scope.$parent.maps[canvas];
        var coord = scope.$parent.restaurant.coordinates; 
        var marker = new google.maps.Marker({
          position: new google.maps.LatLng(coord.lat, coord.lng),
          map: map
        });
        console.log('marker created');

        // events
        google.maps.event.addListener(marker, 'click', scope.click);
        google.maps.event.addListener(marker, 'click', scope.hover);

        // destroy
        element.on('$destroy', function() {
          marker.setMap(null);
          console.log('marker destroyed');
        });
      }
    };
  });
})();
