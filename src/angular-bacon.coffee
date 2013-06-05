angular
    .module("angular-bacon", [])
    .run ["$rootScope", ($rootScope) ->
        $rootScope.$watchAsProperty = (watchExp, objectEquality) ->
            bus = new Bacon.Bus
            this.$watch watchExp, (newValue) ->
                bus.push newValue
            , objectEquality
            initialValue = this.$eval(watchExp)
            if typeof initialValue != "undefined"
                bus.toProperty(initialValue)
            else
                bus.toProperty()

        $rootScope.digestObservables = (observables) ->
            self = this
            angular.forEach observables, (observable, key) ->
                observable.digest self, key

        Bacon.Observable.prototype.digest = ($scope, prop) ->
            this.onValue (val) ->
                if(!$scope.$$phase)
                    $scope.$apply () ->
                        $scope[prop] = val
                else
                    $scope[prop] = val
    ]