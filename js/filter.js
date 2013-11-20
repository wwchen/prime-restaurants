var filters = angular.module('primeFilters', []);

filters.filter('showMap', function() {
  return function(coord) {
    if(!coord || !coord.lat || !coord.lng) {
      return;
    }
    console.log("Show map filter called: " + JSON.stringify(coord));
    var pos = new google.maps.LatLng(coord.lat, coord.lng);
    var mapOptions = {
      zoom: 14,
      center: pos
    }
    var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
    var marker = new google.maps.Marker({
      position: pos,
      map: map
    });
  };
});

filters.filter('addMarker', function() {
  return function(coord, mapObj) {
    console.log("Add marker filter called");
    var pos = new google.maps.LatLng(coord.lat, coord.lng);
    var marker = new google.maps.Marker({
      position: pos,
      map: mapObj
    });
  };
});
