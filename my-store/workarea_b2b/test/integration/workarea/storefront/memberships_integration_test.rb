require 'test_helper'

module Workarea
  module Storefront
    class MembershipsIntegrationTest < Workarea::IntegrationTest
      def test_update
        user = create_user
        set_current_user(user)

        membership_one = create_membership(user: user)
        membership_two = create_membership(user: user, default: true)

        patch storefront.membership_path,
              params: { membership_id: membership_one.id },
              headers: { 'Referer' => storefront.users_account_path }

        assert_redirected_to(storefront.users_account_path)
        assert_equal(session['membership_id'], membership_one.id)

        patch storefront.membership_path,
              params: { membership_id: membership_two.id }

        assert_redirected_to(storefront.accounts_path)
        assert_equal(session['membership_id'], membership_two.id)
      end
    end
  end
end
