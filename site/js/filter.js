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

//  | restaurantInMapView:this.maps['mapCanvas']
filters.filter('restaurantInMapView', function() {
  return function(input, map) {
    var filtered = [];
    if(input && map) {
      $.each(input, function(i, restaurant) {
        var coords = restaurant.coordinates;
        var latlng = new google.maps.LatLng(coords.lat, coords.lng);
        if(map.getBounds() && map.getBounds().contains(latlng)) {
          filtered.push(restaurant);
        }
      });
      return filtered;
    }
    return input
  };
});
