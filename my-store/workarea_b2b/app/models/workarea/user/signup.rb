module Workarea
  class User
    class Signup
      include ApplicationDocument
      include UrlToken

      field :completed_at, type: Time
      belongs_to :user, class_name: 'Workarea::User'
      validates :user, uniqueness: true

      index(user_id: 1)

      def complete?
        completed_at.present?
      end

      def complete(password)
        if password.blank?
          errors.add(:password, I18n.t('errors.messages.blank'))
          return false
        end

        if user.update(password: password)
          update(completed_at: Time.now)
        else
          user.errors.each do |attribute, error|
            errors.add(attribute, error)
          end
          false
        end
      end
    end
  end
end
