module Workarea
  class Checkout
    module Steps
      class Authorization < Base

        def update(params = {})
          set_order_email(params)

          persist_update
        end


        def complete?
          order.valid?
        end

        private

        def set_order_email(params)
          if params[:email].present?
            order.email = params[:email]
          elsif user.present?
            order.email = user.email
          end
        end

        def persist_update
          order.save
        end

      end
    end
  end
end
