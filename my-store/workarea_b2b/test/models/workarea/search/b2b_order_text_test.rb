require 'test_helper'

module Workarea
  module Search
    class B2bOrderTextTest < TestCase
      def test_text_includes_account_and_organization_data
        organization = create_organization(name: 'Foo Co.')
        account = create_account(organization: organization, name: 'Bar Team')
        order = create_order(account_id: account.id)

        result = OrderText.new(order).text
        assert_includes(result, 'Foo Co.')
        assert_includes(result, organization.id.to_s)
        assert_includes(result, 'Bar Team')
        assert_includes(result, account.id.to_s)
      end
    end
  end
end
