require 'test_helper'

module Workarea
  class SendMembershipNotificationTest < TestCase
    include TestCase::Mail

    def test_perform
      user = create_user
      account = create_account

      Sidekiq::Callbacks.enable(SendMembershipNotification) do
        Organization::Membership.create!(
          user: user,
          account: account,
          role: Workarea.config.membership_roles.first
        )
      end

      assert_equal(1, ActionMailer::Base.deliveries.size)
      email = ActionMailer::Base.deliveries.last
      assert_includes(email.to, user.email)
      assert_includes(
        email.subject,
        t('workarea.storefront.email.membership_created.subject', account: account.name)
      )
    end
  end
end
