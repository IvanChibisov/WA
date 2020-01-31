WORKAREA.registerModule('myBlockContentBlocks', (function () {
    'use strict';

    var handleClick = function () {
        // TODO implement click handler
        window.alert('TODO');
    },


    init = function ($scope) {
        $('.my-block-content-block', $scope).on('click', handleClick);
    };

    return {
        init: init
    };
}()));
