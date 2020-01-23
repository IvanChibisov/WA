require 'test_helper'

module Workarea
  class Organization
    class MembershipTest < TestCase
      def test_find_current
        user = create_user
        membership_one = create_membership(user: user)
        membership_two = create_membership(user: user)

        assert_equal(
          Organization::Membership.find_current(user.id),
          membership_one
        )

        membership_two.update(default: true)
        assert_equal(
          Organization::Membership.find_current(user.id),
          membership_two
        )

        assert_equal(
          Organization::Membership.find_current(
            user.id,
            membership_id: membership_one.id.to_s
          ),
          membership_one
        )

        membership_two.account.update(active: false)
        assert_equal(
          Organization::Membership.find_current(user.id),
          membership_one
        )

        membership_two.account.update(active: true)
        membership_two.organization.update(active: false)
        assert_equal(
          Organization::Membership.find_current(user.id),
          membership_one
        )
      end

      def test_default_singularity
        user = create_user
        membership_one = create_membership(user: user, default: true)
        membership_two = create_membership(user: user)

        membership_two.update(default: true)
        refute(membership_one.reload.default?)
      end
    end
  end
end
