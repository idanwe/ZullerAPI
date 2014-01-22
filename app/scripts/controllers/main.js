'use strict';

angular.module('ZullerAdmin')
  .controller('MainCtrl',
    ['$rootScope', '$scope', '$http', '$q', '$modal', 'ZullerAPIUrl', 'promiseTracker',
    function ($rootScope, $scope, $http, $q, $modal, ZullerAPIUrl, promiseTracker) {

      var fetchBars = function () {
        var fetchBarsPromise = $q.defer();
        promiseTracker('fetchBars').addPromise(fetchBarsPromise.promise);
        $http.get(ZullerAPIUrl + '/bars').
          success(function (data) {
            fetchBarsPromise.resolve();
            $scope.bars = data
          })
          .error(function (data) {
            console.log('error!!!: ', data)
          });
      }
      fetchBars();

      $scope.addBar = function () {
        var modalInstance = $modal.open({
          templateUrl: 'views/new-bar-modal.html',
          controller: 'NewBarModalCtrl'
        })
        modalInstance.result.then(function() {
          fetchBars();
        });
      };

      $scope.showBar = function (bar) {
        $scope.selectedBar = bar;
        var modalInstance = $modal.open({
          templateUrl: 'views/bar-modal.html',
          controller: 'BarModalCtrl',
          resolve: {
            selectedBar: function () {
              return bar;
            }
          }
        });
        modalInstance.result.then(function() {
          fetchBars();
        });
      };

      $scope.deleteBar = function (bar) {
        var saveBarPromise = $q.defer();
        promiseTracker('deleteBar').addPromise(saveBarPromise.promise);
        $http.delete(ZullerAPIUrl + '/bars/' + bar._id)
          .success(function (result, status) {
            saveBarPromise.resolve();
            fetchBars();
          })
      };
    }]);
