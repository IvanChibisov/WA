module Workarea
  class SendMembershipNotification
    include Sidekiq::Worker
    include Sidekiq::CallbacksWorker

    sidekiq_options enqueue_on: { Organization::Membership => :create }

    def perform(membership_id)
      Storefront::MembershipMailer.created(membership_id).deliver_now
    end
  end
end
