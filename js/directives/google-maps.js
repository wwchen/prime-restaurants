"use strict";

angular.module('googleMaps', [])

.directive('googleMaps', function() {
  return {
    restrict: 'E', // only match element name
    replace: true,
    transclude: true,
    template: '<div style="height: 100%" ng-transclude></div>',
    scope: {
      center: '=',
      zoom: '=',
      fitBounds: '@',
      boundsChange: '&'
    },
    controller: function ($scope, $element, $attrs) {
      this.getMap = function() {
        return $scope.map;
      };

      this.fitBounds = function(latLngBounds) {
        if ($scope.fitBounds == 'true') {
          console.log("bounds changed");
          $scope.map.fitBounds(latLngBounds);
        }
      };
    },
    link: function ($scope, $element, $attrs) {

      var DEFAULT_OPTS = {
        center: new google.maps.LatLng(0, 0),
        zoom: 10
      }

      /*
      // check for mandatory parameters
      if(!angular.isDefined($scope.center) || 
         !angular.isDefined($scope.zoom)) {
        console.error("Mandatory attributes not configured for initializing a Google Maps canvas");
        return;
      }
      */

      var map = new google.maps.Map($element[0], DEFAULT_OPTS);
      $scope.map = map;

      $scope.$watch('center', function(center) {
        if(!center || !center.lat || !center.lng) { return; }
        map.setCenter(new google.maps.LatLng(center.lat, center.lng));
      });

      $scope.$watch('zoom', function(zoom) {
        if(!zoom || !parseInt(zoom)) { return; }
        map.setZoom(parseInt(zoom));
      });

      google.maps.event.addListener(map, 'dragend', function() {
        console.log('fire!');
        $scope.boundsChange();
      });
      google.maps.event.addListener(map, 'zoom_changed', function() {
        console.log('fire!');
        $scope.boundsChange();
      });
      // destructor
      $element.on('$destroy', function() {
        console.log("canvas destroyed");
      });

      console.log("canvas created");
    }
  };
})

.directive('markers', function () {
  return {
    restrict: 'E',
    require: '^googleMaps',
    scope: {
      model: '=',
      lat: '@',
      lng: '@',
      click: '@'
    },
    link: function ($scope, $element, $attrs, $ctrl) {
            
      $scope.$watch('model', function (newO, oldO) {
        if(!newO) { return; }
        var markers = [];
        var map = $ctrl.getMap();
        var bounds = new google.maps.LatLngBounds();
        var lat = $scope.lat || 'lat';
        var lng = $scope.lng || 'lng';
        // delete all existing markers
        angular.forEach($scope.markers, function (marker) {
          marker.setMap(null);
          google.maps.event.clearListeners(marker, 'click');
        });
        // loop through all the objects
        angular.forEach(newO, function (obj) {
          if(!obj) { return; }
          var latlng = new google.maps.LatLng(obj[lat], obj[lng]);
          var marker = new google.maps.Marker({
            position: latlng,
            map: map
          });
          bounds.extend(latlng);
      console.log(obj);
          google.maps.event.addListener(marker, 'click', function() {
            obj[$scope.click]();
          });
          markers.push(marker);
        });
        $scope.markers = markers;
        $ctrl.fitBounds(bounds);
      });
    }
  }
})
/*
.directive('marker', function () {
  return {
    restrict: 'E',
    require: '^googleMaps',
    scope: {
      coord: '=',
    },
    link: function ($scope, $element, $attrs, $ctrl) {
      $scope.markers = $scope.markers || [];
      $scope.$watch('coord', function (coord) {
        if(!coord || !coord.lat ) { return; }
        angular.forEach($scope.markers, function (m) {
          m.setMap(null);
        });
        $scope.markers.push(new google.maps.Marker({
          position: new google.maps.LatLng(coord.lat, coord.lng),
          map: $ctrl.getMap()
        }));
      });
    }
  }
});
*/
