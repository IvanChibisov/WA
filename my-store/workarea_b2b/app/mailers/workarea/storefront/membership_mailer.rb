module Workarea
  module Storefront
    class MembershipMailer < Storefront::ApplicationMailer
      def created(membership_id)
        @membership = Storefront::MembershipViewModel.wrap(
          Organization::Membership.find(membership_id)
        )

        mail(
          to: @membership.user.email,
          subject: t(
            'workarea.storefront.email.membership_created.subject',
            account: @membership.account_name
          )
        )
      end
    end
  end
end
