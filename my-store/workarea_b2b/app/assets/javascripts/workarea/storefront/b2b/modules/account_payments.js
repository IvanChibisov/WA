/**
 * @namespace WORKAREA.accountPayments
 */
WORKAREA.registerModule('accountPayments', (function () {
    'use strict';

    var hideTenders = function(options, $tenders) {
            if (!_.isEmpty(options.tenders)) {
                $tenders.hide();
                options.tenders.forEach(function(tender, index) {
                    var $tenderContainer = $tenders.filter('.checkout-payment__primary-method--' + tender);

                    $tenderContainer.show();

                    if (index === 0) {
                        $tenderContainer
                            .find('input:radio')
                                .first()
                                .click();
                    }
                });
            }

            if (options.require_account_payment) {
                $tenders.filter('.checkout-payment__primary-method--new').hide();
            }
        },

        /**
         * @method
         * @name init
         * @memberof WORKAREA.accountPayments
         */
        init = function ($scope) {
            var $el = $('[data-account-payments]', $scope),
                options = $el.data('accountPayments');

            if(_.isEmpty($el)) { return; }

            hideTenders(options, $('.checkout-payment__primary-method', $scope));
        };

    return {
        init: init
    };
}()));
