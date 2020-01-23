module Workarea
  module Storefront
    module Checkout
      class AuthorizationController < CheckoutsController

        # GET /checkout/authorization
        def authorization
          @step ||= Storefront::Checkout::AuthorizationViewModel.new(
            authorization_step,
            view_model_options
          )
        end

        # PATCH /checkout/addresses
        def update_authorization
          authorization_step.update(params)
          if authorization_step.complete?
            completed_authorization_step
          else
            incompleted_authorization_step
          end
        end

        private

        def authorization_step
          @authorization_step ||= Workarea::Checkout::Steps::Authorization.new(current_checkout)
        end

        def completed_authorization_step
          flash[:success] = "Success"
          redirect_to checkout_addresses_path
        end

        def incompleted_authorization_step
          authorization
          render :authorization
        end

      end
    end
  end
end
