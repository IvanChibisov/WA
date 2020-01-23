module Workarea
  class Storefront::Checkout::AuthorizationViewModel < ApplicationViewModel
    include Storefront::CheckoutContent

    delegate :email, to: :order

    def show_email_field?
      user.blank?
    end

  end
end
