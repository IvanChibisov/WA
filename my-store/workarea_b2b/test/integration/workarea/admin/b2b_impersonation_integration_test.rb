require 'test_helper'

module Workarea
  module Admin
    class B2bImpersonationsIntegrationTest < Workarea::IntegrationTest
      setup :set_user, :set_super_user

      def set_user
        @user = create_user
        @account = create_account(price_list_id: 'foo')
        @membership = create_membership(user: @user, account: @account)
      end

      def set_super_user
        super_admin = create_user(password: 'W3bl1nc!', super_admin: true)

        post storefront.login_path,
          params: { email: super_admin.email, password: 'W3bl1nc!' }
      end

      def test_sets_price_list_id_for_impersonated_user
        post admin.impersonations_path, params: { user_id: @user.id }

        assert_equal('foo', session[:price_list_id])

        session[:membership_id] = @membership.id.to_s

        delete admin.impersonations_path

        assert_nil(session[:membership_id])
        assert_nil(session[:price_list_id])
      end
    end
  end
end
