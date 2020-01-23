/**
 * @namespace WORKAREA.accountAddresses
 */
WORKAREA.registerModule('accountAddresses', (function () {
    'use strict';

    var disableFields = function($addresses) {
            $addresses
                .find(':input')
                    .filter(':not("[id^=saved_address]")')
                    .attr('readonly', 'readonly');

            $addresses
                .on('mousedown', 'select:not("[id^=saved_address]")', function(e) { e.preventDefault(); })
                .on('keydown', 'select:not("[id^=saved_address]")', function(e) { e.preventDefault(); });
        },

        /**
         * @method
         * @name init
         * @memberof WORKAREA.accountAddresses
         */
        init = function ($scope) {
            var $el = $('[data-account-addresses]', $scope);

            if(_.isEmpty($el)) { return; }

            disableFields($('.address-fields', $scope));
        };

    return {
        init: init
    };
}()));
