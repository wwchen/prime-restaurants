'use strict';

angular.module('primeRestaurantsApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'google-maps'
])
  .config(function ($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      })
      .when('/restaurant/:id', {
        templateUrl: 'views/detail.html',
        controller: 'DetailCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  });
