WORKAREA.registerModule('captionedImageContentBlocks', (function () {
    'use strict';

    var handleClick = function () {
        // TODO implement click handler
        window.alert('TODO');
    },

    /**
     * @method
     * @name init
     * @memberof WORKAREA.captionedImageContentBlocks
     */
    init = function ($scope) {
        $('.captioned-image-content-block', $scope).on('click', handleClick);
    };

    return {
        init: init
    };
}()));
