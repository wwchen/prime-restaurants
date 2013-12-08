"use strict";

angular.module('dollarFilter', [])
.filter('dollar', function() {
  return function(input) {
    if(typeof input === 'number') {
      var output = '';
      for(var i = 0; i < input; i++) {
        output += '$';
      }
      return output;
    }
    return input;
  }
});
