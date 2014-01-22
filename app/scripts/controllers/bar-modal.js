'use strict';

angular.module('ZullerAdmin')
  .controller('BarModalCtrl', ['$scope', '$modalInstance', '$http', '$q', 'ZullerAPIUrl', 'promiseTracker', 'selectedBar',
  function ($scope, $modalInstance, $http, $q, ZullerAPIUrl, promiseTracker, selectedBar) {
    $scope.selectedBar = selectedBar;
    $scope.close = function() {
      $modalInstance.close();
    };

    $scope.submit = function() {
      var saveBarPromise = $q.defer();
      promiseTracker('saveBar').addPromise(saveBarPromise.promise);
      var bar = angular.copy($scope.selectedBar);
      var url = ZullerAPIUrl + '/bars/' + bar._id
      delete bar._id
      $http.put(url, bar)
        .success(function(result, status) {
          saveBarPromise.resolve();
          $modalInstance.close();
        })
    };
  }]);
