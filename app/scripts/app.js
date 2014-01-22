'use strict';

angular.module('ZullerAdmin', [
    'ngRoute',
    'ngAnimate',
    'ui.bootstrap',
    'ajoslin.promise-tracker',
    'cgBusy'
    ])
  .config(['$routeProvider' ,function ($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  }]);
