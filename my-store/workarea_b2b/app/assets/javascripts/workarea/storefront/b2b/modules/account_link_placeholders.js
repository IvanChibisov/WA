/**
 * @namespace WORKAREA.accountLinkPlaceholders
 */
WORKAREA.registerModule('accountLinkPlaceholders', (function () {
    'use strict';

    var accountLinkTemplate = JST['workarea/storefront/b2b/templates/account_link'],

        injectAccountLink = function (user, index, element) {
            $(element).replaceWith(accountLinkTemplate(user));
        },

        testPlaceholders = function ($scope, user) {
            $('[data-account-link-placeholder]', $scope)
            .each(_.partial(injectAccountLink, user));
        },

        testCurrentUser = function ($scope, currentUser) {
            if (!currentUser.logged_in || !currentUser.membership) { return; }

            testPlaceholders($scope, currentUser);
        },

        /**
         * @method
         * @name init
         * @memberof WORKAREA.accountLinkPlaceholders
         */
        init = function ($scope) {
            WORKAREA.currentUser.gettingUserData
            .done(_.partial(testCurrentUser, $scope));
        };

    return {
        init: init
    };
}()));
