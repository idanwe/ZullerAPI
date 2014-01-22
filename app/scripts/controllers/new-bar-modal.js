'use strict';

angular.module('ZullerAdmin')
  .controller('NewBarModalCtrl',
    ['$scope', '$modalInstance', '$http', '$q', 'ZullerAPIUrl', 'promiseTracker',
    function ($scope, $modalInstance, $http, $q, ZullerAPIUrl,  promiseTracker) {
      $scope.newBar = {}

      $scope.close = function() {
        $modalInstance.close();
      };

      $scope.submit = function() {
        var saveBarPromise = $q.defer();
        promiseTracker('saveBar').addPromise(saveBarPromise.promise);
        var newBar = angular.copy($scope.newBar);
        $http.post(ZullerAPIUrl + '/bars', newBar)
          .success(function(result, status) {
            saveBarPromise.resolve();
            $modalInstance.close();
          })
       };
    }]);
