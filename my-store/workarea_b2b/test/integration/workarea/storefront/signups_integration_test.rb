require 'test_helper'

module Workarea
  class SignupsIntegrationTest < Workarea::IntegrationTest
    def test_update
      user = create_user
      signup = User::Signup.create!(user: user)

      patch storefront.signup_path(signup.token),
            params: {
              password: 'W3bl1nc!2'
            }

      assert_redirected_to(storefront.login_path)
      assert(flash[:success].present?)
      assert(signup.reload.complete?)

      post storefront.login_path,
           params: {
             email: user.email,
             password: 'W3bl1nc!2'
           }

      assert_redirected_to(storefront.users_account_path)
    end

    def test_redirect_from_invalid_signup
      get storefront.edit_signup_path('fake_token')

      assert_redirected_to(storefront.login_path)
      assert(flash[:error].present?)

      patch storefront.signup_path('fake_token'),
            params: {
              password: 'W3bl1nc!2'
            }

      assert_redirected_to(storefront.login_path)
      assert(flash[:error].present?)
    end

    def test_redirect_from_signup_thats_already_completed
      user = create_user
      signup = User::Signup.create!(user: user)
      signup.complete('W3bl1nc!')

      get storefront.edit_signup_path(signup.token)

      assert_redirected_to(storefront.login_path)
      assert(flash[:error].present?)

      patch storefront.signup_path(signup.token),
            params: {
              password: 'W3bl1nc!2'
            }

      assert_redirected_to(storefront.login_path)
      assert(flash[:error].present?)
    end
  end
end
